/// Holds app metadata that is loaded once at startup.
///
/// This is deliberately a plain value holder: widget tests then never depend on
/// a platform channel (`PackageInfo`) being available. `main()` fills in the
/// real version; if that lookup fails the fallback keeps the UI honest.
class AppInfo {
  AppInfo._();

  /// Version reported by the platform, taken from `pubspec.yaml`'s `version:`.
  static String version = 'dev';

  /// Subtitle shown in the Settings → About tile.
  static String get label => 'v$version · Offline-first weather app';
}
