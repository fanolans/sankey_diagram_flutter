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
      SankeyNode(id: 'b_bank',      label: 'Bank',            color: _colorBank,      type: SankeyNodeType.buyer,  subLabel: 'KPR · KKB · KTA'),
      SankeyNode(id: 'b_koperasi',  label: 'Koperasi',        color: _colorKoperasi,  type: SankeyNodeType.buyer,  subLabel: 'Simpan Pinjam'),
      SankeyNode(id: 'b_fintech',   label: 'Pinjol / P2P',    color: _colorFintech,   type: SankeyNodeType.buyer,  subLabel: 'Fintech Lending'),
      SankeyNode(id: 'b_pegadaian', label: 'Pegadaian',       color: _colorPegadaian, type: SankeyNodeType.buyer,  subLabel: 'Gadai & Cicilan'),
      SankeyNode(id: 'b_keluarga',  label: 'Keluarga/Teman',  color: _colorKeluarga,  type: SankeyNodeType.buyer,  subLabel: 'Pinjam Informal'),
      SankeyNode(id: 's_rumah',      label: 'Beli Rumah',    color: _colorRumah,      type: SankeyNodeType.seller, subLabel: 'KPR & Properti'),
      SankeyNode(id: 's_kendaraan',  label: 'Kendaraan',     color: _colorKendaraan,  type: SankeyNodeType.seller, subLabel: 'Motor & Mobil'),
      SankeyNode(id: 's_usaha',      label: 'Modal Usaha',   color: _colorUsaha,      type: SankeyNodeType.seller, subLabel: 'UMKM & Wirausaha'),
      SankeyNode(id: 's_pendidikan', label: 'Pendidikan',    color: _colorPendidikan, type: SankeyNodeType.seller, subLabel: 'Sekolah & Kuliah'),
      SankeyNode(id: 's_renovasi',   label: 'Renovasi',      color: _colorRenovasi,   type: SankeyNodeType.seller, subLabel: 'Perbaikan Rumah'),
      SankeyNode(id: 's_konsumsi',   label: 'Konsumsi',      color: _colorKonsumsi,   type: SankeyNodeType.seller, subLabel: 'Kebutuhan Harian'),
      SankeyNode(id: 's_kesehatan',  label: 'Kesehatan',     color: _colorKesehatan,  type: SankeyNodeType.seller, subLabel: 'Biaya Medis'),
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
      subtitle: 'Dari mana orang meminjam → untuk apa pinjamannya (Miliar IDR)',
      buyerLabel: 'Tempat Meminjam',
      sellerLabel: 'Tujuan Pinjaman',
      height: 520,
      legendItems: [
        SankeyLegendItem(color: _colorBank,      label: 'Bank'),
        SankeyLegendItem(color: _colorKoperasi,  label: 'Koperasi'),
        SankeyLegendItem(color: _colorFintech,   label: 'Pinjol / P2P'),
        SankeyLegendItem(color: _colorPegadaian, label: 'Pegadaian'),
        SankeyLegendItem(color: _colorKeluarga,  label: 'Keluarga/Teman'),
      ],
    );
  }
}
