# Crime Maps — App Store & Google Play Compliance Review Notes

Use the sections below when submitting **Crime Maps** to **Apple App Store Connect** and **Google Play Console**. Every guardrail documented here is enforced in Flutter UI code, Firestore/Storage security rules, and Firebase Cloud Functions v2.

---

## 1. Apple App Store Guideline 1.4.4 — Civic Camera Transparency (NOT Law Enforcement Evasion)

**Copy-Paste Reviewer Note:**
> Crime Maps includes a **Civic Camera Transparency & Privacy Awareness** layer that maps publicly documented civic infrastructure cameras (such as municipal Automated License Plate Readers / Flock poles, DOT traffic monitoring cameras, and public intersection safety cameras) sourced from open civic datasets (OpenStreetMap / DeFlock) and moderated community contributions.
>
> This feature is designed strictly for **civic transparency, public data mapping, and personal privacy awareness**—never for evading law enforcement, speed enforcement, or traffic safety controls. Automated pre-commit compliance checks enforce zero evasion terminology across all application UI strings, push notifications, and backend code.

---

## 2. Public Arrest Records — Presumed Innocent & 100% Free Removal

- **Visible Presumed Innocent Disclaimer:** Every alleged offender card and record removal form renders the exact notice:
  > *"Alleged / Public Arrest Record — All individuals are presumed innocent until proven guilty."*
- **45-Day Automatic Firestore TTL:** All `incidents` documents containing `allegedOffender` booking data set `expireAt = bookingDate + 45 days` with a native Firestore TTL policy deployed via `firestore.indexes.json`.
- **100% Free Record Removal / Expungement:** The **"Request Record Removal / Expungement"** workflow is accessible directly from every offender card without signing in and without any paywall or fee. Calling `submitMugshotRemoval` immediately redacts `allegedOffender` fields pending verification and logs an audit entry in `removal_requests`.

---

## 3. Historical Neighborhood Context Overlays & Community Moderation

- All historical territory polygon overlays display the mandatory label **"Historical / Publicly Documented Neighborhood Context"** along with a `citationDate` and `sourceReference`.
- Direct client writes to the live `territories` collection are blocked in `firestore.rules`. Community suggestions/corrections are routed exclusively to the `territory_submissions` moderation queue (`moderationStatus == 'pending_review'`).

---

## 4. Anti-Doxxing (Private Residential Camera Protection)

- Exact street-address pinning of private residential doorbells or home security cameras is strictly forbidden across three layers:
  1. Flutter `FirestoreCameraRepository` throws `AntiDoxxingViolationException` on `isPrivateResidence == true`.
  2. `firestore.rules` rejects any camera write unless `type in ['alpr_flock', 'traffic', 'red_light']` and `isPrivateResidence != true`.
  3. Cloud Function `syncPublicCameras` strips private/residential OSM tags before writing to Firestore.
- Residential data is only permitted as anonymized neighborhood-level density circles (`ResidentialDensityCell`).

---

## 5. Independent Music Rights & DMCA Safe Harbor (17 U.S.C. § 512(c))

- **100% Ownership Attestation:** Artists cannot upload audio unless they check the 100% master & publishing rights warranty and provide a typed electronic legal signature (`rightsWarranty.owns100Percent == true`, `signedName`, `signedAt`, `version`). This is enforced in the Flutter Creator Portal UI, `storage.rules`, `firestore.rules`, and `onTrackUploaded`.
- **Instant DMCA Soft-Takedown:** Every track card and the persistent mini-player expose a one-click **"Report Copyright Infringement (DMCA)"** flow that records a sworn claim in `dmca_claims` and immediately transitions `tracks/{trackId}.status` to `'flagged_dmca'`, removing the track from public queries.

---

## 6. Hosted Legal Portal, In-App Account Deletion (Guideline 5.1.1(v)) & Subscription Disclosures (Guideline 3.1.2(c))

- **Live Hosted Legal & Transparency Portal (Firebase Hosting — `crimemaps-515702`):**
  - Overview & Support URL: `https://crimemaps-515702.web.app/`
  - Privacy Policy URL (App Store Connect & Google Play Data Safety): `https://crimemaps-515702.web.app/privacy.html`
  - Terms of Service & DMCA Policy URL: `https://crimemaps-515702.web.app/terms.html`
  - 100% Free Record Removal & Web Account Deletion URL (Google Play Account Deletion): `https://crimemaps-515702.web.app/removal.html`
- **In-App Permanent Account Deletion (Apple Guideline 5.1.1(v)):** Signed-in users can permanently delete their Firebase Auth account and `users/{uid}` Firestore profile directly inside the **Account** sheet (`AuthSheet` -> **Delete Account Permanently** with confirmation dialog). Guest browsing and 100% free record removal never require an account.
- **Paywall Legal Disclosures (Apple Guideline 3.1.2(c)):** `PaywallScreen` displays auto-renewal cancellation terms alongside clickable **Privacy Policy**, **Terms of Service**, and **Free Record Removal** links.
