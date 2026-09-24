import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../state/weather_notifier.dart';
import 'city_search_page.dart';

class CitiesPage extends StatelessWidget {
  final WeatherNotifier notifier;

  const CitiesPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cities',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (!notifier.canAddMoreCities) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => _openSearch(context),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0B1D33),
            child: const Icon(Icons.add),
          );
        },
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (notifier.savedCities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_city, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'No cities saved yet',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add a city',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifier.savedCities.length,
            itemBuilder: (context, index) {
              final city = notifier.savedCities[index];
              final isActive = notifier.selectedCity?.id == city.id;

              return Dismissible(
                key: ValueKey(city.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => notifier.removeCity(city),
                child: _CityTile(
                  city: city,
                  isActive: isActive,
                  onTap: () {
                    notifier.switchCity(city);
                    Navigator.pop(context);
                  },
                  onLongPress: () => _renameCity(context, city, notifier),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CitySearchPage(notifier: notifier, addMode: true),
      ),
    );
  }

  Future<void> _renameCity(
    BuildContext context,
    CityModel city,
    WeatherNotifier notifier,
  ) async {
    final controller = TextEditingController(
      text: city.customLabel ?? city.name,
    );
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2D45),
        title: const Text('Rename city', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'New name (leave empty to reset)',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await notifier.renameCity(city, result.isEmpty ? null : result);
    }
  }
}

class _CityTile extends StatelessWidget {
  final CityModel city;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CityTile({
    required this.city,
    required this.isActive,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: Text(city.countryFlag, style: const TextStyle(fontSize: 28)),
        title: Row(
          children: [
            Text(
              city.displayName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            if (city.hasCustomLabel) ...[
              const SizedBox(width: 6),
              const Icon(Icons.edit, size: 14, color: Colors.white54),
            ],
          ],
        ),
        subtitle: city.locationLabel.isEmpty
            ? null
            : Text(
                city.locationLabel,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
        trailing: isActive
            ? const Icon(Icons.check_circle, color: Colors.white)
            : const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}
