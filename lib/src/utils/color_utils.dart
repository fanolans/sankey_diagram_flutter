import 'package:flutter/painting.dart';

class ColorUtils {
  const ColorUtils._();

  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color withSaturation(Color color, double saturation) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withSaturation(saturation.clamp(0.0, 1.0)).toColor();
  }

  /// Generates a deterministic, perceptually-spaced colour from [seed] using
  /// golden-angle hue distribution. Useful for auto-assigning colours from API data.
  static Color fromSeed(String seed) {
    var hash = 0;
    for (final c in seed.codeUnits) {
      hash = c + ((hash << 5) - hash);
    }
    // 0.6180339887 = golden-ratio fractional part → spreads hues evenly.
    final hue = ((hash & 0x7fffffff) * 0.6180339887) % 1.0;
    return HSLColor.fromAHSL(1.0, hue * 360, 0.65, 0.50).toColor();
  }
}
