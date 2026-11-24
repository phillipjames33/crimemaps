// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_incidents_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$savedIncidentsControllerHash() =>
    r'7a044df0926e250d226bd7948b74d6c5ad2af694';

/// Persists user-bookmarked public incidents locally via Hive CE (with an
/// automatic in-memory fallback for unit/widget tests or uninitialized boxes).
///
/// Works seamlessly in guest mode with zero Firestore writes.
///
/// Copied from [SavedIncidentsController].
@ProviderFor(SavedIncidentsController)
final savedIncidentsControllerProvider =
    NotifierProvider<SavedIncidentsController, Set<String>>.internal(
      SavedIncidentsController.new,
      name: r'savedIncidentsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedIncidentsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavedIncidentsController = Notifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
