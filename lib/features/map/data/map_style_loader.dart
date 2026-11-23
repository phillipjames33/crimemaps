import 'package:flutter/services.dart';

/// Loads and caches the dark car-navigation Google Maps JSON style asset.
class MapStyleLoader {
  const MapStyleLoader._();

  static const String darkCarNavAssetPath =
      'assets/map_styles/dark_car_nav.json';

  static String? _cachedDarkStyle;

  static Future<String?> loadDarkCarNavStyle({AssetBundle? bundle}) async {
    if (_cachedDarkStyle != null && bundle == null) {
      return _cachedDarkStyle;
    }

    try {
      final activeBundle = bundle ?? rootBundle;
      final styleJson = await activeBundle.loadString(darkCarNavAssetPath);
      if (bundle == null) {
        _cachedDarkStyle = styleJson;
      }
      return styleJson;
    } catch (_) {
      return null;
    }
  }
}
