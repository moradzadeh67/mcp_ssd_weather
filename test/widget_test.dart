import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/city_model.dart';
import 'package:mcp_ssd_weather/models/weather_model.dart';
import 'package:mcp_ssd_weather/pages/city_search_page.dart';
import 'package:mcp_ssd_weather/pages/weather_page.dart';
import 'package:mcp_ssd_weather/services/api_service.dart';
import 'package:mcp_ssd_weather/services/storage_service.dart';
import 'package:mcp_ssd_weather/state/weather_notifier.dart';

class FakeApiService extends ApiService {
  final WeatherModel? weatherToReturn;
  final bool shouldThrow;
  final List<CityModel> citiesToReturn;

  FakeApiService({
    this.weatherToReturn,
    this.shouldThrow = false,
    this.citiesToReturn = const [],
  });

  @override
  Future<WeatherModel> fetchWeather({
    double latitude = 35.6892,
    double longitude = 51.3890,
    String cityName = 'Tehran',
  }) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return weatherToReturn!;
  }

  @override
  Future<List<CityModel>> searchCities(String query) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return citiesToReturn;
  }
}

class FakeStorageService extends StorageService {
  WeatherModel? savedWeather;
  CityModel? savedCity;
  List<CityModel> savedCities = [];
  int? activeCityId;

  @override
  Future<void> saveWeather(WeatherModel weather) async {
    savedWeather = weather;
  }

  @override
  Future<WeatherModel?> loadWeather() async {
    return savedWeather;
  }

  @override
  Future<void> saveSelectedCity(CityModel city) async {
    savedCity = city;
  }

  @override
  Future<CityModel?> loadSelectedCity() async {
    return savedCity;
  }

  @override
  Future<void> saveCities(List<CityModel> cities) async {
    savedCities = cities;
  }

  @override
  Future<List<CityModel>> loadCities() async {
    return savedCities;
  }

  @override
  Future<void> saveActiveCityId(int? id) async {
    activeCityId = id;
  }

  @override
  Future<int?> loadActiveCityId() async {
    return activeCityId;
  }

  @override
  Future<void> clearCache() async {
    savedWeather = null;
    savedCity = null;
    savedCities = [];
    activeCityId = null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const MethodChannel channel = MethodChannel(
      'dev.fluttercommunity.plus/connectivity',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'check') {
            return ['wifi'];
          }
          return null;
        });
  });

  testWidgets('WeatherPage shows loading indicator when status is loading', (
    tester,
  ) async {
    final fakeApi = FakeApiService();
    final fakeStorage = FakeStorageService();
    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    await tester.pumpWidget(MaterialApp(home: WeatherPage(notifier: notifier)));

    // During loading
    expect(find.text('Loading Weather...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('WeatherPage shows weather data when status is success', (
    tester,
  ) async {
    final weather = WeatherModel(
      temperature: 25.5,
      humidity: 60,
      windSpeed: 12.3,
      pressure: 1013.2,
      weatherCode: 0,
      cityName: 'Tehran',
      lastUpdated: DateTime.now(),
      dailyForecasts: [],
    );

    final fakeApi = FakeApiService(weatherToReturn: weather);
    final fakeStorage = FakeStorageService();
    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    // Manually set success state
    await notifier.fetchWeather();

    await tester.pumpWidget(MaterialApp(home: WeatherPage(notifier: notifier)));

    await tester.pumpAndSettle();

    expect(find.text('TEHRAN '), findsOneWidget);
    expect(find.text('26°C'), findsOneWidget); // 25.5 rounded
    expect(find.text('Clear Sky'), findsOneWidget);
  });

  testWidgets('WeatherPage shows error view when status is failure', (
    tester,
  ) async {
    final fakeApi = FakeApiService(shouldThrow: true);
    final fakeStorage = FakeStorageService();
    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    await notifier.fetchWeather();

    await tester.pumpWidget(MaterialApp(home: WeatherPage(notifier: notifier)));

    await tester.pumpAndSettle();

    expect(find.text('Could not load weather data'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('WeatherPage shows offline banner when offline', (tester) async {
    final weather = WeatherModel(
      temperature: 25.5,
      humidity: 60,
      windSpeed: 12.3,
      pressure: 1013.2,
      weatherCode: 0,
      cityName: 'Tehran',
      lastUpdated: DateTime.now(),
      dailyForecasts: [],
    );

    final fakeApi = FakeApiService(shouldThrow: true);
    final fakeStorage = FakeStorageService();
    fakeStorage.savedWeather = weather;

    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    await notifier.initialize();

    await tester.pumpWidget(MaterialApp(home: WeatherPage(notifier: notifier)));

    await tester.pumpAndSettle();

    expect(find.text('Offline: showing saved data'), findsOneWidget);
  });

  testWidgets('CitySearchPage shows empty state initially', (tester) async {
    final fakeApi = FakeApiService();
    final fakeStorage = FakeStorageService();
    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    await tester.pumpWidget(
      MaterialApp(home: CitySearchPage(notifier: notifier)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Type a city name to search'), findsOneWidget);
    expect(find.byIcon(Icons.location_city), findsOneWidget);
  });

  testWidgets('CitySearchPage shows search results', (tester) async {
    final city = CityModel(
      id: 112931,
      name: 'Tehran',
      latitude: 35.6892,
      longitude: 51.3890,
      country: 'Iran',
      admin1: 'Tehran',
      countryCode: 'IR',
    );

    final fakeApi = FakeApiService(citiesToReturn: [city]);
    final fakeStorage = FakeStorageService();
    final notifier = WeatherNotifier(
      apiService: fakeApi,
      storageService: fakeStorage,
    );

    await tester.pumpWidget(
      MaterialApp(home: CitySearchPage(notifier: notifier)),
    );

    // Type in search
    await tester.enterText(find.byType(TextField), 'Tehran');
    await tester.pump(const Duration(milliseconds: 500)); // Wait for debounce
    await tester.pumpAndSettle();

    expect(find.text('Tehran'), findsOneWidget);
  });
}
