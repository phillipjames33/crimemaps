/// Mandatory legal, App Store, and civic transparency compliance constants.
class ComplianceConstants {
  const ComplianceConstants._();

  /// Required disclaimer displayed on every alleged offender / booking card.
  static const String presumedInnocentDisclaimer =
      'Alleged / Public Arrest Record — All individuals are presumed innocent until proven guilty.';

  /// Automatic Firestore TTL window for alleged offender booking records.
  static const int bookingTtlDays = 45;

  /// Mandatory label for every historical territory overlay & context sheet.
  static const String historicalTerritoryLabel =
      'Historical / Publicly Documented Neighborhood Context';

  /// Apple Guideline 1.4.4 compliant framing for public camera transparency.
  static const String cameraRadarTitle = 'Civic Camera Transparency';
  static const String cameraRadarSubtitle =
      'Public Data Mapping & Privacy Awareness';
  static const String cameraZoneBannerPrefix =
      'Entering ALPR / Public Camera Zone';

  /// Current version identifier for the 100% indie music ownership attestation.
  static const String rightsAttestationVersion = '2026-v1.0';

  /// Hosted legal & compliance URLs (deployed on Firebase Hosting).
  static const String privacyPolicyUrl =
      'https://crimemaps-515702.web.app/privacy.html';
  static const String termsOfServiceUrl =
      'https://crimemaps-515702.web.app/terms.html';
  static const String freeRemovalPortalUrl =
      'https://crimemaps-515702.web.app/removal.html';

  /// Maximum allowed audio file size (25 MB) for creator uploads.
  static const int maxAudioUploadBytes = 25 * 1024 * 1024;

  /// Computes the mandatory 45-day expiration timestamp from a booking date.
  static DateTime computeBookingExpiry(DateTime bookingDate) {
    return bookingDate.toUtc().add(const Duration(days: bookingTtlDays));
  }
}
