import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _darkBg = Color(0xFF0D0D1A);
  static const _darkSurface = Color(0xFF1A1A2E);
  static const _darkBorder = Color(0xFF2A2A4A);

  static const _tabLabelStyle =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
  static const _tabUnselectedStyle = TextStyle(fontSize: 13);

  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: _tabLabelStyle,
        unselectedLabelStyle: _tabUnselectedStyle,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: _darkBg,
      colorScheme: const ColorScheme.dark(
        surface: _darkBg,
        surfaceContainerHighest: _darkSurface,
        outline: _darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        indicatorColor: Colors.white,
        labelStyle: _tabLabelStyle,
        unselectedLabelStyle: _tabUnselectedStyle,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white54,
      ),
    );
  }
}
