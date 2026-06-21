import 'package:flutter/material.dart';

/// Controls how columns are assigned when [SankeyStyle.autoLayout] is `true`.
///
/// All modes use a BFS pass from source nodes (no incoming links) to assign
/// an initial column by link depth. The modes differ in how they handle sink
/// nodes (no outgoing links) and intermediate nodes.
enum NodeAlignment {
  /// Source nodes at column 0; column index increases by link depth.
  left,

  /// Sink nodes at the rightmost column; columns propagate from right to left.
  right,

  /// Nodes positioned at the midpoint of their forward and reverse depths,
  /// spreading the graph across the full column range.
  center,

  /// Like [left] but also pushes sink nodes to the rightmost column.
  /// Matches the default behaviour of d3-sankey.
  justify,
}

/// Controls the order in which sibling nodes are stacked in each column.
enum SortOrder {
  /// Largest value at the top.
  byValue,

  /// Alphabetical by [SankeyNode.label].
  byLabel,

  /// Preserves the order nodes appear in [SankeyData.nodes].
  none,
}

/// Position of the legend relative to the diagram.
enum LegendPosition { top, bottom, left, right, hidden }

/// Visual style for the hover tooltip.
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

/// Comprehensive visual configuration for [SankeyDiagram].
///
/// All properties have sensible defaults — only override what you need.
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
    this.autoLayout = false,
    this.layoutIterations = 6,
    this.nodeAlignment = NodeAlignment.justify,
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

  /// When `true`, column positions are derived automatically from link topology
  /// using BFS, and node vertical positions are refined with iterative
  /// relaxation (like d3-sankey). [SankeyNode.column] and [SankeyNode.type]
  /// are ignored in this mode.
  final bool autoLayout;

  /// Number of relaxation iterations to run when [autoLayout] is `true`.
  /// Higher values produce better crossing minimisation at a small CPU cost.
  final int layoutIterations;

  /// Controls how source/sink nodes are placed during auto-layout.
  final NodeAlignment nodeAlignment;

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
    bool? autoLayout,
    int? layoutIterations,
    NodeAlignment? nodeAlignment,
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
      autoLayout: autoLayout ?? this.autoLayout,
      layoutIterations: layoutIterations ?? this.layoutIterations,
      nodeAlignment: nodeAlignment ?? this.nodeAlignment,
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
          verticalPadding == other.verticalPadding &&
          autoLayout == other.autoLayout &&
          layoutIterations == other.layoutIterations &&
          nodeAlignment == other.nodeAlignment;

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
        autoLayout,
        layoutIterations,
        nodeAlignment,
      ]);
}
