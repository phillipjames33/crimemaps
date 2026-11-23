// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'territory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$territoryRepositoryHash() =>
    r'0344c13fd8c63a00bc3f926b1fdf2e9a18e38fd2';

/// See also [territoryRepository].
@ProviderFor(territoryRepository)
final territoryRepositoryProvider = Provider<TerritoryRepository>.internal(
  territoryRepository,
  name: r'territoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$territoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TerritoryRepositoryRef = ProviderRef<TerritoryRepository>;
String _$territoriesForAreaHash() =>
    r'9cb5b22346b8b1d6f975974e76f5650bcb0283a5';

/// See also [territoriesForArea].
@ProviderFor(territoriesForArea)
final territoriesForAreaProvider =
    AutoDisposeFutureProvider<List<Territory>>.internal(
      territoriesForArea,
      name: r'territoriesForAreaProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$territoriesForAreaHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TerritoriesForAreaRef = AutoDisposeFutureProviderRef<List<Territory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
