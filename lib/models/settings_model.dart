import 'package:flutter/material.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin;

  String get symbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.kelvin:
        return 'K';
    }
  }

  String get label {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius (°C)';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit (°F)';
      case TemperatureUnit.kelvin:
        return 'Kelvin (K)';
    }
  }
}

enum AppThemeMode {
  system,
  light,
  dark;

  String get label {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

class SettingsModel {
  final TemperatureUnit temperatureUnit;
  final AppThemeMode themeMode;

  const SettingsModel({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.themeMode = AppThemeMode.system,
  });

  SettingsModel copyWith({
    TemperatureUnit? temperatureUnit,
    AppThemeMode? themeMode,
  }) {
    return SettingsModel(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatureUnit': temperatureUnit.name,
      'themeMode': themeMode.name,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      temperatureUnit: TemperatureUnit.values.firstWhere(
        (u) => u.name == json['temperatureUnit'],
        orElse: () => TemperatureUnit.celsius,
      ),
      themeMode: AppThemeMode.values.firstWhere(
        (t) => t.name == json['themeMode'],
        orElse: () => AppThemeMode.system,
      ),
    );
  }

  /// Convert Celsius temperature to the selected unit
  double convertTemperature(double celsius) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return celsius + 273.15;
    }
  }
}
