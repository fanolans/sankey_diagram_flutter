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
      SankeyNode(id: 'b_batubara', label: 'Coal',          color: _colorBatubara, type: SankeyNodeType.buyer, subLabel: 'Fossil Fuel'),
      SankeyNode(id: 'b_sawit',    label: 'Palm Oil / CPO',color: _colorSawit,    type: SankeyNodeType.buyer, subLabel: 'Vegetable Oil'),
      SankeyNode(id: 'b_nikel',    label: 'Nickel',        color: _colorNikel,    type: SankeyNodeType.buyer, subLabel: 'Metal & Derivatives'),
      SankeyNode(id: 'b_karet',    label: 'Rubber',        color: _colorKaret,    type: SankeyNodeType.buyer, subLabel: 'Processed & Raw'),
      SankeyNode(id: 'b_tekstil',  label: 'Textile',       color: _colorTekstil,  type: SankeyNodeType.buyer, subLabel: 'Garments & Fabric'),
      SankeyNode(id: 'b_elek',     label: 'Electronics',   color: _colorElek,     type: SankeyNodeType.buyer, subLabel: 'Components & Devices'),
      SankeyNode(id: 's_china',  label: 'China',      color: _colorChina,  type: SankeyNodeType.seller, subLabel: 'Largest Partner'),
      SankeyNode(id: 's_india',  label: 'India',      color: _colorIndia,  type: SankeyNodeType.seller, subLabel: 'Emerging Market'),
      SankeyNode(id: 's_jepang', label: 'Japan',      color: _colorJepang, type: SankeyNodeType.seller, subLabel: 'Long-term Partner'),
      SankeyNode(id: 's_usa',    label: 'USA',        color: _colorUSA,    type: SankeyNodeType.seller, subLabel: 'Main Market'),
      SankeyNode(id: 's_asean',  label: 'ASEAN',      color: _colorASEAN,  type: SankeyNodeType.seller, subLabel: 'Regional Bloc'),
      SankeyNode(id: 's_eropa',  label: 'Europe',     color: _colorEropa,  type: SankeyNodeType.seller, subLabel: 'European Union'),
      SankeyNode(id: 's_korsel', label: 'South Korea',color: _colorKorsel, type: SankeyNodeType.seller, subLabel: 'Steel & EV Industry'),
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
      subtitle: 'Indonesian Export Commodities → Destination Countries (Million USD)',
      buyerLabel: 'Commodity',
      sellerLabel: 'Destination',
      height: 520,
      legendItems: [
        SankeyLegendItem(color: _colorBatubara, label: 'Coal'),
        SankeyLegendItem(color: _colorSawit,    label: 'Palm Oil / CPO'),
        SankeyLegendItem(color: _colorNikel,    label: 'Nickel'),
        SankeyLegendItem(color: _colorKaret,    label: 'Rubber'),
        SankeyLegendItem(color: _colorTekstil,  label: 'Textile'),
        SankeyLegendItem(color: _colorElek,     label: 'Electronics'),
      ],
    );
  }
}
