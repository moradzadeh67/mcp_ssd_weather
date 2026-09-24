import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/settings_model.dart';

void main() {
  group('SettingsModel Unit Tests', () {
    test('default constructor initializes with Celsius', () {
      const settings = SettingsModel();
      expect(settings.temperatureUnit, TemperatureUnit.celsius);
    });

    test('copyWith updates properties correctly', () {
      const settings = SettingsModel();
      final updated = settings.copyWith(
        temperatureUnit: TemperatureUnit.fahrenheit,
      );

      expect(updated.temperatureUnit, TemperatureUnit.fahrenheit);
    });

    test('toJson and fromJson work bidirectionally', () {
      const original = SettingsModel(temperatureUnit: TemperatureUnit.kelvin);

      final json = original.toJson();
      final parsed = SettingsModel.fromJson(json);

      expect(parsed.temperatureUnit, TemperatureUnit.kelvin);
    });

    test(
      'fromJson handles invalid or missing keys gracefully with defaults',
      () {
        final parsed = SettingsModel.fromJson({});
        expect(parsed.temperatureUnit, TemperatureUnit.celsius);
      },
    );

    test(
      'convertTemperature converts Celsius to Fahrenheit and Kelvin correctly',
      () {
        const celsiusSettings = SettingsModel(
          temperatureUnit: TemperatureUnit.celsius,
        );
        const fahrenheitSettings = SettingsModel(
          temperatureUnit: TemperatureUnit.fahrenheit,
        );
        const kelvinSettings = SettingsModel(
          temperatureUnit: TemperatureUnit.kelvin,
        );

        expect(celsiusSettings.convertTemperature(25.0), 25.0);
        expect(fahrenheitSettings.convertTemperature(0.0), 32.0);
        expect(fahrenheitSettings.convertTemperature(25.0), 77.0);
        expect(kelvinSettings.convertTemperature(0.0), 273.15);
      },
    );

    test('TemperatureUnit getters return expected symbols and labels', () {
      expect(TemperatureUnit.celsius.symbol, '°C');
      expect(TemperatureUnit.fahrenheit.symbol, '°F');
      expect(TemperatureUnit.kelvin.symbol, 'K');

      expect(TemperatureUnit.celsius.label, 'Celsius (°C)');
      expect(TemperatureUnit.fahrenheit.label, 'Fahrenheit (°F)');
      expect(TemperatureUnit.kelvin.label, 'Kelvin (K)');
    });
  });
}
