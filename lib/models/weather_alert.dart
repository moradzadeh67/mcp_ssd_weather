import 'package:flutter/material.dart';

enum AlertSeverity {
  low,
  medium,
  high;

  Color get color {
    switch (this) {
      case AlertSeverity.low:
        return const Color(0xFFFFC107); // amber
      case AlertSeverity.medium:
        return const Color(0xFFFF9800); // orange
      case AlertSeverity.high:
        return const Color(0xFFF44336); // red
    }
  }

  IconData get icon {
    switch (this) {
      case AlertSeverity.low:
        return Icons.info_outline;
      case AlertSeverity.medium:
        return Icons.warning_amber;
      case AlertSeverity.high:
        return Icons.error_outline;
    }
  }

  String get label {
    switch (this) {
      case AlertSeverity.low:
        return 'Low';
      case AlertSeverity.medium:
        return 'Moderate';
      case AlertSeverity.high:
        return 'Severe';
    }
  }
}

class WeatherAlert {
  final String title;
  final String message;
  final AlertSeverity severity;
  final IconData icon;

  const WeatherAlert({
    required this.title,
    required this.message,
    required this.severity,
    required this.icon,
  });

  /// Generate alerts from weather data
  static List<WeatherAlert> fromWeather({
    required int weatherCode,
    required double temperature,
    required double windSpeed,
    required int humidity,
  }) {
    final alerts = <WeatherAlert>[];

    // Thunderstorm
    if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99) {
      alerts.add(
        const WeatherAlert(
          title: 'Thunderstorm Warning',
          message: 'Thunderstorms expected. Stay indoors and avoid open areas.',
          severity: AlertSeverity.high,
          icon: Icons.thunderstorm,
        ),
      );
    }

    // Heavy Rain
    if (weatherCode == 65 || weatherCode == 82) {
      alerts.add(
        const WeatherAlert(
          title: 'Heavy Rain Warning',
          message:
              'Heavy rainfall expected. Drive carefully and avoid flooded areas.',
          severity: AlertSeverity.medium,
          icon: Icons.water_drop,
        ),
      );
    }

    // Heavy Snow
    if (weatherCode == 75) {
      alerts.add(
        const WeatherAlert(
          title: 'Heavy Snow Warning',
          message: 'Heavy snowfall expected. Roads may be slippery.',
          severity: AlertSeverity.medium,
          icon: Icons.ac_unit,
        ),
      );
    }

    // Extreme Heat
    if (temperature > 40) {
      alerts.add(
        WeatherAlert(
          title: 'Extreme Heat Warning',
          message:
              'Temperature is ${temperature.round()}°C. Stay hydrated and avoid direct sunlight.',
          severity: AlertSeverity.high,
          icon: Icons.thermostat,
        ),
      );
    }

    // Extreme Cold
    if (temperature < -10) {
      alerts.add(
        WeatherAlert(
          title: 'Extreme Cold Warning',
          message:
              'Temperature is ${temperature.round()}°C. Dress warmly and limit outdoor exposure.',
          severity: AlertSeverity.high,
          icon: Icons.ac_unit,
        ),
      );
    }

    // Strong Wind
    if (windSpeed > 50) {
      alerts.add(
        WeatherAlert(
          title: 'Strong Wind Warning',
          message:
              'Wind speed is ${windSpeed.toStringAsFixed(0)} km/h. Secure loose objects.',
          severity: AlertSeverity.medium,
          icon: Icons.air,
        ),
      );
    }

    // High Humidity
    if (humidity > 90) {
      alerts.add(
        WeatherAlert(
          title: 'High Humidity',
          message: 'Humidity is $humidity%. May feel uncomfortable. Stay cool.',
          severity: AlertSeverity.low,
          icon: Icons.water_drop_outlined,
        ),
      );
    }

    return alerts;
  }
}
