# MCP SSD Weather — Privacy

An offline-first weather app with **no accounts, no analytics and no backend**. It needs **no API key**.

## What leaves your device

| Destination | What is sent | Why |
|---|---|---|
| `api.open-meteo.com` | Coordinates of the city you are viewing | To fetch the forecast |
| `geocoding-api.open-meteo.com` | The text you type in city search | To turn a city name into coordinates |

Both are the public **Open-Meteo** API, called directly over HTTPS from your device. There is no API key,
no account and no identifier attached to those requests beyond what a normal HTTP request carries
(Open-Meteo's own privacy policy applies to their logs).

Nothing else is transmitted. There is **no** telemetry, crash reporting, analytics or sync service.

## What is stored on your device

| Data | Where |
|---|---|
| Cached weather (current, hourly, daily, alerts) | A JSON file in the app's application-support directory |
| Saved cities (up to 5) | The same JSON storage |
| Settings (theme mode, temperature unit) | The same JSON storage |

You can clear the cached weather at any time from **Settings → Clear Cache**, and the data lives inside
the app's own sandbox/container.

## MCP Toolkit

The app initialises `mcp_toolkit` so that an **MCP-capable agent running on your own machine** can query
its state. The app itself does not send anything to a model provider: if you attach an agent, that
agent's own configuration governs what happens with the data it reads. If you do not use MCP, the tools
are registered and simply never called.

## Permissions

- **Network** — required for the forecast and city search (the app works from cache without it).
- **No location permission is requested.** Cities are chosen by you via search, and their coordinates
  come from the geocoding lookup.

## Uninstalling

Remove the app; its JSON cache and settings go with the app's container. Nothing is stored elsewhere.

## Reporting a problem

Open an issue on [GitHub](https://github.com/moradzadeh67/mcp_ssd_weather/issues). Please do not paste
personal data or credentials into an issue or a screenshot.
