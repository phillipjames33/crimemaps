// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedGeofence _$SavedGeofenceFromJson(Map<String, dynamic> json) =>
    _SavedGeofence(
      id: json['id'] as String,
      label: json['label'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
      geohashPrefix: json['geohashPrefix'] as String,
      alertsEnabled: json['alertsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$SavedGeofenceToJson(_SavedGeofence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
      'geohashPrefix': instance.geohashPrefix,
      'alertsEnabled': instance.alertsEnabled,
    };

_EntitlementState _$EntitlementStateFromJson(Map<String, dynamic> json) =>
    _EntitlementState(
      isPro: json['isPro'] as bool? ?? false,
      activePlan:
          $enumDecodeNullable(_$SubscriptionPlanEnumMap, json['activePlan']) ??
          SubscriptionPlan.free,
      savedGeofences:
          (json['savedGeofences'] as List<dynamic>?)
              ?.map((e) => SavedGeofence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SavedGeofence>[],
      subscribedFcmTopics:
          (json['subscribedFcmTopics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      renewalDate: json['renewalDate'] == null
          ? null
          : DateTime.parse(json['renewalDate'] as String),
    );

Map<String, dynamic> _$EntitlementStateToJson(_EntitlementState instance) =>
    <String, dynamic>{
      'isPro': instance.isPro,
      'activePlan': _$SubscriptionPlanEnumMap[instance.activePlan]!,
      'savedGeofences': instance.savedGeofences,
      'subscribedFcmTopics': instance.subscribedFcmTopics,
      'renewalDate': instance.renewalDate?.toIso8601String(),
    };

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.free: 'free',
  SubscriptionPlan.proMonthly: 'proMonthly',
  SubscriptionPlan.proAnnual: 'proAnnual',
};

_ArtistBoostPackage _$ArtistBoostPackageFromJson(Map<String, dynamic> json) =>
    _ArtistBoostPackage(
      productId: json['productId'] as String,
      label: json['label'] as String,
      durationHours: (json['durationHours'] as num).toInt(),
      priceDisplay: json['priceDisplay'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ArtistBoostPackageToJson(_ArtistBoostPackage instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'label': instance.label,
      'durationHours': instance.durationHours,
      'priceDisplay': instance.priceDisplay,
      'description': instance.description,
    };
