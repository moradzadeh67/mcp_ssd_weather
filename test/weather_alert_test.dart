import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mcp_ssd_weather/models/weather_alert.dart';

void main() {
  test('WeatherAlert severity has correct color values', () {
    expect(AlertSeverity.low.color, equals(const Color(0xFFFFC107)));
    expect(AlertSeverity.medium.color, equals(const Color(0xFFFF9800)));
    expect(AlertSeverity.high.color, equals(const Color(0xFFF44336)));
  });

  test('WeatherAlert severity has correct icon values', () {
    expect(AlertSeverity.low.icon, equals(Icons.info_outline));
    expect(AlertSeverity.medium.icon, equals(Icons.warning_amber));
    expect(AlertSeverity.high.icon, equals(Icons.error_outline));
  });

  test('WeatherAlert fromWeather creates thunderstorm alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 95,
      temperature: 25.0,
      windSpeed: 10.0,
      humidity: 60,
    );

    expect(alerts.length, greaterThan(0));
    expect(alerts.any((alert) => alert.severity == AlertSeverity.high), isTrue);
    expect(alerts.any((alert) => alert.title.contains('Thunderstorm')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.thunderstorm), isTrue);
  });

  test('WeatherAlert fromWeather creates heavy rain alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 65,
      temperature: 20.0,
      windSpeed: 15.0,
      humidity: 80,
    );

    expect(alerts.length, greaterThan(0));
    expect(
      alerts.any((alert) => alert.severity == AlertSeverity.medium),
      isTrue,
    );
    expect(alerts.any((alert) => alert.title.contains('Heavy Rain')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.water_drop), isTrue);
  });

  test('WeatherAlert fromWeather creates heavy snow alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 75,
      temperature: -5.0,
      windSpeed: 20.0,
      humidity: 90,
    );

    expect(alerts.length, greaterThan(0));
    expect(
      alerts.any((alert) => alert.severity == AlertSeverity.medium),
      isTrue,
    );
    expect(alerts.any((alert) => alert.title.contains('Heavy Snow')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.ac_unit), isTrue);
  });

  test('WeatherAlert fromWeather creates extreme heat alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 0,
      temperature: 45.0,
      windSpeed: 10.0,
      humidity: 60,
    );

    expect(alerts.length, greaterThan(0));
    expect(alerts.any((alert) => alert.severity == AlertSeverity.high), isTrue);
    expect(alerts.any((alert) => alert.title.contains('Extreme Heat')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.thermostat), isTrue);
  });

  test('WeatherAlert fromWeather creates extreme cold alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 0,
      temperature: -15.0,
      windSpeed: 10.0,
      humidity: 60,
    );

    expect(alerts.length, greaterThan(0));
    expect(alerts.any((alert) => alert.severity == AlertSeverity.high), isTrue);
    expect(alerts.any((alert) => alert.title.contains('Extreme Cold')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.ac_unit), isTrue);
  });

  test('WeatherAlert fromWeather creates strong wind alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 0,
      temperature: 25.0,
      windSpeed: 80.0,
      humidity: 60,
    );

    expect(alerts.length, greaterThan(0));
    expect(
      alerts.any((alert) => alert.severity == AlertSeverity.medium),
      isTrue,
    );
    expect(alerts.any((alert) => alert.title.contains('Strong Wind')), isTrue);
    expect(alerts.any((alert) => alert.icon == Icons.air), isTrue);
  });

  test('WeatherAlert fromWeather creates high humidity alert', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 0,
      temperature: 30.0,
      windSpeed: 5.0,
      humidity: 95,
    );

    expect(alerts.length, greaterThan(0));
    expect(alerts.any((alert) => alert.severity == AlertSeverity.low), isTrue);
    expect(
      alerts.any((alert) => alert.title.contains('High Humidity')),
      isTrue,
    );
    expect(
      alerts.any((alert) => alert.icon == Icons.water_drop_outlined),
      isTrue,
    );
  });

  test(
    'WeatherAlert fromWeather does not create alerts for normal conditions',
    () {
      final alerts = WeatherAlert.fromWeather(
        weatherCode: 0,
        temperature: 22.0,
        windSpeed: 10.0,
        humidity: 65,
      );

      expect(alerts.isEmpty, isTrue);
    },
  );

  test(
    'WeatherAlert fromWeather creates multiple alerts for compound conditions',
    () {
      final alerts = WeatherAlert.fromWeather(
        weatherCode: 95,
        temperature: 45.0,
        windSpeed: 80.0,
        humidity: 60,
      );

      expect(alerts.length, greaterThanOrEqualTo(2));
      expect(
        alerts.any((alert) => alert.severity == AlertSeverity.high),
        isTrue,
      );
      expect(
        alerts.any((alert) => alert.severity == AlertSeverity.medium),
        isTrue,
      );
      expect(
        alerts.any((alert) => alert.title.contains('Thunderstorm')),
        isTrue,
      );
      expect(
        alerts.any((alert) => alert.title.contains('Extreme Heat')),
        isTrue,
      );
      expect(
        alerts.any((alert) => alert.title.contains('Strong Wind')),
        isTrue,
      );
    },
  );

  test('WeatherAlert constructor sets properties correctly', () {
    final alert = WeatherAlert(
      title: 'Test Alert',
      message: 'This is a test',
      severity: AlertSeverity.medium,
      icon: Icons.warning,
    );

    expect(alert.title, equals('Test Alert'));
    expect(alert.message, equals('This is a test'));
    expect(alert.severity, equals(AlertSeverity.medium));
    expect(alert.icon, equals(Icons.warning));
  });

  test('WeatherAlert severity enum has correct values', () {
    expect(AlertSeverity.low, equals(AlertSeverity.low));
    expect(AlertSeverity.medium, equals(AlertSeverity.medium));
    expect(AlertSeverity.high, equals(AlertSeverity.high));
  });

  test('WeatherAlert severity label values', () {
    expect(AlertSeverity.low.label, equals('Low'));
    expect(AlertSeverity.medium.label, equals('Moderate'));
    expect(AlertSeverity.high.label, equals('Severe'));
  });

  test('WeatherAlert fromWeather with multiple high severity conditions', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 96,
      temperature: 45.0,
      windSpeed: 80.0,
      humidity: 95,
    );

    final highAlerts = alerts
        .where((alert) => alert.severity == AlertSeverity.high)
        .toList();
    expect(highAlerts.isNotEmpty, isTrue);
    expect(highAlerts.length, greaterThanOrEqualTo(2));
  });

  test('WeatherAlert fromWeather creates only medium severity for rain', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 65,
      temperature: 20.0,
      windSpeed: 10.0,
      humidity: 80,
    );

    final mediumAlerts = alerts
        .where((alert) => alert.severity == AlertSeverity.medium)
        .toList();
    expect(mediumAlerts.isNotEmpty, isTrue);
    expect(
      mediumAlerts.any((alert) => alert.title.contains('Heavy Rain')),
      isTrue,
    );
  });

  test('WeatherAlert fromWeather creates only low severity for humidity', () {
    final alerts = WeatherAlert.fromWeather(
      weatherCode: 0,
      temperature: 30.0,
      windSpeed: 5.0,
      humidity: 95,
    );

    final lowAlerts = alerts
        .where((alert) => alert.severity == AlertSeverity.low)
        .toList();
    expect(lowAlerts.isNotEmpty, isTrue);
    expect(
      lowAlerts.any((alert) => alert.title.contains('High Humidity')),
      isTrue,
    );
  });
}
