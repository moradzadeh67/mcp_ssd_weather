# Security Policy

MCP SSD Weather is a small offline-first client: it holds no API keys, no accounts and no server-side
component. That keeps the attack surface small — but reports are still welcome.

## Reporting a vulnerability

Please **do not** open a public issue. Use GitHub's private reporting
(<https://github.com/moradzadeh67/mcp_ssd_weather/security/advisories> → *Report a vulnerability*), or
contact the author via <https://github.com/moradzadeh67>.

Include: affected version, platform, steps to reproduce, and the impact you see.

## Design facts worth knowing (not bugs)

- **No secrets in the repository.** The app needs no API key (Open-Meteo is open); the Android upload key
  and `android/key.properties` are git-ignored and never committed.
- **No backend.** The app talks only to the public Open-Meteo endpoints over HTTPS.
- **Local storage only** — cached weather, cities and settings live in the app's own container as JSON.
- **MCP Toolkit** exposes read-only weather tools to an MCP-capable agent on the same machine; the app
  itself sends nothing to any model provider. See [docs/PRIVACY.md](docs/PRIVACY.md).

## Please never

- Paste personal data, cached files or credentials into an issue, a log or a screenshot.
