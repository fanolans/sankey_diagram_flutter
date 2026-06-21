class ValueFormatter {
  const ValueFormatter._();

  static String format(double value, {int decimals = 2}) {
    final abs = value.abs();
    if (abs >= 1e12) return '${(value / 1e12).toStringAsFixed(decimals)} T';
    if (abs >= 1e9) return '${(value / 1e9).toStringAsFixed(decimals)} B';
    if (abs >= 1e6) return '${(value / 1e6).toStringAsFixed(decimals)} M';
    if (abs >= 1e3) return '${(value / 1e3).toStringAsFixed(decimals)} K';
    return value.toStringAsFixed(decimals);
  }

  static String suffix(double value) {
    final abs = value.abs();
    if (abs >= 1e12) return 'T';
    if (abs >= 1e9) return 'B';
    if (abs >= 1e6) return 'M';
    if (abs >= 1e3) return 'K';
    return '';
  }
}
