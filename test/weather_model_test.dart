import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('fromApiJson parses current and hourly weather correctly', () {
      final json = {
        'current': {
          'temperature_2m': 25.5,
          'relative_humidity_2m': 60,
          'weather_code': 1,
          'wind_speed_10m': 12.3,
          'surface_pressure': 1013.2,
        },
        'daily': {
          'time': ['2026-01-01', '2026-01-02'],
          'temperature_2m_max': [28.0, 30.0],
          'temperature_2m_min': [18.0, 20.0],
          'weather_code': [1, 2],
        },
        'hourly': {
          'time': ['2026-01-01T00:00', '2026-01-01T01:00'],
          'temperature_2m': [20.0, 21.0],
          'weather_code': [0, 1],
        },
      };

      final weather = WeatherModel.fromApiJson(json, 'Tehran');

      expect(weather.temperature, 25.5);
      expect(weather.humidity, 60);
      expect(weather.windSpeed, 12.3);
      expect(weather.pressure, 1013.2);
      expect(weather.weatherCode, 1);
      expect(weather.cityName, 'Tehran');
      expect(weather.dailyForecasts.length, 2);
      expect(weather.hourlyForecasts.length, 2);
      expect(weather.hourlyForecasts[0].temperature, 20.0);
      expect(weather.hourlyForecasts[0].weatherCode, 0);
    });

    test('weatherCondition returns correct text for each WMO code', () {
      final codes = {
        0: 'Clear Sky',
        1: 'Partly Cloudy',
        2: 'Partly Cloudy',
        3: 'Partly Cloudy',
        45: 'Foggy',
        48: 'Foggy',
        51: 'Drizzle',
        61: 'Rainy',
        71: 'Snowy',
        80: 'Rain Showers',
        95: 'Thunderstorm',
        99: 'Thunderstorm',
      };

      for (final entry in codes.entries) {
        final weather = WeatherModel(
          temperature: 20,
          humidity: 50,
          windSpeed: 10,
          pressure: 1000,
          weatherCode: entry.key,
          cityName: 'Test',
          lastUpdated: DateTime.now(),
          dailyForecasts: [],
          hourlyForecasts: [],
        );
        expect(weather.weatherCondition, entry.value);
      }
    });

    test('weatherEmoji returns correct emoji for each WMO code', () {
      final codes = {
        0: '☀️',
        1: '🌤️',
        45: '🌫️',
        61: '🌧️',
        71: '❄️',
        80: '🌦️',
        95: '⚡',
      };

      for (final entry in codes.entries) {
        final weather = WeatherModel(
          temperature: 20,
          humidity: 50,
          windSpeed: 10,
          pressure: 1000,
          weatherCode: entry.key,
          cityName: 'Test',
          lastUpdated: DateTime.now(),
          dailyForecasts: [],
          hourlyForecasts: [],
        );
        expect(weather.weatherEmoji, entry.value);
      }
    });

    test('toJson and fromJson round-trip correctly', () {
      final original = WeatherModel(
        temperature: 25.5,
        humidity: 60,
        windSpeed: 12.3,
        pressure: 1013.2,
        weatherCode: 1,
        cityName: 'Tehran',
        lastUpdated: DateTime(2026, 1, 1, 12, 0),
        dailyForecasts: [
          DailyForecast(
            date: DateTime(2026, 1, 1),
            maxTemp: 28.0,
            minTemp: 18.0,
            weatherCode: 1,
          ),
        ],
        hourlyForecasts: [
          HourlyForecast(
            time: DateTime(2026, 1, 1, 12, 0),
            temperature: 25.0,
            weatherCode: 0,
          ),
        ],
      );

      final json = original.toJson();
      final restored = WeatherModel.fromJson(json);

      expect(restored.temperature, original.temperature);
      expect(restored.humidity, original.humidity);
      expect(restored.cityName, original.cityName);
      expect(restored.dailyForecasts.length, 1);
      expect(restored.dailyForecasts[0].maxTemp, 28.0);
      expect(restored.hourlyForecasts.length, 1);
      expect(restored.hourlyForecasts[0].temperature, 25.0);
    });
  });

  group('DailyForecast', () {
    test('weatherEmoji returns correct emoji', () {
      final forecast = DailyForecast(
        date: DateTime(2026, 1, 1),
        maxTemp: 25,
        minTemp: 15,
        weatherCode: 0,
      );
      expect(forecast.weatherEmoji, '☀️');
    });

    test('toJson and fromJson round-trip correctly', () {
      final original = DailyForecast(
        date: DateTime(2026, 1, 1),
        maxTemp: 25.5,
        minTemp: 15.5,
        weatherCode: 1,
      );
      final restored = DailyForecast.fromJson(original.toJson());

      expect(restored.date, original.date);
      expect(restored.maxTemp, original.maxTemp);
      expect(restored.minTemp, original.minTemp);
      expect(restored.weatherCode, original.weatherCode);
    });
  });

  group('HourlyForecast', () {
    test('weatherEmoji returns correct emoji', () {
      final forecast = HourlyForecast(
        time: DateTime(2026, 1, 1, 12),
        temperature: 25,
        weatherCode: 0,
      );
      expect(forecast.weatherEmoji, '☀️');
    });

    test('toJson and fromJson round-trip correctly', () {
      final original = HourlyForecast(
        time: DateTime(2026, 1, 1, 12),
        temperature: 25.5,
        weatherCode: 1,
      );
      final restored = HourlyForecast.fromJson(original.toJson());

      expect(restored.time, original.time);
      expect(restored.temperature, original.temperature);
      expect(restored.weatherCode, original.weatherCode);
    });
  });
}
