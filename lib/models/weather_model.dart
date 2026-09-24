class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '🌤️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 95:
      case 96:
      case 99:
        return '⚡';
      default:
        return '🌡️';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'weatherCode': weatherCode,
    };
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time']),
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  // Convert WMO code to Emoji (Same logic as main model)
  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '🌤️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
        return '🌧️';
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 95:
      case 96:
      case 99:
        return '⚡';
      default:
        return '🌡️';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'weatherCode': weatherCode,
    };
  }

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['date']),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
    );
  }
}

class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double pressure;
  final int weatherCode;
  final String cityName;
  final DateTime lastUpdated;
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.weatherCode,
    required this.cityName,
    required this.lastUpdated,
    required this.dailyForecasts,
    this.hourlyForecasts = const [],
  });

  // Factory constructor for creating a WeatherModel from API response JSON
  factory WeatherModel.fromApiJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final List<String> times = List<String>.from(daily['time']);
    final List<double> maxTemps = (daily['temperature_2m_max'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final List<double> minTemps = (daily['temperature_2m_min'] as List)
        .map((e) => (e as num).toDouble())
        .toList();
    final List<int> codes = List<int>.from(daily['weather_code']);

    final forecasts = List.generate(times.length, (i) {
      return DailyForecast(
        date: DateTime.parse(times[i]),
        maxTemp: maxTemps[i],
        minTemp: minTemps[i],
        weatherCode: codes[i],
      );
    });

    List<HourlyForecast> hourlyForecasts = [];
    if (json.containsKey('hourly') && json['hourly'] != null) {
      final hourly = json['hourly'] as Map<String, dynamic>;
      final List<String> hourlyTimes = List<String>.from(hourly['time']);
      final List<double> hourlyTemps = (hourly['temperature_2m'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
      final List<int> hourlyCodes = List<int>.from(hourly['weather_code']);

      // Take first 24 hours
      hourlyForecasts = List.generate(
        hourlyTimes.length > 24 ? 24 : hourlyTimes.length,
        (i) => HourlyForecast(
          time: DateTime.parse(hourlyTimes[i]),
          temperature: hourlyTemps[i],
          weatherCode: hourlyCodes[i],
        ),
      );
    }

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      pressure: (current['surface_pressure'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      cityName: cityName,
      lastUpdated: DateTime.now(),
      dailyForecasts: forecasts,
      hourlyForecasts: hourlyForecasts,
    );
  }

  // Factory constructor for creating a WeatherModel from Saved Local JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
      cityName: json['cityName'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      dailyForecasts: (json['dailyForecasts'] as List)
          .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      hourlyForecasts:
          (json['hourlyForecasts'] as List?)
              ?.map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Convert WeatherModel to JSON map for Local Storage
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'weatherCode': weatherCode,
      'cityName': cityName,
      'lastUpdated': lastUpdated.toIso8601String(),
      'dailyForecasts': dailyForecasts.map((e) => e.toJson()).toList(),
      'hourlyForecasts': hourlyForecasts.map((e) => e.toJson()).toList(),
    };
  }

  // Helper method to get readable weather condition text based on WMO code
  String get weatherCondition {
    switch (weatherCode) {
      case 0:
        return 'Clear Sky';
      case 1:
      case 2:
      case 3:
        return 'Partly Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  // Helper method to get weather emoji
  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '🌤️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
        return '🌧️';
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 95:
      case 96:
      case 99:
        return '⚡';
      default:
        return '🌡️';
    }
  }
}
