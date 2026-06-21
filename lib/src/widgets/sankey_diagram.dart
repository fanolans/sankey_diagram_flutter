import 'package:flutter/material.dart';

import '../layout/layout_link.dart';
import '../layout/layout_node.dart';
import '../layout/sankey_layout.dart';
import '../models/sankey_data.dart';
import '../models/sankey_node.dart';
import '../models/sankey_style.dart';
import '../painter/bezier_helper.dart';
import '../painter/sankey_painter.dart';
import '../utils/value_formatter.dart';
import 'sankey_controller.dart';
import 'sankey_legend.dart';
import 'sankey_tooltip.dart';

/// Convenience alias for [LayoutLink] in tap callbacks.
typedef SankeyLayoutLink = LayoutLink;

/// An interactive, animated Sankey diagram widget.
///
/// Provide [data] with nodes and links. Customise appearance with [style],
/// react to interaction via [onNodeTap] / [onLinkTap] / [onNodeHover], and
/// drive highlight state externally via [controller].
///
/// ```dart
/// SankeyDiagram(
///   data: SankeyData(nodes: myNodes, links: myLinks),
///   height: 400,
/// )
/// ```
class SankeyDiagram extends StatefulWidget {
  const SankeyDiagram({
    super.key,
    required this.data,
    this.style = const SankeyStyle(),
    this.height = 400.0,
    this.controller,
    this.onNodeTap,
    this.onLinkTap,
    this.onNodeHover,
    this.tooltipBuilder,
    this.legendBuilder,
    this.legendItems,
    this.buyerLabel = 'Buyer',
    this.sellerLabel = 'Seller',
    this.buyerLabelStyle,
    this.sellerLabelStyle,
  });

  final SankeyData data;
  final SankeyStyle style;
  final double height;
  final SankeyController? controller;
  final void Function(SankeyNode node)? onNodeTap;
  final void Function(SankeyLayoutLink link)? onLinkTap;

  final void Function(SankeyNode? node)? onNodeHover;
  final Widget Function(BuildContext, SankeyTooltipData)? tooltipBuilder;
  final Widget Function(BuildContext, List<SankeyLegendItem>)? legendBuilder;
  final List<SankeyLegendItem>? legendItems;

  final String buyerLabel;
  final String sellerLabel;
  final TextStyle? buyerLabelStyle;
  final TextStyle? sellerLabelStyle;

  @override
  State<SankeyDiagram> createState() => _SankeyDiagramState();
}

class _SankeyDiagramState extends State<SankeyDiagram>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _animation;

  late AnimationController _linkHighlightCtrl;
  late Animation<double> _linkHighlightAnim;
  bool _sweepFromRight = false;

  SankeyLayoutResult? _layout;
  Size? _lastSize;

  String? _hoveredNodeId;
  int? _hoveredLinkIndex;
  String? _selectedNodeId;

  final _tooltipCtrl = SankeyTooltipController();
  SankeyController? _attachedController;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: widget.style.animationDuration,
    );
    _animation = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();

    _linkHighlightCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1.0, // start fully revealed so there's no sweep on initial load
    );
    _linkHighlightAnim = CurvedAnimation(
      parent: _linkHighlightCtrl,
      curve: Curves.easeOut,
    );

    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(SankeyDiagram old) {
    super.didUpdateWidget(old);

    if (old.controller != widget.controller) {
      _detachController(old.controller);
      _attachController(widget.controller);
    }

    if (old.data != widget.data || old.style != widget.style) {
      _layout = null; // invalidate cache
      _animCtrl
        ..duration = widget.style.animationDuration
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _tooltipCtrl.hide();
    _detachController(_attachedController);
    _animCtrl.dispose();
    _linkHighlightCtrl.dispose();
    super.dispose();
  }

  void _attachController(SankeyController? ctrl) {
    _attachedController = ctrl;
    ctrl?.addListener(_onControllerChanged);
  }

  void _detachController(SankeyController? ctrl) {
    ctrl?.removeListener(_onControllerChanged);
    if (_attachedController == ctrl) _attachedController = null;
  }

  void _onControllerChanged() {
    setState(() => _hoveredNodeId = _attachedController?.highlightedNodeId);
  }

  SankeyLayoutResult _getLayout(Size size) {
    if (_layout == null || _lastSize != size) {
      _layout = SankeyLayout.compute(
        data: widget.data,
        size: size,
        style: widget.style,
      );
      _lastSize = size;
    }
    return _layout!;
  }

  void _handleTapUp(TapUpDetails details, SankeyLayoutResult layout) {
    final pos = details.localPosition;

    for (final ln in layout.nodes.values) {
      if (BezierHelper.hitTestNode(ln.rect, pos)) {
        _handleNodeTap(ln, details.globalPosition);
        return;
      }
    }

    for (var i = 0; i < layout.links.length; i++) {
      if (BezierHelper.hitTestLink(layout.links[i], pos)) {
        _handleLinkTap(layout.links[i], pos, details.globalPosition);
        return;
      }
    }

    setState(() => _selectedNodeId = null);
    _tooltipCtrl.hide();
  }

  void _handleNodeTap(LayoutNode ln, Offset globalPos) {
    final newId = (_selectedNodeId == ln.node.id) ? null : ln.node.id;
    if (newId != null) {
      _sweepFromRight = _layout != null &&
          ln.column >= _layout!.numColumns / 2;
      _linkHighlightCtrl.forward(from: 0);
    }
    setState(() => _selectedNodeId = newId);
    widget.onNodeTap?.call(ln.node);
    if (!widget.style.showTooltip) return;

    final totalFlow = _computeTotalFlow();
    _tooltipCtrl.show(
      overlayState: Overlay.of(context),
      globalPosition: globalPos,
      tooltipData: SankeyTooltipData.node(
        label: ln.node.label,
        value: ln.value,
        color: ln.node.color,
        percentage: totalFlow > 0 ? (ln.value / totalFlow) * 100 : null,
      ),
      tooltipStyle: widget.style.resolvedTooltipStyle,
      builder: widget.tooltipBuilder,
    );
  }

  void _handleLinkTap(LayoutLink ll, Offset localPos, Offset globalPos) {
    final midX = (ll.sourceNode.rect.right + ll.targetNode.rect.left) / 2;
    _sweepFromRight = localPos.dx > midX;

    final tappedNode = _sweepFromRight ? ll.targetNode : ll.sourceNode;
    final newId =
        (_selectedNodeId == tappedNode.node.id) ? null : tappedNode.node.id;
    setState(() => _selectedNodeId = newId);
    if (newId != null) _linkHighlightCtrl.forward(from: 0);

    widget.onLinkTap?.call(ll);
    if (!widget.style.showTooltip) return;

    final totalFlow = _computeTotalFlow();
    _tooltipCtrl.show(
      overlayState: Overlay.of(context),
      globalPosition: globalPos,
      tooltipData: SankeyTooltipData.link(
        label: ll.link.label ?? '${ll.sourceNode.node.label} → ${ll.targetNode.node.label}',
        value: ll.link.value,
        color: ll.link.color ?? ll.sourceNode.node.color,
        percentage: totalFlow > 0 ? (ll.link.value / totalFlow) * 100 : null,
      ),
      tooltipStyle: widget.style.resolvedTooltipStyle,
      builder: widget.tooltipBuilder,
    );
  }

  void _handleHoverUpdate(PointerEvent event, SankeyLayoutResult layout) {
    final pos = event.localPosition;
    String? newNode;
    int? newLink;

    for (final ln in layout.nodes.values) {
      if (BezierHelper.hitTestNode(ln.rect, pos)) {
        newNode = ln.node.id;
        break;
      }
    }

    if (newNode == null) {
      for (var i = 0; i < layout.links.length; i++) {
        if (BezierHelper.hitTestLink(layout.links[i], pos)) {
          newLink = i;
          break;
        }
      }
    }

    if (newNode != _hoveredNodeId || newLink != _hoveredLinkIndex) {
      if (_selectedNodeId == null && (newNode != null || newLink != null)) {
        if (newNode != null) {
          final col = layout.nodes[newNode]?.column ?? 0;
          _sweepFromRight = col >= layout.numColumns / 2;
        } else {
          final ll = layout.links[newLink!];
          final midX =
              (ll.sourceNode.rect.right + ll.targetNode.rect.left) / 2;
          _sweepFromRight = pos.dx > midX;
        }
        _linkHighlightCtrl.forward(from: 0);
      }
      setState(() {
        _hoveredNodeId = newNode;
        _hoveredLinkIndex = newLink;
      });
      widget.onNodeHover?.call(
        newNode != null ? layout.nodes[newNode]?.node : null,
      );
    }
  }

  void _handleHoverExit() {
    if (_hoveredNodeId != null || _hoveredLinkIndex != null) {
      setState(() {
        _hoveredNodeId = null;
        _hoveredLinkIndex = null;
      });
      widget.onNodeHover?.call(null);
    }
  }

  double _computeTotalFlow() {
    final layout = _layout;
    if (layout == null) {
      return widget.data.links.fold(0.0, (s, l) => s + l.value);
    }
    // Only count links leaving column 0 to avoid double-counting flows
    // that pass through intermediate columns in multi-column diagrams.
    return widget.data.links
        .where((l) => (layout.nodes[l.sourceId]?.column ?? 0) == 0)
        .fold(0.0, (s, l) => s + l.value);
  }

  @override
  Widget build(BuildContext context) {
    final legendItems =
        widget.legendItems ?? deriveLegendItems(widget.data.nodes);
    final showLegend = widget.style.legendPosition != LegendPosition.hidden;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLegend && widget.style.legendPosition == LegendPosition.top)
            _buildLegend(legendItems),
          _buildHeaderRow(),
          SizedBox(height: widget.height, child: _buildDiagramCanvas()),
          if (showLegend &&
              widget.style.legendPosition == LegendPosition.bottom)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildLegend(legendItems),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    final labelColor = Theme.of(context).colorScheme.onSurface;
    final defaultStyle = TextStyle(
      color: labelColor,
      fontSize: 13,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.buyerLabel,
            style: widget.buyerLabelStyle ?? defaultStyle,
          ),
          Text(
            widget.sellerLabel,
            style: widget.sellerLabelStyle ?? defaultStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, widget.height);
        final layout = _getLayout(size);

        return GestureDetector(
          onTapUp: (d) => _handleTapUp(d, layout),
          onTap: _tooltipCtrl.hide,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (e) => _handleHoverUpdate(e, layout),
            onExit: (_) => _handleHoverExit(),
            child: SizedBox(
              width: constraints.maxWidth,
              height: widget.height,
              child: AnimatedBuilder(
                animation: Listenable.merge([_animation, _linkHighlightAnim]),
                builder: (context, _) => CustomPaint(
                  painter: SankeyPainter(
                    layout: layout,
                    data: widget.data,
                    style: widget.style,
                    hoveredNodeId: _hoveredNodeId ??
                        _attachedController?.highlightedNodeId,
                    hoveredLinkIndex: _hoveredLinkIndex,
                    selectedNodeId: _selectedNodeId,
                    animationValue: _animation.value,
                    linkHighlightProgress: _linkHighlightAnim.value,
                    sweepFromRight: _sweepFromRight,
                    brightness: Theme.of(context).brightness,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(List<SankeyLegendItem> items) {
    if (widget.legendBuilder != null) {
      return Builder(builder: (ctx) => widget.legendBuilder!(ctx, items));
    }
    return SankeyLegend(items: items, style: widget.style);
  }
}

extension SankeyValueExt on double {
  String toSankeyLabel({int decimals = 2}) =>
      ValueFormatter.format(this, decimals: decimals);
}
