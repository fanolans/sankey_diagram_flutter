import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class ApbnRepository implements SankeyRepository {
  const ApbnRepository();

  // Column 0 · Sumber Penerimaan
  static const _colPph        = Color(0xFF3B82F6);
  static const _colPpn        = Color(0xFF8B5CF6);
  static const _colCukai      = Color(0xFFF97316);
  static const _colPnbp       = Color(0xFF10B981);
  static const _colPembiayaan = Color(0xFFEF4444);

  // Column 1 · Fungsi Belanja
  static const _colPendidikan = Color(0xFF34D399);
  static const _colInfra      = Color(0xFF60A5FA);
  static const _colKesehatan  = Color(0xFFEC4899);
  static const _colPerlSos    = Color(0xFFFBBF24);
  static const _colPertHan    = Color(0xFF94A3B8);
  static const _colTataKelola = Color(0xFFA78BFA);
  static const _colUtang      = Color(0xFFDC2626);

  // Column 2 · Penerima Manfaat
  static const _colMasyarakat = Color(0xFF22C55E);
  static const _colDaerah     = Color(0xFF0EA5E9);
  static const _colInfraNas   = Color(0xFF64748B);
  static const _colAparatur   = Color(0xFF9333EA);
  static const _colKewNeg     = Color(0xFF6B7280);

  static const _data = SankeyData(
    nodes: [
      // Column 0 : Sumber Penerimaan
      SankeyNode(id: 'rev_pph',   label: 'PPh',            color: _colPph,        column: 0, subLabel: 'Pajak Penghasilan'),
      SankeyNode(id: 'rev_ppn',   label: 'PPN & PPnBM',    color: _colPpn,        column: 0, subLabel: 'Pajak Konsumsi'),
      SankeyNode(id: 'rev_cukai', label: 'Cukai & Bea',    color: _colCukai,      column: 0, subLabel: 'Rokok, Alkohol, Impor'),
      SankeyNode(id: 'rev_pnbp',  label: 'PNBP',           color: _colPnbp,       column: 0, subLabel: 'SDA, BUMN, BLU'),
      SankeyNode(id: 'rev_pemb',  label: 'Pembiayaan',     color: _colPembiayaan, column: 0, subLabel: 'SBN & Pinjaman'),

      // Column 1 : Fungsi Belanja Negara
      SankeyNode(id: 'fnc_pend',  label: 'Pendidikan',              color: _colPendidikan, column: 1, subLabel: 'Riset & Dikti'),
      SankeyNode(id: 'fnc_infra', label: 'Infrastruktur',           color: _colInfra,      column: 1, subLabel: 'Energi & Konektivitas'),
      SankeyNode(id: 'fnc_kes',   label: 'Kesehatan',               color: _colKesehatan,  column: 1, subLabel: 'JKN & Faskes'),
      SankeyNode(id: 'fnc_sos',   label: 'Perlindungan Sosial',     color: _colPerlSos,    column: 1, subLabel: 'PKH, BLT, Sembako'),
      SankeyNode(id: 'fnc_han',   label: 'Pertahanan & Keamanan',   color: _colPertHan,    column: 1, subLabel: 'TNI & Polri'),
      SankeyNode(id: 'fnc_gov',   label: 'Tata Kelola',             color: _colTataKelola, column: 1, subLabel: 'Transfer Daerah & Birokrasi'),
      SankeyNode(id: 'fnc_utang', label: 'Bayar Utang',             color: _colUtang,      column: 1, subLabel: 'Pokok & Bunga'),

      // Column 2 : Penerima Manfaat
      SankeyNode(id: 'ben_mas', label: 'Masyarakat',            color: _colMasyarakat, column: 2, subLabel: 'Program Langsung'),
      SankeyNode(id: 'ben_dae', label: 'Daerah & Desa',         color: _colDaerah,     column: 2, subLabel: 'DAU, DAK, Dana Desa'),
      SankeyNode(id: 'ben_inf', label: 'Infrastruktur Nasional',color: _colInfraNas,   column: 2, subLabel: 'Jalan, Bendungan, Pelabuhan'),
      SankeyNode(id: 'ben_apa', label: 'Aparatur Negara',       color: _colAparatur,   column: 2, subLabel: 'Gaji PNS, TNI & Polri'),
      SankeyNode(id: 'ben_kew', label: 'Kewajiban Negara',      color: _colKewNeg,     column: 2, subLabel: 'Pembayaran Kreditur'),
    ],
    links: [
      // Sumber Penerimaan → Fungsi Belanja
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

      // Fungsi Belanja → Penerima Manfaat
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
      subtitle: 'Perkiraan APBN 2024 — dari Penerimaan hingga Penerima Manfaat  (Triliun IDR)',
      buyerLabel: 'Sumber Penerimaan',
      sellerLabel: 'Penerima Manfaat',
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
        SankeyLegendItem(color: _colPph,        label: 'PPh'),
        SankeyLegendItem(color: _colPpn,        label: 'PPN & PPnBM'),
        SankeyLegendItem(color: _colCukai,      label: 'Cukai & Bea'),
        SankeyLegendItem(color: _colPnbp,       label: 'PNBP'),
        SankeyLegendItem(color: _colPembiayaan, label: 'Pembiayaan Defisit'),
      ],
    );
  }
}
