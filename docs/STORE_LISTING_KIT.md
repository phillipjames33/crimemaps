# Crime Maps — Google Play Console & Apple App Store Connect Submission Kit

Use this copy-paste kit together with [APP_STORE_COMPLIANCE.md](./APP_STORE_COMPLIANCE.md) when creating your **Google Play Console** and **Apple App Store Connect** listings. Every string below is verified against Apple App Store Guideline 1.4.4, 3.1.2(c), and 5.1.1(v), as well as Google Play Data Safety policies.

---

## 1. Store Listing Metadata

| Field | Google Play Limit | Apple App Store Limit | Recommended Copy |
| :--- | :--- | :--- | :--- |
| **App Name** | 30 chars | 30 chars | `Crime Maps` |
| **Subtitle (iOS)** | — | 30 chars | `Civic Safety & Local Geo-Radio` |
| **Short Description (Android)** | 80 chars | — | `Dark car-nav crime map, civic camera transparency & 100% indie local Geo-Radio.` |
| **Primary Category** | Navigation / News | Navigation | Navigation (Secondary: News / Reference) |
| **Support URL** | Required | Required | `https://crimemaps-515702.web.app/` |
| **Privacy Policy URL** | Required | Required | `https://crimemaps-515702.web.app/privacy.html` |
| **Terms of Service / EULA URL** | Recommended | Required (Subscriptions) | `https://crimemaps-515702.web.app/terms.html` |
| **Account Deletion & Free Removal URL** | Required (Data Safety) | Recommended | `https://crimemaps-515702.web.app/removal.html` |
| **Contact Email** | Required | Required | `phillipojames@gmail.com` |
| **Bundle / Package ID** | `com.crimemaps.crime_maps` | `com.crimemaps.crimeMaps` | Matches Firebase & RevenueCat (`CrimeMapsAi`) |

### Apple App Store Keywords (97 / 100 chars)
```text
crime map,public safety,neighborhood safety,civic cameras,alpr map,local radio,indie music,alerts
```

### Full Description (Copy-Paste for Both Stores)
```text
Navigate your city with real-time public safety intelligence, civic infrastructure transparency, and 100% independent local music — all in one dark-mode car-navigation interface.

LIVE PUBLIC SAFETY MAP
• Switch seamlessly between My Area (5 mi), City, and State views with zoom-aware incident clustering and instant city quick-jump presets (Atlanta, Chicago, San Francisco, Dallas, Los Angeles, Houston, and Savannah).
• Inspect incident details with Street View imagery and Photorealistic 3D contextual views.
• Powered by publicly available municipal open-data portals (including Chicago PD, San Francisco PD, and Dallas PD live feeds).

CIVIC CAMERA TRANSPARENCY & PRIVACY AWARENESS
• Visualize publicly documented civic infrastructure cameras (municipal ALPR / Flock poles, DOT traffic cameras, and public intersection monitoring) sourced from open civic datasets (OpenStreetMap).
• Computed 100% locally on your device using an offline spatial cache — zero continuous server GPS tracking.
• Strict anti-doxxing enforcement: private residential doorbells and home security cameras are never pinned to street addresses.

HISTORICAL NEIGHBORHOOD CONTEXT
• Toggle translucent neighborhood context overlays backed by source citations and dates, with a community-moderated correction queue.

100% INDEPENDENT GEO-RADIO & CREATOR PORTAL
• Stream independent local artists tied to the city you're exploring on the map — with persistent background audio playback.
• Independent creators who own 100% of their master and publishing rights can upload tracks directly to their local zip code or metro area, backed by immediate DMCA Safe Harbor enforcement.

PRESUMPTION OF INNOCENCE & 100% FREE RECORD REMOVAL
• Every individual referenced in any public arrest or booking entry is presumed innocent until proven guilty in a court of law.
• Booking entries automatically expire after 45 days.
• Record removal and expungement requests are ALWAYS 100% free — accessible with one tap inside the app or online, with no account or subscription required.

CRIME MAPS PRO (OPTIONAL SUBSCRIPTION)
• Upgrade to Crime Maps Pro (Monthly or Annual) for ad-free Geo-Radio, extended historical heatmaps, unlimited custom geofence push alert zones, and offline camera cache sync.
• Subscriptions renew automatically unless canceled at least 24 hours before the end of the current period in your App Store or Google Play account settings.
```

### Release Notes (v1.0.0)
```text
Initial launch of Crime Maps:
• Live dark-mode car-nav public safety map with municipal open-data feeds
• Civic Camera Transparency layer with 100% on-device spatial caching
• Historical neighborhood context overlays with source citations
• Persistent 100% indie Geo-Radio and Creator Upload Portal
• Presumption of Innocence notice, 45-day automatic record expiration, and 100% free record removal
```

---

## 2. In-App Subscriptions & Consumables (Match RevenueCat `CrimeMapsAi`)

Create these exact Product IDs in **Google Play Console** (`com.crimemaps.crime_maps`) and **App Store Connect** (`com.crimemaps.crimeMaps`):

| Product ID | Type | Entitlement / Purpose | Suggested Price | Display Title |
| :--- | :--- | :--- | :--- | :--- |
| `pro_monthly` | Auto-Renewing Subscription | `pro_access` (Offering `default` / `$rc_monthly`) | `$6.99 / month` | Crime Maps Pro (Monthly) |
| `pro_annual` | Auto-Renewing Subscription | `pro_access` (Offering `default` / `$rc_annual`) | `$49.99 / year` | Crime Maps Pro (Annual) |
| `boost_24h_zip` | Consumable IAP | 24-Hour ZIP Geo-Radio Creator Boost | `$4.99` | 24-Hour ZIP Code Boost |
| `boost_7d_city` | Consumable IAP | 7-Day City Geo-Radio Creator Boost | `$19.99` | 7-Day Citywide Boost |
| `boost_30d_metro` | Consumable IAP | 30-Day Metro Geo-Radio Creator Boost | `$49.99` | 30-Day Metro Area Boost |

---

## 3. Google Play Data Safety & Apple App Privacy Matrix

| Data Category | Collected? | Shared with 3rd Parties? | Optional / Guest Supported? | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Email Address & User ID** | Yes (if signed in) | No (Firebase Auth processor only) | Yes — full map & free removal work as guest | Account management, Pro sync, Creator attribution |
| **Approximate / Precise Location** | Processed on-device; coarse geohash query sent to Firestore | No | Yes — city presets work without GPS | Map centering, nearby public incidents, local Geo-Radio, on-device civic camera proximity alerts |
| **Purchase History** | Yes (via RevenueCat) | No (Apple/Google/RevenueCat processors) | Optional | Unlock Crime Maps Pro & Creator Boosts |
| **User Content (Audio / Submissions)** | Only if uploaded by user | No | Optional | Indie Geo-Radio streaming & moderated historical notes |
| **Device / Advertising ID** | Free tier only (AdMob) | Advertising (Free tier only; zero ads for Pro) | Disabled for Pro subscribers | Non-intrusive sponsor banner on Free tier |

- **Data encrypted in transit:** **Yes** (HTTPS/TLS across Firebase, Google Maps, RevenueCat).
- **Users can request data & account deletion:** **Yes** — instant in-app **Delete Account Permanently** button inside the **Account** sheet (`AuthSheet`) AND web portal at `https://crimemaps-515702.web.app/removal.html`.

---

## 4. Store Graphic Assets Generated in Repository

- **App Icons:** Installed across Android `mipmap-*`, all 15 opaque iOS `AppIcon.appiconset` PNGs (including `1024x1024` App Store icon), and Web `icons/`.
- **Google Play Feature Graphic (`1024 x 500`):** [assets/store/feature_graphic_1024x500.png](../assets/store/feature_graphic_1024x500.png)
- **Live Android Phone Screenshots (`1080 x 2400`):** [assets/store/screenshots/](../assets/store/screenshots/)

---

## 5. App Reviewer Testing Guide (Copy-Paste into Review Notes)

1. **No Account Required:** Launch the app and browse live public safety incidents immediately in guest mode across Atlanta, Chicago, San Francisco, and Dallas.
2. **Test 100% Free Record Removal:** Tap any booking/arrest record card to verify the visible *"Presumed innocent until proven guilty"* notice and tap **Request Record Removal / Expungement** — confirm it works with zero login and zero fee.
3. **Test Civic Camera Transparency:** Open the **Radar** tab to inspect publicly mapped civic infrastructure cameras (OpenStreetMap). Note that private residential camera submissions are rejected across client, Firestore rules, and Cloud Functions.
4. **Test Account Creation & Permanent Deletion (Guideline 5.1.1(v)):** Tap the **Account** chip in the top-right corner of the Map screen, create a test email account, then tap **Delete Account Permanently** to confirm immediate deletion of the account and profile document.
5. **Test Subscriptions & Legal Links (Guideline 3.1.2(c)):** Open the **Pro** tab to inspect Monthly/Annual options, **Restore**, auto-renewal disclosures, and live **Privacy Policy** / **Terms of Service** links.
