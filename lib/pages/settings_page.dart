// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/settings_model.dart';
import '../state/settings_notifier.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  final SettingsNotifier notifier;

  const SettingsPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.textPrimary(context)),
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
                    style: TextStyle(color: AppTheme.textPrimary(context)),
                  ),
                  value: unit,
                  groupValue: notifier.temperatureUnit,
                  onChanged: (v) {
                    if (v != null) notifier.setTemperatureUnit(v);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(),
              const _SectionHeader('Appearance'),
              ...AppThemeMode.values.map(
                (mode) => RadioListTile<AppThemeMode>(
                  title: Row(
                    children: [
                      Icon(
                        mode.icon,
                        color: AppTheme.textSecondary(context),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        mode.label,
                        style: TextStyle(color: AppTheme.textPrimary(context)),
                      ),
                    ],
                  ),
                  value: mode,
                  groupValue: notifier.themeMode,
                  onChanged: (v) {
                    if (v != null) notifier.setThemeMode(v);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(),
              const _SectionHeader('Data'),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: AppTheme.textSecondary(context),
                ),
                title: Text(
                  'Clear Cache',
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                ),
                subtitle: Text(
                  'Remove cached weather data',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
                onTap: () => _confirmClearCache(context),
              ),
              const Divider(),
              const _SectionHeader('About'),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: AppTheme.textSecondary(context),
                ),
                title: Text(
                  'mcp_ssd_weather',
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                ),
                subtitle: Text(
                  'v1.0.0 · Offline-first weather app',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.cloud_outlined,
                  color: AppTheme.textSecondary(context),
                ),
                title: Text(
                  'Weather data by Open-Meteo',
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                ),
                subtitle: Text(
                  'open-meteo.com',
                  style: TextStyle(
                    color: AppTheme.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
                onTap: () async {
                  final url = Uri.parse('https://open-meteo.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
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
        backgroundColor: AppTheme.surface(ctx),
        title: Text(
          'Clear cache?',
          style: TextStyle(color: AppTheme.textPrimary(ctx)),
        ),
        content: Text(
          'This will remove all cached weather data. '
          'You will need internet to fetch fresh data.',
          style: TextStyle(color: AppTheme.textSecondary(ctx)),
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
        style: TextStyle(
          color: AppTheme.textSecondary(context),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
