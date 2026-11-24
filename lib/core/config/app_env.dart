/// Runtime environment configuration supplied via `--dart-define` or
/// `--dart-define-from-file=.env`. Zero secrets are ever hardcoded.
class AppEnv {
  const AppEnv._();

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );

  static const String googleMapsMapId = String.fromEnvironment(
    'GOOGLE_MAPS_MAP_ID',
  );

  static const String spotCrimeApiKey = String.fromEnvironment(
    'SPOTCRIME_API_KEY',
  );

  static const String bookingApiKey = String.fromEnvironment(
    'BOOKING_API_KEY',
  );

  static const String revenueCatIosKey = String.fromEnvironment(
    'REVENUECAT_IOS_KEY',
  );

  static const String revenueCatAndroidKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
  );

  static const String admobBannerUnitId = String.fromEnvironment(
    'ADMOB_BANNER_UNIT_ID',
  );

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );

  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
  );

  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );

  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'crimemaps-515702',
  );

  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );

  static const String firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
  );

  static bool get hasFirebaseWebOptions =>
      firebaseApiKey.isNotEmpty &&
      !firebaseApiKey.startsWith('your_') &&
      firebaseAppId.isNotEmpty &&
      firebaseMessagingSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;

  /// Defaults to true so the app runs out-of-the-box with realistic seeded data
  /// on emulators/simulators without requiring live API keys.
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: true,
  );

  static const bool useFirebaseEmulators = bool.fromEnvironment(
    'USE_FIREBASE_EMULATORS',
  );

  static const String firebaseEmulatorHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: 'localhost',
  );

  static bool get hasGoogleMapsKey =>
      googleMapsApiKey.isNotEmpty &&
      !googleMapsApiKey.startsWith('your_');

  static bool get hasRevenueCatIosKey =>
      revenueCatIosKey.isNotEmpty &&
      !revenueCatIosKey.startsWith('your_');

  static bool get hasRevenueCatAndroidKey =>
      revenueCatAndroidKey.isNotEmpty &&
      !revenueCatAndroidKey.startsWith('your_');

  /// Constructs a Google Street View Static API URL when a key is supplied.
  static String? buildStreetViewUrl({
    required double latitude,
    required double longitude,
    int width = 640,
    int height = 320,
  }) {
    if (!hasGoogleMapsKey) return null;
    return 'https://maps.googleapis.com/maps/api/streetview'
        '?size=${width}x$height'
        '&location=$latitude,$longitude'
        '&fov=85&pitch=5'
        '&key=$googleMapsApiKey';
  }
}
