import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/settings_model.dart';
import '../models/weather_model.dart';
import '../models/weather_alert.dart';
import '../state/settings_notifier.dart';
import '../state/weather_notifier.dart';
import 'cities_page.dart';
import 'city_search_page.dart';
import 'settings_page.dart';

class WeatherPage extends StatefulWidget {
  final WeatherNotifier notifier;
  final SettingsNotifier? settingsNotifier;

  const WeatherPage({super.key, required this.notifier, this.settingsNotifier});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherNotifier get _notifier => widget.notifier;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure initialization (which notifies listeners)
    // happens after the first frame is built, avoiding "setState() called during build" error.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notifier.initialize();
      if (_notifier.isOffline) {
        _showOfflineSnackBar();
      }
    });
  }

  void _showOfflineSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Showing cached data (offline)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        // The Scaffold itself extends behind the status / nav bars.
        // Each child view fills the body edge-to-edge so the gradient
        // covers the entire physical screen.
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            return _buildScreen(_notifier);
          },
        ),
      ),
    );
  }

  // Build the main screen based on app status
  Widget _buildScreen(WeatherNotifier notifier) {
    switch (notifier.status) {
      case WeatherStatus.loading:
        return const _LoadingView();
      case WeatherStatus.failure:
        return _ErrorView(
          errorMessage: notifier.errorMessage,
          onRetry: notifier.fetchWeather,
        );
      case WeatherStatus.success:
        final displayName =
            notifier.selectedCity?.displayName ?? notifier.weather!.cityName;
        return _WeatherView(
          weather: notifier.weather!,
          countryFlag: notifier.selectedCity?.countryFlag ?? '',
          isOffline: notifier.isOffline,
          onRefresh: notifier.fetchWeather,
          onSearch: _openSearch,
          onSettings: _openSettings,
          notifier: widget.notifier,
          settingsNotifier: widget.settingsNotifier,
          displayName: displayName,
        );
    }
  }

  // Open the city search page
  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CitySearchPage(notifier: widget.notifier),
      ),
    );
  }

  // Open the settings page
  void _openSettings() {
    if (widget.settingsNotifier != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SettingsPage(notifier: widget.settingsNotifier!),
        ),
      );
    }
  }
}

// ===================== Loading View =====================
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.white70),
                SizedBox(height: 20),
                Text(
                  'Loading Weather...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Error View =====================
class _ErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 72, color: Colors.white38),
                  const SizedBox(height: 16),
                  const Text(
                    'Could not load weather data',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0B1D33),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== Weather View =====================
class _WeatherView extends StatelessWidget {
  final WeatherModel weather;
  final String countryFlag;
  final bool isOffline;
  final Future<void> Function() onRefresh;
  final VoidCallback onSearch;
  final VoidCallback onSettings;
  final WeatherNotifier notifier;
  final SettingsNotifier? settingsNotifier;
  final String displayName;

  const _WeatherView({
    required this.weather,
    required this.countryFlag,
    required this.isOffline,
    required this.onRefresh,
    required this.onSearch,
    required this.onSettings,
    required this.notifier,
    this.settingsNotifier,
    required this.displayName,
  });

  // Format temperature according to selected unit in settings
  String _formatTemp(double celsiusTemp) {
    if (settingsNotifier != null) {
      final settings = settingsNotifier!.settings;
      final converted = settings.convertTemperature(celsiusTemp);
      return '${converted.round()}${settings.temperatureUnit.symbol}';
    }
    return '${celsiusTemp.round()}°C';
  }

  // Get gradient colors based on weather condition
  List<Color> _getBackgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ═══════════════════════════════════════════
    // DARK MODE GRADIENTS (تیرهتر ولی نه مشکی)
    // ═══════════════════════════════════════════
    if (isDark) {
      if (isOffline) {
        return const [Color(0xFF1A1F2E), Color(0xFF2A2F3E)];
      }
      switch (weather.weatherCode) {
        case 0: // Clear/Sunny
          return const [Color(0xFF1A2D45), Color(0xFF4A3A2A)];
        case 1:
        case 2:
        case 3: // Cloudy
          return const [Color(0xFF1A1F2E), Color(0xFF2C3540)];
        case 45:
        case 48: // Foggy
          return const [Color(0xFF1F242E), Color(0xFF2C3540)];
        case 51:
        case 53:
        case 55:
        case 61:
        case 63:
        case 65: // Rainy
          return const [Color(0xFF0F1A2A), Color(0xFF1A2D45)];
        case 71:
        case 73:
        case 75: // Snowy
          return const [Color(0xFF1F242E), Color(0xFF3A4048)];
        case 80:
        case 81:
        case 82: // Showers
          return const [Color(0xFF1A1F2E), Color(0xFF2C3540)];
        case 95:
        case 96:
        case 99: // Thunderstorm
          return const [Color(0xFF0A0A14), Color(0xFF1A1A2E)];
        default:
          return const [Color(0xFF0B1D33), Color(0xFF1A2D45)];
      }
    }

    // ═══════════════════════════════════════════
    // LIGHT MODE GRADIENTS (روشن و رنگی)
    // ═══════════════════════════════════════════
    if (isOffline) {
      return const [Color(0xFF2C3E50), Color(0xFF555555)];
    }
    switch (weather.weatherCode) {
      case 0:
        // Clear sky / sunny: warm sunrise palette
        return const [Color(0xFF3A6EA5), Color(0xFFD98E3B)];
      case 1:
      case 2:
      case 3:
        return const [Color(0xFF3C4B64), Color(0xFF708090)];
      case 45:
      case 48:
        return const [Color(0xFF5D6D7E), Color(0xFF85929E)];
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return const [Color(0xFF2E4053), Color(0xFF5D6D7E)];
      case 71:
      case 73:
      case 75:
        return const [Color(0xFF85929E), Color(0xFFD5DBDB)];
      case 80:
      case 81:
      case 82:
        return const [Color(0xFF34495E), Color(0xFF7F8C8D)];
      case 95:
      case 96:
      case 99:
        return const [Color(0xFF1A1A2E), Color(0xFF4A4A68)];
      default:
        return const [Color(0xFF0B1D33), Color(0xFF4A90E2)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getBackgroundGradient(context),
        ),
      ),
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.white24,
        onRefresh: () async {
          await onRefresh();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Weather updated'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            24,
            24 + media.padding.top,
            24,
            24 + media.padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Buttons (Search, Cities & Settings)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onSearch,
                    tooltip: 'Search city',
                    icon: const Icon(Icons.search, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CitiesPage(notifier: notifier),
                        ),
                      );
                    },
                    tooltip: 'Cities',
                    icon: const Icon(Icons.location_city, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.18),
                    ),
                  ),
                  if (settingsNotifier != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onSettings,
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.18),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: media.size.height * 0.003), // Pulled up
              // Offline Warning Banner
              if (isOffline) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline: showing saved data',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.size.height * 0.003), // Pulled up
              ],

              // Weather Alerts
              if (notifier.alerts.isNotEmpty) ...[
                ...notifier.alerts.map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _AlertBanner(
                      alert: alert,
                      onTap: () => _showAlertDetails(context, alert),
                    ),
                  ),
                ),
                SizedBox(height: media.size.height * 0.003),
              ],

              // City Name & Last Updated
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$displayName '.toUpperCase()),
                    TextSpan(
                      text: countryFlag,
                      style: TextStyle(
                        fontSize:
                            (media.size.width * 0.07).clamp(20.0, 28.0) * 1.15,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (media.size.width * 0.07).clamp(20.0, 28.0),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Last update: ${_formatTime(weather.lastUpdated)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: (media.size.width * 0.045).clamp(
                    16.0,
                    20.0,
                  ), // Responsive & Larger
                ),
              ),

              SizedBox(height: media.size.height * 0.003), // Pulled up
              // Main Weather Display
              Text(
                weather.weatherEmoji,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (media.size.height * 0.06).clamp(
                    36.0,
                    55.0,
                  ), // More compact
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTemp(weather.temperature),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (media.size.height * 0.045).clamp(
                    28.0,
                    44.0,
                  ), // More compact
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                weather.weatherCondition,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: media.size.height * 0.003), // Pulled up
              // Refresh Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await onRefresh();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Weather updated'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Update Weather'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0B1D33),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              SizedBox(height: media.size.height * 0.008), // Pulled up
              // Additional Info Grid
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.water_drop_outlined,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '${weather.pressure.toStringAsFixed(0)} hPa',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.thermostat,
                      label: 'Feels Like',
                      value: _formatTemp(_calculateFeelsLike(weather)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: media.size.height * 0.008), // Pulled up
              // ===================== Hourly Forecast =====================
              const Text(
                'HOURLY FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: (media.size.height * 0.12).clamp(80.0, 100.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: weather.hourlyForecasts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final hour = weather.hourlyForecasts[index];
                    return _HourlyCard(
                      forecast: hour,
                      isNow: index == 0,
                      settings:
                          settingsNotifier?.settings ?? const SettingsModel(),
                    );
                  },
                ),
              ),

              SizedBox(height: media.size.height * 0.008), // Pulled up
              // ===================== 7-Day Forecast =====================
              const Text(
                '7-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: (media.size.height * 0.18).clamp(140.0, 165.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: weather.dailyForecasts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final forecast = weather.dailyForecasts[index];
                    final isToday = index == 0;
                    return _ForecastCard(
                      forecast: forecast,
                      isToday: isToday,
                      settingsNotifier: settingsNotifier,
                    );
                  },
                ),
              ),
              SizedBox(
                height: media.size.height * 0.02,
              ), // 2% Empty space at bottom
            ],
          ),
        ),
      ),
    );
  }

  // Format time to HH:mm
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Simple feels-like calculation using humidity
  double _calculateFeelsLike(WeatherModel weather) {
    // Basic approximation: Humidex-like formula
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final dewPoint = temp - ((100 - humidity) / 5);
    return dewPoint + 5;
  }
}

// ===================== Hourly Card =====================
class _HourlyCard extends StatelessWidget {
  final HourlyForecast forecast;
  final bool isNow;
  final SettingsModel settings;

  const _HourlyCard({
    required this.forecast,
    required this.isNow,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final temp = settings.convertTemperature(forecast.temperature);

    return Container(
      width: (media.size.width * 0.15).clamp(60.0, 75.0),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isNow
            ? Colors.black.withValues(alpha: 0.20)
            : Colors.black.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isNow
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.05),
          width: isNow ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isNow ? 'Now' : _formatHour(forecast.time),
            style: TextStyle(
              color: isNow ? Colors.white : Colors.white70,
              fontSize: 10,
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(forecast.weatherEmoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            '${temp.round()}${settings.temperatureUnit.symbol}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }
}

// ===================== Info Card =====================
// Glass card: dark translucent fill with subtle border so it stays
// readable on BOTH dark and bright (sunny) gradient backgrounds.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Dark translucent surface -> contrasts well with bright orange
        // as well as with dark night gradients.
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== Forecast Card =====================
class _ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;
  final SettingsNotifier? settingsNotifier;

  const _ForecastCard({
    required this.forecast,
    required this.isToday,
    this.settingsNotifier,
  });

  String _formatForecastTemp(double celsiusTemp) {
    if (settingsNotifier != null) {
      final settings = settingsNotifier!.settings;
      final converted = settings.convertTemperature(celsiusTemp);
      return '${converted.round()}°';
    }
    return '${celsiusTemp.round()}°';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      width: (media.size.width * 0.22).clamp(85.0, 110.0),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        // Darker alpha (0.25) for maximum contrast.
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isToday ? 'Today' : _getDayName(forecast.date),
            style: TextStyle(
              color: isToday ? Colors.white : Colors.white70,
              fontSize: (media.size.width * 0.030).clamp(11.0, 13.0),
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            forecast.weatherEmoji,
            style: TextStyle(
              fontSize: (media.size.width * 0.055).clamp(22.0, 28.0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatForecastTemp(forecast.maxTemp),
            style: TextStyle(
              color: Colors.white,
              fontSize: (media.size.width * 0.040).clamp(14.0, 18.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _formatForecastTemp(forecast.minTemp),
            style: TextStyle(
              color: Colors.white54,
              fontSize: (media.size.width * 0.030).clamp(12.0, 14.0),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}

// ===================== Alert Banner =====================
class _AlertBanner extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback onTap;

  const _AlertBanner({required this.alert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: alert.severity.color.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(alert.severity.icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                alert.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}

// ===================== Alert Details Dialog =====================
void _showAlertDetails(BuildContext context, WeatherAlert alert) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1A2D45),
      title: Row(
        children: [
          Icon(alert.severity.icon, color: alert.severity.color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alert.title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: alert.severity.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              alert.severity.label.toUpperCase(),
              style: TextStyle(
                color: alert.severity.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            alert.message,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
