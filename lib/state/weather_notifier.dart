import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/city_model.dart';
import '../models/weather_model.dart';
import '../models/weather_alert.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// Enum to represent different Loading/Error states of the app
enum WeatherStatus { loading, success, failure }

class WeatherNotifier extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherNotifier({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  WeatherStatus _status = WeatherStatus.loading;
  WeatherModel? _weather;
  bool _isOffline = false;
  String? _errorMessage;

  // Weather alerts state
  List<WeatherAlert> _alerts = [];
  List<WeatherAlert> get alerts => _alerts;

  // City search state
  CityModel? _selectedCity;
  bool _isSearching = false;
  List<CityModel> _searchResults = [];
  String? _searchError;

  // Saved cities state (max 5)
  List<CityModel> _savedCities = [];
  static const int maxCities = 5;

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  CityModel? get selectedCity => _selectedCity;
  bool get isSearching => _isSearching;
  List<CityModel> get searchResults => _searchResults;
  String? get searchError => _searchError;

  List<CityModel> get savedCities => _savedCities;
  int get maxCitiesAllowed => maxCities;
  bool get canAddMoreCities => _savedCities.length < maxCities;

  // Initialize App: Load saved city, cached data, then fetch fresh from internet
  Future<void> initialize() async {
    _savedCities = await _storageService.loadCities();
    final activeId = await _storageService.loadActiveCityId();
    if (activeId != null && _savedCities.isNotEmpty) {
      _selectedCity = _savedCities.firstWhere(
        (c) => c.id == activeId,
        orElse: () => _savedCities.first,
      );
    } else if (_savedCities.isNotEmpty) {
      _selectedCity = _savedCities.first;
    } else {
      _selectedCity = await _storageService.loadSelectedCity();
    }

    _weather = await _storageService.loadWeather();

    // If we have cached weather, show it immediately while fetching fresh data in background
    if (_weather != null) {
      _status = WeatherStatus.success;
      _isOffline = true; // Temporary status until background fetch finishes
      notifyListeners();
    }

    await fetchWeather();
  }

  // Fetch weather data from internet (for selected city, or default Tehran)
  Future<void> fetchWeather() async {
    // Only show loading if we don't have ANY data (initial state or city change)
    if (_weather == null || _status == WeatherStatus.failure) {
      _status = WeatherStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      // Check for internet connection before making the request
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasNoInternet = connectivityResult.contains(
        ConnectivityResult.none,
      );

      if (hasNoInternet) {
        throw const NoInternetException();
      }

      final city = _selectedCity;
      final freshWeather = city == null
          ? await _apiService.fetchWeather()
          : await _apiService.fetchWeather(
              latitude: city.latitude,
              longitude: city.longitude,
              cityName: city.displayName,
            );
      _weather = freshWeather;
      _isOffline = false;
      _status = WeatherStatus.success;
      _errorMessage = null;
      // Generate weather alerts based on fresh weather data
      _alerts = WeatherAlert.fromWeather(
        weatherCode: freshWeather.weatherCode,
        temperature: freshWeather.temperature,
        windSpeed: freshWeather.windSpeed,
        humidity: freshWeather.humidity,
      );

      // Save fresh data to local storage for offline fallback
      await _storageService.saveWeather(freshWeather);
    } catch (e) {
      // Clear alerts when an error occurs
      _alerts = [];
      if (_weather != null) {
        // Cached data exists -> show offline mode
        _isOffline = true;
        _status = WeatherStatus.success;
        _errorMessage = null;
      } else {
        // No cache -> show error
        _isOffline = false;
        _status = WeatherStatus.failure;
        if (e is ApiException) {
          _errorMessage = e.userMessage;
        } else {
          _errorMessage = 'Something went wrong. Please try again.';
        }
      }
    }
    notifyListeners();
  }

  // Set the searching state immediately (to show loader and clear old errors)
  void startSearch() {
    _isSearching = true;
    _searchError = null;
    _searchResults = [];
    notifyListeners();
  }

  // Search for cities using the Geocoding API
  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
      _searchError = null;
      notifyListeners();
      return;
    }

    // Ensure state is correctly set if startSearch wasn't called manually
    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      final rawResults = await _apiService.searchCities(query);
      final lowercaseQuery = query.trim().toLowerCase();

      // Filter results to only keep those containing the query in name, country, or admin1
      _searchResults = rawResults.where((city) {
        return city.name.toLowerCase().contains(lowercaseQuery) ||
            (city.country != null &&
                city.country!.toLowerCase().contains(lowercaseQuery)) ||
            (city.admin1 != null &&
                city.admin1!.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      _searchResults = [];
      _searchError = 'Search failed. Please check your connection.';
    }
    _isSearching = false;
    notifyListeners();
  }

  // Select a city and fetch its weather (connected to addCity)
  Future<void> selectCity(CityModel city) async {
    await addCity(city);
  }

  // Add a city to the saved list (max 5)
  Future<bool> addCity(CityModel city) async {
    if (_savedCities.length >= maxCities) {
      return false;
    }
    if (_savedCities.any((c) => c.id == city.id)) {
      // Already exists, just switch to it
      await switchCity(city);
      return true;
    }
    _savedCities.add(city);
    await _storageService.saveCities(_savedCities);
    await switchCity(city);
    return true;
  }

  // Remove a city from the saved list
  Future<void> removeCity(CityModel city) async {
    _savedCities.removeWhere((c) => c.id == city.id);
    await _storageService.saveCities(_savedCities);

    // If removed city was active, switch to first available or default
    if (_selectedCity?.id == city.id) {
      if (_savedCities.isNotEmpty) {
        await switchCity(_savedCities.first);
      } else {
        _selectedCity = null;
        await _storageService.saveActiveCityId(null);
        await _storageService.saveSelectedCity(
          CityModel(
            id: 0,
            name: 'Tehran',
            latitude: 35.6892,
            longitude: 51.3890,
            countryCode: 'IR',
          ),
        );
        await fetchWeather();
      }
    }
    notifyListeners();
  }

  // Switch to a different city
  Future<void> switchCity(CityModel city) async {
    _selectedCity = city;
    await _storageService.saveActiveCityId(city.id);
    await _storageService.saveSelectedCity(city);
    await fetchWeather();
    notifyListeners();
  }

  // Rename a city (set or clear custom label)
  Future<void> renameCity(CityModel city, String? newLabel) async {
    final index = _savedCities.indexWhere((c) => c.id == city.id);
    if (index == -1) return;

    final trimmed = newLabel?.trim();
    final label = (trimmed == null || trimmed.isEmpty) ? null : trimmed;

    final updated = CityModel(
      id: city.id,
      name: city.name,
      customLabel: label, // میتونه null باشه
      latitude: city.latitude,
      longitude: city.longitude,
      country: city.country,
      admin1: city.admin1,
      countryCode: city.countryCode,
      population: city.population,
    );

    _savedCities[index] = updated;

    // Update selected city if it's the same
    if (_selectedCity?.id == city.id) {
      _selectedCity = updated;
      await _storageService.saveSelectedCity(updated);
      await fetchWeather();
    }

    await _storageService.saveCities(_savedCities);
    notifyListeners();
  }

  // Reset search state (e.g. when entering the search page)
  void resetSearch() {
    _isSearching = false;
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }
}
