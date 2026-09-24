import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mcp_toolkit/mcp_toolkit.dart';

import 'pages/weather_page.dart';
import 'models/settings_model.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'state/settings_notifier.dart';
import 'state/weather_notifier.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize MCP Toolkit
      MCPToolkitBinding.instance
        ..initialize()
        ..initializeFlutterToolkit();

      // Full screen (Edge-to-Edge): draw behind status & navigation bars
      // with transparent bars on all Android versions (and iOS status bar).
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          // Light icons on the dark weather background
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simple dependency injection
      final storageService = StorageService();
      final weatherNotifier = WeatherNotifier(
        apiService: ApiService(),
        storageService: storageService,
      );
      final settingsNotifier = SettingsNotifier(storageService: storageService);
      await settingsNotifier.initialize();

      runApp(
        WeatherApp(
          notifier: weatherNotifier,
          settingsNotifier: settingsNotifier,
        ),
      );
    },
    (error, stack) {
      // Handle zone errors for MCP server error reporting
      MCPToolkitBinding.instance.handleZoneError(error, stack);
    },
  );
}

class WeatherApp extends StatelessWidget {
  final WeatherNotifier notifier;
  final SettingsNotifier settingsNotifier;

  const WeatherApp({
    super.key,
    required this.notifier,
    required this.settingsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0B1D33),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0B1D33),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: _getThemeMode(settingsNotifier.themeMode),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: WeatherPage(
            notifier: notifier,
            settingsNotifier: settingsNotifier,
          ),
        );
      },
    );
  }

  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}
