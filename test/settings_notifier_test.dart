import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/settings_model.dart';
import 'package:mcp_ssd_weather/services/storage_service.dart';
import 'package:mcp_ssd_weather/state/settings_notifier.dart';

class FakeStorageService extends StorageService {
  SettingsModel? _savedSettings;
  bool cacheCleared = false;

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    _savedSettings = settings;
  }

  @override
  Future<SettingsModel?> loadSettings() async {
    return _savedSettings;
  }

  @override
  Future<void> clearCache() async {
    cacheCleared = true;
  }
}

void main() {
  group('SettingsNotifier Tests', () {
    late FakeStorageService fakeStorage;
    late SettingsNotifier notifier;

    setUp(() {
      fakeStorage = FakeStorageService();
      notifier = SettingsNotifier(storageService: fakeStorage);
    });

    test('initial state has default settings', () {
      expect(notifier.temperatureUnit, TemperatureUnit.celsius);
    });

    test('initialize loads saved settings', () async {
      fakeStorage._savedSettings = const SettingsModel(
        temperatureUnit: TemperatureUnit.fahrenheit,
      );

      await notifier.initialize();

      expect(notifier.temperatureUnit, TemperatureUnit.fahrenheit);
    });

    test('setTemperatureUnit updates settings and calls storage', () async {
      await notifier.setTemperatureUnit(TemperatureUnit.fahrenheit);

      expect(notifier.temperatureUnit, TemperatureUnit.fahrenheit);
      expect(
        fakeStorage._savedSettings?.temperatureUnit,
        TemperatureUnit.fahrenheit,
      );
    });

    test('clearCache delegates to storageService', () async {
      await notifier.clearCache();

      expect(fakeStorage.cacheCleared, isTrue);
    });
  });
}
