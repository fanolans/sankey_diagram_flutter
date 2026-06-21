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
      // Sumber Energi Primer — kolom ditentukan otomatis oleh BFS
      SankeyNode(id: 'solar',    label: 'Solar',    color: _solar,    subLabel: 'PLTS'),
      SankeyNode(id: 'angin',    label: 'Angin',    color: _angin,    subLabel: 'PLTB'),
      SankeyNode(id: 'batubara', label: 'Batubara', color: _batubara, subLabel: 'PLTU'),
      SankeyNode(id: 'gas',      label: 'Gas Alam', color: _gas,      subLabel: 'PLTG'),
      SankeyNode(id: 'hydro',    label: 'Air',      color: _hydro,    subLabel: 'PLTA'),

      // Energi Sekunder
      SankeyNode(id: 'listrik', label: 'Listrik',    color: _listrik, subLabel: 'Grid PLN'),
      SankeyNode(id: 'panas',   label: 'Energi Panas', color: _panas, subLabel: 'Steam'),
      SankeyNode(id: 'bbm',     label: 'BBM',        color: _bbm,    subLabel: 'Kilang'),

      // Pengguna Akhir
      SankeyNode(id: 'industri',  label: 'Industri',      color: _industri,  subLabel: 'Manufaktur'),
      SankeyNode(id: 'rumah',     label: 'Rumah Tangga',  color: _rumah,     subLabel: 'Residensial'),
      SankeyNode(id: 'transport', label: 'Transportasi',  color: _transport, subLabel: 'Darat & Udara'),
      SankeyNode(id: 'komersial', label: 'Komersial',     color: _komersial, subLabel: 'Gedung & Mal'),
    ],
    links: [
      // Sumber → Energi Sekunder
      SankeyLink(sourceId: 'solar',    targetId: 'listrik', value: 18000),
      SankeyLink(sourceId: 'angin',    targetId: 'listrik', value: 10000),
      SankeyLink(sourceId: 'batubara', targetId: 'listrik', value: 52000),
      SankeyLink(sourceId: 'batubara', targetId: 'panas',   value: 18000),
      SankeyLink(sourceId: 'gas',      targetId: 'listrik', value: 28000),
      SankeyLink(sourceId: 'gas',      targetId: 'panas',   value: 14000),
      SankeyLink(sourceId: 'gas',      targetId: 'bbm',     value:  8000),
      SankeyLink(sourceId: 'hydro',    targetId: 'listrik', value: 22000),

      // Energi Sekunder → Pengguna Akhir
      SankeyLink(sourceId: 'listrik', targetId: 'industri',  value: 52000),
      SankeyLink(sourceId: 'listrik', targetId: 'rumah',     value: 36000),
      SankeyLink(sourceId: 'listrik', targetId: 'komersial', value: 22000),
      SankeyLink(sourceId: 'listrik', targetId: 'transport', value:  8000),
      SankeyLink(sourceId: 'panas',   targetId: 'industri',  value: 28000),
      SankeyLink(sourceId: 'panas',   targetId: 'komersial', value:  4000),
      SankeyLink(sourceId: 'bbm',     targetId: 'transport', value:  8000),

      // Circular link: industri → listrik (cogeneration — sisa energi dikembalikan ke grid)
      SankeyLink(sourceId: 'industri', targetId: 'listrik', value: 6000),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Aliran Energi Nasional — kolom & posisi dihitung otomatis dari topologi link (TWh)',
      buyerLabel: 'Sumber',
      sellerLabel: 'Pengguna',
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
        SankeyLegendItem(color: _angin,    label: 'Angin'),
        SankeyLegendItem(color: _batubara, label: 'Batubara'),
        SankeyLegendItem(color: _gas,      label: 'Gas Alam'),
        SankeyLegendItem(color: _hydro,    label: 'Air'),
      ],
    );
  }
}
