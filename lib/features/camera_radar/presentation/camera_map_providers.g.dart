// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$camerasForMapViewportHash() =>
    r'd1191f3697ada86126fc52da1ffd0b0cdc919b84';

/// Streams/loads publicly documented civic cameras for the active map city or
/// state via [CameraRepository] with an explicit `limit(150)`.
///
/// Uses scoped `.select(...)` on city, state, and scope so map panning, zooming,
/// tilting, and GPS ticks NEVER trigger redundant Firestore reads.
///
/// Copied from [camerasForMapViewport].
@ProviderFor(camerasForMapViewport)
final camerasForMapViewportProvider =
    AutoDisposeFutureProvider<List<PublicCamera>>.internal(
      camerasForMapViewport,
      name: r'camerasForMapViewportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$camerasForMapViewportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CamerasForMapViewportRef =
    AutoDisposeFutureProviderRef<List<PublicCamera>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
