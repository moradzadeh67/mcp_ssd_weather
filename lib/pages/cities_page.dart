import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../state/weather_notifier.dart';
import '../theme/app_theme.dart';
import 'city_search_page.dart';

class CitiesPage extends StatelessWidget {
  final WeatherNotifier notifier;

  const CitiesPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cities',
          style: TextStyle(
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.textPrimary(context)),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (!notifier.canAddMoreCities) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => _openSearch(context),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                children: [
                  Icon(
                    Icons.location_city,
                    size: 64,
                    color: AppTheme.textSecondary(
                      context,
                    ).withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No cities saved yet',
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a city',
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 13,
                    ),
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
        backgroundColor: AppTheme.surface(ctx),
        title: Text(
          'Rename city',
          style: TextStyle(color: AppTheme.textPrimary(ctx)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: AppTheme.textPrimary(ctx)),
          decoration: InputDecoration(
            hintText: 'New name (leave empty to reset)',
            hintStyle: TextStyle(color: AppTheme.textSecondary(ctx)),
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
    final isDark = AppTheme.isDark(context);
    final surfaceColor = AppTheme.surface(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? (isActive ? surfaceColor : surfaceColor.withValues(alpha: 0.5))
            : (isActive
                  ? Theme.of(context).colorScheme.primaryContainer
                  : surfaceColor),
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              )
            : Border.all(
                color: isDark
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.2),
              ),
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
                color: AppTheme.textPrimary(context),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            if (city.hasCustomLabel) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.edit,
                size: 14,
                color: AppTheme.textSecondary(context),
              ),
            ],
          ],
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
        trailing: isActive
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : Icon(Icons.chevron_right, color: AppTheme.textSecondary(context)),
      ),
    );
  }
}
