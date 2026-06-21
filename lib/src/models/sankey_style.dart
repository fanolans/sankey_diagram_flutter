import 'package:flutter/material.dart';

enum SortOrder { byValue, byLabel, none }

enum LegendPosition { top, bottom, left, right, hidden }

@immutable
class TooltipStyle {
  const TooltipStyle({
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.borderColor = const Color(0xFF3A3A5C),
    this.borderWidth = 1.0,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 8.0,
    this.elevation = 4.0,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double borderRadius;
  final double elevation;

  TooltipStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    TextStyle? textStyle,
    EdgeInsets? padding,
    double? borderRadius,
    double? elevation,
  }) {
    return TooltipStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooltipStyle &&
          backgroundColor == other.backgroundColor &&
          borderColor == other.borderColor &&
          textStyle == other.textStyle &&
          padding == other.padding &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode => Object.hash(
      backgroundColor, borderColor, textStyle, padding, borderRadius);
}

@immutable
class SankeyStyle {
  const SankeyStyle({
    this.nodeWidth = 8.0,
    this.nodePadding = 12.0,
    this.nodeRadius = 4.0,
    this.linkOpacity = 0.45,
    this.hoverOpacity = 0.85,
    this.dimOpacity = 0.12,
    this.labelStyle,
    this.valueStyle,
    this.labelBackgroundColor,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    this.labelBorderRadius = 4.0,
    this.showNodeLabels = true,
    this.showTooltip = true,
    this.animationDuration = const Duration(milliseconds: 600),
    this.tooltipStyle,
    this.sortOrder = SortOrder.byValue,
    this.legendPosition = LegendPosition.bottom,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
  });

  final double nodeWidth;
  final double nodePadding;
  final double nodeRadius;
  final double linkOpacity;
  final double hoverOpacity;
  final double dimOpacity;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? labelBackgroundColor;
  final EdgeInsets labelPadding;
  final double labelBorderRadius;
  final bool showNodeLabels;
  final bool showTooltip;

  final Duration animationDuration;

  final TooltipStyle? tooltipStyle;
  final SortOrder sortOrder;
  final LegendPosition legendPosition;
  final Color backgroundColor;
  final double horizontalPadding;
  final double verticalPadding;

  TooltipStyle get resolvedTooltipStyle => tooltipStyle ?? const TooltipStyle();

  TextStyle get resolvedLabelStyle =>
      labelStyle ??
      const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      );

  TextStyle get resolvedValueStyle =>
      valueStyle ??
      const TextStyle(
        color: Colors.white70,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  SankeyStyle copyWith({
    double? nodeWidth,
    double? nodePadding,
    double? nodeRadius,
    double? linkOpacity,
    double? hoverOpacity,
    double? dimOpacity,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? Function()? labelBackgroundColor,
    EdgeInsets? labelPadding,
    double? labelBorderRadius,
    bool? showNodeLabels,
    bool? showTooltip,
    Duration? animationDuration,
    TooltipStyle? tooltipStyle,
    SortOrder? sortOrder,
    LegendPosition? legendPosition,
    Color? backgroundColor,
    double? horizontalPadding,
    double? verticalPadding,
  }) {
    return SankeyStyle(
      nodeWidth: nodeWidth ?? this.nodeWidth,
      nodePadding: nodePadding ?? this.nodePadding,
      nodeRadius: nodeRadius ?? this.nodeRadius,
      linkOpacity: linkOpacity ?? this.linkOpacity,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,
      dimOpacity: dimOpacity ?? this.dimOpacity,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      labelBackgroundColor: labelBackgroundColor != null ? labelBackgroundColor() : this.labelBackgroundColor,
      labelPadding: labelPadding ?? this.labelPadding,
      labelBorderRadius: labelBorderRadius ?? this.labelBorderRadius,
      showNodeLabels: showNodeLabels ?? this.showNodeLabels,
      showTooltip: showTooltip ?? this.showTooltip,
      animationDuration: animationDuration ?? this.animationDuration,
      tooltipStyle: tooltipStyle ?? this.tooltipStyle,
      sortOrder: sortOrder ?? this.sortOrder,
      legendPosition: legendPosition ?? this.legendPosition,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SankeyStyle &&
          nodeWidth == other.nodeWidth &&
          nodePadding == other.nodePadding &&
          nodeRadius == other.nodeRadius &&
          linkOpacity == other.linkOpacity &&
          hoverOpacity == other.hoverOpacity &&
          dimOpacity == other.dimOpacity &&
          labelStyle == other.labelStyle &&
          valueStyle == other.valueStyle &&
          labelBackgroundColor == other.labelBackgroundColor &&
          labelPadding == other.labelPadding &&
          labelBorderRadius == other.labelBorderRadius &&
          showNodeLabels == other.showNodeLabels &&
          showTooltip == other.showTooltip &&
          animationDuration == other.animationDuration &&
          tooltipStyle == other.tooltipStyle &&
          sortOrder == other.sortOrder &&
          legendPosition == other.legendPosition &&
          backgroundColor == other.backgroundColor &&
          horizontalPadding == other.horizontalPadding &&
          verticalPadding == other.verticalPadding;

  @override
  int get hashCode => Object.hashAll([
        nodeWidth,
        nodePadding,
        nodeRadius,
        linkOpacity,
        hoverOpacity,
        dimOpacity,
        labelStyle,
        valueStyle,
        labelBackgroundColor,
        labelPadding,
        labelBorderRadius,
        showNodeLabels,
        showTooltip,
        animationDuration,
        tooltipStyle,
        sortOrder,
        legendPosition,
        backgroundColor,
        horizontalPadding,
        verticalPadding,
      ]);
}
