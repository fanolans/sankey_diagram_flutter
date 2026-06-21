import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class FinancingRepository implements SankeyRepository {
  const FinancingRepository();

  static const _colorBank      = Color(0xFF3B82F6);
  static const _colorKoperasi  = Color(0xFF10B981);
  static const _colorFintech   = Color(0xFFF97316);
  static const _colorPegadaian = Color(0xFF8B5CF6);
  static const _colorKeluarga  = Color(0xFFFBBF24);

  static const _colorRumah      = Color(0xFFEF4444);
  static const _colorKendaraan  = Color(0xFF38BDF8);
  static const _colorUsaha      = Color(0xFF34D399);
  static const _colorPendidikan = Color(0xFFA78BFA);
  static const _colorRenovasi   = Color(0xFFFF9F43);
  static const _colorKonsumsi   = Color(0xFF9CA3AF);
  static const _colorKesehatan  = Color(0xFF0D9488);

  static const _data = SankeyData(
    nodes: [
      SankeyNode(id: 'b_bank',      label: 'Bank',            color: _colorBank,      type: SankeyNodeType.buyer,  subLabel: 'Mortgage · Auto · Personal'),
      SankeyNode(id: 'b_koperasi',  label: 'Credit Union',    color: _colorKoperasi,  type: SankeyNodeType.buyer,  subLabel: 'Savings & Loans'),
      SankeyNode(id: 'b_fintech',   label: 'Fintech / P2P',   color: _colorFintech,   type: SankeyNodeType.buyer,  subLabel: 'Fintech Lending'),
      SankeyNode(id: 'b_pegadaian', label: 'Pawnshop',        color: _colorPegadaian, type: SankeyNodeType.buyer,  subLabel: 'Collateral & Installment'),
      SankeyNode(id: 'b_keluarga',  label: 'Family / Friends',color: _colorKeluarga,  type: SankeyNodeType.buyer,  subLabel: 'Informal Lending'),
      SankeyNode(id: 's_rumah',      label: 'Home Purchase',  color: _colorRumah,      type: SankeyNodeType.seller, subLabel: 'Mortgage & Property'),
      SankeyNode(id: 's_kendaraan',  label: 'Vehicle',        color: _colorKendaraan,  type: SankeyNodeType.seller, subLabel: 'Motorcycle & Car'),
      SankeyNode(id: 's_usaha',      label: 'Business Capital',color: _colorUsaha,     type: SankeyNodeType.seller, subLabel: 'SME & Entrepreneur'),
      SankeyNode(id: 's_pendidikan', label: 'Education',      color: _colorPendidikan, type: SankeyNodeType.seller, subLabel: 'School & University'),
      SankeyNode(id: 's_renovasi',   label: 'Renovation',     color: _colorRenovasi,   type: SankeyNodeType.seller, subLabel: 'Home Repair'),
      SankeyNode(id: 's_konsumsi',   label: 'Consumption',    color: _colorKonsumsi,   type: SankeyNodeType.seller, subLabel: 'Daily Needs'),
      SankeyNode(id: 's_kesehatan',  label: 'Healthcare',     color: _colorKesehatan,  type: SankeyNodeType.seller, subLabel: 'Medical Expenses'),
    ],
    links: [
      SankeyLink(sourceId: 'b_bank',      targetId: 's_rumah',      value: 8500),
      SankeyLink(sourceId: 'b_bank',      targetId: 's_kendaraan',  value: 5200),
      SankeyLink(sourceId: 'b_bank',      targetId: 's_usaha',      value: 3800),
      SankeyLink(sourceId: 'b_bank',      targetId: 's_renovasi',   value: 1600),
      SankeyLink(sourceId: 'b_bank',      targetId: 's_pendidikan', value: 900),
      SankeyLink(sourceId: 'b_koperasi',  targetId: 's_usaha',      value: 2400),
      SankeyLink(sourceId: 'b_koperasi',  targetId: 's_konsumsi',   value: 1400),
      SankeyLink(sourceId: 'b_koperasi',  targetId: 's_pendidikan', value: 900),
      SankeyLink(sourceId: 'b_koperasi',  targetId: 's_kesehatan',  value: 600),
      SankeyLink(sourceId: 'b_koperasi',  targetId: 's_renovasi',   value: 500),
      SankeyLink(sourceId: 'b_fintech',   targetId: 's_konsumsi',   value: 2800),
      SankeyLink(sourceId: 'b_fintech',   targetId: 's_usaha',      value: 1500),
      SankeyLink(sourceId: 'b_fintech',   targetId: 's_kesehatan',  value: 900),
      SankeyLink(sourceId: 'b_fintech',   targetId: 's_pendidikan', value: 600),
      SankeyLink(sourceId: 'b_fintech',   targetId: 's_kendaraan',  value: 400),
      SankeyLink(sourceId: 'b_pegadaian', targetId: 's_konsumsi',   value: 1800),
      SankeyLink(sourceId: 'b_pegadaian', targetId: 's_usaha',      value: 1100),
      SankeyLink(sourceId: 'b_pegadaian', targetId: 's_kesehatan',  value: 700),
      SankeyLink(sourceId: 'b_pegadaian', targetId: 's_kendaraan',  value: 400),
      SankeyLink(sourceId: 'b_keluarga',  targetId: 's_konsumsi',   value: 1000),
      SankeyLink(sourceId: 'b_keluarga',  targetId: 's_usaha',      value: 700),
      SankeyLink(sourceId: 'b_keluarga',  targetId: 's_kesehatan',  value: 500),
      SankeyLink(sourceId: 'b_keluarga',  targetId: 's_pendidikan', value: 300),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Where people borrow → what they borrow for (Billion IDR)',
      buyerLabel: 'Lender',
      sellerLabel: 'Loan Purpose',
      height: 520,
      legendItems: [
        SankeyLegendItem(color: _colorBank,      label: 'Bank'),
        SankeyLegendItem(color: _colorKoperasi,  label: 'Credit Union'),
        SankeyLegendItem(color: _colorFintech,   label: 'Fintech / P2P'),
        SankeyLegendItem(color: _colorPegadaian, label: 'Pawnshop'),
        SankeyLegendItem(color: _colorKeluarga,  label: 'Family / Friends'),
      ],
    );
  }
}
