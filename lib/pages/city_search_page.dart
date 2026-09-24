import 'dart:async';

import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../state/weather_notifier.dart';

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
      backgroundColor: const Color(0xFF0B1D33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search City',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                style: const TextStyle(color: Colors.white, fontSize: 16),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  hintText: 'e.g. Shiraz, Dubai, London...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            _notifier.resetSearch();
                          },
                        ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
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
          return const Center(
            child: CircularProgressIndicator(color: Colors.white70),
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
                  const Icon(Icons.cloud_off, size: 56, color: Colors.white38),
                  const SizedBox(height: 12),
                  Text(
                    _notifier.searchError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
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
                    color: isSearchingEmpty ? Colors.white24 : Colors.white38,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSearchingEmpty
                        ? 'Type a city name to search'
                        : 'No cities found for "${_controller.text.trim()}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSearchingEmpty ? Colors.white54 : Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  if (!isSearchingEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Try a different spelling or check your connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 13),
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
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            color: Colors.white12,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            final city = results[index];
            return ListTile(
              leading: const Icon(Icons.place_outlined, color: Colors.white54),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: city.locationLabel.isEmpty
                  ? null
                  : Text(
                      city.locationLabel,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white38),
              onTap: () => _onCitySelected(city),
            );
          },
        );
      },
    );
  }
}
