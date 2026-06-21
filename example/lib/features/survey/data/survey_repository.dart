import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class SurveyRepository implements SankeyRepository {
  const SurveyRepository();

  static const _genz = Color(0xFF7C3AED);
  static const _mill = Color(0xFF3B82F6);
  static const _genx = Color(0xFF10B981);
  static const _boom = Color(0xFFF97316);

  static const _data = SankeyData(
    nodes: [
      SankeyNode(id: 'b_genz', label: 'Gen Z',      color: _genz, type: SankeyNodeType.buyer, subLabel: '1997–2012'),
      SankeyNode(id: 'b_mill', label: 'Millennial',  color: _mill, type: SankeyNodeType.buyer, subLabel: '1981–1996'),
      SankeyNode(id: 'b_genx', label: 'Gen X',       color: _genx, type: SankeyNodeType.buyer, subLabel: '1965–1980'),
      SankeyNode(id: 'b_boom', label: 'Boomer',      color: _boom, type: SankeyNodeType.buyer, subLabel: '1946–1964'),
      SankeyNode(id: 's_yt',   label: 'YouTube',   color: Color(0xFFEF4444), type: SankeyNodeType.seller, subLabel: 'Long-form Video'),
      SankeyNode(id: 's_ig',   label: 'Instagram', color: Color(0xFFE879F9), type: SankeyNodeType.seller, subLabel: 'Photos & Reels'),
      SankeyNode(id: 's_nf',   label: 'Netflix',   color: Color(0xFFB91C1C), type: SankeyNodeType.seller, subLabel: 'Streaming'),
      SankeyNode(id: 's_tt',   label: 'TikTok',    color: Color(0xFF06B6D4), type: SankeyNodeType.seller, subLabel: 'Short-form Video'),
      SankeyNode(id: 's_fb',   label: 'Facebook',  color: Color(0xFF2563EB), type: SankeyNodeType.seller, subLabel: 'Social & Groups'),
      SankeyNode(id: 's_news', label: 'News',      color: Color(0xFF78716C), type: SankeyNodeType.seller, subLabel: 'Online Portal'),
      SankeyNode(id: 's_tw',   label: 'Twitter/X', color: Color(0xFF38BDF8), type: SankeyNodeType.seller, subLabel: 'Microblog'),
    ],
    links: [
      SankeyLink(sourceId: 'b_genz', targetId: 's_tt',   value: 9000),
      SankeyLink(sourceId: 'b_genz', targetId: 's_ig',   value: 8000),
      SankeyLink(sourceId: 'b_genz', targetId: 's_yt',   value: 7000),
      SankeyLink(sourceId: 'b_genz', targetId: 's_nf',   value: 4000),
      SankeyLink(sourceId: 'b_genz', targetId: 's_tw',   value: 2000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_yt',   value: 6000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_ig',   value: 5000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_nf',   value: 5000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_tt',   value: 3000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_fb',   value: 2000),
      SankeyLink(sourceId: 'b_mill', targetId: 's_news', value: 1000),
      SankeyLink(sourceId: 'b_genx', targetId: 's_yt',   value: 5000),
      SankeyLink(sourceId: 'b_genx', targetId: 's_fb',   value: 5000),
      SankeyLink(sourceId: 'b_genx', targetId: 's_nf',   value: 3000),
      SankeyLink(sourceId: 'b_genx', targetId: 's_news', value: 2000),
      SankeyLink(sourceId: 'b_genx', targetId: 's_ig',   value: 2000),
      SankeyLink(sourceId: 'b_boom', targetId: 's_yt',   value: 4000),
      SankeyLink(sourceId: 'b_boom', targetId: 's_fb',   value: 4000),
      SankeyLink(sourceId: 'b_boom', targetId: 's_news', value: 3000),
      SankeyLink(sourceId: 'b_boom', targetId: 's_nf',   value: 2000),
      SankeyLink(sourceId: 'b_boom', targetId: 's_tw',   value: 1000),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Digital Platform Usage by Generation (hours/week)',
      buyerLabel: 'Generation',
      sellerLabel: 'Platform',
      height: 460,
      legendItems: [
        SankeyLegendItem(color: _genz, label: 'Gen Z'),
        SankeyLegendItem(color: _mill, label: 'Millennial'),
        SankeyLegendItem(color: _genx, label: 'Gen X'),
        SankeyLegendItem(color: _boom, label: 'Baby Boomer'),
      ],
    );
  }
}
