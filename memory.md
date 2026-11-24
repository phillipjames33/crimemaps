# CRIME MAPS — PROJECT MEMORY & PROGRESS TRACKER

> **Living Document:** Update this file whenever a feature, integration, verification step, or deployment milestone is completed, or when new work / blockers are identified. Never store API keys, tokens, or secrets in this file.

- **Last Updated:** 2026-11-24
- **GitHub Repository:** https://github.com/phillipjames33/crimemaps (`origin/main`)
- **Default Branch:** `main`
- **Google Cloud Project:** `crimemaps-515702` (Project Number `864680228535`)
- **RevenueCat Project:** `CrimeMapsAi` (`proj3c8fa1e5`)
- **App Identifiers:** Android `com.crimemaps.crime_maps` | iOS `com.crimemaps.crimeMaps`

---

## 1. Completed Work

### Phase 1 — Project Scaffold, Native Permissions & Core Architecture
- [x] Initialized Flutter project (`crime_maps`) targeting iOS, Android, and Web preview.
- [x] Configured strict lints (`analysis_options.yaml`) and workspace rules (`.agents/rules/crime-maps-rules.md`).
- [x] Configured Android (`AndroidManifest.xml`, `build.gradle.kts`) and iOS (`Info.plist`, `Podfile`, `AppDelegate.swift`) permissions for Google Maps, foreground/background Location, Audio background playback (`audio_service`), and AdMob placeholders.
- [x] Wired `android/app/build.gradle.kts` to read `GOOGLE_MAPS_API_KEY` and `ADMOB_ANDROID_APP_ID` from Gradle properties, environment variables, or the gitignored root `.env` file (zero hardcoded secrets).
- [x] Built `lib/core/` infrastructure: `AppEnv` (`--dart-define`), `ComplianceConstants`, dark car-navigation `AppTheme`, pure-Dart `GeohashUtil` (geohash encoder + Haversine distance), `LocationGateway` / `userLocationStream`, `FirebaseBootstrap`, `FcmTopicService`, and realistic Atlanta/Georgia + multi-state `SeedData`.
- [x] Defined all 8 feature `domain/` layers using Freezed v3 immutable models with zero Flutter UI or Firebase SDK imports.

### Phase 2 — Firebase Backend, Security Rules & Seed Pipeline
- [x] Authored default-deny `firestore.rules` and `storage.rules` enforcing:
  - Public read / Admin-only write on `incidents` and `territories`.
  - Anti-doxxing validation on `cameras` (`alpr_flock`, `traffic`, `red_light` only; `isPrivateResidence != true`).
  - Moderated `territory_submissions` queue (`moderationStatus == 'pending_review'`).
  - 100% indie ownership warranty (`rightsWarranty.owns100Percent == true`, `signedName`, `signedAt`) on `tracks` & Storage uploads (<= 25 MB).
  - 100% free `removal_requests` creation and DMCA Safe Harbor `dmca_claims` + instant `flagged_dmca` transition.
- [x] Authored `firestore.indexes.json` with composite indexes and native 45-day TTL override (`incidents.expireAt`).
- [x] Implemented all 5 Firebase Cloud Functions v2 in strict TypeScript (`"strict": true`, 0 `any` types):
  - `ingestCrimeFeeds` (`onSchedule`) — idempotent deterministic IDs, geohashing, 45-day TTL, Presumed Innocent disclaimer, Socrata/ArcGIS/SpotCrime/Mock adapters.
  - `syncPublicCameras` (`onSchedule`) — OpenStreetMap/DeFlock adapter with anti-doxxing rejection.
  - `onHighSeverityIncident` (`onDocumentCreated`) — FCM push notifications to `geo_`, `city_`, `state_` topics.
  - `onTrackUploaded` (`onObjectFinalized`) — MIME/size/warranty validation, track activation or quarantine.
  - `submitMugshotRemoval` (`onCall`) — 100% free instant redaction of `allegedOffender` pending verification.
- [x] Built Firestore CLI seeder (`functions/src/seed/seedFirestore.ts`) and verified seeding against the local Firebase Emulator Suite (`14` incidents, `7` public cameras with `2` private residential cameras blocked, `4` historical territories, `6` indie tracks).
- [x] Verified `functions/` build (`tsc`) and Jest test suite (**3/3 suites, 25/25 tests passed**).

### Phases 3–6 — Flutter Features, Compliance & Verification
- [x] **Module A (Car-Nav Crime Map & Incidents):** Full-screen dark car-nav Google Map, scope pills (`My Area (5 mi) | City | State`), city presets, zoom-aware marker clustering, `IncidentDetailSheet`, Street View Static API + CesiumJS Photorealistic 3D Tiles WebView, `CountyJailBookingAdapter`, and `AllegedOffenderCard` with mandatory `"Presumed innocent"` disclaimer and 100% free removal button.
- [x] **Module B (Historical Territories):** Toggleable translucent `Polygon` overlays, tap-to-inspect `TerritoryContextSheet` (`"Historical / Publicly Documented Neighborhood Context"`, `citationDate`, `sourceReference`), and `TerritorySubmissionDialog` writing strictly to `territory_submissions`.
- [x] **Module C (Civic Camera Radar):** Local Hive CE spatial cache (`LocalCameraCache`) keyed by geohash cell (zero Firestore polling on GPS ticks), Haversine proximity engine (`CameraRadarController`), animated `"Entering ALPR / Public Camera Zone"` banner, audio chime ducking, anonymized residential density circles, and anti-doxxing public camera report form.
- [x] **Module D (Indie Geo-Radio & Creator Portal):** Persistent `just_audio` + `audio_service` mini-player docked above the 5-tab `StatefulShellRoute` shell, map-to-radio city sync via `ref.listen`, city/genre discovery tab with one-click DMCA reporting, and `CreatorPortalScreen` enforcing 100% ownership warranty checkbox + typed legal signature before upload.
- [x] **Module E (Monetization, FCM & Compliance):** RevenueCat v9 Free vs Pro paywall (`PaywallScreen`), `FreeTierAdBanner` (auto-hidden for Pro), custom geofence & FCM topic manager, `ArtistBoostSheet`, 100% free `MugshotRemovalSheet`, and `DmcaReportDialog`.
- [x] **Firebase Auth UI (`lib/features/auth/`):** Implemented immutable `AppUser`, `AuthRepository`, `FirebaseAuthRepository` (Email/Password, Google, Apple, Password Reset + `users/{uid}` Firestore profile sync with offline mock fallback), `AuthController`, `AuthSheet` (explicitly preserving guest access for map browsing and 100% free record removal), and `AccountActionChip` across Creator, Pro, and Radar screens.
- [x] **Web Preview & Android Emulator Launch:** Verified live Android Emulator (`emulator-5554`) launch with live Google Maps tiles and zero authorization errors; enabled Flutter Web preview (`http://127.0.0.1:8088/#/map`) with gitignored `web/env_config.js` Maps JS loader and `kIsWeb` platform guards.
- [x] **Pre-Commit Verification Gate:** `build_runner` (0 errors), `flutter analyze --fatal-infos` (0 issues), `flutter test` (**35/35 passed**), `functions` Jest (**25/25 passed**), and Compliance/Secret/Architecture scans (**0 hardcoded secrets, 0 banned Apple 1.4.4 strings, 0 layer violations**).
- [x] **GitHub Sync:** Connected `origin` (`https://github.com/phillipjames33/crimemaps.git`) and pushed `main` with zero tracked secret files.

### External Service & Key Setup (Stored Locally in Gitignored `.env`)
- [x] **Google Cloud (`crimemaps-515702`):** Enabled Maps SDK for Android, Maps SDK for iOS, Maps JavaScript API, Street View Static API, and Map Tiles API; created `GOOGLE_MAPS_API_KEY` and Android `GOOGLE_MAPS_MAP_ID` (`85079358df0fab979e47647c`).
- [x] **Firebase (`crimemaps-515702` — Blaze Active & Production Backend Deployed):**
  - Provisioned Firebase on `crimemaps-515702`; enabled Authentication (**Email/Password** + **Google**), Cloud Firestore (`nam5`, production mode), and Firebase Storage (`gs://crimemaps-515702.firebasestorage.app`, `US-EAST1`, production mode).
  - Registered Web (`1:864680228535:web:d59629693cb445b1757f32`), Android (`com.crimemaps.crime_maps` with debug SHA-1, `google-services.json` placed locally in gitignored `android/app/`), and iOS (`com.crimemaps.crimeMaps`) apps; saved Firebase Web config to local `.env` and updated `.firebaserc`.
  - Deployed `firestore.rules`, `firestore.indexes.json` (with `incidents.expireAt` 45-day TTL override), `storage.rules`, Secret Manager entries (`SPOTCRIME_API_KEY`, `SOCRATA_APP_TOKEN`, `ARCGIS_TOKEN`, `DEFLOCK_API_KEY`), and **all 5 Cloud Functions v2** (`ingestCrimeFeeds`, `syncPublicCameras`, `onHighSeverityIncident`, `submitMugshotRemoval` in `us-central1`, and `onTrackUploaded` in `us-east1`).
  - Configured Artifact Registry 1-day container cleanup policy across `us-central1` and `us-east1`.
- [x] **RevenueCat (`CrimeMapsAi` / `proj3c8fa1e5`):** Created `Crime Maps Android` (`com.crimemaps.crime_maps`) and `Crime Maps iOS` (`com.crimemaps.crimeMaps`, reusing Apple IAP key `H2Q4Y496N5`); saved both public SDK keys to local `.env`.
- [x] **Google AdMob:** Configured official Google test AdMob App IDs & Banner Unit ID in `.env` for safe dev/emulator testing.

---

## 2. What Still Needs to Be Completed

### Security & Production Backend Provisioning
- [ ] **Finalize Native Firebase & Live Mode (`crimemaps-515702`):**
  - [ ] Add `com.google.gms.google-services` Gradle plugin to Android build (using local gitignored `android/app/google-services.json`) and download `ios/Runner/GoogleService-Info.plist` from Firebase Console for iOS builds.
  - [ ] Enable Apple Sign-In provider & Firebase App Check in Firebase Console before App Store release.
  - [ ] Replace Secret Manager placeholders (`SPOTCRIME_API_KEY`, `SOCRATA_APP_TOKEN`, `ARCGIS_TOKEN`, `DEFLOCK_API_KEY`) when plugging in live paid/authenticated feeds, configure `CRIME_FEED_SOURCES` / `CAMERA_FEED_SOURCES`, and switch `USE_MOCK_DATA=false`.
- [ ] **Restrict Google Maps API Key:** In Google Cloud Console (`crimemaps-515702` → Maps Platform → Credentials), restrict `Maps Platform API Key` to only the 5 enabled Maps APIs and your Android SHA-1 / iOS Bundle ID / Web referrer restrictions before release.
- [ ] **Attach Dark Cloud Map Style (Optional):** Bind a dark map style to Cloud Map ID `85079358df0fab979e47647c` in Google Maps Studio (or leave `GOOGLE_MAPS_MAP_ID` blank to use the bundled `assets/map_styles/dark_car_nav.json`).

### Live Data Feeds (Post-MVP / Production)
- [ ] **Municipal Open Data Crime Feeds (Free):** Configure `CRIME_FEED_SOURCES` with live Socrata/ArcGIS endpoints (e.g., Atlanta PD, Chicago PD, LAPD open data portals) in Cloud Functions runtime config.
- [ ] **SpotCrime API (Optional Paid):** Apply at `spotcrime.io/request-access` (\$199+/mo + static egress IP via Cloud NAT) if commercial nationwide SpotCrime aggregation is needed.
- [ ] **County Jail Booking API (`BOOKING_API_KEY`):** Connect a self-serve booking API provider (e.g., RapidAPI JailBase) or official county sheriff API feeds if live booking photos/charges are required beyond mock/adapter testing.

### Monetization & Store Readiness
- [ ] **Google AdMob Reactivation & Production IDs:** Complete AdMob account reactivation review in Google AdMob console, register production Android & iOS apps + Banner Ad Unit, and replace the Google test IDs in release `.env`.
- [ ] **RevenueCat Store Credentials & Offerings:**
  - [ ] Upload Google Play Service Account JSON to RevenueCat `Crime Maps Android` (`app4470811710`).
  - [ ] Create matching subscriptions (`pro_monthly`, `pro_annual`) and consumable IAPs (`boost_24h_zip`, `boost_7d_city`, `boost_30d_metro`) in App Store Connect and Google Play Console, and attach them to RevenueCat Entitlement `pro_access` / Offerings.
- [ ] **Release Signing & Store Submission:**
  - [ ] Configure Android release keystore (`key.properties`) and build signed AAB (`flutter build appbundle`).
  - [ ] Build & archive iOS IPA on macOS/Xcode (`pod install`, set `GOOGLE_MAPS_API_KEY` in `ios/Flutter/Release.xcconfig`), verify Apple Guideline 1.4.4 review notes (Civic Transparency & Privacy Awareness framing), and submit to App Store & Google Play.
