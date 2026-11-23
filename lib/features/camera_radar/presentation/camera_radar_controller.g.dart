// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_radar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraRadarControllerHash() =>
    r'5f71ad68c196261fbfed0de531964a2b5a21ba2a';

/// Manages the local public-camera cache, alert settings and proximity alerts.
///
/// GPS ticks are evaluated purely locally (Haversine against the cached
/// cameras of the current geohash cell). Firestore is only consulted when the
/// user enters a geohash cell that is not already in [LocalCameraCache].
///
/// Copied from [CameraRadarController].
@ProviderFor(CameraRadarController)
final cameraRadarControllerProvider =
    NotifierProvider<CameraRadarController, CameraRadarState>.internal(
      CameraRadarController.new,
      name: r'cameraRadarControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cameraRadarControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CameraRadarController = Notifier<CameraRadarState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
