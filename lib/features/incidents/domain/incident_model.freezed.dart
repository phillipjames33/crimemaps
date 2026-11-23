// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incident_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoCoordinate {

 double get latitude; double get longitude; String get geohash;
/// Create a copy of GeoCoordinate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoCoordinateCopyWith<GeoCoordinate> get copyWith => _$GeoCoordinateCopyWithImpl<GeoCoordinate>(this as GeoCoordinate, _$identity);

  /// Serializes this GeoCoordinate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoCoordinate&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geohash, geohash) || other.geohash == geohash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,geohash);

@override
String toString() {
  return 'GeoCoordinate(latitude: $latitude, longitude: $longitude, geohash: $geohash)';
}


}

/// @nodoc
abstract mixin class $GeoCoordinateCopyWith<$Res>  {
  factory $GeoCoordinateCopyWith(GeoCoordinate value, $Res Function(GeoCoordinate) _then) = _$GeoCoordinateCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String geohash
});




}
/// @nodoc
class _$GeoCoordinateCopyWithImpl<$Res>
    implements $GeoCoordinateCopyWith<$Res> {
  _$GeoCoordinateCopyWithImpl(this._self, this._then);

  final GeoCoordinate _self;
  final $Res Function(GeoCoordinate) _then;

/// Create a copy of GeoCoordinate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? geohash = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoCoordinate].
extension GeoCoordinatePatterns on GeoCoordinate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoCoordinate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoCoordinate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoCoordinate value)  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoCoordinate value)?  $default,){
final _that = this;
switch (_that) {
case _GeoCoordinate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String geohash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoCoordinate() when $default != null:
return $default(_that.latitude,_that.longitude,_that.geohash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String geohash)  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinate():
return $default(_that.latitude,_that.longitude,_that.geohash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  String geohash)?  $default,) {final _that = this;
switch (_that) {
case _GeoCoordinate() when $default != null:
return $default(_that.latitude,_that.longitude,_that.geohash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoCoordinate implements GeoCoordinate {
  const _GeoCoordinate({required this.latitude, required this.longitude, required this.geohash});
  factory _GeoCoordinate.fromJson(Map<String, dynamic> json) => _$GeoCoordinateFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override final  String geohash;

/// Create a copy of GeoCoordinate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoCoordinateCopyWith<_GeoCoordinate> get copyWith => __$GeoCoordinateCopyWithImpl<_GeoCoordinate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoCoordinateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoCoordinate&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geohash, geohash) || other.geohash == geohash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,geohash);

@override
String toString() {
  return 'GeoCoordinate(latitude: $latitude, longitude: $longitude, geohash: $geohash)';
}


}

/// @nodoc
abstract mixin class _$GeoCoordinateCopyWith<$Res> implements $GeoCoordinateCopyWith<$Res> {
  factory _$GeoCoordinateCopyWith(_GeoCoordinate value, $Res Function(_GeoCoordinate) _then) = __$GeoCoordinateCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, String geohash
});




}
/// @nodoc
class __$GeoCoordinateCopyWithImpl<$Res>
    implements _$GeoCoordinateCopyWith<$Res> {
  __$GeoCoordinateCopyWithImpl(this._self, this._then);

  final _GeoCoordinate _self;
  final $Res Function(_GeoCoordinate) _then;

/// Create a copy of GeoCoordinate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? geohash = null,}) {
  return _then(_GeoCoordinate(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AllegedOffender {

 String get name; String? get bookingPhotoUrl; List<String> get charges; DateTime get bookingDate; String get sourceAgency; String get disclaimer; DateTime get expiresAt; bool get redacted;
/// Create a copy of AllegedOffender
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllegedOffenderCopyWith<AllegedOffender> get copyWith => _$AllegedOffenderCopyWithImpl<AllegedOffender>(this as AllegedOffender, _$identity);

  /// Serializes this AllegedOffender to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllegedOffender&&(identical(other.name, name) || other.name == name)&&(identical(other.bookingPhotoUrl, bookingPhotoUrl) || other.bookingPhotoUrl == bookingPhotoUrl)&&const DeepCollectionEquality().equals(other.charges, charges)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.sourceAgency, sourceAgency) || other.sourceAgency == sourceAgency)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.redacted, redacted) || other.redacted == redacted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bookingPhotoUrl,const DeepCollectionEquality().hash(charges),bookingDate,sourceAgency,disclaimer,expiresAt,redacted);

@override
String toString() {
  return 'AllegedOffender(name: $name, bookingPhotoUrl: $bookingPhotoUrl, charges: $charges, bookingDate: $bookingDate, sourceAgency: $sourceAgency, disclaimer: $disclaimer, expiresAt: $expiresAt, redacted: $redacted)';
}


}

/// @nodoc
abstract mixin class $AllegedOffenderCopyWith<$Res>  {
  factory $AllegedOffenderCopyWith(AllegedOffender value, $Res Function(AllegedOffender) _then) = _$AllegedOffenderCopyWithImpl;
@useResult
$Res call({
 String name, String? bookingPhotoUrl, List<String> charges, DateTime bookingDate, String sourceAgency, String disclaimer, DateTime expiresAt, bool redacted
});




}
/// @nodoc
class _$AllegedOffenderCopyWithImpl<$Res>
    implements $AllegedOffenderCopyWith<$Res> {
  _$AllegedOffenderCopyWithImpl(this._self, this._then);

  final AllegedOffender _self;
  final $Res Function(AllegedOffender) _then;

/// Create a copy of AllegedOffender
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? bookingPhotoUrl = freezed,Object? charges = null,Object? bookingDate = null,Object? sourceAgency = null,Object? disclaimer = null,Object? expiresAt = null,Object? redacted = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bookingPhotoUrl: freezed == bookingPhotoUrl ? _self.bookingPhotoUrl : bookingPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,charges: null == charges ? _self.charges : charges // ignore: cast_nullable_to_non_nullable
as List<String>,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,sourceAgency: null == sourceAgency ? _self.sourceAgency : sourceAgency // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,redacted: null == redacted ? _self.redacted : redacted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AllegedOffender].
extension AllegedOffenderPatterns on AllegedOffender {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AllegedOffender value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllegedOffender() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AllegedOffender value)  $default,){
final _that = this;
switch (_that) {
case _AllegedOffender():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AllegedOffender value)?  $default,){
final _that = this;
switch (_that) {
case _AllegedOffender() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? bookingPhotoUrl,  List<String> charges,  DateTime bookingDate,  String sourceAgency,  String disclaimer,  DateTime expiresAt,  bool redacted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllegedOffender() when $default != null:
return $default(_that.name,_that.bookingPhotoUrl,_that.charges,_that.bookingDate,_that.sourceAgency,_that.disclaimer,_that.expiresAt,_that.redacted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? bookingPhotoUrl,  List<String> charges,  DateTime bookingDate,  String sourceAgency,  String disclaimer,  DateTime expiresAt,  bool redacted)  $default,) {final _that = this;
switch (_that) {
case _AllegedOffender():
return $default(_that.name,_that.bookingPhotoUrl,_that.charges,_that.bookingDate,_that.sourceAgency,_that.disclaimer,_that.expiresAt,_that.redacted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? bookingPhotoUrl,  List<String> charges,  DateTime bookingDate,  String sourceAgency,  String disclaimer,  DateTime expiresAt,  bool redacted)?  $default,) {final _that = this;
switch (_that) {
case _AllegedOffender() when $default != null:
return $default(_that.name,_that.bookingPhotoUrl,_that.charges,_that.bookingDate,_that.sourceAgency,_that.disclaimer,_that.expiresAt,_that.redacted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AllegedOffender implements AllegedOffender {
  const _AllegedOffender({required this.name, this.bookingPhotoUrl, required final  List<String> charges, required this.bookingDate, required this.sourceAgency, required this.disclaimer, required this.expiresAt, this.redacted = false}): _charges = charges;
  factory _AllegedOffender.fromJson(Map<String, dynamic> json) => _$AllegedOffenderFromJson(json);

@override final  String name;
@override final  String? bookingPhotoUrl;
 final  List<String> _charges;
@override List<String> get charges {
  if (_charges is EqualUnmodifiableListView) return _charges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_charges);
}

@override final  DateTime bookingDate;
@override final  String sourceAgency;
@override final  String disclaimer;
@override final  DateTime expiresAt;
@override@JsonKey() final  bool redacted;

/// Create a copy of AllegedOffender
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllegedOffenderCopyWith<_AllegedOffender> get copyWith => __$AllegedOffenderCopyWithImpl<_AllegedOffender>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllegedOffenderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllegedOffender&&(identical(other.name, name) || other.name == name)&&(identical(other.bookingPhotoUrl, bookingPhotoUrl) || other.bookingPhotoUrl == bookingPhotoUrl)&&const DeepCollectionEquality().equals(other._charges, _charges)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.sourceAgency, sourceAgency) || other.sourceAgency == sourceAgency)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.redacted, redacted) || other.redacted == redacted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,bookingPhotoUrl,const DeepCollectionEquality().hash(_charges),bookingDate,sourceAgency,disclaimer,expiresAt,redacted);

@override
String toString() {
  return 'AllegedOffender(name: $name, bookingPhotoUrl: $bookingPhotoUrl, charges: $charges, bookingDate: $bookingDate, sourceAgency: $sourceAgency, disclaimer: $disclaimer, expiresAt: $expiresAt, redacted: $redacted)';
}


}

/// @nodoc
abstract mixin class _$AllegedOffenderCopyWith<$Res> implements $AllegedOffenderCopyWith<$Res> {
  factory _$AllegedOffenderCopyWith(_AllegedOffender value, $Res Function(_AllegedOffender) _then) = __$AllegedOffenderCopyWithImpl;
@override @useResult
$Res call({
 String name, String? bookingPhotoUrl, List<String> charges, DateTime bookingDate, String sourceAgency, String disclaimer, DateTime expiresAt, bool redacted
});




}
/// @nodoc
class __$AllegedOffenderCopyWithImpl<$Res>
    implements _$AllegedOffenderCopyWith<$Res> {
  __$AllegedOffenderCopyWithImpl(this._self, this._then);

  final _AllegedOffender _self;
  final $Res Function(_AllegedOffender) _then;

/// Create a copy of AllegedOffender
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? bookingPhotoUrl = freezed,Object? charges = null,Object? bookingDate = null,Object? sourceAgency = null,Object? disclaimer = null,Object? expiresAt = null,Object? redacted = null,}) {
  return _then(_AllegedOffender(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bookingPhotoUrl: freezed == bookingPhotoUrl ? _self.bookingPhotoUrl : bookingPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,charges: null == charges ? _self._charges : charges // ignore: cast_nullable_to_non_nullable
as List<String>,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,sourceAgency: null == sourceAgency ? _self.sourceAgency : sourceAgency // ignore: cast_nullable_to_non_nullable
as String,disclaimer: null == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,redacted: null == redacted ? _self.redacted : redacted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Incident {

 String get id; String get title; IncidentCategory get category; IncidentSeverity get severity; String get address; String get placeName; String get placeType; GeoCoordinate get geo; String get citySlug; String get cityName; String get stateCode; DateTime get occurredAt; String? get streetViewUrl; String get sourceAgency; AllegedOffender? get allegedOffender; DateTime? get expireAt;
/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncidentCopyWith<Incident> get copyWith => _$IncidentCopyWithImpl<Incident>(this as Incident, _$identity);

  /// Serializes this Incident to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Incident&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.address, address) || other.address == address)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.streetViewUrl, streetViewUrl) || other.streetViewUrl == streetViewUrl)&&(identical(other.sourceAgency, sourceAgency) || other.sourceAgency == sourceAgency)&&(identical(other.allegedOffender, allegedOffender) || other.allegedOffender == allegedOffender)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,severity,address,placeName,placeType,geo,citySlug,cityName,stateCode,occurredAt,streetViewUrl,sourceAgency,allegedOffender,expireAt);

@override
String toString() {
  return 'Incident(id: $id, title: $title, category: $category, severity: $severity, address: $address, placeName: $placeName, placeType: $placeType, geo: $geo, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, occurredAt: $occurredAt, streetViewUrl: $streetViewUrl, sourceAgency: $sourceAgency, allegedOffender: $allegedOffender, expireAt: $expireAt)';
}


}

/// @nodoc
abstract mixin class $IncidentCopyWith<$Res>  {
  factory $IncidentCopyWith(Incident value, $Res Function(Incident) _then) = _$IncidentCopyWithImpl;
@useResult
$Res call({
 String id, String title, IncidentCategory category, IncidentSeverity severity, String address, String placeName, String placeType, GeoCoordinate geo, String citySlug, String cityName, String stateCode, DateTime occurredAt, String? streetViewUrl, String sourceAgency, AllegedOffender? allegedOffender, DateTime? expireAt
});


$GeoCoordinateCopyWith<$Res> get geo;$AllegedOffenderCopyWith<$Res>? get allegedOffender;

}
/// @nodoc
class _$IncidentCopyWithImpl<$Res>
    implements $IncidentCopyWith<$Res> {
  _$IncidentCopyWithImpl(this._self, this._then);

  final Incident _self;
  final $Res Function(Incident) _then;

/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? severity = null,Object? address = null,Object? placeName = null,Object? placeType = null,Object? geo = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? occurredAt = null,Object? streetViewUrl = freezed,Object? sourceAgency = null,Object? allegedOffender = freezed,Object? expireAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as IncidentCategory,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as IncidentSeverity,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeType: null == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as GeoCoordinate,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,streetViewUrl: freezed == streetViewUrl ? _self.streetViewUrl : streetViewUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceAgency: null == sourceAgency ? _self.sourceAgency : sourceAgency // ignore: cast_nullable_to_non_nullable
as String,allegedOffender: freezed == allegedOffender ? _self.allegedOffender : allegedOffender // ignore: cast_nullable_to_non_nullable
as AllegedOffender?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinateCopyWith<$Res> get geo {
  
  return $GeoCoordinateCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AllegedOffenderCopyWith<$Res>? get allegedOffender {
    if (_self.allegedOffender == null) {
    return null;
  }

  return $AllegedOffenderCopyWith<$Res>(_self.allegedOffender!, (value) {
    return _then(_self.copyWith(allegedOffender: value));
  });
}
}


/// Adds pattern-matching-related methods to [Incident].
extension IncidentPatterns on Incident {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Incident value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Incident() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Incident value)  $default,){
final _that = this;
switch (_that) {
case _Incident():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Incident value)?  $default,){
final _that = this;
switch (_that) {
case _Incident() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  IncidentCategory category,  IncidentSeverity severity,  String address,  String placeName,  String placeType,  GeoCoordinate geo,  String citySlug,  String cityName,  String stateCode,  DateTime occurredAt,  String? streetViewUrl,  String sourceAgency,  AllegedOffender? allegedOffender,  DateTime? expireAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Incident() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.severity,_that.address,_that.placeName,_that.placeType,_that.geo,_that.citySlug,_that.cityName,_that.stateCode,_that.occurredAt,_that.streetViewUrl,_that.sourceAgency,_that.allegedOffender,_that.expireAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  IncidentCategory category,  IncidentSeverity severity,  String address,  String placeName,  String placeType,  GeoCoordinate geo,  String citySlug,  String cityName,  String stateCode,  DateTime occurredAt,  String? streetViewUrl,  String sourceAgency,  AllegedOffender? allegedOffender,  DateTime? expireAt)  $default,) {final _that = this;
switch (_that) {
case _Incident():
return $default(_that.id,_that.title,_that.category,_that.severity,_that.address,_that.placeName,_that.placeType,_that.geo,_that.citySlug,_that.cityName,_that.stateCode,_that.occurredAt,_that.streetViewUrl,_that.sourceAgency,_that.allegedOffender,_that.expireAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  IncidentCategory category,  IncidentSeverity severity,  String address,  String placeName,  String placeType,  GeoCoordinate geo,  String citySlug,  String cityName,  String stateCode,  DateTime occurredAt,  String? streetViewUrl,  String sourceAgency,  AllegedOffender? allegedOffender,  DateTime? expireAt)?  $default,) {final _that = this;
switch (_that) {
case _Incident() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.severity,_that.address,_that.placeName,_that.placeType,_that.geo,_that.citySlug,_that.cityName,_that.stateCode,_that.occurredAt,_that.streetViewUrl,_that.sourceAgency,_that.allegedOffender,_that.expireAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Incident implements Incident {
  const _Incident({required this.id, required this.title, required this.category, required this.severity, required this.address, required this.placeName, required this.placeType, required this.geo, required this.citySlug, required this.cityName, required this.stateCode, required this.occurredAt, this.streetViewUrl, required this.sourceAgency, this.allegedOffender, this.expireAt});
  factory _Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

@override final  String id;
@override final  String title;
@override final  IncidentCategory category;
@override final  IncidentSeverity severity;
@override final  String address;
@override final  String placeName;
@override final  String placeType;
@override final  GeoCoordinate geo;
@override final  String citySlug;
@override final  String cityName;
@override final  String stateCode;
@override final  DateTime occurredAt;
@override final  String? streetViewUrl;
@override final  String sourceAgency;
@override final  AllegedOffender? allegedOffender;
@override final  DateTime? expireAt;

/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncidentCopyWith<_Incident> get copyWith => __$IncidentCopyWithImpl<_Incident>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncidentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Incident&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.address, address) || other.address == address)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.streetViewUrl, streetViewUrl) || other.streetViewUrl == streetViewUrl)&&(identical(other.sourceAgency, sourceAgency) || other.sourceAgency == sourceAgency)&&(identical(other.allegedOffender, allegedOffender) || other.allegedOffender == allegedOffender)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,severity,address,placeName,placeType,geo,citySlug,cityName,stateCode,occurredAt,streetViewUrl,sourceAgency,allegedOffender,expireAt);

@override
String toString() {
  return 'Incident(id: $id, title: $title, category: $category, severity: $severity, address: $address, placeName: $placeName, placeType: $placeType, geo: $geo, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, occurredAt: $occurredAt, streetViewUrl: $streetViewUrl, sourceAgency: $sourceAgency, allegedOffender: $allegedOffender, expireAt: $expireAt)';
}


}

/// @nodoc
abstract mixin class _$IncidentCopyWith<$Res> implements $IncidentCopyWith<$Res> {
  factory _$IncidentCopyWith(_Incident value, $Res Function(_Incident) _then) = __$IncidentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, IncidentCategory category, IncidentSeverity severity, String address, String placeName, String placeType, GeoCoordinate geo, String citySlug, String cityName, String stateCode, DateTime occurredAt, String? streetViewUrl, String sourceAgency, AllegedOffender? allegedOffender, DateTime? expireAt
});


@override $GeoCoordinateCopyWith<$Res> get geo;@override $AllegedOffenderCopyWith<$Res>? get allegedOffender;

}
/// @nodoc
class __$IncidentCopyWithImpl<$Res>
    implements _$IncidentCopyWith<$Res> {
  __$IncidentCopyWithImpl(this._self, this._then);

  final _Incident _self;
  final $Res Function(_Incident) _then;

/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? severity = null,Object? address = null,Object? placeName = null,Object? placeType = null,Object? geo = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? occurredAt = null,Object? streetViewUrl = freezed,Object? sourceAgency = null,Object? allegedOffender = freezed,Object? expireAt = freezed,}) {
  return _then(_Incident(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as IncidentCategory,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as IncidentSeverity,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeType: null == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as GeoCoordinate,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,streetViewUrl: freezed == streetViewUrl ? _self.streetViewUrl : streetViewUrl // ignore: cast_nullable_to_non_nullable
as String?,sourceAgency: null == sourceAgency ? _self.sourceAgency : sourceAgency // ignore: cast_nullable_to_non_nullable
as String,allegedOffender: freezed == allegedOffender ? _self.allegedOffender : allegedOffender // ignore: cast_nullable_to_non_nullable
as AllegedOffender?,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoCoordinateCopyWith<$Res> get geo {
  
  return $GeoCoordinateCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of Incident
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AllegedOffenderCopyWith<$Res>? get allegedOffender {
    if (_self.allegedOffender == null) {
    return null;
  }

  return $AllegedOffenderCopyWith<$Res>(_self.allegedOffender!, (value) {
    return _then(_self.copyWith(allegedOffender: value));
  });
}
}

// dart format on
