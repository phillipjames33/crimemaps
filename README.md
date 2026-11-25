# Crime Maps (iOS, Android & Live Web App)

**Crime Maps** is a real-time civic situational awareness, public camera transparency, and hyper-local independent music streaming application built with **Flutter**, **Riverpod (codegen)**, **Google Maps Platform**, **RevenueCat**, and **Firebase Cloud Functions v2 (Node.js 22 / strict TypeScript)**.

- **Live Web App:** https://crimemaps-515702.web.app/app/
- **Civic & Legal Portal:** https://crimemaps-515702.web.app/ ([Privacy Policy](https://crimemaps-515702.web.app/privacy.html) · [Terms & DMCA](https://crimemaps-515702.web.app/terms.html) · [100% Free Record Removal & Account Deletion](https://crimemaps-515702.web.app/removal.html))

---

## Key Features

- **Car-Navigation Dark Crime Map (`lib/features/map/`, `lib/features/incidents/`):** Full-screen dark car-nav Google Map with 3D building tilt, car-follow bearing/pitch, quick scope toggles (**My Area 5 mi | City | State**), 8 city quick-jump presets (**Atlanta, Savannah, Chicago, San Francisco, Dallas, Los Angeles, Houston, New York**), collapsible **Category & Severity** filters, local Hive-backed **Saved** incident bookmarks, live municipal 2026 Socrata feeds (**Chicago PD, San Francisco PD, Dallas PD**), official **INTERPOL U.S. Arrest Warrant Red Notices** with live mugshot thumbnails & 1-tap **`Mugshots (N)`** map filter, Street View Static API thumbnails, CesiumJS + Photorealistic 3D Tiles WebView, and Alleged Offender cards with mandatory Presumed Innocent disclaimers and 45-day automatic TTL.
- **Historical Neighborhood Context (`lib/features/territories/`):** Toggleable translucent GeoJSON polygon overlays displaying *"Historical / Publicly Documented Neighborhood Context"*, citation dates, source references, and a moderated `territory_submissions` correction queue.
- **Civic Camera Transparency Radar (`lib/features/camera_radar/`):** Live Firestore OSM civic camera map layer (`limit(150)` per city/state, zero GPS polling) paired with a local Hive CE spatial cache for Haversine proximity alerts, animated *"Entering ALPR / Public Camera Zone"* banner with audio chime ducking, anonymized residential density circles, and anti-doxxing validation blocking private residential exact pins.
- **Indie Geo-Radio & Creator Portal (`lib/features/geo_radio/`, `lib/features/creator_portal/`):** Persistent `just_audio` + `audio_service` mini-player docked above the 5-tab `StatefulShellRoute` shell, city/ZIP-prioritized queue with Artist Boost support, 100% ownership legal warranty attestation on upload, and one-click DMCA takedown on every track.
- **Authentication, Monetization, App Check & Compliance (`lib/features/auth/`, `lib/features/monetization/`, `lib/features/compliance/`):** Firebase Auth (Email/Password, Google, Apple) with Apple Guideline 5.1.1(v) **Delete Account Permanently**, Firebase App Check (`Play Integrity` / `App Attest` / Web `reCAPTCHA v3`), RevenueCat Free vs Pro subscriptions & Artist Boost IAPs with Apple 3.1.2(c) legal disclosures, AdMob free-tier banner slot, custom geofence & FCM topic alerts (`geo_`, `city_`, `state_`), and 100% free Record Removal / Expungement requests.

---

## Local Setup & Run

### 1. Configure Environment Variables (Gitignored)
Copy [.env.example](.env.example) to `.env` and fill in your keys:
```bash
cp .env.example .env
```
- **Android:** `android/app/build.gradle.kts` automatically reads `GOOGLE_MAPS_API_KEY` and `ADMOB_ANDROID_APP_ID` from `.env` (or Gradle properties / env vars) and conditionally enables `com.google.gms.google-services` when local `android/app/google-services.json` is present.
- **iOS:** Copy `ios/Flutter/Secrets.xcconfig.example` to `ios/Flutter/Secrets.xcconfig` (gitignored) and place `GoogleService-Info.plist` in `ios/Runner/`.
- **Web Preview:** Generate gitignored `web/env_config.js` containing `window.__CRIME_MAPS_GOOGLE_API_KEY__ = '<your-key>';`.

### 2. Install Flutter Dependencies & Codegen
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
# Android / iOS
flutter run --dart-define-from-file=.env

# Local Browser Preview
flutter run -d web-server --web-port 8088 --web-hostname 127.0.0.1 --dart-define-from-file=.env
```

### 4. Firebase Backend, Emulator Suite & Deployment
```bash
cd functions
npm install
npm run build
npm test

# Run local Emulator Suite & seed Firestore
cd ..
firebase emulators:start
# In a second terminal:
cd functions && FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 npm run seed

# Deploy to production Firebase project (crimemaps-515702)
firebase deploy --project crimemaps-515702 --only firestore:rules,firestore:indexes,storage,functions,hosting
```

---

## Pre-Commit Verification Gate & CI

Every commit and pull request to `main` is automatically verified by [.github/workflows/ci.yml](.github/workflows/ci.yml) enforcing all 4 steps defined in [.agents/rules/crime-maps-rules.md](.agents/rules/crime-maps-rules.md):
1. `dart run build_runner build --delete-conflicting-outputs && flutter analyze --fatal-infos`
2. `flutter test --reporter expanded`
3. `cd functions && npm run build && npm test`
4. Automated Compliance & Secret Scan (0 hardcoded keys, 0 banned Apple 1.4.4 strings, verified `"Presumed innocent"` offender test assertions, strict domain/presentation layering).

See [memory.md](memory.md) for live project status, [docs/APP_STORE_COMPLIANCE.md](docs/APP_STORE_COMPLIANCE.md) for App Store & Google Play compliance review notes, and [docs/STORE_LISTING_KIT.md](docs/STORE_LISTING_KIT.md) for ready-to-paste store metadata, SKU tables, Data Safety answers, and graphic asset paths.
