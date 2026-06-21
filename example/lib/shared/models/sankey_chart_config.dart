import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

class SankeyChartConfig {
  const SankeyChartConfig({
    required this.data,
    required this.subtitle,
    required this.buyerLabel,
    required this.sellerLabel,
    required this.legendItems,
    this.style = const SankeyStyle(
      nodeWidth: 8,
      nodePadding: 12,
      linkOpacity: 0.42,
      hoverOpacity: 0.90,
      dimOpacity: 0.07,
      sortOrder: SortOrder.byValue,
      legendPosition: LegendPosition.bottom,
    ),
    this.buyerLabelStyle,
    this.sellerLabelStyle,
    this.height = 520,
  });

  final SankeyData data;
  final String subtitle;
  final String buyerLabel;
  final String sellerLabel;
  final List<SankeyLegendItem> legendItems;
  final SankeyStyle style;
  final TextStyle? buyerLabelStyle;
  final TextStyle? sellerLabelStyle;
  final double height;
}
