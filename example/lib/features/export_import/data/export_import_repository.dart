import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class ExportImportRepository implements SankeyRepository {
  const ExportImportRepository();

  static const _colorBatubara = Color(0xFF78716C);
  static const _colorSawit    = Color(0xFF10B981);
  static const _colorNikel    = Color(0xFF94A3B8);
  static const _colorKaret    = Color(0xFFF97316);
  static const _colorTekstil  = Color(0xFF8B5CF6);
  static const _colorElek     = Color(0xFF3B82F6);

  static const _colorChina  = Color(0xFFEF4444);
  static const _colorIndia  = Color(0xFFFF9F43);
  static const _colorJepang = Color(0xFFEC4899);
  static const _colorUSA    = Color(0xFF60A5FA);
  static const _colorASEAN  = Color(0xFF34D399);
  static const _colorEropa  = Color(0xFF818CF8);
  static const _colorKorsel = Color(0xFF0D9488);

  static const _data = SankeyData(
    nodes: [
      SankeyNode(id: 'b_batubara', label: 'Batu Bara',  color: _colorBatubara, type: SankeyNodeType.buyer, subLabel: 'Energi Fosil'),
      SankeyNode(id: 'b_sawit',    label: 'Sawit / CPO', color: _colorSawit,   type: SankeyNodeType.buyer, subLabel: 'Minyak Nabati'),
      SankeyNode(id: 'b_nikel',    label: 'Nikel',       color: _colorNikel,   type: SankeyNodeType.buyer, subLabel: 'Logam & Turunan'),
      SankeyNode(id: 'b_karet',    label: 'Karet',       color: _colorKaret,   type: SankeyNodeType.buyer, subLabel: 'Olahan & Mentah'),
      SankeyNode(id: 'b_tekstil',  label: 'Tekstil',     color: _colorTekstil, type: SankeyNodeType.buyer, subLabel: 'Garmen & Kain'),
      SankeyNode(id: 'b_elek',     label: 'Elektronik',  color: _colorElek,    type: SankeyNodeType.buyer, subLabel: 'Komponen & Perangkat'),
      SankeyNode(id: 's_china',  label: 'China',      color: _colorChina,  type: SankeyNodeType.seller, subLabel: 'Mitra Terbesar'),
      SankeyNode(id: 's_india',  label: 'India',      color: _colorIndia,  type: SankeyNodeType.seller, subLabel: 'Pasar Berkembang'),
      SankeyNode(id: 's_jepang', label: 'Jepang',     color: _colorJepang, type: SankeyNodeType.seller, subLabel: 'Mitra Lama'),
      SankeyNode(id: 's_usa',    label: 'Amerika',    color: _colorUSA,    type: SankeyNodeType.seller, subLabel: 'Pasar Utama'),
      SankeyNode(id: 's_asean',  label: 'ASEAN',      color: _colorASEAN,  type: SankeyNodeType.seller, subLabel: 'Kawasan Regional'),
      SankeyNode(id: 's_eropa',  label: 'Eropa',      color: _colorEropa,  type: SankeyNodeType.seller, subLabel: 'Uni Eropa'),
      SankeyNode(id: 's_korsel', label: 'Korea Sel.', color: _colorKorsel, type: SankeyNodeType.seller, subLabel: 'Industri Baja & EV'),
    ],
    links: [
      SankeyLink(sourceId: 'b_batubara', targetId: 's_china',  value: 14000),
      SankeyLink(sourceId: 'b_batubara', targetId: 's_india',  value: 8000),
      SankeyLink(sourceId: 'b_batubara', targetId: 's_jepang', value: 6000),
      SankeyLink(sourceId: 'b_batubara', targetId: 's_korsel', value: 4000),
      SankeyLink(sourceId: 'b_batubara', targetId: 's_asean',  value: 3000),
      SankeyLink(sourceId: 'b_sawit', targetId: 's_india',  value: 7000),
      SankeyLink(sourceId: 'b_sawit', targetId: 's_china',  value: 5500),
      SankeyLink(sourceId: 'b_sawit', targetId: 's_eropa',  value: 4800),
      SankeyLink(sourceId: 'b_sawit', targetId: 's_asean',  value: 4200),
      SankeyLink(sourceId: 'b_sawit', targetId: 's_usa',    value: 2000),
      SankeyLink(sourceId: 'b_nikel', targetId: 's_china',  value: 16000),
      SankeyLink(sourceId: 'b_nikel', targetId: 's_jepang', value: 2000),
      SankeyLink(sourceId: 'b_nikel', targetId: 's_korsel', value: 1500),
      SankeyLink(sourceId: 'b_nikel', targetId: 's_eropa',  value: 800),
      SankeyLink(sourceId: 'b_karet', targetId: 's_usa',    value: 2200),
      SankeyLink(sourceId: 'b_karet', targetId: 's_china',  value: 1800),
      SankeyLink(sourceId: 'b_karet', targetId: 's_jepang', value: 1500),
      SankeyLink(sourceId: 'b_karet', targetId: 's_eropa',  value: 1200),
      SankeyLink(sourceId: 'b_karet', targetId: 's_india',  value: 300),
      SankeyLink(sourceId: 'b_tekstil', targetId: 's_usa',    value: 3500),
      SankeyLink(sourceId: 'b_tekstil', targetId: 's_eropa',  value: 2500),
      SankeyLink(sourceId: 'b_tekstil', targetId: 's_jepang', value: 1000),
      SankeyLink(sourceId: 'b_tekstil', targetId: 's_asean',  value: 900),
      SankeyLink(sourceId: 'b_elek', targetId: 's_usa',    value: 3000),
      SankeyLink(sourceId: 'b_elek', targetId: 's_china',  value: 2200),
      SankeyLink(sourceId: 'b_elek', targetId: 's_jepang', value: 1800),
      SankeyLink(sourceId: 'b_elek', targetId: 's_eropa',  value: 1600),
      SankeyLink(sourceId: 'b_elek', targetId: 's_asean',  value: 1400),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Komoditas Ekspor Indonesia → Negara Tujuan (Juta USD)',
      buyerLabel: 'Komoditas',
      sellerLabel: 'Negara Tujuan',
      height: 520,
      legendItems: [
        SankeyLegendItem(color: _colorBatubara, label: 'Batu Bara'),
        SankeyLegendItem(color: _colorSawit,    label: 'Sawit / CPO'),
        SankeyLegendItem(color: _colorNikel,    label: 'Nikel'),
        SankeyLegendItem(color: _colorKaret,    label: 'Karet'),
        SankeyLegendItem(color: _colorTekstil,  label: 'Tekstil'),
        SankeyLegendItem(color: _colorElek,     label: 'Elektronik'),
      ],
    );
  }
}
