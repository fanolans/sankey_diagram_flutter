import 'package:flutter/material.dart';

import '../models/sankey_style.dart';
import '../utils/value_formatter.dart';

class SankeyTooltipData {
  const SankeyTooltipData.node({
    required this.label,
    required this.value,
    required this.color,
    this.percentage,
  }) : isNode = true;

  const SankeyTooltipData.link({
    required this.label,
    required this.value,
    required this.color,
    this.percentage,
  }) : isNode = false;

  final bool isNode;
  final String label;
  final double value;
  final Color color;

  final double? percentage;
}

class SankeyTooltipController {
  OverlayEntry? _entry;

  bool get isVisible => _entry != null;

  void show({
    required OverlayState overlayState,
    required Offset globalPosition,
    required SankeyTooltipData tooltipData,
    required TooltipStyle tooltipStyle,
    Widget Function(BuildContext, SankeyTooltipData)? builder,
  }) {
    hide();
    _entry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        globalPosition: globalPosition,
        tooltipData: tooltipData,
        tooltipStyle: tooltipStyle,
        builder: builder,
      ),
    );
    overlayState.insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.globalPosition,
    required this.tooltipData,
    required this.tooltipStyle,
    this.builder,
  });

  final Offset globalPosition;
  final SankeyTooltipData tooltipData;
  final TooltipStyle tooltipStyle;
  final Widget Function(BuildContext, SankeyTooltipData)? builder;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    // Real size unknown pre-layout; use conservative bounds to avoid edge clipping.
    const estimatedW = 160.0;
    const estimatedH = 72.0;
    const gap = 12.0;

    double left = globalPosition.dx + gap;
    double top = globalPosition.dy - gap;

    if (left + estimatedW > screen.width) left = globalPosition.dx - estimatedW - gap;
    if (top + estimatedH > screen.height) top = globalPosition.dy - estimatedH - gap;
    if (left < 0) left = gap;
    if (top < 0) top = gap;

    return Positioned(
      left: left,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: builder != null
            ? builder!(context, tooltipData)
            : _DefaultTooltip(data: tooltipData, style: tooltipStyle),
      ),
    );
  }
}

class _DefaultTooltip extends StatelessWidget {
  const _DefaultTooltip({required this.data, required this.style});

  final SankeyTooltipData data;
  final TooltipStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: Border.all(color: style.borderColor, width: style.borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: style.elevation * 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: data.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(data.label, style: style.textStyle),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            ValueFormatter.format(data.value),
            style: style.textStyle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: (style.textStyle.fontSize ?? 12) + 1,
            ),
          ),
          if (data.percentage != null)
            Text(
              '${data.percentage!.toStringAsFixed(1)} %',
              style: style.textStyle.copyWith(
                color: (style.textStyle.color ?? Colors.white)
                    .withValues(alpha: 0.6),
                fontSize: (style.textStyle.fontSize ?? 12) - 1,
              ),
            ),
        ],
      ),
    );
  }
}
