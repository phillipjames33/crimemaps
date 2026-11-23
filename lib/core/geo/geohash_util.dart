import 'dart:math' as math;

/// Pure-Dart geospatial helpers (geohash encoding & Haversine distance)
/// usable from domain layers, local caches, and unit tests without SDK imports.
class GeohashUtil {
  const GeohashUtil._();

  static const String _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
  static const double _earthRadiusMeters = 6371000.0;

  /// Encodes WGS84 [latitude], [longitude] into a base32 geohash string.
  static String encode(
    double latitude,
    double longitude, {
    int precision = 7,
  }) {
    var minLat = -90.0;
    var maxLat = 90.0;
    var minLng = -180.0;
    var maxLng = 180.0;

    var isEven = true;
    var bit = 0;
    var ch = 0;
    final buffer = StringBuffer();

    while (buffer.length < precision) {
      if (isEven) {
        final mid = (minLng + maxLng) / 2;
        if (longitude >= mid) {
          ch |= 1 << (4 - bit);
          minLng = mid;
        } else {
          maxLng = mid;
        }
      } else {
        final mid = (minLat + maxLat) / 2;
        if (latitude >= mid) {
          ch |= 1 << (4 - bit);
          minLat = mid;
        } else {
          maxLat = mid;
        }
      }
      isEven = !isEven;
      if (bit < 4) {
        bit++;
      } else {
        buffer.write(_base32[ch]);
        bit = 0;
        ch = 0;
      }
    }
    return buffer.toString();
  }

  /// Computes great-circle distance in meters using the Haversine formula.
  static double haversineDistanceMeters({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final rLat1 = _toRadians(lat1);
    final rLat2 = _toRadians(lat2);

    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rLat1) * math.cos(rLat2) * math.pow(math.sin(dLng / 2), 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  /// Computes great-circle distance in miles.
  static double haversineDistanceMiles({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return haversineDistanceMeters(
          lat1: lat1,
          lng1: lng1,
          lat2: lat2,
          lng2: lng2,
        ) /
        1609.344;
  }

  /// Returns a deterministic cell prefix for local camera cache syncing.
  static String cellKey(double latitude, double longitude, {int precision = 5}) {
    return encode(latitude, longitude, precision: precision);
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;
}
