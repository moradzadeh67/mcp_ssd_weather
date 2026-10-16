<p align="center">
  <a href="https://github.com/moradzadeh67/mcp_ssd_weather">
    <img src="assets/branding/readme-banner.png" width="100%" alt="MCP SSD Weather Banner">
  </a>
</p>

<p align="center">
  <a href="https://github.com/moradzadeh67/mcp_ssd_weather/releases/latest">
    <img src="https://img.shields.io/github/v/release/moradzadeh67/mcp_ssd_weather?style=for-the-badge&color=2e7d32" alt="Latest Release">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-orange.svg?style=for-the-badge" alt="License MIT">
  </a>
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Web-02569B?style=for-the-badge&logo=flutter" alt="Platform Support">
  </a>
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.47.2-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-3.13.2-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  </a>
  <a href="https://github.com/moradzadeh67/mcp_ssd_weather/actions/workflows/ci.yml">
    <img src="https://github.com/moradzadeh67/mcp_ssd_weather/actions/workflows/ci.yml/badge.svg" alt="CI Status">
  </a>
  <a href="https://moradzadeh67.github.io/mcp_ssd_weather/">
    <img src="https://img.shields.io/badge/Live%20Web%20Demo-moradzadeh67.github.io-blue?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Live Demo">
  </a>
</p>

<p align="center">
  <a href="https://github.com/moradzadeh67/mcp_ssd_weather/releases/latest"><b>📥 Download APK</b></a> •
  <a href="https://moradzadeh67.github.io/mcp_ssd_weather/"><b>🌐 Live Web Demo</b></a> •
  <a href="#-features"><b>✨ Features</b></a> •
  <a href="#-architecture"><b>🏗️ Architecture</b></a> •
  <a href="#-installation--running"><b>🚀 Getting Started</b></a> •
  <a href="#-troubleshooting--faq"><b>❓ FAQ</b></a>
</p>

---

## 🌍 What is MCP SSD Weather?

**MCP SSD Weather** is a **free, open-source weather app** built with **Flutter**, running on
**Android, iOS, macOS and the web**. It is **offline-first** and needs **no API key**.

Look up a city and see the current conditions, a 24-hour strip, a 7-day forecast and severity-based
weather alerts — then keep working when the network drops, because everything is cached locally.

- ✅ **100% free** — no accounts, no ads, no tracking, no backend
- ✅ **MIT licensed** — read it, fork it, ship it
- ✅ **No API key required** — Open-Meteo is open, so there is nothing to configure or leak
- ✅ **Offline-first** — cache-first rendering with a connectivity check and graceful fallback
- ✅ **Agent-addressable** — MCP Toolkit exposes the app's state to AI agents running on your machine
- ✅ **Built with SSD/SPARC** — specification-driven, layered architecture

## 💡 Why I Built This

I wanted to build a real-world Flutter weather app that combines **live API data**, **offline-first caching**, and **modern AI integration** through MCP (Model Context Protocol). Most weather apps I found were either too basic (just temperature) or lacked proper offline support.

MCP SSD Weather is my attempt at a **production-ready weather app**: adaptive UI, full offline support, dark mode, weather alerts, and seamless integration with AI agents via MCP Toolkit.

## 🤖 Development Approach

This project was built using **SSD/SPARC methodology** with **AI-assisted development** via [OpenHands](https://github.com/All-Hands-AI/OpenHands). 

The architecture, feature design, and code review were done by me, while AI agents assisted with implementation. 

### My Role
- **Architecture design** — Layered architecture (Models, Services, State, Pages, Theme)
- **Feature specification** — 14 features (Weather, Forecasts, Alerts, Cities, Search, Dark Mode, etc.)
- **Code review** — Reviewed and refined all AI-generated code
- **Testing strategy** — 59 unit and widget tests
- **UI/UX decisions** — Responsive design, dynamic gradients, dark mode

### OpenHands' Role
- **Implementation** — Generated code based on my specifications
- **Iterative refinement** — Applied fixes and improvements
- **Git operations** — Commits and pushes on my behalf

### Why This Approach?
I chose AI-assisted development to:
1. Focus on **architecture** and **design decisions**
2. **Accelerate implementation** of well-specified features
3. **Learn modern workflows** (AI agents are standard in 2026)
4. **Deliver a production-ready app** faster

This reflects how **modern Flutter development** works — AI handles implementation, developers handle architecture and quality.

## 🎬 Demo

<p align="center">
  <img src="assets/demo/demo.gif" width="420" alt="MCP SSD Weather demo: the Tehran forecast on the dark theme, then the settings page switching to light mode">
</p>

A quick tour: live conditions for Tehran (temperature, humidity, wind, pressure, feels-like, hourly
strip), then the settings page switching the app from the dark theme to light.

## 📸 Screenshots

### Android

**Light Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/android/home_light.png" width="150" /> | <img src="assets/screenshots/android/settings_light.png" width="150" /> | <img src="assets/screenshots/android/search_light.png" width="150" /> | <img src="assets/screenshots/android/cities_light.png" width="150" /> |

**Dark Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/android/home_dark.png" width="150" /> | <img src="assets/screenshots/android/settings_dark.png" width="150" /> | <img src="assets/screenshots/android/search_dark.png" width="150" /> | <img src="assets/screenshots/android/cities_dark.png" width="150" /> |

### iOS

**Light Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/ios/home_light.png" width="150" /> | <img src="assets/screenshots/ios/settings_light.png" width="150" /> | <img src="assets/screenshots/ios/search_light.png" width="150" /> | <img src="assets/screenshots/ios/cities_light.png" width="150" /> |

**Dark Mode**

| Home | Settings | (Empty) | (Empty) |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/ios/home_dark.png" width="150" /> | <img src="assets/screenshots/ios/settings_dark.png" width="150" /> | | |

### macOS

**Light Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/macos/home_light.png" width="150" /> | <img src="assets/screenshots/macos/settings_light.png" width="150" /> | <img src="assets/screenshots/macos/search_light.png" width="150" /> | <img src="assets/screenshots/macos/cities_light.png" width="150" /> |

**Dark Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/macos/home_dark.png" width="150" /> | <img src="assets/screenshots/macos/settings_dark.png" width="150" /> | <img src="assets/screenshots/macos/search_dark.png" width="150" /> | <img src="assets/screenshots/macos/cities_dark.png" width="150" /> |

### Web

**Light Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/web/home_light.png" width="150" /> | <img src="assets/screenshots/web/settings_light.png" width="150" /> | <img src="assets/screenshots/web/search_light.png" width="150" /> | <img src="assets/screenshots/web/cities_light.png" width="150" /> |

**Dark Mode**

| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| <img src="assets/screenshots/web/home_dark.png" width="150" /> | <img src="assets/screenshots/web/settings_dark.png" width="150" /> | <img src="assets/screenshots/web/search_dark.png" width="150" /> | <img src="assets/screenshots/web/cities_dark.png" width="150" /> |

> 💡 **Note:** Screenshots are stored in `assets/screenshots/` and organized by platform and theme.

## ✨ Features

- 🌤️ **Real-time Weather** — Current temperature, condition, humidity, wind speed, pressure, and feels-like.
- ⏰ **24-Hour Forecast** — Horizontal scrollable hourly forecast cards.
- 📅 **7-Day Forecast** — Daily max/min temperatures with weather icons.
- ⚠️ **Weather Alerts** — 7 alert types (Thunderstorm, Heavy Rain, Heavy Snow, Extreme Heat, Extreme Cold, Strong Wind, High Humidity) with severity levels.
- 🌍 **Multiple Cities** — Save up to 5 cities, rename them, and switch between them.
- 🔍 **Smart Search** — Search cities by name using Open-Meteo Geocoding API with debounce (400ms).
- 💾 **Offline-First** — Cached data with JSON storage; automatically shows saved data when offline.
- 🌗 **Dark Mode** — System / Light / Dark theme with persistent storage.
- 🌡️ **Temperature Units** — Celsius (°C), Fahrenheit (°F), and Kelvin (K).
- 🎨 **Dynamic Gradient** — Background gradient changes based on weather condition and theme.
- 📱 **Responsive Design** — Adapts to all screen sizes (5" to 7"+) using relative sizing.
- 🔌 **Connectivity Check** — Auto-detects network status before API calls.
- 🤖 **MCP Toolkit** — AI-agent integration for runtime interaction.
- 🛡️ **Error Handling** — Custom exceptions with user-friendly messages.

## 🏗️ Methodology: SSD & SPARC

This project follows **SSD (Specification-Driven Development)** and **SPARC** workflow:

1. **S**etup — Project initialization and dependency management.
2. **P**ersistence — Data models and local storage services.
3. **A**PI — Stateless network services for data retrieval.
4. **R**eactivity — State management with `ChangeNotifier`.
5. **C**omponents — Responsive UI with reusable widgets.

## 🛠️ Tech Stack

- **Flutter & Dart** (3.47.2, Dart 3.13.2)
- **State Management**: `ChangeNotifier` + `ListenableBuilder`
- **API**: [`http`](https://pub.dev/packages/http) — Open-Meteo API (no key required)
- **Local Persistence**: Custom JSON storage via [`path_provider`](https://pub.dev/packages/path_provider)
- **Connectivity**: [`connectivity_plus`](https://pub.dev/packages/connectivity_plus)
- **AI Integration**: [`mcp_toolkit`](https://pub.dev/packages/mcp_toolkit)
- **Icons**: [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
- **Localization**: `flutter_localizations` + `intl`

### Key Dependencies

| Package | Version | Purpose |
|---|:---:|---|
| `http` | `^1.2.2` | Minimal client for the two Open-Meteo REST endpoints |
| `connectivity_plus` | `^7.3.1` | Network-status check so cached data is shown first when offline |
| `path_provider` | `^2.1.5` | Locates the app support directory for the JSON cache |
| `path` | `^1.9.1` | Safe path joining for the cache files |
| `mcp_toolkit` | `^0.3.0` | Exposes the app's state to MCP-capable AI agents |
| `intl` | `^0.20.2` | Number/date formatting (plus `flutter_localizations`) |
| `url_launcher` | `^6.3.1` | Opening external links (e.g. Open-Meteo attribution) |

> 💡 **Note:** Versions are the constraints declared in `pubspec.yaml`. Resolved at the time of writing
> (`pubspec.lock`): `http` 1.6.0, `connectivity_plus` 7.3.1, `mcp_toolkit` 0.3.0, `path_provider` 2.1.5,
> `intl` 0.20.3, `url_launcher` 6.3.2. `flutter_launcher_icons` is a dev dependency (build-time icon
> generation).

## ✅ Testing

The test suite runs fully offline — no network access or platform channels are required.

```bash
# Static analysis (must report zero issues)
flutter analyze

# Unit + widget tests (59 tests)
flutter test
```

## 🔒 Privacy & Security

> [!IMPORTANT]
> - **No accounts, no analytics, no telemetry, no backend.** Nothing is collected about you.
> - **Only Open-Meteo is contacted** — the city's coordinates (and the text you type in search) go to the public Open-Meteo API over HTTPS. No API key, no identifier.
> - **Everything else stays local** — cached weather, saved cities and settings are JSON files inside the app's own container; *Settings → Clear Cache* wipes the weather cache.
> - **No location permission is requested** — you pick cities by search.
> - **MCP** exposes read-only state to an agent running on your machine; the app itself never sends data to a model provider.

Details: [docs/PRIVACY.md](docs/PRIVACY.md) · Vulnerability reports: [SECURITY.md](SECURITY.md).

## 🔐 Release Signing

Android releases are signed with the project's **upload key** (`mcp_ssd_weather-upload.jks`, alias
`upload`). The keystore lives **outside** this repository; credentials are read from
`android/key.properties`, which is git-ignored and never committed.

```properties
# android/key.properties — NEVER commit this file
storePassword=YOUR_STORE_PASSWORD_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
keyAlias=upload
storeFile=/absolute/path/to/your/upload-keystore.jks
```

```bash
flutter build apk --release
$ANDROID_HOME/build-tools/<version>/apksigner verify --print-certs \
  build/app/outputs/flutter-apk/app-release.apk
```

> [!NOTE]
> If `android/key.properties` is missing — on a fresh clone, for example — Gradle automatically falls back
> to the debug signing key. The build never breaks; it simply is not signed with the release key.

> [!CAUTION]
> Keep the keystore and its passwords backed up (the author keeps a zipped copy on an external backup).
> If the upload key is lost you can no longer publish updates for `io.github.moradzadeh67.mcpssdweather`.

Full release process and the key's verified fingerprint: [docs/RELEASE.md](docs/RELEASE.md).

## 🔄 CI/CD

| Workflow | Trigger | What it does |
|---|---|---|
| [`ci.yml`](.github/workflows/ci.yml) | push / PR / manual | Runs `flutter analyze` and `flutter test` |
| [`deploy-web.yml`](.github/workflows/deploy-web.yml) | push to `main` | Builds the web bundle and publishes it to GitHub Pages |

**Published site:** <https://moradzadeh67.github.io/mcp_ssd_weather/>

> [!NOTE]
> No secrets live in this repository: `android/key.properties`, `*.jks` and `*.keystore` are ignored by
> Git, and the app needs no API key at all.

## 🏗️ Architecture

MCP SSD Weather follows a clean layered architecture:

### Project Structure

![Project Structure](assets/diagrams/project-structure.png)

### Architecture Layers

![Architecture Layers](assets/diagrams/architecture-layers.png)

### Data Flow

![Data Flow](assets/diagrams/data-flow.png)

### Layer Breakdown

```
lib/
├── main.dart                    → Entry point + DI + MCP Toolkit
├── models/
│   ├── weather_model.dart       → WeatherModel + DailyForecast + HourlyForecast
│   ├── city_model.dart          → CityModel + country flag
│   ├── settings_model.dart      → SettingsModel + TemperatureUnit + AppThemeMode
│   └── weather_alert.dart       → WeatherAlert + AlertSeverity
├── services/
│   ├── api_service.dart         → Open-Meteo API (forecast + geocoding)
│   ├── api_exceptions.dart      → Custom API exceptions
│   └── storage_service.dart     → JSON file storage
├── state/
│   ├── weather_notifier.dart    → ChangeNotifier (weather + cities + alerts)
│   └── settings_notifier.dart   → ChangeNotifier (settings)
├── pages/
│   ├── weather_page.dart        → Main screen
│   ├── settings_page.dart       → Settings
│   ├── cities_page.dart         → Saved cities list
│   └── city_search_page.dart    → Search cities
└── theme/
    ├── app_theme.dart           → Centralized light/dark themes
    └── responsive_sizes.dart    → Responsive sizing helpers
```

## 📱 Platform Support

| Platform | Status | Notes |
|---|:---:|---|
| 🤖 Android | ✅ Tested | Working |
| 🍎 iOS | ✅ Tested | Runs from source — installing on a device needs your own Apple Developer team |
| 🌐 Web | ✅ Tested | Chrome, Firefox, Safari compatible |
| 🖥️ macOS | ✅ Tested | Apple Silicon |
| 🪟 Windows | ⚠️ Untested | Build available |
| 🐧 Linux | ⚠️ Untested | Build available |

## 🗺️ Roadmap

- [x] Real-time weather + 24-hour and 7-day forecasts
- [x] Offline-first caching with a connectivity check
- [x] Multi-city support (up to 5 cities)
- [x] Dark mode and temperature units (°C / °F / K)
- [x] Weather alerts (7 severity-based types)
- [x] MCP Toolkit integration for AI agents
- [ ] Windows desktop — verify the existing build
- [ ] Linux desktop — verify the existing build

## 🛠️ Technical Decisions

Every technical choice was made to keep the app small, offline-first, and dependency-light:

- **Open-Meteo API:** No API key required — zero configuration and no secrets to leak in a public repository.
- **`ChangeNotifier` + `ListenableBuilder`:** Flutter's built-in state management, so no extra state-management package is needed.
- **Custom JSON storage via `path_provider`:** Persistence without a database dependency; cached weather stays readable and portable.
- **Connectivity check before every request (`connectivity_plus`):** Keeps the app offline-first — cached data is shown instantly when the network is down.
- **Plain `http`:** A minimal HTTP client instead of a heavier networking stack.
- **Layered SSD/SPARC architecture:** Models → Services → State → Pages, so business logic never leaks into the UI.
- **`mcp_toolkit`:** Exposes the app to AI agents at runtime.
- **`flutter_launcher_icons`:** One source icon generates every platform icon.

## 🚀 Installation & Running

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — stable channel, tested with Flutter 3.47.2
- Dart SDK 3.13.2 — bundled with the Flutter version above

### Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/moradzadeh67/mcp_ssd_weather.git
   cd mcp_ssd_weather
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

### Building

```bash
# Build Android APK
flutter build apk --release

# Build macOS Desktop app
flutter build macos --release

# Build iOS app
flutter build ios --release

# Build Web distribution
flutter build web --release
```

> 💡 **Note on iOS signing:** there is no prebuilt iOS build to download, because iOS apps cannot be side-loaded the way Android APKs can. The iOS target works, but you sign it yourself:
>
> 1. Open `ios/Runner.xcodeproj` in Xcode.
> 2. Select the **Runner** target, then the **Signing & Capabilities** tab.
> 3. Sign in with your Apple ID and choose your team under **Team**.
> 4. Run it from Xcode or with `flutter run`, and it installs on your device.
>
> A free Apple ID is enough to run the app on your own device. Publishing to **TestFlight** or the **App Store** needs a paid Apple Developer Program membership, and at that point you register an App ID for the bundle identifier `io.github.moradzadeh67.mcpssdweather`.
>
> If you are contributing, just use your own team — nothing in the repository needs to change.

## ⚠️ Known Limitations

- **Cached data can be stale** — when offline the app shows the last successful fetch, with the update time visible.
- **iOS is source-only** — there is no downloadable iOS build; you sign it with your own Apple team (see the note under *Building*).
- **Windows and Linux are untested** — build folders exist but nobody has verified them.
- **No location auto-detection** — cities are chosen by search by design (that is also why no location permission is requested).
- **Alerts are heuristic** — the 7 alert types are derived from the forecast data, not from official government warnings.

## ❓ Troubleshooting & FAQ

<details>
<summary><b>1. The app shows old data / "offline" badge.</b></summary>

That is the offline-first behaviour: the cached snapshot is rendered immediately and refreshed when the
network is available. Tap **Update Weather**, or clear the cache from **Settings → Clear Cache** to force a
fresh fetch.
</details>

<details>
<summary><b>2. Do I need an API key?</b></summary>

No. Weather data and city search come from the public **Open-Meteo** API, which needs no key. There is
nothing to configure and no secret in the repository.
</details>

<details>
<summary><b>3. Why doesn't it use my current location?</b></summary>

By design: no location permission is requested. Search for your city (up to 5 can be saved and renamed)
and the app remembers them.
</details>

<details>
<summary><b>4. What is the MCP Toolkit part for?</b></summary>

It exposes the app's state as tools that an MCP-capable AI agent running on your machine can query. If you
do not use an MCP client, the tools are simply registered and never called — the app works exactly the
same. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
</details>

<details>
<summary><b>5. Where is my data stored?</b></summary>

In JSON files inside the app's own container (cached weather, saved cities, settings). Removing the app
removes them. See [docs/PRIVACY.md](docs/PRIVACY.md).
</details>

## 💻 Development Environment

This project is developed and tested on:

- **Hardware**: MacBook Pro (Apple M3 Pro)
- **OS**: macOS 27.0.1
- **IDE**: VS Code / Android Studio
- **Xcode**: Xcode 27.0
- **Flutter**: Flutter 3.47.2 • channel stable • https://github.com/flutter/flutter.git

## 📋 Requirements

- Flutter SDK 3.47.2 (stable)
- Dart SDK 3.13.2
- Android: SDK 24+ (`minSdk 24`) for the Android build
- iOS/macOS: Xcode 15+ (development used Xcode 27.0)
- Web: any modern browser

## 🙏 Credits & Attribution

- **[Open-Meteo](https://open-meteo.com)** — Weather data (CC BY 4.0)
- **[MCP Toolkit](https://pub.dev/packages/mcp_toolkit)** — AI-agent integration

Weather data by Open-Meteo.com

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get started.
Security problems: please **do not** open a public issue — see [SECURITY.md](SECURITY.md).
Release history: [CHANGELOG.md](CHANGELOG.md).

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Copyright © 2026 moradzadeh67