import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class ApbnRepository implements SankeyRepository {
  const ApbnRepository();

  // Column 0 · Revenue Sources
  static const _colPph        = Color(0xFF3B82F6);
  static const _colPpn        = Color(0xFF8B5CF6);
  static const _colCukai      = Color(0xFFF97316);
  static const _colPnbp       = Color(0xFF10B981);
  static const _colPembiayaan = Color(0xFFEF4444);

  // Column 1 · Spending Functions
  static const _colPendidikan = Color(0xFF34D399);
  static const _colInfra      = Color(0xFF60A5FA);
  static const _colKesehatan  = Color(0xFFEC4899);
  static const _colPerlSos    = Color(0xFFFBBF24);
  static const _colPertHan    = Color(0xFF94A3B8);
  static const _colTataKelola = Color(0xFFA78BFA);
  static const _colUtang      = Color(0xFFDC2626);

  // Column 2 · Beneficiaries
  static const _colMasyarakat = Color(0xFF22C55E);
  static const _colDaerah     = Color(0xFF0EA5E9);
  static const _colInfraNas   = Color(0xFF64748B);
  static const _colAparatur   = Color(0xFF9333EA);
  static const _colKewNeg     = Color(0xFF6B7280);

  static const _data = SankeyData(
    nodes: [
      // Column 0 : Revenue Sources
      SankeyNode(id: 'rev_pph',   label: 'Income Tax',        color: _colPph,        column: 0, subLabel: 'Personal & Corporate'),
      SankeyNode(id: 'rev_ppn',   label: 'Sales & Luxury Tax',color: _colPpn,        column: 0, subLabel: 'Consumption Tax'),
      SankeyNode(id: 'rev_cukai', label: 'Excise & Customs',  color: _colCukai,      column: 0, subLabel: 'Tobacco, Alcohol, Imports'),
      SankeyNode(id: 'rev_pnbp',  label: 'Non-Tax Revenue',   color: _colPnbp,       column: 0, subLabel: 'Resources, SOEs, BLU'),
      SankeyNode(id: 'rev_pemb',  label: 'Deficit Financing', color: _colPembiayaan, column: 0, subLabel: 'Gov. Bonds & Loans'),

      // Column 1 : State Spending Functions
      SankeyNode(id: 'fnc_pend',  label: 'Education',         color: _colPendidikan, column: 1, subLabel: 'Research & Higher Education'),
      SankeyNode(id: 'fnc_infra', label: 'Infrastructure',    color: _colInfra,      column: 1, subLabel: 'Energy & Connectivity'),
      SankeyNode(id: 'fnc_kes',   label: 'Healthcare',        color: _colKesehatan,  column: 1, subLabel: 'Health Insurance & Facilities'),
      SankeyNode(id: 'fnc_sos',   label: 'Social Protection', color: _colPerlSos,    column: 1, subLabel: 'Family Aid, Cash Transfer, Food'),
      SankeyNode(id: 'fnc_han',   label: 'Defense & Security',color: _colPertHan,    column: 1, subLabel: 'Military & Police'),
      SankeyNode(id: 'fnc_gov',   label: 'Governance',        color: _colTataKelola, column: 1, subLabel: 'Regional Transfers & Bureaucracy'),
      SankeyNode(id: 'fnc_utang', label: 'Debt Repayment',    color: _colUtang,      column: 1, subLabel: 'Principal & Interest'),

      // Column 2 : Beneficiaries
      SankeyNode(id: 'ben_mas', label: 'Public',                color: _colMasyarakat, column: 2, subLabel: 'Direct Programs'),
      SankeyNode(id: 'ben_dae', label: 'Regions & Villages',    color: _colDaerah,     column: 2, subLabel: 'Regional & Village Funds'),
      SankeyNode(id: 'ben_inf', label: 'National Infrastructure',color: _colInfraNas,  column: 2, subLabel: 'Roads, Dams, Ports'),
      SankeyNode(id: 'ben_apa', label: 'State Apparatus',       color: _colAparatur,   column: 2, subLabel: 'Civil Servant & Military Pay'),
      SankeyNode(id: 'ben_kew', label: 'State Obligations',     color: _colKewNeg,     column: 2, subLabel: 'Creditor Payments'),
    ],
    links: [
      // Revenue Sources → Spending Functions
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_pend',  value: 330),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_infra', value: 200),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_kes',   value:  80),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_sos',   value: 150),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_han',   value: 100),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_gov',   value:  90),
      SankeyLink(sourceId: 'rev_pph',   targetId: 'fnc_utang', value:  50),

      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_pend',  value: 200),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_infra', value: 120),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_kes',   value:  60),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_sos',   value: 200),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_han',   value: 100),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_gov',   value:  80),
      SankeyLink(sourceId: 'rev_ppn',   targetId: 'fnc_utang', value:  40),

      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_pend',  value: 130),
      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_infra', value:  10),
      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_kes',   value:  40),
      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_sos',   value:  50),
      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_han',   value:  30),
      SankeyLink(sourceId: 'rev_cukai', targetId: 'fnc_gov',   value:  40),

      SankeyLink(sourceId: 'rev_pnbp',  targetId: 'fnc_infra', value: 100),
      SankeyLink(sourceId: 'rev_pnbp',  targetId: 'fnc_sos',   value: 100),
      SankeyLink(sourceId: 'rev_pnbp',  targetId: 'fnc_han',   value: 100),
      SankeyLink(sourceId: 'rev_pnbp',  targetId: 'fnc_gov',   value: 150),
      SankeyLink(sourceId: 'rev_pnbp',  targetId: 'fnc_utang', value:  50),

      SankeyLink(sourceId: 'rev_pemb',  targetId: 'fnc_gov',   value:  40),
      SankeyLink(sourceId: 'rev_pemb',  targetId: 'fnc_utang', value: 360),

      // Spending Functions → Beneficiaries
      SankeyLink(sourceId: 'fnc_pend',  targetId: 'ben_mas', value: 330),
      SankeyLink(sourceId: 'fnc_pend',  targetId: 'ben_dae', value: 290),
      SankeyLink(sourceId: 'fnc_pend',  targetId: 'ben_apa', value:  40),

      SankeyLink(sourceId: 'fnc_infra', targetId: 'ben_inf', value: 300),
      SankeyLink(sourceId: 'fnc_infra', targetId: 'ben_dae', value:  90),
      SankeyLink(sourceId: 'fnc_infra', targetId: 'ben_mas', value:  40),

      SankeyLink(sourceId: 'fnc_kes',   targetId: 'ben_mas', value: 150),
      SankeyLink(sourceId: 'fnc_kes',   targetId: 'ben_dae', value:  20),
      SankeyLink(sourceId: 'fnc_kes',   targetId: 'ben_apa', value:  10),

      SankeyLink(sourceId: 'fnc_sos',   targetId: 'ben_mas', value: 480),
      SankeyLink(sourceId: 'fnc_sos',   targetId: 'ben_dae', value:  20),

      SankeyLink(sourceId: 'fnc_han',   targetId: 'ben_apa', value: 320),
      SankeyLink(sourceId: 'fnc_han',   targetId: 'ben_kew', value:  10),

      SankeyLink(sourceId: 'fnc_gov',   targetId: 'ben_dae', value: 310),
      SankeyLink(sourceId: 'fnc_gov',   targetId: 'ben_kew', value:  90),

      SankeyLink(sourceId: 'fnc_utang', targetId: 'ben_kew', value: 350),
      SankeyLink(sourceId: 'fnc_utang', targetId: 'ben_mas', value: 100),
      SankeyLink(sourceId: 'fnc_utang', targetId: 'ben_inf', value:  50),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Indonesia State Budget 2024 — from Revenue to Beneficiaries (Trillion IDR)',
      buyerLabel: 'Revenue Sources',
      sellerLabel: 'Beneficiaries',
      height: 600,
      style: SankeyStyle(
        nodeWidth: 9,
        nodePadding: 10,
        linkOpacity: 0.34,
        hoverOpacity: 0.88,
        dimOpacity: 0.05,
        sortOrder: SortOrder.byValue,
        legendPosition: LegendPosition.bottom,
        verticalPadding: 4,
        animationDuration: Duration(milliseconds: 700),
      ),
      legendItems: [
        SankeyLegendItem(color: _colPph,        label: 'Income Tax'),
        SankeyLegendItem(color: _colPpn,        label: 'Sales & Luxury Tax'),
        SankeyLegendItem(color: _colCukai,      label: 'Excise & Customs'),
        SankeyLegendItem(color: _colPnbp,       label: 'Non-Tax Revenue'),
        SankeyLegendItem(color: _colPembiayaan, label: 'Deficit Financing'),
      ],
    );
  }
}
