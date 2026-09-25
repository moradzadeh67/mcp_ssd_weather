import 'package:flutter/material.dart';

/// Centralized theme for mcp_ssd_weather.
///
/// All colors are defined here. Screens should use these constants
/// instead of hardcoded colors.
class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Brand Colors (shared between light & dark)
  // ─────────────────────────────────────────────
  static const Color brandNavy = Color(0xFF0B1D33);
  static const Color brandBlue = Color(0xFF3A6EA5);

  // ─────────────────────────────────────────────
  // Light Theme Colors
  // ─────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // ─────────────────────────────────────────────
  // Dark Theme Colors
  // ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0B1D33);
  static const Color darkSurface = Color(0xFF1A2D45);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B8C4);

  // ─────────────────────────────────────────────
  // Gradients (for weather backgrounds)
  // ─────────────────────────────────────────────
  static const List<Color> gradientClear = [
    Color(0xFF3A6EA5),
    Color(0xFFD98E3B),
  ];
  static const List<Color> gradientCloudy = [
    Color(0xFF3C4B64),
    Color(0xFF708090),
  ];
  static const List<Color> gradientFoggy = [
    Color(0xFF5D6D7E),
    Color(0xFF85929E),
  ];
  static const List<Color> gradientRainy = [
    Color(0xFF2E4053),
    Color(0xFF5D6D7E),
  ];
  static const List<Color> gradientSnowy = [
    Color(0xFF85929E),
    Color(0xFFD5DBDB),
  ];
  static const List<Color> gradientShowers = [
    Color(0xFF34495E),
    Color(0xFF7F8C8D),
  ];
  static const List<Color> gradientThunderstorm = [
    Color(0xFF1A1A2E),
    Color(0xFF4A4A68),
  ];
  static const List<Color> gradientOffline = [
    Color(0xFF2C3E50),
    Color(0xFF555555),
  ];
  static const List<Color> gradientDefault = [
    Color(0xFF0B1D33),
    Color(0xFF4A90E2),
  ];

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandNavy,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBackground,
      cardTheme: CardThemeData(color: lightSurface, elevation: 2),
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandNavy,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardThemeData(color: darkSurface, elevation: 2),
    );
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color textPrimary(BuildContext context) {
    return isDark(context) ? darkTextPrimary : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return isDark(context) ? darkTextSecondary : lightTextSecondary;
  }

  static Color surface(BuildContext context) {
    return isDark(context) ? darkSurface : lightSurface;
  }

  static Color background(BuildContext context) {
    return isDark(context) ? darkBackground : lightBackground;
  }
}
