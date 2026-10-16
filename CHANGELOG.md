# Changelog

All notable changes to MCP SSD Weather are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- `docs/ARCHITECTURE.md`, `docs/PRIVACY.md`, `docs/RELEASE.md`, `SECURITY.md` and this changelog.
- Demo GIF in the README, captured from the running macOS app (dark → settings → light).
- README sections: *What is MCP SSD Weather?*, *Demo*, *Key Dependencies*, *Privacy & Security*,
  *Release Signing*, *CI/CD*, *Known Limitations*, *FAQ* and *Requirements*.
- Complete zipped backup of the Android upload key
  (`~/Desktop/McpSsdWeather-upload-key.zip` on the author's machine) — the copied keystore was verified
  with `keytool -list` against the stored password.

### Changed
- Badges upgraded to `for-the-badge`, a release badge and a centered banner were added.

## [1.0.1] — 2026-10-14

### Changed
- ⚠️ **New app identifier** across Android, iOS and macOS: `com.example.mcp_ssd_weather` →
  `io.github.moradzadeh67.mcpssdweather`. Android treats this as a **brand-new app** — uninstall the
  previous build first.
- **Release signing**: APKs are now signed with a dedicated upload key instead of the Android debug key.
- Consistent branding: the app is called *MCP SSD Weather* on every platform.
- `.artifacts/` is no longer tracked.

### Removed
- Leftover `weather_db_api_spare` references in the iOS/macOS Xcode projects and the web manifest.

### Added
- README banner.

**APK SHA-256:** `9d159399fdce301dbd086667cfa1ba0c89843068bc908e46c1283969c78b9528`

## [1.0.0] — 2026-09-25

First stable release.

### Added
- 🌤️ Real-time weather from the **Open-Meteo API** (no API key required).
- ⏰ 24-hour forecast strip and 📅 7-day forecast.
- ⚠️ Weather alerts — 7 types with severity levels.
- 🌍 Up to 5 saved cities, switchable and renamable; 🔍 debounced city search.
- 💾 Offline-first JSON caching; 🔌 connectivity check before requests.
- 🌗 System / Light / Dark theme; 🌡️ Celsius, Fahrenheit and Kelvin.
- 🎨 Weather- and theme-aware background gradient; 📱 responsive sizing.
- 🤖 MCP Toolkit integration for AI-agent interaction.
- 🛡️ Custom exceptions with user-friendly messages.
- Android, iOS, macOS and Web targets.
