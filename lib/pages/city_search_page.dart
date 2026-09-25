import 'dart:async';

import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../state/weather_notifier.dart';
import '../theme/app_theme.dart';

class CitySearchPage extends StatefulWidget {
  final WeatherNotifier notifier;
  final bool addMode;

  const CitySearchPage({
    super.key,
    required this.notifier,
    this.addMode = false,
  });

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  WeatherNotifier get _notifier => widget.notifier;

  @override
  void initState() {
    super.initState();
    _notifier.resetSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isNotEmpty) {
      _notifier.startSearch(); // Show loader immediately
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      await _notifier.searchCities(query);
      if (_notifier.searchError != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _notifier.searchError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(_notifier.searchError!)));
          }
        });
      }
    });
  }

  Future<void> _onCitySelected(CityModel city) async {
    if (widget.addMode) {
      final added = await _notifier.addCity(city);
      if (!added) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 5 cities allowed')),
          );
        }
        return;
      }
    } else {
      await _notifier.switchCity(city);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search City',
          style: TextStyle(
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.textPrimary(context)),
      ),
      // Full-screen background; AppBar handles the top inset and
      // SafeArea keeps the list clear of the bottom navigation bar.
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).size.height * 0.01,
                16,
                MediaQuery.of(context).size.height * 0.01,
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onQueryChanged,
                style: TextStyle(
                  color: AppTheme.textPrimary(context),
                  fontSize: 16,
                ),
                cursorColor: AppTheme.textSecondary(context),
                decoration: InputDecoration(
                  hintText: 'e.g. Shiraz, Dubai, London...',
                  hintStyle: TextStyle(color: AppTheme.textSecondary(context)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textSecondary(context),
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppTheme.textSecondary(context),
                          ),
                          onPressed: () {
                            _controller.clear();
                            _notifier.resetSearch();
                          },
                        ),
                  filled: true,
                  fillColor: AppTheme.isDark(context)
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppTheme.isDark(context)
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppTheme.isDark(context)
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        // Loading state
        if (_notifier.isSearching) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.textSecondary(context),
            ),
          );
        }

        // Error state
        if (_notifier.searchError != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 56,
                    color: AppTheme.textSecondary(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _notifier.searchError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final results = _notifier.searchResults;

        // Empty state (no search yet or no results)
        if (results.isEmpty) {
          final isSearchingEmpty = _controller.text.trim().isEmpty;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSearchingEmpty ? Icons.location_city : Icons.search_off,
                    size: 56,
                    color: AppTheme.textSecondary(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSearchingEmpty
                        ? 'Type a city name to search'
                        : 'No cities found for "${_controller.text.trim()}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textPrimary(context),
                      fontSize: 15,
                    ),
                  ),
                  if (!isSearchingEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Try a different spelling or check your connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        // Results list
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: results.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final city = results[index];
            return ListTile(
              leading: Icon(
                Icons.place_outlined,
                color: AppTheme.textSecondary(context),
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: city.name),
                    TextSpan(
                      text: ' ${city.countryFlag}',
                      style: const TextStyle(
                        fontSize: 18.5,
                      ), // ~15% larger than 16
                    ),
                    TextSpan(text: ' (${city.countryCode})'),
                  ],
                ),
                style: TextStyle(
                  color: AppTheme.textPrimary(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: city.locationLabel.isEmpty
                  ? null
                  : Text(
                      city.locationLabel,
                      style: TextStyle(
                        color: AppTheme.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary(context),
              ),
              onTap: () => _onCitySelected(city),
            );
          },
        );
      },
    );
  }
}
