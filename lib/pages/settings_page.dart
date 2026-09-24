// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../models/settings_model.dart';
import '../state/settings_notifier.dart';

class SettingsPage extends StatelessWidget {
  final SettingsNotifier notifier;

  const SettingsPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionHeader('Temperature Unit'),
              ...TemperatureUnit.values.map(
                (unit) => RadioListTile<TemperatureUnit>(
                  title: Text(
                    unit.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: unit,
                  groupValue: notifier.temperatureUnit,
                  onChanged: (v) {
                    if (v != null) notifier.setTemperatureUnit(v);
                  },
                  activeColor: Colors.white,
                ),
              ),
              const Divider(color: Colors.white24),
              _SectionHeader('Appearance'),
              ...AppThemeMode.values.map(
                (mode) => RadioListTile<AppThemeMode>(
                  title: Row(
                    children: [
                      Icon(mode.icon, color: Colors.white70, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        mode.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  value: mode,
                  groupValue: notifier.themeMode,
                  onChanged: (v) {
                    if (v != null) notifier.setThemeMode(v);
                  },
                  activeColor: Colors.white,
                ),
              ),
              const Divider(color: Colors.white24),
              const _SectionHeader('Data'),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.white70,
                ),
                title: const Text(
                  'Clear Cache',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Remove cached weather data',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onTap: () => _confirmClearCache(context),
              ),
              const Divider(color: Colors.white24),
              const _SectionHeader('About'),
              const ListTile(
                leading: Icon(Icons.info_outline, color: Colors.white70),
                title: Text(
                  'mcp_ssd_weather',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'v1.0.0 · Offline-first weather app',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmClearCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2D45),
        title: const Text(
          'Clear cache?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will remove all cached weather data. '
          'You will need internet to fetch fresh data.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.clearCache();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
