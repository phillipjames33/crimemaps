---
description: Core engineering, Flutter/Riverpod, compliance, and pre-commit verification rules for Crime Maps.
alwaysApply: true
---

# CRIME MAPS — WORKSPACE RULES

You are working on **Crime Maps** (Flutter iOS/Android + Firebase + Google Maps Platform). Every file you write, modify, or commit MUST comply with the architectural, legal, and verification standards below. Never bypass a rule to make a build pass.

---

## 1. FLUTTER & RIVERPOD ARCHITECTURE STANDARDS

### Project Structure (Feature-First, Strict Layering)
Organize `lib/` strictly by feature under `lib/features/<feature_name>/` (`map`, `incidents`, `territories`, `camera_radar`, `geo_radio`, `creator_portal`, `monetization`, `compliance`):
- `domain/` — Immutable models (`freezed` + `json_serializable`), enums, and repository interfaces. Zero Flutter UI or Firebase SDK imports.
- `data/` — Firestore repositories, SQLite/Hive local caches, and external API adapters (SpotCrime, OSM/DeFlock, Jail Booking APIs).
- `presentation/` — Widgets, screens, and Riverpod controllers/notifiers.

### Riverpod Rules (Mandatory)
- **Codegen Only:** Use `@riverpod` (`riverpod_annotation` + `riverpod_generator`). Do NOT use legacy `StateNotifierProvider` or `ChangeNotifierProvider`.
- **No Side Effects in `build()`:** Never trigger navigation, snackbars, or Firestore writes inside widget `build()` methods. Use `ref.listen()` for UI side effects.
- **No Direct SDK Calls in UI:** Widgets must NEVER import `cloud_firestore`, `firebase_storage`, or `geolocator` directly. All data access goes through Riverpod providers backed by repository interfaces.
- **Exhaustive `AsyncValue` Handling:** Always handle `.when(data:, loading:, error:)` or pattern-match `AsyncData` / `AsyncLoading` / `AsyncError` cleanly—never force-unwrap `.value!`.
- **Scoped Rebuilds:** Use `ref.watch(provider.select((s) => s.field))` on high-frequency streams (GPS heading, audio playback position, map camera movement) to prevent 60fps frame drops.

### Maps, Geospatial & Audio Performance
- **Geohash Bounding-Box Queries Only:** Never query entire `incidents` or `cameras` collections without a geohash bounding-box filter (`geoflutterfire_plus`) and a `limit()`.
- **Zero Firestore Polling for Camera Radar:** Real-time "On Camera" proximity checks MUST run locally against the SQLite/Hive spatial cache synced per geohash cell—never hit Firestore on every GPS tick.
- **Persistent Shell Navigation:** Use `go_router` `StatefulShellRoute` so the Google Map instance and `just_audio` / `audio_service` mini-player stay alive without re-initializing when switching tabs.
- **Resource Disposal:** Every `GoogleMapController`, `StreamSubscription`, `TextEditingController`, and `AudioPlayer` must be disposed via `ref.onDispose()` or `State.dispose()`.

---

## 2. MANDATORY LEGAL & APP STORE COMPLIANCE GUARDRAILS

These constraints are **non-negotiable**. Reject or refactor any code, UI copy, or schema that violates them:

1. **Apple Guideline 1.4.4 (Civic Transparency Only):**
   - Frame the Camera Radar feature strictly as **Civic Transparency, Public Data Mapping & Privacy Awareness**.
   - **BANNED UI/Code Copy:** Never use phrases like *"avoid police"*, *"evade cops"*, *"dodge speed traps"*, *"hide from cameras"*, or *"beat the radar"* anywhere in UI strings, push notifications, metadata, or comments.
2. **Alleged Offender & Mugshot Protection:**
   - Every incident detail view displaying booking data MUST render the visible disclaimer: *"Alleged / Public Arrest Record — All individuals are presumed innocent until proven guilty."*
   - Every `incidents` document containing `allegedOffender` data MUST set an automatic Firestore TTL timestamp (`expireAt` = `bookingDate + 45 days`).
   - The **"Request Record Removal / Expungement"** flow MUST remain 100% free, accessible from every offender card, and never gated behind a paywall or subscription.
3. **Historical Territory Context:**
   - All gang territory overlays MUST display the label **"Historical / Publicly Documented Neighborhood Context"** along with a `citationDate` and `sourceReference`.
   - Community territory edits must write to `territory_submissions` for moderation—never directly to the live `territories` collection.
4. **Anti-Doxxing (Private Residential Cameras):**
   - Never allow exact street-address pinning of private residential doorbells (e.g., individual Ring cameras). Public pins are restricted to `alpr_flock`, `traffic`, and `red_light` infrastructure. Residential data is only permitted as anonymized neighborhood-level density heatmaps.
5. **100% Indie Music Rights & DMCA Safe Harbor:**
   - Block any audio upload in both the Flutter UI and `storage.rules` / `firestore.rules` unless `rightsWarranty.owns100Percent == true` and `signedName` + `signedAt` are recorded.
   - Every track card/player must include a working **"Report Copyright Infringement (DMCA)"** action that writes to `dmca_claims` and immediately transitions `status` to `flagged_dmca` (hiding it from public queries).

---

## 3. FIREBASE BACKEND & SECURITY RULES

- **Strict TypeScript:** All code in `functions/` must compile with `"strict": true` in `tsconfig.json`. No `any` types without an explicit justification comment.
- **Rules Parity:** Whenever a new Firestore collection or Firebase Storage path is added, you MUST update `firestore.rules`, `storage.rules`, and `firestore.indexes.json` in the same commit. Default-deny everything not explicitly matched.
- **Zero Hardcoded Secrets:** Never commit API keys, service account JSONs, `.env` files, or RevenueCat/Google Maps keys. Read all secrets via `--dart-define` (Flutter) or Firebase Secret Manager / `defineSecret()` (Cloud Functions v2).
- **Idempotent Pipelines:** Scheduled ingestion functions (`ingestCrimeFeeds`, `syncPublicCameras`) must use deterministic document IDs so re-runs update rather than duplicate records.

---

## 4. AUTOMATED PRE-COMMIT VERIFICATION GATE

Before executing **any** `git commit` or marking a task complete, you MUST run the full verification pipeline below and confirm **zero errors** from actual terminal output. Never skip tests or use `--no-verify`.

### Step 1: Code Generation & Static Analysis (Flutter)
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze --fatal-infos
```

### Step 2: Flutter Unit & Widget Tests
```bash
flutter test --reporter expanded
```

### Step 3: Firebase Functions Build & Tests
```bash
cd functions && npm run build && npm test
```

### Step 4: Automated Compliance & Secret Scan
Run a quick grep check across `lib/` and `functions/src/` before committing:
- Confirm **0 matches** for hardcoded keys (`AIzaSy`, `sk_live_`, `appl_`, `goog_`).
- Confirm **0 matches** for banned Apple 1.4.4 evasion strings (`evade police`, `avoid cops`, `dodge camera`, `speed trap`).
- Confirm the *"Presumed innocent"* disclaimer exists in the offender widget test suite.

### Commit Standard
- Use **Conventional Commits** (`feat(map): ...`, `fix(radar): ...`, `chore(compliance): ...`).
- Never force-push (`git push --force`) or delete branches without explicit confirmation.
- If any check in Steps 1–4 fails, fix the root cause and re-run the entire gate from Step 1 before committing.
