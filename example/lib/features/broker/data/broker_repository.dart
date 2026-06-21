import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class BrokerRepository implements SankeyRepository {
  const BrokerRepository();

  static const _domestic = Color(0xFF7C3AED);
  static const _bumn     = Color(0xFF10B981);
  static const _foreign  = Color(0xFFEF4444);

  static SankeyData _buildData() {
    const buyers = [
      ('XL', _domestic, 'Domestic'), ('AK', _foreign, 'Foreign'),
      ('YP', _domestic, 'Domestic'), ('KK', _domestic, 'Domestic'),
      ('CC', _bumn,     'BUMN'),     ('DR', _foreign,  'Foreign'),
      ('PD', _domestic, 'Domestic'), ('ZP', _foreign,  'Foreign'),
      ('GR', _domestic, 'Domestic'), ('CP', _domestic, 'Domestic'),
      ('NI', _bumn,     'BUMN'),
    ];
    const sellers = [
      ('AK', _foreign, 'Foreign'),   ('XL', _domestic, 'Domestic'),
      ('YP', _domestic, 'Domestic'), ('CC', _bumn,     'BUMN'),
      ('KK', _domestic, 'Domestic'), ('GR', _domestic, 'Domestic'),
      ('PD', _domestic, 'Domestic'), ('DR', _foreign,  'Foreign'),
      ('ZP', _foreign,  'Foreign'),  ('CP', _domestic, 'Domestic'),
      ('NI', _bumn,     'BUMN'),
    ];
    const links = [
      ('XL', 'AK', 62500.0), ('XL', 'XL', 24800.0), ('XL', 'CC', 11200.0),
      ('XL', 'DR', 8900.0),  ('XL', 'ZP', 5700.0),  ('XL', 'NI', 7400.0),
      ('AK', 'AK', 32400.0), ('AK', 'XL', 28900.0), ('AK', 'YP', 12600.0),
      ('AK', 'NI', 5200.0),
      ('YP', 'YP', 26800.0), ('YP', 'AK', 18200.0), ('YP', 'KK', 9400.0),
      ('YP', 'NI', 3800.0),
      ('KK', 'KK', 22400.0), ('KK', 'XL', 14800.0), ('KK', 'GR', 8200.0),
      ('CC', 'CC', 19200.0), ('CC', 'YP', 12800.0), ('CC', 'AK', 9400.0),
      ('DR', 'DR', 18100.0), ('DR', 'AK', 11600.0), ('DR', 'PD', 7800.0),
      ('DR', 'CP', 4800.0),  ('DR', 'NI', 4100.0),
      ('PD', 'PD', 16400.0), ('PD', 'XL', 10200.0), ('PD', 'GR', 4600.0),
      ('ZP', 'ZP', 14800.0), ('ZP', 'KK', 8600.0),  ('ZP', 'AK', 6400.0),
      ('GR', 'GR', 12800.0), ('GR', 'XL', 7600.0),  ('GR', 'AK', 6200.0),
      ('GR', 'DR', 4600.0),
      ('CP', 'CP', 11400.0), ('CP', 'YP', 6800.0),  ('CP', 'KK', 4600.0),
      ('NI', 'NI', 8600.0),  ('NI', 'AK', 28500.0), ('NI', 'XL', 15200.0),
      ('NI', 'YP', 9800.0),
    ];

    return SankeyData(
      nodes: [
        ...buyers.map((b) => SankeyNode(
              id: 'b_${b.$1}', label: b.$1, color: b.$2,
              type: SankeyNodeType.buyer, subLabel: b.$3,
            )),
        ...sellers.map((s) => SankeyNode(
              id: 's_${s.$1}', label: s.$1, color: s.$2,
              type: SankeyNodeType.seller, subLabel: s.$3,
            )),
      ],
      links: links
          .map((l) => SankeyLink(
                sourceId: 'b_${l.$1}',
                targetId: 's_${l.$2}',
                value: l.$3,
              ))
          .toList(),
    );
  }

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return SankeyChartConfig(
      data: _buildData(),
      subtitle: 'Aliran Transaksi Antar Broker (lot)',
      buyerLabel: 'Buyer',
      sellerLabel: 'Seller',
      height: 620,
      style: const SankeyStyle(
        nodeWidth: 8,
        nodePadding: 8,
        linkOpacity: 0.38,
        hoverOpacity: 0.90,
        dimOpacity: 0.07,
        sortOrder: SortOrder.byValue,
        legendPosition: LegendPosition.bottom,
        verticalPadding: 4,
      ),
      buyerLabelStyle: const TextStyle(
        color: Color(0xFF4ADE80),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      sellerLabelStyle: const TextStyle(
        color: Color(0xFFF87171),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      legendItems: const [
        SankeyLegendItem(color: _domestic, label: 'Domestic'),
        SankeyLegendItem(color: _bumn,     label: 'BUMN'),
        SankeyLegendItem(color: _foreign,  label: 'Foreign'),
      ],
    );
  }
}
