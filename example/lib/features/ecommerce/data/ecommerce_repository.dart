import 'package:flutter/material.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../../../shared/data/sankey_repository.dart';
import '../../../shared/models/sankey_chart_config.dart';

class EcommerceRepository implements SankeyRepository {
  const EcommerceRepository();

  // Column 0 · Traffic Sources
  static const _colSocial  = Color(0xFFE879F9);
  static const _colOrganic = Color(0xFF34D399);
  static const _colAds     = Color(0xFF3B82F6);
  static const _colDirect  = Color(0xFFFBBF24);

  // Column 1 · Product Categories
  static const _colFashion = Color(0xFFEC4899);
  static const _colElek    = Color(0xFF60A5FA);
  static const _colBeauty  = Color(0xFFA78BFA);
  static const _colFood    = Color(0xFF4ADE80);
  static const _colHome    = Color(0xFFFB923C);

  // Column 2 · Payment Methods
  static const _colEwallet  = Color(0xFF06B6D4);
  static const _colCod      = Color(0xFF10B981);
  static const _colPaylater = Color(0xFFF97316);
  static const _colTransfer = Color(0xFF6366F1);

  // Column 3 · Delivery Services
  static const _colSameday = Color(0xFFEF4444);
  static const _colNextday = Color(0xFF8B5CF6);
  static const _colRegular = Color(0xFF64748B);
  static const _colCargo   = Color(0xFF78716C);

  static const _data = SankeyData(
    nodes: [
      // Column 0 : Traffic Sources
      SankeyNode(id: 'src_social',  label: 'Social Media',  color: _colSocial,  column: 0, subLabel: 'Instagram & TikTok'),
      SankeyNode(id: 'src_organic', label: 'Organic / SEO', color: _colOrganic, column: 0, subLabel: 'Google & Bing'),
      SankeyNode(id: 'src_ads',     label: 'Paid Ads',      color: _colAds,     column: 0, subLabel: 'Google & Meta Ads'),
      SankeyNode(id: 'src_direct',  label: 'Direct',        color: _colDirect,  column: 0, subLabel: 'Returning Customers'),

      // Column 1 : Product Categories
      SankeyNode(id: 'cat_fashion', label: 'Fashion',      color: _colFashion, column: 1, subLabel: 'Clothing & Accessories'),
      SankeyNode(id: 'cat_elek',    label: 'Electronics',  color: _colElek,    column: 1, subLabel: 'Gadgets & Devices'),
      SankeyNode(id: 'cat_beauty',  label: 'Beauty',       color: _colBeauty,  column: 1, subLabel: 'Skincare & Cosmetics'),
      SankeyNode(id: 'cat_food',    label: 'Food',         color: _colFood,    column: 1, subLabel: 'FMCG & Grocery'),
      SankeyNode(id: 'cat_home',    label: 'Home & Living',color: _colHome,    column: 1, subLabel: 'Furniture & Appliances'),

      // Column 2 : Payment Methods
      SankeyNode(id: 'pay_ewallet',  label: 'E-Wallet',      color: _colEwallet,  column: 2, subLabel: 'GoPay & OVO & Dana'),
      SankeyNode(id: 'pay_cod',      label: 'COD',           color: _colCod,      column: 2, subLabel: 'Cash on Delivery'),
      SankeyNode(id: 'pay_paylater', label: 'Paylater',      color: _colPaylater, column: 2, subLabel: '0% Installment'),
      SankeyNode(id: 'pay_transfer', label: 'Bank Transfer', color: _colTransfer, column: 2, subLabel: 'Virtual Account & Bank'),

      // Column 3 : Delivery Services
      SankeyNode(id: 'del_sameday', label: 'Same Day', color: _colSameday, column: 3, subLabel: 'Same-day in city'),
      SankeyNode(id: 'del_nextday', label: 'Next Day', color: _colNextday, column: 3, subLabel: 'H+1'),
      SankeyNode(id: 'del_regular', label: 'Regular',  color: _colRegular, column: 3, subLabel: '2–5 Days'),
      SankeyNode(id: 'del_cargo',   label: 'Cargo',    color: _colCargo,   column: 3, subLabel: 'Heavy & Bulk'),
    ],
    links: [
      // Traffic → Product Categories
      SankeyLink(sourceId: 'src_social',  targetId: 'cat_fashion', value: 15000),
      SankeyLink(sourceId: 'src_social',  targetId: 'cat_beauty',  value: 10000),
      SankeyLink(sourceId: 'src_social',  targetId: 'cat_food',    value:  3000),
      SankeyLink(sourceId: 'src_social',  targetId: 'cat_elek',    value:  1500),
      SankeyLink(sourceId: 'src_social',  targetId: 'cat_home',    value:   500),

      SankeyLink(sourceId: 'src_organic', targetId: 'cat_elek',    value: 10000),
      SankeyLink(sourceId: 'src_organic', targetId: 'cat_fashion', value:  7000),
      SankeyLink(sourceId: 'src_organic', targetId: 'cat_home',    value:  4000),
      SankeyLink(sourceId: 'src_organic', targetId: 'cat_beauty',  value:  3000),
      SankeyLink(sourceId: 'src_organic', targetId: 'cat_food',    value:  1000),

      SankeyLink(sourceId: 'src_ads',     targetId: 'cat_fashion', value:  9000),
      SankeyLink(sourceId: 'src_ads',     targetId: 'cat_beauty',  value:  7000),
      SankeyLink(sourceId: 'src_ads',     targetId: 'cat_elek',    value:  5000),
      SankeyLink(sourceId: 'src_ads',     targetId: 'cat_food',    value:  3000),
      SankeyLink(sourceId: 'src_ads',     targetId: 'cat_home',    value:  1000),

      SankeyLink(sourceId: 'src_direct',  targetId: 'cat_food',    value:  8000),
      SankeyLink(sourceId: 'src_direct',  targetId: 'cat_home',    value:  4500),
      SankeyLink(sourceId: 'src_direct',  targetId: 'cat_fashion', value:  4000),
      SankeyLink(sourceId: 'src_direct',  targetId: 'cat_elek',    value:  3500),

      // Product Categories → Payment
      SankeyLink(sourceId: 'cat_fashion', targetId: 'pay_ewallet',  value: 18000),
      SankeyLink(sourceId: 'cat_fashion', targetId: 'pay_cod',      value: 10000),
      SankeyLink(sourceId: 'cat_fashion', targetId: 'pay_paylater', value:  5000),
      SankeyLink(sourceId: 'cat_fashion', targetId: 'pay_transfer', value:  2000),

      SankeyLink(sourceId: 'cat_elek',    targetId: 'pay_paylater', value: 10000),
      SankeyLink(sourceId: 'cat_elek',    targetId: 'pay_transfer', value:  5000),
      SankeyLink(sourceId: 'cat_elek',    targetId: 'pay_ewallet',  value:  4000),
      SankeyLink(sourceId: 'cat_elek',    targetId: 'pay_cod',      value:  1000),

      SankeyLink(sourceId: 'cat_beauty',  targetId: 'pay_ewallet',  value: 12000),
      SankeyLink(sourceId: 'cat_beauty',  targetId: 'pay_cod',      value:  5000),
      SankeyLink(sourceId: 'cat_beauty',  targetId: 'pay_paylater', value:  2000),
      SankeyLink(sourceId: 'cat_beauty',  targetId: 'pay_transfer', value:  1000),

      SankeyLink(sourceId: 'cat_food',    targetId: 'pay_cod',      value: 10000),
      SankeyLink(sourceId: 'cat_food',    targetId: 'pay_ewallet',  value:  3000),
      SankeyLink(sourceId: 'cat_food',    targetId: 'pay_paylater', value:  1000),
      SankeyLink(sourceId: 'cat_food',    targetId: 'pay_transfer', value:  1000),

      SankeyLink(sourceId: 'cat_home',    targetId: 'pay_cod',      value:  4000),
      SankeyLink(sourceId: 'cat_home',    targetId: 'pay_ewallet',  value:  3000),
      SankeyLink(sourceId: 'cat_home',    targetId: 'pay_paylater', value:  2000),
      SankeyLink(sourceId: 'cat_home',    targetId: 'pay_transfer', value:  1000),

      // Payment → Delivery
      SankeyLink(sourceId: 'pay_ewallet',  targetId: 'del_sameday', value: 20000),
      SankeyLink(sourceId: 'pay_ewallet',  targetId: 'del_nextday', value: 14000),
      SankeyLink(sourceId: 'pay_ewallet',  targetId: 'del_regular', value:  5000),
      SankeyLink(sourceId: 'pay_ewallet',  targetId: 'del_cargo',   value:  1000),

      SankeyLink(sourceId: 'pay_cod',      targetId: 'del_sameday', value: 12000),
      SankeyLink(sourceId: 'pay_cod',      targetId: 'del_nextday', value:  8000),
      SankeyLink(sourceId: 'pay_cod',      targetId: 'del_regular', value:  9000),
      SankeyLink(sourceId: 'pay_cod',      targetId: 'del_cargo',   value:  1000),

      SankeyLink(sourceId: 'pay_paylater', targetId: 'del_nextday', value:  6000),
      SankeyLink(sourceId: 'pay_paylater', targetId: 'del_regular', value:  8000),
      SankeyLink(sourceId: 'pay_paylater', targetId: 'del_sameday', value:  2000),
      SankeyLink(sourceId: 'pay_paylater', targetId: 'del_cargo',   value:  4000),

      SankeyLink(sourceId: 'pay_transfer', targetId: 'del_regular', value:  3000),
      SankeyLink(sourceId: 'pay_transfer', targetId: 'del_nextday', value:  2000),
      SankeyLink(sourceId: 'pay_transfer', targetId: 'del_sameday', value:  1000),
      SankeyLink(sourceId: 'pay_transfer', targetId: 'del_cargo',   value:  4000),
    ],
  );

  @override
  Future<SankeyChartConfig> loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const SankeyChartConfig(
      data: _data,
      subtitle: 'Customer Journey: Traffic → Category → Payment → Delivery (orders/month)',
      buyerLabel: 'Traffic Sources',
      sellerLabel: 'Delivery',
      height: 580,
      style: SankeyStyle(
        nodeWidth: 7,
        nodePadding: 8,
        linkOpacity: 0.36,
        hoverOpacity: 0.88,
        dimOpacity: 0.06,
        sortOrder: SortOrder.byValue,
        legendPosition: LegendPosition.bottom,
        verticalPadding: 4,
      ),
      legendItems: [
        SankeyLegendItem(color: _colSocial,  label: 'Social Media'),
        SankeyLegendItem(color: _colOrganic, label: 'Organic / SEO'),
        SankeyLegendItem(color: _colAds,     label: 'Paid Ads'),
        SankeyLegendItem(color: _colDirect,  label: 'Direct / Repeat'),
      ],
    );
  }
}
