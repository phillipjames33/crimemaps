import 'package:freezed_annotation/freezed_annotation.dart';

part 'incident_model.freezed.dart';
part 'incident_model.g.dart';

enum IncidentCategory {
  violent,
  property,
  trafficDui,
  other,
}

enum IncidentSeverity {
  low,
  medium,
  high,
  critical,
}

@freezed
abstract class GeoCoordinate with _$GeoCoordinate {
  const factory GeoCoordinate({
    required double latitude,
    required double longitude,
    required String geohash,
  }) = _GeoCoordinate;

  factory GeoCoordinate.fromJson(Map<String, dynamic> json) =>
      _$GeoCoordinateFromJson(json);
}

@freezed
abstract class AllegedOffender with _$AllegedOffender {
  const factory AllegedOffender({
    required String name,
    String? bookingPhotoUrl,
    required List<String> charges,
    required DateTime bookingDate,
    required String sourceAgency,
    required String disclaimer,
    required DateTime expiresAt,
    @Default(false) bool redacted,
  }) = _AllegedOffender;

  factory AllegedOffender.fromJson(Map<String, dynamic> json) =>
      _$AllegedOffenderFromJson(json);
}

@freezed
abstract class Incident with _$Incident {
  const factory Incident({
    required String id,
    required String title,
    required IncidentCategory category,
    required IncidentSeverity severity,
    required String address,
    required String placeName,
    required String placeType,
    required GeoCoordinate geo,
    required String citySlug,
    required String cityName,
    required String stateCode,
    required DateTime occurredAt,
    String? streetViewUrl,
    required String sourceAgency,
    AllegedOffender? allegedOffender,
    DateTime? expireAt,
  }) = _Incident;

  factory Incident.fromJson(Map<String, dynamic> json) =>
      _$IncidentFromJson(json);
}
