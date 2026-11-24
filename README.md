# Crime Maps (iOS, Android & Web Preview)

**Crime Maps** is a real-time civic situational awareness, public camera transparency, and hyper-local independent music streaming application built with **Flutter**, **Riverpod (codegen)**, **Google Maps Platform**, **RevenueCat**, and **Firebase Cloud Functions v2 (Node.js 22 / strict TypeScript)**.

---

## Key Features

- **Car-Navigation Dark Crime Map (`lib/features/map/`, `lib/features/incidents/`):** Full-screen dark Google Map with 3D building tilt, car-follow bearing/pitch, quick scope toggles (**My Area 5 mi | City | State**), zoom-aware marker clustering, Incident Detail bottom sheets, Street View Static API thumbnails, CesiumJS + Google Photorealistic 3D Tiles flyover WebView, and Alleged Offender cards with mandatory Presumed Innocent disclaimers and 45-day automatic TTL.
- **Historical Neighborhood Context (`lib/features/territories/`):** Toggleable translucent GeoJSON polygon overlays displaying *"Historical / Publicly Documented Neighborhood Context"*, citation dates, source references, and a moderated `territory_submissions` correction queue.
- **Civic Camera Transparency Radar (`lib/features/camera_radar/`):** Local Hive CE spatial cache keyed by geohash cell (zero Firestore polling on GPS ticks), Haversine proximity alerts, animated *"Entering ALPR / Public Camera Zone"* banner with audio chime ducking, anonymized residential density circles, and anti-doxxing validation blocking private residential exact pins.
- **Indie Geo-Radio & Creator Portal (`lib/features/geo_radio/`, `lib/features/creator_portal/`):** Persistent `just_audio` + `audio_service` mini-player docked above the 5-tab `StatefulShellRoute` shell, city/ZIP-prioritized queue with Artist Boost support, 100% ownership legal warranty attestation on upload, and one-click DMCA takedown on every track.
- **Authentication, Monetization & Compliance (`lib/features/auth/`, `lib/features/monetization/`, `lib/features/compliance/`):** Firebase Auth (Email/Password, Google, Apple), RevenueCat Free vs Pro subscriptions & Artist Boost IAPs, AdMob free-tier banner slot, custom geofence & FCM topic alerts (`geo_`, `city_`, `state_`), and 100% free Record Removal / Expungement requests.

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
firebase deploy --project crimemaps-515702 --only firestore:rules,firestore:indexes,storage,functions
```

---

## Pre-Commit Verification Gate

Every commit must pass all 4 verification steps defined in [.agents/rules/crime-maps-rules.md](.agents/rules/crime-maps-rules.md):
1. `dart run build_runner build --delete-conflicting-outputs && flutter analyze --fatal-infos`
2. `flutter test --reporter expanded`
3. `cd functions && npm run build && npm test`
4. Automated Compliance & Secret Scan (0 hardcoded keys, 0 banned Apple 1.4.4 strings, verified `"Presumed innocent"` offender test assertions, strict domain/presentation layering).

See [memory.md](memory.md) for live project status and [docs/APP_STORE_COMPLIANCE.md](docs/APP_STORE_COMPLIANCE.md) for App Store & Google Play compliance review notes.
