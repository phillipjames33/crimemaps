// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_tier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedGeofence {

 String get id; String get label; double get latitude; double get longitude; double get radiusMeters; String get geohashPrefix; bool get alertsEnabled;
/// Create a copy of SavedGeofence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedGeofenceCopyWith<SavedGeofence> get copyWith => _$SavedGeofenceCopyWithImpl<SavedGeofence>(this as SavedGeofence, _$identity);

  /// Serializes this SavedGeofence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedGeofence&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.geohashPrefix, geohashPrefix) || other.geohashPrefix == geohashPrefix)&&(identical(other.alertsEnabled, alertsEnabled) || other.alertsEnabled == alertsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,latitude,longitude,radiusMeters,geohashPrefix,alertsEnabled);

@override
String toString() {
  return 'SavedGeofence(id: $id, label: $label, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, geohashPrefix: $geohashPrefix, alertsEnabled: $alertsEnabled)';
}


}

/// @nodoc
abstract mixin class $SavedGeofenceCopyWith<$Res>  {
  factory $SavedGeofenceCopyWith(SavedGeofence value, $Res Function(SavedGeofence) _then) = _$SavedGeofenceCopyWithImpl;
@useResult
$Res call({
 String id, String label, double latitude, double longitude, double radiusMeters, String geohashPrefix, bool alertsEnabled
});




}
/// @nodoc
class _$SavedGeofenceCopyWithImpl<$Res>
    implements $SavedGeofenceCopyWith<$Res> {
  _$SavedGeofenceCopyWithImpl(this._self, this._then);

  final SavedGeofence _self;
  final $Res Function(SavedGeofence) _then;

/// Create a copy of SavedGeofence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? geohashPrefix = null,Object? alertsEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,geohashPrefix: null == geohashPrefix ? _self.geohashPrefix : geohashPrefix // ignore: cast_nullable_to_non_nullable
as String,alertsEnabled: null == alertsEnabled ? _self.alertsEnabled : alertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedGeofence].
extension SavedGeofencePatterns on SavedGeofence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedGeofence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedGeofence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedGeofence value)  $default,){
final _that = this;
switch (_that) {
case _SavedGeofence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedGeofence value)?  $default,){
final _that = this;
switch (_that) {
case _SavedGeofence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  double latitude,  double longitude,  double radiusMeters,  String geohashPrefix,  bool alertsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedGeofence() when $default != null:
return $default(_that.id,_that.label,_that.latitude,_that.longitude,_that.radiusMeters,_that.geohashPrefix,_that.alertsEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  double latitude,  double longitude,  double radiusMeters,  String geohashPrefix,  bool alertsEnabled)  $default,) {final _that = this;
switch (_that) {
case _SavedGeofence():
return $default(_that.id,_that.label,_that.latitude,_that.longitude,_that.radiusMeters,_that.geohashPrefix,_that.alertsEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  double latitude,  double longitude,  double radiusMeters,  String geohashPrefix,  bool alertsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _SavedGeofence() when $default != null:
return $default(_that.id,_that.label,_that.latitude,_that.longitude,_that.radiusMeters,_that.geohashPrefix,_that.alertsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedGeofence implements SavedGeofence {
  const _SavedGeofence({required this.id, required this.label, required this.latitude, required this.longitude, required this.radiusMeters, required this.geohashPrefix, this.alertsEnabled = true});
  factory _SavedGeofence.fromJson(Map<String, dynamic> json) => _$SavedGeofenceFromJson(json);

@override final  String id;
@override final  String label;
@override final  double latitude;
@override final  double longitude;
@override final  double radiusMeters;
@override final  String geohashPrefix;
@override@JsonKey() final  bool alertsEnabled;

/// Create a copy of SavedGeofence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedGeofenceCopyWith<_SavedGeofence> get copyWith => __$SavedGeofenceCopyWithImpl<_SavedGeofence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedGeofenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedGeofence&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.geohashPrefix, geohashPrefix) || other.geohashPrefix == geohashPrefix)&&(identical(other.alertsEnabled, alertsEnabled) || other.alertsEnabled == alertsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,latitude,longitude,radiusMeters,geohashPrefix,alertsEnabled);

@override
String toString() {
  return 'SavedGeofence(id: $id, label: $label, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, geohashPrefix: $geohashPrefix, alertsEnabled: $alertsEnabled)';
}


}

/// @nodoc
abstract mixin class _$SavedGeofenceCopyWith<$Res> implements $SavedGeofenceCopyWith<$Res> {
  factory _$SavedGeofenceCopyWith(_SavedGeofence value, $Res Function(_SavedGeofence) _then) = __$SavedGeofenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, double latitude, double longitude, double radiusMeters, String geohashPrefix, bool alertsEnabled
});




}
/// @nodoc
class __$SavedGeofenceCopyWithImpl<$Res>
    implements _$SavedGeofenceCopyWith<$Res> {
  __$SavedGeofenceCopyWithImpl(this._self, this._then);

  final _SavedGeofence _self;
  final $Res Function(_SavedGeofence) _then;

/// Create a copy of SavedGeofence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,Object? geohashPrefix = null,Object? alertsEnabled = null,}) {
  return _then(_SavedGeofence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,geohashPrefix: null == geohashPrefix ? _self.geohashPrefix : geohashPrefix // ignore: cast_nullable_to_non_nullable
as String,alertsEnabled: null == alertsEnabled ? _self.alertsEnabled : alertsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EntitlementState {

 bool get isPro; SubscriptionPlan get activePlan; List<SavedGeofence> get savedGeofences; List<String> get subscribedFcmTopics; DateTime? get renewalDate;
/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementStateCopyWith<EntitlementState> get copyWith => _$EntitlementStateCopyWithImpl<EntitlementState>(this as EntitlementState, _$identity);

  /// Serializes this EntitlementState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementState&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.activePlan, activePlan) || other.activePlan == activePlan)&&const DeepCollectionEquality().equals(other.savedGeofences, savedGeofences)&&const DeepCollectionEquality().equals(other.subscribedFcmTopics, subscribedFcmTopics)&&(identical(other.renewalDate, renewalDate) || other.renewalDate == renewalDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPro,activePlan,const DeepCollectionEquality().hash(savedGeofences),const DeepCollectionEquality().hash(subscribedFcmTopics),renewalDate);

@override
String toString() {
  return 'EntitlementState(isPro: $isPro, activePlan: $activePlan, savedGeofences: $savedGeofences, subscribedFcmTopics: $subscribedFcmTopics, renewalDate: $renewalDate)';
}


}

/// @nodoc
abstract mixin class $EntitlementStateCopyWith<$Res>  {
  factory $EntitlementStateCopyWith(EntitlementState value, $Res Function(EntitlementState) _then) = _$EntitlementStateCopyWithImpl;
@useResult
$Res call({
 bool isPro, SubscriptionPlan activePlan, List<SavedGeofence> savedGeofences, List<String> subscribedFcmTopics, DateTime? renewalDate
});




}
/// @nodoc
class _$EntitlementStateCopyWithImpl<$Res>
    implements $EntitlementStateCopyWith<$Res> {
  _$EntitlementStateCopyWithImpl(this._self, this._then);

  final EntitlementState _self;
  final $Res Function(EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPro = null,Object? activePlan = null,Object? savedGeofences = null,Object? subscribedFcmTopics = null,Object? renewalDate = freezed,}) {
  return _then(_self.copyWith(
isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,activePlan: null == activePlan ? _self.activePlan : activePlan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,savedGeofences: null == savedGeofences ? _self.savedGeofences : savedGeofences // ignore: cast_nullable_to_non_nullable
as List<SavedGeofence>,subscribedFcmTopics: null == subscribedFcmTopics ? _self.subscribedFcmTopics : subscribedFcmTopics // ignore: cast_nullable_to_non_nullable
as List<String>,renewalDate: freezed == renewalDate ? _self.renewalDate : renewalDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementState].
extension EntitlementStatePatterns on EntitlementState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementState value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementState value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPro,  SubscriptionPlan activePlan,  List<SavedGeofence> savedGeofences,  List<String> subscribedFcmTopics,  DateTime? renewalDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.isPro,_that.activePlan,_that.savedGeofences,_that.subscribedFcmTopics,_that.renewalDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPro,  SubscriptionPlan activePlan,  List<SavedGeofence> savedGeofences,  List<String> subscribedFcmTopics,  DateTime? renewalDate)  $default,) {final _that = this;
switch (_that) {
case _EntitlementState():
return $default(_that.isPro,_that.activePlan,_that.savedGeofences,_that.subscribedFcmTopics,_that.renewalDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPro,  SubscriptionPlan activePlan,  List<SavedGeofence> savedGeofences,  List<String> subscribedFcmTopics,  DateTime? renewalDate)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementState() when $default != null:
return $default(_that.isPro,_that.activePlan,_that.savedGeofences,_that.subscribedFcmTopics,_that.renewalDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementState implements EntitlementState {
  const _EntitlementState({this.isPro = false, this.activePlan = SubscriptionPlan.free, final  List<SavedGeofence> savedGeofences = const <SavedGeofence>[], final  List<String> subscribedFcmTopics = const <String>[], this.renewalDate}): _savedGeofences = savedGeofences,_subscribedFcmTopics = subscribedFcmTopics;
  factory _EntitlementState.fromJson(Map<String, dynamic> json) => _$EntitlementStateFromJson(json);

@override@JsonKey() final  bool isPro;
@override@JsonKey() final  SubscriptionPlan activePlan;
 final  List<SavedGeofence> _savedGeofences;
@override@JsonKey() List<SavedGeofence> get savedGeofences {
  if (_savedGeofences is EqualUnmodifiableListView) return _savedGeofences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedGeofences);
}

 final  List<String> _subscribedFcmTopics;
@override@JsonKey() List<String> get subscribedFcmTopics {
  if (_subscribedFcmTopics is EqualUnmodifiableListView) return _subscribedFcmTopics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscribedFcmTopics);
}

@override final  DateTime? renewalDate;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementStateCopyWith<_EntitlementState> get copyWith => __$EntitlementStateCopyWithImpl<_EntitlementState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementState&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.activePlan, activePlan) || other.activePlan == activePlan)&&const DeepCollectionEquality().equals(other._savedGeofences, _savedGeofences)&&const DeepCollectionEquality().equals(other._subscribedFcmTopics, _subscribedFcmTopics)&&(identical(other.renewalDate, renewalDate) || other.renewalDate == renewalDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPro,activePlan,const DeepCollectionEquality().hash(_savedGeofences),const DeepCollectionEquality().hash(_subscribedFcmTopics),renewalDate);

@override
String toString() {
  return 'EntitlementState(isPro: $isPro, activePlan: $activePlan, savedGeofences: $savedGeofences, subscribedFcmTopics: $subscribedFcmTopics, renewalDate: $renewalDate)';
}


}

/// @nodoc
abstract mixin class _$EntitlementStateCopyWith<$Res> implements $EntitlementStateCopyWith<$Res> {
  factory _$EntitlementStateCopyWith(_EntitlementState value, $Res Function(_EntitlementState) _then) = __$EntitlementStateCopyWithImpl;
@override @useResult
$Res call({
 bool isPro, SubscriptionPlan activePlan, List<SavedGeofence> savedGeofences, List<String> subscribedFcmTopics, DateTime? renewalDate
});




}
/// @nodoc
class __$EntitlementStateCopyWithImpl<$Res>
    implements _$EntitlementStateCopyWith<$Res> {
  __$EntitlementStateCopyWithImpl(this._self, this._then);

  final _EntitlementState _self;
  final $Res Function(_EntitlementState) _then;

/// Create a copy of EntitlementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPro = null,Object? activePlan = null,Object? savedGeofences = null,Object? subscribedFcmTopics = null,Object? renewalDate = freezed,}) {
  return _then(_EntitlementState(
isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,activePlan: null == activePlan ? _self.activePlan : activePlan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,savedGeofences: null == savedGeofences ? _self._savedGeofences : savedGeofences // ignore: cast_nullable_to_non_nullable
as List<SavedGeofence>,subscribedFcmTopics: null == subscribedFcmTopics ? _self._subscribedFcmTopics : subscribedFcmTopics // ignore: cast_nullable_to_non_nullable
as List<String>,renewalDate: freezed == renewalDate ? _self.renewalDate : renewalDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ArtistBoostPackage {

 String get productId; String get label; int get durationHours; String get priceDisplay; String get description;
/// Create a copy of ArtistBoostPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistBoostPackageCopyWith<ArtistBoostPackage> get copyWith => _$ArtistBoostPackageCopyWithImpl<ArtistBoostPackage>(this as ArtistBoostPackage, _$identity);

  /// Serializes this ArtistBoostPackage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistBoostPackage&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.label, label) || other.label == label)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.priceDisplay, priceDisplay) || other.priceDisplay == priceDisplay)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,label,durationHours,priceDisplay,description);

@override
String toString() {
  return 'ArtistBoostPackage(productId: $productId, label: $label, durationHours: $durationHours, priceDisplay: $priceDisplay, description: $description)';
}


}

/// @nodoc
abstract mixin class $ArtistBoostPackageCopyWith<$Res>  {
  factory $ArtistBoostPackageCopyWith(ArtistBoostPackage value, $Res Function(ArtistBoostPackage) _then) = _$ArtistBoostPackageCopyWithImpl;
@useResult
$Res call({
 String productId, String label, int durationHours, String priceDisplay, String description
});




}
/// @nodoc
class _$ArtistBoostPackageCopyWithImpl<$Res>
    implements $ArtistBoostPackageCopyWith<$Res> {
  _$ArtistBoostPackageCopyWithImpl(this._self, this._then);

  final ArtistBoostPackage _self;
  final $Res Function(ArtistBoostPackage) _then;

/// Create a copy of ArtistBoostPackage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? label = null,Object? durationHours = null,Object? priceDisplay = null,Object? description = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as int,priceDisplay: null == priceDisplay ? _self.priceDisplay : priceDisplay // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistBoostPackage].
extension ArtistBoostPackagePatterns on ArtistBoostPackage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistBoostPackage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistBoostPackage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistBoostPackage value)  $default,){
final _that = this;
switch (_that) {
case _ArtistBoostPackage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistBoostPackage value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistBoostPackage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String label,  int durationHours,  String priceDisplay,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistBoostPackage() when $default != null:
return $default(_that.productId,_that.label,_that.durationHours,_that.priceDisplay,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String label,  int durationHours,  String priceDisplay,  String description)  $default,) {final _that = this;
switch (_that) {
case _ArtistBoostPackage():
return $default(_that.productId,_that.label,_that.durationHours,_that.priceDisplay,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String label,  int durationHours,  String priceDisplay,  String description)?  $default,) {final _that = this;
switch (_that) {
case _ArtistBoostPackage() when $default != null:
return $default(_that.productId,_that.label,_that.durationHours,_that.priceDisplay,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistBoostPackage implements ArtistBoostPackage {
  const _ArtistBoostPackage({required this.productId, required this.label, required this.durationHours, required this.priceDisplay, required this.description});
  factory _ArtistBoostPackage.fromJson(Map<String, dynamic> json) => _$ArtistBoostPackageFromJson(json);

@override final  String productId;
@override final  String label;
@override final  int durationHours;
@override final  String priceDisplay;
@override final  String description;

/// Create a copy of ArtistBoostPackage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistBoostPackageCopyWith<_ArtistBoostPackage> get copyWith => __$ArtistBoostPackageCopyWithImpl<_ArtistBoostPackage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistBoostPackageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistBoostPackage&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.label, label) || other.label == label)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.priceDisplay, priceDisplay) || other.priceDisplay == priceDisplay)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,label,durationHours,priceDisplay,description);

@override
String toString() {
  return 'ArtistBoostPackage(productId: $productId, label: $label, durationHours: $durationHours, priceDisplay: $priceDisplay, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ArtistBoostPackageCopyWith<$Res> implements $ArtistBoostPackageCopyWith<$Res> {
  factory _$ArtistBoostPackageCopyWith(_ArtistBoostPackage value, $Res Function(_ArtistBoostPackage) _then) = __$ArtistBoostPackageCopyWithImpl;
@override @useResult
$Res call({
 String productId, String label, int durationHours, String priceDisplay, String description
});




}
/// @nodoc
class __$ArtistBoostPackageCopyWithImpl<$Res>
    implements _$ArtistBoostPackageCopyWith<$Res> {
  __$ArtistBoostPackageCopyWithImpl(this._self, this._then);

  final _ArtistBoostPackage _self;
  final $Res Function(_ArtistBoostPackage) _then;

/// Create a copy of ArtistBoostPackage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? label = null,Object? durationHours = null,Object? priceDisplay = null,Object? description = null,}) {
  return _then(_ArtistBoostPackage(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as int,priceDisplay: null == priceDisplay ? _self.priceDisplay : priceDisplay // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
