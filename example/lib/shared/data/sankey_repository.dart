import '../models/sankey_chart_config.dart';

abstract interface class SankeyRepository {
  Future<SankeyChartConfig> loadConfig();
}
