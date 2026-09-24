import 'package:flutter/foundation.dart';

import '../models/settings_model.dart';
import '../services/storage_service.dart';

class SettingsNotifier extends ChangeNotifier {
  final StorageService _storageService;

  SettingsModel _settings = const SettingsModel();

  SettingsNotifier({required StorageService storageService})
    : _storageService = storageService;

  SettingsModel get settings => _settings;

  TemperatureUnit get temperatureUnit => _settings.temperatureUnit;
  AppThemeMode get themeMode => _settings.themeMode;

  /// Load settings from storage
  Future<void> initialize() async {
    final saved = await _storageService.loadSettings();
    if (saved != null) {
      _settings = saved;
      notifyListeners();
    }
  }

  /// Change temperature unit
  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    if (_settings.temperatureUnit == unit) return;
    _settings = _settings.copyWith(temperatureUnit: unit);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  /// Change theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_settings.themeMode == mode) return;
    _settings = _settings.copyWith(themeMode: mode);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  /// Clear all cached weather data (not settings)
  Future<void> clearCache() async {
    await _storageService.clearCache();
    notifyListeners();
  }
}
