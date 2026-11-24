// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapControllerHash() => r'e8cfc47b52c15cc2152d2a58e11712e390c8c54c';

/// Manages car-navigation map viewport state, scope switching (`area`/`city`/`state`),
/// city quick-jump presets, search filtering, and overlay layer toggles.
///
/// Copied from [MapController].
@ProviderFor(MapController)
final mapControllerProvider =
    NotifierProvider<MapController, MapViewportState>.internal(
      MapController.new,
      name: r'mapControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapController = Notifier<MapViewportState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
