# MCP SSD Weather — Release and Distribution

## Status

Active. Distribution is **GitHub releases** (signed Android APK) plus the **Flutter web build on GitHub
Pages**. There is no store listing.

| Platform | Distribution | Signing |
|---|---|---|
| Android | `mcp_ssd_weather-vX.Y.Z.apk` on the [Releases page](https://github.com/moradzadeh67/mcp_ssd_weather/releases/latest) | Upload key (see below) |
| Web | <https://moradzadeh67.github.io/mcp_ssd_weather/> (built and deployed by `deploy-web.yml`) | N/A |
| macOS | build from source (`flutter build macos --release`) | not notarized |
| iOS | build from source — installing on a device needs your own Apple Developer team | no distribution yet |

Latest: **v1.0.1** (signed APK, app id `io.github.moradzadeh67.mcpssdweather`).

## Android release signing

- **App id**: `io.github.moradzadeh67.mcpssdweather` (changed from the template `com.example.mcp_ssd_weather` in v1.0.1).
- **Upload key**: `mcp_ssd_weather-upload.jks`, alias **`upload`**.
  - Original location: `~/keystores/mcp_ssd_weather-upload.jks`
  - Verified certificate SHA-256: `76:22:77:5A:BF:38:65:A9:6F:15:B9:CC:83:DC:F5:43:E2:C9:B0:3E:03:6A:EF:DF:12:01:92:57:BF:DC:48:56`
- **Complete zipped backup** (keystore + `key.properties` + the passwords in a README):
  `~/Desktop/McpSsdWeather-upload-key.zip` — created **2026-10-16**; the copied keystore was opened with
  the stored password (`keytool -list`) to prove the backup works.
- **Wiring**: `android/key.properties` (git-ignored) points Gradle at the keystore;
  `android/app/build.gradle.kts` reads it and falls back to the **debug** key when the file is absent, so
  a fresh clone still builds.
- **Never** commit the keystore, `key.properties` or the passwords. Losing the key means no further
  updates for `io.github.moradzadeh67.mcpssdweather`.

> ⚠️ Since v1.0.1 the app id differs from the pre-1.0.1 builds: uninstall the old
> `com.example.mcp_ssd_weather` app before installing.

## CI/CD

| Workflow | Trigger | What it does |
|---|---|---|
| [`ci.yml`](.github/workflows/ci.yml) | push / PR / manual | `flutter analyze` + `flutter test` (with concurrency cancellation) |
| [`deploy-web.yml`](.github/workflows/deploy-web.yml) | push to `main` | builds the web bundle and publishes it to GitHub Pages |

## Checklist before every release

1. `flutter analyze` clean and `flutter test` green.
2. Bump `version:` in `pubspec.yaml`; the tag must match (`vX.Y.Z`). v1.0.1's tag matched `1.0.1+2`.
3. `flutter build apk --release` and verify the signature:
   `apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk`.
4. Create the GitHub release and attach the APK; publish its **SHA-256** in the notes
   (v1.0.1's hash: `9d159399fdce301dbd086667cfa1ba0c89843068bc908e46c1283969c78b9528`).
5. Confirm the Pages deploy succeeded (`gh run list`).
6. Update `README.md` and `CHANGELOG.md`.

## Outstanding

- iOS: no distribution (needs a paid Apple Developer team for device installs).
- Windows / Linux: builds exist but are untested.
- macOS: unsigned/not notarized.
