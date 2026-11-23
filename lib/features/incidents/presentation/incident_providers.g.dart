// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incidentRepositoryHash() =>
    r'4b00ecf561c441ba34fa308b95b12307380f7c6c';

/// See also [incidentRepository].
@ProviderFor(incidentRepository)
final incidentRepositoryProvider = Provider<IncidentRepository>.internal(
  incidentRepository,
  name: r'incidentRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incidentRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncidentRepositoryRef = ProviderRef<IncidentRepository>;
String _$jailBookingAdapterHash() =>
    r'bb0d1396a641fed6ba4634e889a65c377bd30b5f';

/// See also [jailBookingAdapter].
@ProviderFor(jailBookingAdapter)
final jailBookingAdapterProvider = Provider<JailBookingAdapter>.internal(
  jailBookingAdapter,
  name: r'jailBookingAdapterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$jailBookingAdapterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JailBookingAdapterRef = ProviderRef<JailBookingAdapter>;
String _$scopedIncidentsHash() => r'13df5a7eaa754f3a1d0dfa38375b3a29a052c84c';

/// See also [scopedIncidents].
@ProviderFor(scopedIncidents)
final scopedIncidentsProvider =
    AutoDisposeFutureProvider<List<Incident>>.internal(
      scopedIncidents,
      name: r'scopedIncidentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scopedIncidentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScopedIncidentsRef = AutoDisposeFutureProviderRef<List<Incident>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
