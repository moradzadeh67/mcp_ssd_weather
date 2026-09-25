# 🌤️ MCP SSD Weather

An offline-first Flutter weather application built with **SSD/SPARC methodology** and **MCP Toolkit** for AI-agent integration.

[![Latest Release](https://img.shields.io/github/v/release/moradzadeh67/mcp_ssd_weather?style=flat-square&color=green)](https://github.com/moradzadeh67/mcp_ssd_weather/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Web-blue?style=flat-square)]()

### 📥 [Download Latest APK](https://github.com/moradzadeh67/mcp_ssd_weather/releases/latest)

## 💡 Why I Built This

I wanted to build a real-world Flutter weather app that combines **live API data**, **offline-first caching**, and **modern AI integration** through MCP (Model Context Protocol). Most weather apps I found were either too basic (just temperature) or lacked proper offline support.

MCP SSD Weather is my attempt at a **production-ready weather app**: adaptive UI, full offline support, dark mode, weather alerts, and seamless integration with AI agents via MCP Toolkit.

## 📸 Screenshots

### Android
| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/android/home_light.png) | ![Settings](assets/screenshots/android/settings_light.png) | ![Search](assets/screenshots/android/search_light.png) | ![Cities](assets/screenshots/android/cities_light.png) |

### iOS
| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/ios/home_light.png) | ![Settings](assets/screenshots/ios/settings_light.png) | ![Search](assets/screenshots/ios/search_light.png) | ![Cities](assets/screenshots/ios/cities_light.png) |

### macOS
| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/macos/home_light.png) | ![Settings](assets/screenshots/macos/settings_light.png) | ![Search](assets/screenshots/macos/search_light.png) | ![Cities](assets/screenshots/macos/cities_light.png) |

### Web
| Home | Settings | Search | Cities |
|:---:|:---:|:---:|:---:|
| ![Home](assets/screenshots/web/home_light.png) | ![Settings](assets/screenshots/web/settings_light.png) | ![Search](assets/screenshots/web/search_light.png) | ![Cities](assets/screenshots/web/cities_light.png) |

> 💡 **Note:** Screenshots are stored in `assets/screenshots/` and organized by platform.

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
| 🍎 iOS | ✅ Tested | Working |
| 🌐 Web | ✅ Tested | Chrome, Firefox, Safari compatible |
| 🖥️ macOS | ✅ Tested | Apple Silicon |
| 🪟 Windows | ⚠️ Untested | Build available |
| 🐧 Linux | ⚠️ Untested | Build available |

## 🚀 Installation & Running

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.2+)
- Dart SDK (v3.x)

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

## 💻 Development Environment

This project is actively developed and tested using:
- **OS**: macOS (Apple Silicon)
- **IDE**: VS Code / Android Studio
- **iOS/macOS Build Toolchain**: Xcode 14+
- **Flutter Framework**: Flutter 3.13+

## 🙏 Credits & Attribution

- **[Open-Meteo](https://open-meteo.com)** — Weather data (CC BY 4.0)
- **[MCP Toolkit](https://pub.dev/packages/mcp_toolkit)** — AI-agent integration

Weather data by Open-Meteo.com

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get started.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Copyright © 2026 moradzadeh67
