import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../layout/layout_link.dart';
import '../layout/layout_node.dart';
import '../layout/sankey_layout.dart';
import '../models/sankey_data.dart';
import '../models/sankey_style.dart';
import '../utils/value_formatter.dart';
import 'bezier_helper.dart';

class SankeyPainter extends CustomPainter {
  SankeyPainter({
    required this.layout,
    required this.data,
    required this.style,
    this.hoveredNodeId,
    this.hoveredLinkIndex,
    this.selectedNodeId,
    this.animationValue = 1.0,
    this.linkHighlightProgress = 1.0,
    this.sweepFromRight = false,
    this.brightness = Brightness.dark,
  });

  final SankeyLayoutResult layout;
  final SankeyData data;
  final SankeyStyle style;
  final String? hoveredNodeId;
  final int? hoveredLinkIndex;
  final String? selectedNodeId;
  final double animationValue;
  final double linkHighlightProgress;
  final bool sweepFromRight;
  final Brightness brightness;

  bool get _isDark => brightness == Brightness.dark;

  Color get _resolvedLabelBg =>
      style.labelBackgroundColor ??
      (_isDark ? const Color(0xCC0D0D1A) : const Color(0xCCF8FAFC));

  TextStyle get _resolvedValueStyle =>
      style.valueStyle ??
      TextStyle(
        color: _isDark ? Colors.white70 : Colors.black54,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  final _nodePaint = Paint()..style = PaintingStyle.fill;
  final _linkPaint = Paint()..style = PaintingStyle.fill;
  final _glowPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  // Cache TextPainter per node — layout() is expensive; avoid rebuilding each frame.
  final Map<String, TextPainter> _labelCache = {};

  @override
  void paint(Canvas canvas, Size size) {
    if (layout.nodes.isEmpty) return;
    _drawBackground(canvas, size);
    _drawLinks(canvas);
    _drawNodes(canvas);
    if (style.showNodeLabels) _drawLabels(canvas);
  }

  @override
  bool shouldRepaint(SankeyPainter old) {
    if (old.layout != layout || old.data != data || old.style != style) {
      _labelCache.clear();
    }
    return old.layout != layout ||
        old.data != data ||
        old.style != style ||
        old.hoveredNodeId != hoveredNodeId ||
        old.hoveredLinkIndex != hoveredLinkIndex ||
        old.selectedNodeId != selectedNodeId ||
        old.animationValue != animationValue ||
        old.linkHighlightProgress != linkHighlightProgress ||
        old.sweepFromRight != sweepFromRight ||
        old.brightness != brightness;
  }

  void _drawBackground(Canvas canvas, Size size) {
    if (style.backgroundColor == Colors.transparent) return;
    canvas.drawRect(Offset.zero & size, Paint()..color = style.backgroundColor);
  }

  void _drawLinks(Canvas canvas) {
    final effectiveNodeId = selectedNodeId ?? hoveredNodeId;
    final hasHighlight = effectiveNodeId != null || hoveredLinkIndex != null;

    for (var i = 0; i < layout.links.length; i++) {
      final ll = layout.links[i];
      final path = BezierHelper.buildLinkPath(
        ll,
        animationValue: animationValue,
        nodeOverlap: style.nodeRadius,
      );
      final srcColor = ll.link.color ?? ll.sourceNode.node.color;
      final tgtColor = ll.link.color ?? ll.targetNode.node.color;
      final isHighlighted = _isLinkHighlighted(ll, i, effectiveNodeId);

      if (!hasHighlight) {
        _paintLink(canvas, path, ll, srcColor, tgtColor, style.linkOpacity);
        continue;
      }

      if (!isHighlighted) {
        _paintLink(canvas, path, ll, srcColor, tgtColor, style.dimOpacity);
        continue;
      }

      if (linkHighlightProgress >= 1.0) {
        _paintLink(canvas, path, ll, srcColor, tgtColor, style.hoverOpacity);
      } else {
        _paintLink(canvas, path, ll, srcColor, tgtColor, style.dimOpacity);
        _drawSweepReveal(canvas, path, ll, srcColor, tgtColor);
      }
    }

    _linkPaint.shader = null;
  }

  void _drawSweepReveal(
    Canvas canvas,
    Path path,
    LayoutLink ll,
    Color srcColor,
    Color tgtColor,
  ) {
    final x0 = ll.sourceNode.rect.right;
    final x1 = ll.targetNode.rect.left;
    final span = x1 - x0;

    final double sweepX = sweepFromRight
        ? x1 - span * linkHighlightProgress
        : x0 + span * linkHighlightProgress;

    final double clipLeft = sweepFromRight ? sweepX : x0 - style.nodeWidth - 2;
    final double clipRight = sweepFromRight ? x1 + style.nodeWidth + 2 : sweepX;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(clipLeft, -1e7, clipRight, 1e7));
    _paintLink(canvas, path, ll, srcColor, tgtColor, style.hoverOpacity);
    canvas.restore();

    const edgeHalf = 5.0;
    canvas.save();
    canvas.clipRect(
        Rect.fromLTRB(sweepX - edgeHalf, -1e7, sweepX + edgeHalf, 1e7));
    canvas.drawPath(
        path, _glowPaint..color = Colors.white.withValues(alpha: 0.28));
    canvas.restore();
  }

  void _paintLink(
    Canvas canvas,
    Path path,
    LayoutLink ll,
    Color srcColor,
    Color tgtColor,
    double opacity,
  ) {
    _linkPaint.shader = ui.Gradient.linear(
      Offset(ll.sourceNode.rect.right, 0),
      Offset(ll.targetNode.rect.left, 0),
      [
        srcColor.withValues(alpha: opacity),
        tgtColor.withValues(alpha: opacity),
      ],
    );
    canvas.drawPath(path, _linkPaint);
  }

  void _drawNodes(Canvas canvas) {
    for (final ln in layout.nodes.values) {
      final rect = _animatedNodeRect(ln.rect);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(style.nodeRadius)),
        _nodePaint..color = ln.node.color,
      );
      if (selectedNodeId == ln.node.id) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(style.nodeRadius)),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white.withValues(alpha: 0.9),
        );
      }
    }
  }

  void _drawLabels(Canvas canvas) {
    for (final ln in layout.nodes.values) {
      if (ln.rect.height < 4) continue;
      _drawNodeLabel(canvas, ln);
    }
  }

  void _drawNodeLabel(Canvas canvas, LayoutNode ln) {
    // Column 0 labels sit right of the bar; all others sit left.
    final isBuyer = ln.column == 0;

    final cacheKey = '${ln.node.id}_${ln.value}_$isBuyer';
    final tp = _labelCache.putIfAbsent(cacheKey, () {
      final p = _buildTextPainter(
          ln.node.label, ValueFormatter.format(ln.value), isBuyer, ln.node.color);
      p.layout();
      return p;
    });

    const chipGap = 4.0;
    final chipW = tp.width + style.labelPadding.horizontal;
    final chipH = tp.height + style.labelPadding.vertical;
    final chipX =
        isBuyer ? ln.rect.right + chipGap : ln.rect.left - chipW - chipGap;
    final chipY = ln.rect.center.dy - chipH / 2;

    final chipRect = Rect.fromLTWH(chipX, chipY, chipW, chipH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          chipRect, Radius.circular(style.labelBorderRadius)),
      Paint()..color = _resolvedLabelBg,
    );

    tp.paint(
        canvas,
        Offset(
            chipX + style.labelPadding.left, chipY + style.labelPadding.top));
  }

  TextPainter _buildTextPainter(
      String code, String value, bool isBuyer, Color nodeColor) {
    final labelStyle =
        style.resolvedLabelStyle.copyWith(color: nodeColor);
    final span = isBuyer
        ? TextSpan(
            text: '$code ',
            style: labelStyle,
            children: [TextSpan(text: value, style: _resolvedValueStyle)],
          )
        : TextSpan(
            children: [
              TextSpan(text: '$value ', style: _resolvedValueStyle),
              TextSpan(text: code, style: labelStyle),
            ],
          );

    return TextPainter(
        text: span, textDirection: TextDirection.ltr, maxLines: 1);
  }

  bool _isLinkHighlighted(LayoutLink ll, int index, String? effectiveNodeId) {
    if (hoveredLinkIndex == index) return true;
    if (effectiveNodeId == null) return false;
    return ll.link.sourceId == effectiveNodeId ||
        ll.link.targetId == effectiveNodeId;
  }

  Rect _animatedNodeRect(Rect rect) {
    if (animationValue >= 1.0) return rect;
    final centreY = rect.top + rect.height / 2;
    final animH = rect.height * animationValue;
    return Rect.fromLTWH(rect.left, centreY - animH / 2, rect.width, animH);
  }
}
