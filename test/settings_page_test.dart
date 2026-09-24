import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mcp_ssd_weather/models/settings_model.dart';
import 'package:mcp_ssd_weather/pages/settings_page.dart';
import 'package:mcp_ssd_weather/services/storage_service.dart';
import 'package:mcp_ssd_weather/state/settings_notifier.dart';

class FakeStorageService extends StorageService {
  SettingsModel? savedSettings;
  bool cacheCleared = false;

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    savedSettings = settings;
  }

  @override
  Future<SettingsModel?> loadSettings() async {
    return savedSettings;
  }

  @override
  Future<void> clearCache() async {
    cacheCleared = true;
  }
}

void main() {
  group('SettingsPage Widget Tests', () {
    late FakeStorageService fakeStorage;
    late SettingsNotifier settingsNotifier;

    setUp(() {
      fakeStorage = FakeStorageService();
      settingsNotifier = SettingsNotifier(storageService: fakeStorage);
    });

    Widget createSettingsWidget() {
      return MaterialApp(home: SettingsPage(notifier: settingsNotifier));
    }

    testWidgets(
      'renders all section headers, radio tiles, clear cache, and about section',
      (tester) async {
        await tester.pumpWidget(createSettingsWidget());

        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('TEMPERATURE UNIT'), findsOneWidget);
        expect(find.text('Celsius (°C)'), findsOneWidget);
        expect(find.text('Fahrenheit (°F)'), findsOneWidget);
        expect(find.text('Kelvin (K)'), findsOneWidget);

        final clearCacheFinder = find.text('Clear Cache');
        await tester.scrollUntilVisible(clearCacheFinder, 100.0);
        expect(clearCacheFinder, findsOneWidget);

        final aboutFinder = find.text('mcp_ssd_weather');
        await tester.scrollUntilVisible(aboutFinder, 100.0);
        expect(aboutFinder, findsOneWidget);
        expect(find.text('v1.0.0 · Offline-first weather app'), findsOneWidget);
      },
    );

    testWidgets('selecting Fahrenheit updates temperatureUnit in notifier', (
      tester,
    ) async {
      await tester.pumpWidget(createSettingsWidget());

      await tester.tap(find.text('Fahrenheit (°F)'));
      await tester.pumpAndSettle();

      expect(settingsNotifier.temperatureUnit, TemperatureUnit.fahrenheit);
    });

    testWidgets(
      'clear cache button opens confirm dialog and clears cache on confirmation',
      (tester) async {
        await tester.pumpWidget(createSettingsWidget());

        final clearCacheTile = find.text('Clear Cache');
        await tester.scrollUntilVisible(clearCacheTile, 100.0);
        await tester.tap(clearCacheTile);
        await tester.pumpAndSettle();

        expect(find.text('Clear cache?'), findsOneWidget);

        await tester.tap(find.text('Clear'));
        await tester.pumpAndSettle();

        expect(fakeStorage.cacheCleared, isTrue);
        expect(find.text('Cache cleared'), findsOneWidget);
      },
    );
  });
}
