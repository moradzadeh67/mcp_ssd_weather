# MCP SSD Weather — Architecture

A small, offline-first Flutter app built with the **SSD / SPARC** workflow (Setup → Persistence → API →
Reactivity → Components). State management is Flutter's built-in `ChangeNotifier` — no state package.

## Layers

| Layer | Folder | Responsibility |
|---|---|---|
| Entry / DI | `main.dart` | Builds the object graph, initialises `MCPToolkitBinding` and error handling |
| Models | `lib/models/` | `WeatherModel` (+`DailyForecast`, `HourlyForecast`), `CityModel`, `SettingsModel`, `WeatherAlert` |
| Services | `lib/services/` | `ApiService` (Open-Meteo forecast + geocoding), `ApiExceptions`, `StorageService` (JSON files) |
| State | `lib/state/` | `WeatherNotifier` (weather, cities, alerts) and `SettingsNotifier` (theme, units) — both `ChangeNotifier` |
| Pages | `lib/pages/` | `WeatherPage` (main), `SettingsPage`, `CitiesPage`, `CitySearchPage` |
| Theme | `lib/theme/` | `AppTheme` (centralised light/dark) + `ResponsiveSizes` (relative sizing) |

## Data flow

```text
main.dart
  ├── StorageService ──► reads cached JSON (weather, cities, settings)
  ├── ApiService ──────► Open-Meteo forecast + geocoding (http)
  └── MCPToolkitBinding ─► registers tools for an MCP-capable agent host

WeatherPage / SettingsPage / CitiesPage
        │  ListenableBuilder
        ▼
WeatherNotifier / SettingsNotifier  (ChangeNotifier)
        │  notifyListeners()
        ▼
UI rebuilds  ──►  any change is written back through StorageService
```

Offline-first behaviour: the cache is read first and rendered immediately; a connectivity check
(`connectivity_plus`) runs before network calls, and a failed fetch falls back to the cached data with a
user-visible notice.

## Diagrams

- Project structure — `assets/diagrams/project-structure.png`
- Architecture layers — `assets/diagrams/architecture-layers.png`
- Data flow — `assets/diagrams/data-flow.png`

## MCP integration

`mcp_toolkit` (`MCPToolkitBinding`) exposes the app's runtime to an **MCP-capable agent host** running on
the same machine; at startup the app logs which tools it registered. This is what makes the app
"agent-addressable": an agent can query the weather state instead of screen-scraping. Nothing is sent by
the app to any model provider — see [docs/PRIVACY.md](PRIVACY.md).

## Key decisions

- **Open-Meteo, no API key** — zero configuration, nothing to leak in a public repository.
- **`ChangeNotifier` + `ListenableBuilder`** — Flutter's own primitives; no Provider/BLoC/Riverpod.
- **JSON files over a database** — the payload is tiny and stays human-readable and portable.
- **Plain `http`** — two REST endpoints do not justify a heavier client.
- **Layered SSD/SPARC structure** — business logic never leaks into widgets.

## Testing

`flutter test` runs fully offline (59 tests): models, services with fakes, state notifiers and page
widgets. No network, platform channel or API key is required.
