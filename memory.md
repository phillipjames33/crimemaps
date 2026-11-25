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
- [x] **Live Production Data Ingestion Verified (`crimemaps-515702` — `USE_MOCK_DATA=false`):**
  - Activated live free 2026 municipal Socrata crime feeds (**Chicago PD `ijzp-q8t2`**, **San Francisco PD `wg3w-h783`**, and **Dallas PD `qv6i-rri7`** with nested dot-path coordinate support in `functions/src/utils/json.ts`) PLUS the official public **INTERPOL U.S. Arrest Warrant Red Notices API** (`InterpolRedNoticeAdapter`, `ws-public.interpol.int`, CORS-enabled `image/JPG` public warrant photos) with a 14-day lookback window, idempotent deterministic IDs, mandatory Presumed Innocent disclaimer, 45-day automatic TTL, 100% free record removal preservation, and a 24-hour recency guard in `onHighSeverityIncident`.
  - Activated live **OpenStreetMap Overpass** multi-city civic camera sync (**Atlanta, Chicago & San Francisco** metros) with compliant `User-Agent` header and anti-doxxing filter.
  - Added `San Francisco, CA`, `Dallas, TX`, and `New York, NY` city presets to `MapController.cityPresets`, added live mugshot thumbnails on map incident cards, a 1-tap **`Mugshots (N)`** map filter chip, and a **`View City`** empty-scope quick button.
  - Verified live production Firestore collections on `crimemaps-515702`: **290+ live `incidents`** (**100** Dallas PD + **98** Chicago PD + **63** San Francisco PD + **20** live official INTERPOL U.S. Arrest Warrant records with CORS-enabled mugshots across San Francisco [6], New York [4], Dallas [3], Los Angeles [3], Atlanta [2], Chicago [1], Houston [1] + **13** Atlanta/GA/US baseline), **752 live OSM `cameras`**, **4 historical `territories`**, and **6 active royalty-free `tracks`**.
  - Verified end-to-end live Firestore streaming on https://crimemaps-515702.web.app/app/ and on the native Android production release build (`com.crimemaps.crime_maps`).
- [x] Built Firestore CLI seeder (`functions/src/seed/seedFirestore.ts`) and verified seeding against the local Firebase Emulator Suite (`14` incidents, `7` public cameras with `2` private residential cameras blocked, `4` historical territories, `6` indie tracks).
- [x] Configured Artifact Registry 1-day container cleanup policy across `us-central1` and `us-east1`.

### Phases 3–6 — Flutter Features, Compliance, Release Builds & Verification
- [x] **Module A (Car-Nav Crime Map & Incidents):** Full-screen dark car-nav Google Map, scope pills (`My Area (5 mi) | City | State`), city presets, zoom-aware marker clustering, `IncidentDetailSheet`, Street View Static API + CesiumJS Photorealistic 3D Tiles WebView, `CountyJailBookingAdapter`, and `AllegedOffenderCard` with mandatory `"Presumed innocent"` disclaimer and 100% free removal button.
- [x] **Module B (Historical Territories):** Toggleable translucent `Polygon` overlays, tap-to-inspect `TerritoryContextSheet` (`"Historical / Publicly Documented Neighborhood Context"`, `citationDate`, `sourceReference`), and `TerritorySubmissionDialog` writing strictly to `territory_submissions`.
- [x] **Module C (Civic Camera Radar):** Local Hive CE spatial cache (`LocalCameraCache`) keyed by geohash cell (zero Firestore polling on GPS ticks), Haversine proximity engine (`CameraRadarController`), animated `"Entering ALPR / Public Camera Zone"` banner, audio chime ducking, anonymized residential density circles, and anti-doxxing public camera report form.
- [x] **Module D (Indie Geo-Radio & Creator Portal):** Persistent `just_audio` + `audio_service` mini-player docked above the 5-tab `StatefulShellRoute` shell, map-to-radio city sync via `ref.listen`, city/genre discovery tab with one-click DMCA reporting, and `CreatorPortalScreen` enforcing 100% ownership warranty checkbox + typed legal signature before upload.
- [x] **Module E (Monetization, FCM & Compliance):** RevenueCat v9 Free vs Pro paywall (`PaywallScreen`), `FreeTierAdBanner` (auto-hidden for Pro), custom geofence & FCM topic manager, `ArtistBoostSheet`, 100% free `MugshotRemovalSheet`, and `DmcaReportDialog`.
- [x] **Firebase Auth UI & Guideline 5.1.1(v) Account Deletion (`lib/features/auth/`):** `AppUser`, `AuthRepository`, `FirebaseAuthRepository` (Email/Password, Google, Apple, Password Reset, permanent `deleteAccount()` deleting `users/{uid}` + Firebase Auth user, with offline mock fallback), `AuthController`, `AuthSheet` (preserving guest browsing, 100% free record removal, **Delete Account Permanently** confirmation flow, and clickable hosted legal links), and `AccountActionChip`.
- [x] **Paywall Legal Disclosures (Apple Guideline 3.1.2(c)):** Added auto-renewal cancellation notice and clickable **Privacy Policy**, **Terms of Service**, and **Free Record Removal** links directly on `PaywallScreen`.
- [x] **Live Production Web App & Legal Portal (`hosting/` -> `https://crimemaps-515702.web.app`):**
  - Deployed and HTTP-200 verified live production Flutter Web app (`USE_MOCK_DATA=false`, `--base-href "/app/"`, `hosting/app/` gitignored so zero build artifacts or keys enter Git) alongside the static legal portal:
    - `https://crimemaps-515702.web.app/` (Overview, Presumed Innocent Pledge & **Launch Live Web App** CTA)
    - `https://crimemaps-515702.web.app/app/` (**Live Production Crime Maps Web App** with SPA `/app/**` rewrite in `firebase.json`)
    - `https://crimemaps-515702.web.app/privacy.html` (App Store & Google Play Privacy Policy)
    - `https://crimemaps-515702.web.app/terms.html` (Terms of Service, Indie Warranty & DMCA Safe Harbor)
    - `https://crimemaps-515702.web.app/removal.html` (100% Free Record Removal & Web Account Deletion Portal)
- [x] **Live Firestore Civic Camera Map Layer, Local Bookmarks & Firebase App Check:**
  - Wired `CameraRepository.fetchCamerasForArea(...)` (`limit(150)`, zero GPS polling, anti-doxxing filtered) and `camerasForMapViewportProvider` (scoped `.select()` on city/state/scope) directly into `CrimeMapScreen`, rendering live Firestore OSM civic cameras and a live `Civic Cameras` count pill on the map.
  - Added local Hive-backed `SavedIncidentsController` with a 1-tap bookmark toggle on `IncidentDetailSheet` and a toggleable `Saved (N)` bookmark filter chip on `CrimeMapScreen` (works cleanly in guest mode with zero Firestore writes).
  - Activated `FirebaseAppCheck` safely in `FirebaseBootstrap` (`AndroidProvider.playIntegrity`/`debug`, `AppleProvider.appAttestWithDeviceCheckFallback`/`debug`, optional Web `ReCaptchaV3Provider` via `RECAPTCHA_V3_SITE_KEY`).
- [x] **GitHub Actions CI/CD Verification Pipeline (`.github/workflows/ci.yml`):** Automated 3-job workflow (`flutter-verify`, `functions-verify`, `compliance-and-security-scan`) enforcing the 4-Step Pre-Commit Verification Gate on every push and pull request to `main`.
- [x] **Store Launch Assets & Submission Kit (`assets/store/` + `docs/STORE_LISTING_KIT.md`):**
  - Generated official **Google Play Feature Graphic (`1024x500`)** at `assets/store/feature_graphic_1024x500.png`.
  - Captured and visually verified **5 live production dark-mode Android phone screenshots (`1080x2400`)** across all 5 tabs (`assets/store/screenshots/01_crime_map.png` through `05_pro_paywall.png`).
  - Fixed Android/iOS dark car-navigation map rendering (`_darkMapStyle`) across both Light and Dark OS themes and fixed Creator Portal narrow-screen audio button wrapping (`Wrap`).
  - Authored complete copy-paste **Google Play Console & Apple App Store Connect Submission Kit** (`docs/STORE_LISTING_KIT.md`) covering metadata, keywords, SKU tables, Data Safety / App Privacy matrices, and reviewer test steps.
- [x] **Documentation & Store Review Materials:** Authored comprehensive `README.md`, `docs/APP_STORE_COMPLIANCE.md`, and `docs/STORE_LISTING_KIT.md` including live Hosting legal URLs.
- [x] **Custom App Icon & Dark Launch Splash Screen (Android, iOS & Web):**
  - Rendered and installed custom dark car-navigation Crime Maps emblem across all 5 Android `mipmap-*` densities, all 15 opaque 24-bit RGB iOS `AppIcon.appiconset` sizes (`20x20` to `1024x1024`), and all 5 Web icons/favicons (`web/manifest.json` theme `#0B0F17`).
  - Configured `#0B0F17` dark Android launch background with centered `splash_logo.png` (`drawable/launch_background.xml` & `drawable-v21/launch_background.xml`).
- [x] **Release Build Verification & Signed Google Play `.aab`:**
  - Verified live Android Emulator (`emulator-5554`) launch + live Flutter Web preview (`http://127.0.0.1:8088/#/map`).
  - Generated local gitignored 2048-bit RSA Android upload keystore (`android/upload-keystore.jks` + `android/key.properties`), registered release SHA-1 (`26:A4:B0:0A:37:BD:D5:D3:2A:E4:0D:29:79:9A:55:21:F2:49:C9:FD`) & SHA-256 on Firebase Android app `1:864680228535:android:763df22703a56cfa757f32`, and refreshed `android/app/google-services.json`.
  - Built & verified signed **Google Play App Bundle:** `build/app/outputs/bundle/release/app-release.aab` (`53.3 MB`, `jarsigner -verify` passed) with `USE_MOCK_DATA=false`, custom icon/splash, and live Firebase/Maps/RevenueCat keys.
  - Built production **Android Release APK** (`build/app/outputs/flutter-apk/app-release.apk`, `60.8 MB`) and **Flutter Web Release Bundle** (`build/web/`).
- [x] **Pre-Commit Verification Gate:** `build_runner` (0 errors), `flutter analyze --fatal-infos` (0 issues), `flutter test` (**39/39 passed**), `functions` build & Jest (**27/27 passed**), and Compliance/Secret/Architecture scans (**0 hardcoded secrets, 0 banned Apple 1.4.4 strings, 0 layer violations, 0 tracked secret files**).

### External Services & Key Setup (All Secrets Kept Locally in Gitignored Files)
- [x] **Google Cloud (`crimemaps-515702`):** Enabled all 5 Maps APIs; restricted `Maps Platform API Key` to **only those 5 Maps APIs**; created & published Dark Map Style **`Crime Maps Dark Car-Nav`** (`4daefcf00649c519c8e4111b`) and attached it to Map ID `85079358df0fab979e47647c`.
- [x] **Firebase (`crimemaps-515702` — Blaze Active & Deployed):** Enabled Authentication (Email/Password + Google), Cloud Firestore (`nam5`), Firebase Storage (`US-EAST1`), Secret Manager entries, and all 5 Cloud Functions v2; downloaded official gitignored `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` via Firebase CLI and saved Web config to local `.env`.
- [x] **RevenueCat (`CrimeMapsAi` / `proj3c8fa1e5`):**
  - Created `Crime Maps Android` (`com.crimemaps.crime_maps`) and `Crime Maps iOS` (`com.crimemaps.crimeMaps`, reusing Apple IAP key `H2Q4Y496N5`); saved both public SDK keys to local `.env`.
  - Created **`pro_access`** entitlement (`entlab0724eb2e`) with 6 attached products across Android, iOS, and Test Store.
  - Registered all 10 Android & iOS product IDs (`pro_monthly`, `pro_annual`, `boost_24h_zip`, `boost_7d_city`, `boost_30d_metro`) and configured **`default`** Current Offering (`ofrng4d0aa6f57c`) with `$rc_monthly` and `$rc_annual`.
- [x] **Google AdMob:** Configured official Google test AdMob IDs in `.env` for dev/emulator safety.

---

## 2. Remaining Manual / Owner-Action Items for Store Launch

Everything buildable and verifiable in code, tests, Cloud Functions, security rules, and release artifacts is **complete**. The remaining checklist items require store console accounts, signing keys, or optional paid subscriptions owned by you:

1. **Google Play Console & App Store Connect Store Sync:**
   - [ ] Upload `build/app/outputs/bundle/release/app-release.aab` to Google Play Console (Internal Testing / Production track) using review notes from `docs/APP_STORE_COMPLIANCE.md`.
   - [ ] Create matching subscription/IAP SKUs (`pro_monthly`, `pro_annual`, `boost_24h_zip`, `boost_7d_city`, `boost_30d_metro`) in Google Play Console & App Store Connect, and upload your Google Play Service Account JSON to RevenueCat `Crime Maps Android` (`app4470811710`).
2. **Google AdMob Production IDs:**
   - [ ] Complete AdMob reactivation review (`phillipojames@gmail.com`), create production Android & iOS AdMob apps + Banner Ad Unit, and replace Google's test IDs in release `.env`.
3. **Optional Paid Feeds & App Check (Before Public Store Launch):**
   - [ ] Optionally replace Secret Manager placeholders (`SPOTCRIME_API_KEY`, `SOCRATA_APP_TOKEN`, `ARCGIS_TOKEN`, `DEFLOCK_API_KEY`) if adding higher-rate or paid commercial feeds.
   - [ ] Enable Apple Sign-In provider & Firebase App Check in Firebase Console before App Store review.
4. **macOS / Xcode iOS Archive & Final Key Restrictions:**
   - [ ] Back up local gitignored `android/upload-keystore.jks` and `android/key.properties` safely outside the repo (required for all future Google Play updates!).
   - [ ] On macOS/Xcode: create local gitignored `ios/Flutter/Secrets.xcconfig` from `ios/Flutter/Secrets.xcconfig.example`, run `cd ios && pod install`, archive via Xcode, and attach review notes from `docs/APP_STORE_COMPLIANCE.md`.
   - [ ] Add final release SHA-1 (`26:A4:B0:0A:37:BD:D5:D3:2A:E4:0D:29:79:9A:55:21:F2:49:C9:FD`) / Play App Signing SHA-1 / iOS Bundle ID restrictions to `Maps Platform API Key` once store signing is finalized.
