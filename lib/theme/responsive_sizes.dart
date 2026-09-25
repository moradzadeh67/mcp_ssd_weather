import 'package:flutter/material.dart';

/// Responsive sizes for all screen sizes (5" to 7" and beyond).
class ResponsiveSizes {
  ResponsiveSizes._();

  /// Get scale factor based on screen width.
  ///
  /// - Small phones (5"): ~320-375px width → 0.85
  /// - Medium phones (6"): ~375-430px width → 1.0
  /// - Large phones (7"): ~430-500px width → 1.1
  /// - Tablets: >600px width → 1.2
  static double scaleFactor(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 375) return 0.85;
    if (width < 430) return 1.0;
    if (width < 600) return 1.1;
    return 1.2;
  }

  /// Hourly card height (relative to screen height).
  static double hourlyCardHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.10;
  }

  /// Daily card height (relative to screen height).
  static double dailyCardHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.15;
  }

  /// Forecast card width.
  static double forecastCardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.22).clamp(70.0, 100.0);
  }

  /// Hourly card width.
  static double hourlyCardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.18).clamp(55.0, 78.0);
  }

  /// Font sizes.
  static double fontSizeSmall(BuildContext context) {
    return MediaQuery.sizeOf(context).width * 0.028;
  }

  static double fontSizeMedium(BuildContext context) {
    return MediaQuery.sizeOf(context).width * 0.035;
  }

  static double fontSizeLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width * 0.045;
  }
}
