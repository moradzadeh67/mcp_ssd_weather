import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/city_model.dart';
import '../models/settings_model.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _fileName = 'cached_weather_data.json';
  static const String _cityFileName = 'selected_city.json';
  static const String _settingsFileName = 'settings.json';
  static const String _savedCitiesFileName = 'saved_cities.json';
  static const String _activeCityIdFileName = 'active_city_id.json';

  // Get path to local file inside app's documents directory
  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  // ==================== Weather Cache ====================

  // Save WeatherModel to local storage as JSON
  Future<void> saveWeather(WeatherModel weather) async {
    try {
      final file = await _getLocalFile(_fileName);
      final jsonString = jsonEncode(weather.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Fail silently or log error
      debugPrint('Error saving cached weather: $e');
    }
  }

  // Load WeatherModel from local storage
  Future<WeatherModel?> loadWeather() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return WeatherModel.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading cached weather: $e');
    }
    return null; // Return null if file doesn't exist or loading fails
  }

  // ==================== Selected City ====================

  // Save selected city to local storage
  Future<void> saveSelectedCity(CityModel city) async {
    try {
      final file = await _getLocalFile(_cityFileName);
      final jsonString = jsonEncode(city.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving selected city: $e');
    }
  }

  // Load selected city from local storage
  Future<CityModel?> loadSelectedCity() async {
    try {
      final file = await _getLocalFile(_cityFileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return CityModel.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading selected city: $e');
    }
    return null;
  }

  // ==================== Saved Cities ====================

  Future<void> saveCities(List<CityModel> cities) async {
    try {
      final file = await _getLocalFile(_savedCitiesFileName);
      final jsonString = jsonEncode(cities.map((c) => c.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving cities: $e');
    }
  }

  Future<List<CityModel>> loadCities() async {
    try {
      final file = await _getLocalFile(_savedCitiesFileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading cities: $e');
    }
    return [];
  }

  Future<void> saveActiveCityId(int? id) async {
    try {
      final file = await _getLocalFile(_activeCityIdFileName);
      await file.writeAsString(jsonEncode({'id': id}));
    } catch (e) {
      debugPrint('Error saving active city id: $e');
    }
  }

  Future<int?> loadActiveCityId() async {
    try {
      final file = await _getLocalFile(_activeCityIdFileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return jsonMap['id'] as int?;
      }
    } catch (e) {
      debugPrint('Error loading active city id: $e');
    }
    return null;
  }

  // ==================== Settings ====================

  // Save SettingsModel to local storage as JSON
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final file = await _getLocalFile(_settingsFileName);
      final jsonString = jsonEncode(settings.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Load SettingsModel from local storage
  Future<SettingsModel?> loadSettings() async {
    try {
      final file = await _getLocalFile(_settingsFileName);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return SettingsModel.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    return null;
  }

  // Clear all cached data
  Future<void> clearCache() async {
    try {
      final weatherFile = await _getLocalFile(_fileName);
      if (await weatherFile.exists()) {
        await weatherFile.delete();
      }
      final cityFile = await _getLocalFile(_cityFileName);
      if (await cityFile.exists()) {
        await cityFile.delete();
      }
      final citiesFile = await _getLocalFile(_savedCitiesFileName);
      if (await citiesFile.exists()) {
        await citiesFile.delete();
      }
      final activeIdFile = await _getLocalFile(_activeCityIdFileName);
      if (await activeIdFile.exists()) {
        await activeIdFile.delete();
      }
    } catch (e) {
      debugPrint('Error deleting cached files: $e');
    }
  }
}
