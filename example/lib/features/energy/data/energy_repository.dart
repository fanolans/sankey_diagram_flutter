import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

/// Demonstrates [SankeyStyle.autoLayout] = true.
///
/// No [SankeyNode.column] or [SankeyNode.type] is set — the layout engine
/// derives column positions from link topology via BFS. The link
/// `industri → listrik` is a backward flow (circular link) representing
/// industrial cogeneration feeding surplus electricity back to the grid.
class EnergyRepository implements SankeyRepository {
  const EnergyRepository();

  static const _solar    = Color(0xFFFBBF24);
  static const _angin    = Color(0xFF60A5FA);
  static const _batubara = Color(0xFF78716C);
  static const _gas      = Color(0xFF34D399);
  static const _hydro    = Color(0xFF06B6D4);

  static const _listrik  = Color(0xFFF59E0B);
  static const _panas    = Color(0xFFEF4444);
  static const _bbm      = Color(0xFFA78BFA);

  static const _industri   = Color(0xFF6366F1);
  static const _rumah      = Color(0xFF10B981);
  static const _transport  = Color(0xFF3B82F6);
  static const _komersial  = Color(0xFFEC4899);

  static const _data = SankeyData(
    nodes: [
      // Primary energy sources — columns assigned automatically by BFS
      SankeyNode(id: 'solar',    label: 'Solar',        color: _solar,    subLabel: 'Solar PV'),
      SankeyNode(id: 'angin',    label: 'Wind',         color: _angin,    subLabel: 'Wind Farm'),
      SankeyNode(id: 'batubara', label: 'Coal',         color: _batubara, subLabel: 'Coal Plant'),
      SankeyNode(id: 'gas',      label: 'Natural Gas',  color: _gas,      subLabel: 'Gas Turbine'),
      SankeyNode(id: 'hydro',    label: 'Hydro',        color: _hydro,    subLabel: 'Hydro Plant'),

      // Secondary energy
      SankeyNode(id: 'listrik', label: 'Electricity', color: _listrik, subLabel: 'Power Grid'),
      SankeyNode(id: 'panas',   label: 'Heat',        color: _panas,   subLabel: 'Steam'),
      SankeyNode(id: 'bbm',     label: 'Fuel Oil',    color: _bbm,     subLabel: 'Refinery'),

      // End consumers
      SankeyNode(id: 'industri',  label: 'Industry',    color: _industri,  subLabel: 'Manufacturing'),
      SankeyNode(id: 'rumah',     label: 'Households',  color: _rumah,     subLabel: 'Residential'),
      SankeyNode(id: 'transport', label: 'Transport',   color: _transport, subLabel: 'Road & Air'),
      SankeyNode(id: 'komersial', label: 'Commercial',  color: _komersial, subLabel: 'Buildings & Malls'),
    ],
    links: [
      // Primary sources → Secondary energy
      SankeyLink(sourceId: 'solar',    targetId: 'listrik', value: 18000),
      SankeyLink(sourceId: 'angin',    targetId: 'listrik', value: 10000),
      SankeyLink(sourceId: 'batubara', targetId: 'listrik', value: 52000),
      SankeyLink(sourceId: 'batubara', targetId: 'panas',   value: 18000),
      SankeyLink(sourceId: 'gas',      targetId: 'listrik', value: 28000),
      SankeyLink(sourceId: 'gas',      targetId: 'panas',   value: 14000),
      SankeyLink(sourceId: 'gas',      targetId: 'bbm',     value:  8000),
      SankeyLink(sourceId: 'hydro',    targetId: 'listrik', value: 22000),

      // Secondary energy → End consumers
      SankeyLink(sourceId: 'listrik', targetId: 'industri',  value: 52000),
      SankeyLink(sourceId: 'listrik', targetId: 'rumah',     value: 36000),
      SankeyLink(sourceId: 'listrik', targetId: 'komersial', value: 22000),
      SankeyLink(sourceId: 'listrik', targetId: 'transport', value:  8000),
      SankeyLink(sourceId: 'panas',   targetId: 'industri',  value: 28000),
      SankeyLink(sourceId: 'panas',   targetId: 'komersial', value:  4000),
      SankeyLink(sourceId: 'bbm',     targetId: 'transport', value:  8000),

      // Circular link: industri → listrik (cogeneration — surplus electricity fed back to the grid)
      SankeyLink(sourceId: 'industri', targetId: 'listrik', value: 6000),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'National Energy Flow — columns & positions auto-computed from link topology (TWh)',
      buyerLabel: 'Sources',
      sellerLabel: 'Consumers',
      height: 560,
      style: SankeyStyle(
        autoLayout: true,
        layoutIterations: 6,
        nodeAlignment: NodeAlignment.justify,
        nodeWidth: 8,
        nodePadding: 10,
        linkOpacity: 0.38,
        hoverOpacity: 0.88,
        dimOpacity: 0.07,
        sortOrder: SortOrder.byValue,
        legendPosition: LegendPosition.bottom,
        verticalPadding: 48,
      ),
      legendItems: [
        SankeyLegendItem(color: _solar,    label: 'Solar'),
        SankeyLegendItem(color: _angin,    label: 'Wind'),
        SankeyLegendItem(color: _batubara, label: 'Coal'),
        SankeyLegendItem(color: _gas,      label: 'Natural Gas'),
        SankeyLegendItem(color: _hydro,    label: 'Hydro'),
      ],
    );
  }
}
