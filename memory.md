# CRIME MAPS — PROJECT MEMORY & PROGRESS TRACKER

> **Living Document:** Update this file whenever a feature, integration, verification step, or deployment milestone is completed, or when new work / blockers are identified. Never store API keys, tokens, or secrets in this file.

- **Last Updated:** 2026-11-24
- **GitHub Repository:** https://github.com/phillipjames33/crimemaps (`origin/main`)
- **Default Branch:** `main`
- **Google Cloud / Firebase Project:** `crimemaps-515702` (Project Number `864680228535`, Blaze Active)
- **RevenueCat Project:** `CrimeMapsAi` (`proj3c8fa1e5`)
- **App Identifiers:** Android `com.crimemaps.crime_maps` | iOS `com.crimemaps.crimeMaps`

---

## 1. Completed Work

### Phase 1 — Project Scaffold, Native Permissions & Core Architecture
- [x] Initialized Flutter project (`crime_maps`) targeting iOS, Android, and Web.
- [x] Configured strict lints (`analysis_options.yaml`) and workspace rules (`.agents/rules/crime-maps-rules.md`).
- [x] Configured Android (`AndroidManifest.xml`, `build.gradle.kts`, `settings.gradle.kts`, `key.properties.example`) and iOS (`Info.plist`, `Podfile`, `AppDelegate.swift`, `Debug.xcconfig`, `Release.xcconfig`, `Secrets.xcconfig.example`) for Google Maps, Location, Background Audio (`audio_service`), AdMob, and conditional native Firebase (`com.google.gms.google-services`).
- [x] Wired `android/app/build.gradle.kts` to read `GOOGLE_MAPS_API_KEY` and `ADMOB_ANDROID_APP_ID` from Gradle properties, environment variables, or the gitignored root `.env` file, and support optional release keystore signing (`android/key.properties`, gitignored).
- [x] Built `lib/core/` infrastructure: `AppEnv` (`--dart-define`), `ComplianceConstants`, dark car-navigation `AppTheme`, pure-Dart `GeohashUtil` (geohash encoder + Haversine distance), `LocationGateway` / `userLocationStream`, `FirebaseBootstrap`, `FcmTopicService`, and realistic Atlanta/Georgia + multi-state `SeedData`.
- [x] Defined all 9 feature `domain/` layers (`auth`, `map`, `incidents`, `territories`, `camera_radar`, `geo_radio`, `creator_portal`, `monetization`, `compliance`) using Freezed v3 immutable models with zero Flutter UI or Firebase SDK imports.

### Phase 2 — Firebase Backend, Security Rules, Seed Pipeline & Production Deploy
- [x] Authored default-deny `firestore.rules` and `storage.rules` enforcing:
  - Public read / Admin-only write on `incidents` and `territories`.
  - Anti-doxxing validation on `cameras` (`alpr_flock`, `traffic`, `red_light` only; `isPrivateResidence != true`).
  - Moderated `territory_submissions` queue (`moderationStatus == 'pending_review'`).
  - 100% indie ownership warranty (`rightsWarranty.owns100Percent == true`, `signedName`, `signedAt`) on `tracks` & Storage uploads (<= 25 MB).
  - 100% free `removal_requests` creation and DMCA Safe Harbor `dmca_claims` + instant `flagged_dmca` transition.
- [x] Authored `firestore.indexes.json` with composite indexes and native 45-day TTL override (`incidents.expireAt`).
- [x] Implemented and **deployed live to `crimemaps-515702`** all 5 Firebase Cloud Functions v2 (Node.js 22, strict TypeScript `"strict": true`, 0 `any` types):
  - `ingestCrimeFeeds` (`us-central1`, scheduled every 15 min) — idempotent deterministic IDs, geohashing, 45-day TTL, Presumed Innocent disclaimer, Socrata/ArcGIS/SpotCrime/Mock adapters.
  - `syncPublicCameras` (`us-central1`, scheduled every 6 hr) — OpenStreetMap/DeFlock adapter with anti-doxxing rejection.
  - `onHighSeverityIncident` (`us-central1`, Firestore trigger) — FCM push notifications to `geo_`, `city_`, `state_` topics.
  - `onTrackUploaded` (`us-east1`, Storage bucket trigger) — MIME/size/warranty validation, track activation or quarantine.
  - `submitMugshotRemoval` (`us-central1`, HTTPS callable) — 100% free instant redaction of `allegedOffender` pending verification.
- [x] Verified live free municipal Socrata Open Data crime feeds (Chicago PD `ijzp-q8t2` and San Francisco PD `wg3w-h783` returning live 2026 JSON) and documented ready-to-deploy config in `functions/.env.live.example`.
- [x] Built Firestore CLI seeder (`functions/src/seed/seedFirestore.ts`) and verified seeding against the local Firebase Emulator Suite (`14` incidents, `7` public cameras with `2` private residential cameras blocked, `4` historical territories, `6` indie tracks).
- [x] Configured Artifact Registry 1-day container cleanup policy across `us-central1` and `us-east1`.

### Phases 3–6 — Flutter Features, Compliance, Release Builds & Verification
- [x] **Module A (Car-Nav Crime Map & Incidents):** Full-screen dark car-nav Google Map, scope pills (`My Area (5 mi) | City | State`), city presets, zoom-aware marker clustering, `IncidentDetailSheet`, Street View Static API + CesiumJS Photorealistic 3D Tiles WebView, `CountyJailBookingAdapter`, and `AllegedOffenderCard` with mandatory `"Presumed innocent"` disclaimer and 100% free removal button.
- [x] **Module B (Historical Territories):** Toggleable translucent `Polygon` overlays, tap-to-inspect `TerritoryContextSheet` (`"Historical / Publicly Documented Neighborhood Context"`, `citationDate`, `sourceReference`), and `TerritorySubmissionDialog` writing strictly to `territory_submissions`.
- [x] **Module C (Civic Camera Radar):** Local Hive CE spatial cache (`LocalCameraCache`) keyed by geohash cell (zero Firestore polling on GPS ticks), Haversine proximity engine (`CameraRadarController`), animated `"Entering ALPR / Public Camera Zone"` banner, audio chime ducking, anonymized residential density circles, and anti-doxxing public camera report form.
- [x] **Module D (Indie Geo-Radio & Creator Portal):** Persistent `just_audio` + `audio_service` mini-player docked above the 5-tab `StatefulShellRoute` shell, map-to-radio city sync via `ref.listen`, city/genre discovery tab with one-click DMCA reporting, and `CreatorPortalScreen` enforcing 100% ownership warranty checkbox + typed legal signature before upload.
- [x] **Module E (Monetization, FCM & Compliance):** RevenueCat v9 Free vs Pro paywall (`PaywallScreen`), `FreeTierAdBanner` (auto-hidden for Pro), custom geofence & FCM topic manager, `ArtistBoostSheet`, 100% free `MugshotRemovalSheet`, and `DmcaReportDialog`.
- [x] **Firebase Auth UI (`lib/features/auth/`):** `AppUser`, `AuthRepository`, `FirebaseAuthRepository` (Email/Password, Google, Apple, Password Reset + `users/{uid}` Firestore profile sync with offline mock fallback), `AuthController`, `AuthSheet` (preserving guest browsing & 100% free record removal), and `AccountActionChip`.
- [x] **Documentation & Store Review Materials:** Authored comprehensive `README.md` and copy-paste App Store / Google Play compliance review notes (`docs/APP_STORE_COMPLIANCE.md`).
- [x] **Release Build Verification:**
  - Verified live Android Emulator (`emulator-5554`) launch + live Flutter Web preview (`http://127.0.0.1:8088/#/map`).
  - Built production **Android Release APK** (`build/app/outputs/flutter-apk/app-release.apk`, `60.8 MB`) cleanly with official Firebase `google-services.json`, live Maps API key, and live RevenueCat SDK.
  - Built production **Flutter Web Release Bundle** (`build/web/`).
- [x] **Pre-Commit Verification Gate:** `build_runner` (0 errors), `flutter analyze --fatal-infos` (0 issues), `flutter test` (**35/35 passed**), `functions` build & Jest (**25/25 passed**), and Compliance/Secret/Architecture scans (**0 hardcoded secrets, 0 banned Apple 1.4.4 strings, 0 layer violations, 0 tracked secret files**).

### External Services & Key Setup (All Secrets Kept Locally in Gitignored Files)
- [x] **Google Cloud (`crimemaps-515702`):** Enabled all 5 Maps APIs; restricted `Maps Platform API Key` to **only those 5 Maps APIs**; created & published Dark Map Style **`Crime Maps Dark Car-Nav`** (`4daefcf00649c519c8e4111b`) and attached it to Map ID `85079358df0fab979e47647c`.
- [x] **Firebase (`crimemaps-515702` — Blaze Active & Deployed):** Enabled Authentication (Email/Password + Google), Cloud Firestore (`nam5`), Firebase Storage (`US-EAST1`), Secret Manager entries, and all 5 Cloud Functions v2; downloaded official gitignored `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` via Firebase CLI and saved Web config to local `.env`.
- [x] **RevenueCat (`CrimeMapsAi` / `proj3c8fa1e5`):** Created `Crime Maps Android` (`com.crimemaps.crime_maps`) and `Crime Maps iOS` (`com.crimemaps.crimeMaps`, reusing Apple IAP key `H2Q4Y496N5`); saved both public SDK keys to local `.env`.
- [x] **Google AdMob:** Configured official Google test AdMob IDs in `.env` for dev/emulator safety.

---

## 2. Remaining Manual / Owner-Action Items for Store Launch

Everything buildable and verifiable in code, tests, Cloud Functions, security rules, and release artifacts is **complete**. The remaining checklist items require store console accounts, signing keys, or optional paid subscriptions owned by you:

1. **Google Play & App Store Subscriptions (RevenueCat):**
   - [ ] Create matching subscriptions (`pro_monthly`, `pro_annual`) and Artist Boost consumables (`boost_24h_zip`, `boost_7d_city`, `boost_30d_metro`) in Google Play Console & App Store Connect and link them to RevenueCat entitlement `pro_access`.
   - [ ] Upload Google Play Service Account JSON to RevenueCat `Crime Maps Android` (`app4470811710`).
2. **Google AdMob Production IDs:**
   - [ ] Complete AdMob reactivation review (`phillipojames@gmail.com`), create production Android & iOS AdMob apps + Banner Ad Unit, and replace Google's test IDs in release `.env`.
3. **Production Live Data Mode Switch (When Ready):**
   - [ ] Copy desired live Socrata/OSM config from `functions/.env.live.example` into `functions/.env.crimemaps-515702`, optionally set real Secret Manager API keys (`SPOTCRIME_API_KEY`, `SOCRATA_APP_TOKEN`, `ARCGIS_TOKEN`, `DEFLOCK_API_KEY`), run `firebase deploy --project crimemaps-515702 --only functions`, and flip `USE_MOCK_DATA=false` in `.env`.
   - [ ] Enable Apple Sign-In provider & Firebase App Check in Firebase Console before App Store review.
4. **Signed Store Release Artifacts:**
   - [ ] Generate your private Android upload keystore (`keytool`), create local gitignored `android/key.properties` from `android/key.properties.example`, and build `flutter build appbundle --release --dart-define-from-file=.env`.
   - [ ] On macOS/Xcode: create local gitignored `ios/Flutter/Secrets.xcconfig` from `ios/Flutter/Secrets.xcconfig.example`, run `cd ios && pod install`, archive via Xcode, and attach review notes from `docs/APP_STORE_COMPLIANCE.md`.
   - [ ] Add final release SHA-1 / iOS Bundle ID / web domain application restrictions to `Maps Platform API Key` once store signing certificates are finalized.
