// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicCamera {

 String get id; PublicCameraType get type; String get operatorName; double get latitude; double get longitude; String get geohash; double? get directionHeading; bool get verified; CameraSource get source; String get citySlug; String get stateCode; DateTime get updatedAt;
/// Create a copy of PublicCamera
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicCameraCopyWith<PublicCamera> get copyWith => _$PublicCameraCopyWithImpl<PublicCamera>(this as PublicCamera, _$identity);

  /// Serializes this PublicCamera to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicCamera&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geohash, geohash) || other.geohash == geohash)&&(identical(other.directionHeading, directionHeading) || other.directionHeading == directionHeading)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.source, source) || other.source == source)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,operatorName,latitude,longitude,geohash,directionHeading,verified,source,citySlug,stateCode,updatedAt);

@override
String toString() {
  return 'PublicCamera(id: $id, type: $type, operatorName: $operatorName, latitude: $latitude, longitude: $longitude, geohash: $geohash, directionHeading: $directionHeading, verified: $verified, source: $source, citySlug: $citySlug, stateCode: $stateCode, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PublicCameraCopyWith<$Res>  {
  factory $PublicCameraCopyWith(PublicCamera value, $Res Function(PublicCamera) _then) = _$PublicCameraCopyWithImpl;
@useResult
$Res call({
 String id, PublicCameraType type, String operatorName, double latitude, double longitude, String geohash, double? directionHeading, bool verified, CameraSource source, String citySlug, String stateCode, DateTime updatedAt
});




}
/// @nodoc
class _$PublicCameraCopyWithImpl<$Res>
    implements $PublicCameraCopyWith<$Res> {
  _$PublicCameraCopyWithImpl(this._self, this._then);

  final PublicCamera _self;
  final $Res Function(PublicCamera) _then;

/// Create a copy of PublicCamera
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? operatorName = null,Object? latitude = null,Object? longitude = null,Object? geohash = null,Object? directionHeading = freezed,Object? verified = null,Object? source = null,Object? citySlug = null,Object? stateCode = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PublicCameraType,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,directionHeading: freezed == directionHeading ? _self.directionHeading : directionHeading // ignore: cast_nullable_to_non_nullable
as double?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CameraSource,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicCamera].
extension PublicCameraPatterns on PublicCamera {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicCamera value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicCamera() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicCamera value)  $default,){
final _that = this;
switch (_that) {
case _PublicCamera():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicCamera value)?  $default,){
final _that = this;
switch (_that) {
case _PublicCamera() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String geohash,  double? directionHeading,  bool verified,  CameraSource source,  String citySlug,  String stateCode,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicCamera() when $default != null:
return $default(_that.id,_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.geohash,_that.directionHeading,_that.verified,_that.source,_that.citySlug,_that.stateCode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String geohash,  double? directionHeading,  bool verified,  CameraSource source,  String citySlug,  String stateCode,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PublicCamera():
return $default(_that.id,_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.geohash,_that.directionHeading,_that.verified,_that.source,_that.citySlug,_that.stateCode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String geohash,  double? directionHeading,  bool verified,  CameraSource source,  String citySlug,  String stateCode,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PublicCamera() when $default != null:
return $default(_that.id,_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.geohash,_that.directionHeading,_that.verified,_that.source,_that.citySlug,_that.stateCode,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicCamera implements PublicCamera {
  const _PublicCamera({required this.id, required this.type, required this.operatorName, required this.latitude, required this.longitude, required this.geohash, this.directionHeading, this.verified = true, required this.source, required this.citySlug, required this.stateCode, required this.updatedAt});
  factory _PublicCamera.fromJson(Map<String, dynamic> json) => _$PublicCameraFromJson(json);

@override final  String id;
@override final  PublicCameraType type;
@override final  String operatorName;
@override final  double latitude;
@override final  double longitude;
@override final  String geohash;
@override final  double? directionHeading;
@override@JsonKey() final  bool verified;
@override final  CameraSource source;
@override final  String citySlug;
@override final  String stateCode;
@override final  DateTime updatedAt;

/// Create a copy of PublicCamera
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicCameraCopyWith<_PublicCamera> get copyWith => __$PublicCameraCopyWithImpl<_PublicCamera>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicCameraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicCamera&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.geohash, geohash) || other.geohash == geohash)&&(identical(other.directionHeading, directionHeading) || other.directionHeading == directionHeading)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.source, source) || other.source == source)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,operatorName,latitude,longitude,geohash,directionHeading,verified,source,citySlug,stateCode,updatedAt);

@override
String toString() {
  return 'PublicCamera(id: $id, type: $type, operatorName: $operatorName, latitude: $latitude, longitude: $longitude, geohash: $geohash, directionHeading: $directionHeading, verified: $verified, source: $source, citySlug: $citySlug, stateCode: $stateCode, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PublicCameraCopyWith<$Res> implements $PublicCameraCopyWith<$Res> {
  factory _$PublicCameraCopyWith(_PublicCamera value, $Res Function(_PublicCamera) _then) = __$PublicCameraCopyWithImpl;
@override @useResult
$Res call({
 String id, PublicCameraType type, String operatorName, double latitude, double longitude, String geohash, double? directionHeading, bool verified, CameraSource source, String citySlug, String stateCode, DateTime updatedAt
});




}
/// @nodoc
class __$PublicCameraCopyWithImpl<$Res>
    implements _$PublicCameraCopyWith<$Res> {
  __$PublicCameraCopyWithImpl(this._self, this._then);

  final _PublicCamera _self;
  final $Res Function(_PublicCamera) _then;

/// Create a copy of PublicCamera
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? operatorName = null,Object? latitude = null,Object? longitude = null,Object? geohash = null,Object? directionHeading = freezed,Object? verified = null,Object? source = null,Object? citySlug = null,Object? stateCode = null,Object? updatedAt = null,}) {
  return _then(_PublicCamera(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PublicCameraType,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,geohash: null == geohash ? _self.geohash : geohash // ignore: cast_nullable_to_non_nullable
as String,directionHeading: freezed == directionHeading ? _self.directionHeading : directionHeading // ignore: cast_nullable_to_non_nullable
as double?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CameraSource,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ResidentialDensityCell {

 String get geohashCell; double get centerLat; double get centerLng; double get radiusMeters; double get normalizedDensity; String get neighborhoodName;
/// Create a copy of ResidentialDensityCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentialDensityCellCopyWith<ResidentialDensityCell> get copyWith => _$ResidentialDensityCellCopyWithImpl<ResidentialDensityCell>(this as ResidentialDensityCell, _$identity);

  /// Serializes this ResidentialDensityCell to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentialDensityCell&&(identical(other.geohashCell, geohashCell) || other.geohashCell == geohashCell)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.normalizedDensity, normalizedDensity) || other.normalizedDensity == normalizedDensity)&&(identical(other.neighborhoodName, neighborhoodName) || other.neighborhoodName == neighborhoodName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,geohashCell,centerLat,centerLng,radiusMeters,normalizedDensity,neighborhoodName);

@override
String toString() {
  return 'ResidentialDensityCell(geohashCell: $geohashCell, centerLat: $centerLat, centerLng: $centerLng, radiusMeters: $radiusMeters, normalizedDensity: $normalizedDensity, neighborhoodName: $neighborhoodName)';
}


}

/// @nodoc
abstract mixin class $ResidentialDensityCellCopyWith<$Res>  {
  factory $ResidentialDensityCellCopyWith(ResidentialDensityCell value, $Res Function(ResidentialDensityCell) _then) = _$ResidentialDensityCellCopyWithImpl;
@useResult
$Res call({
 String geohashCell, double centerLat, double centerLng, double radiusMeters, double normalizedDensity, String neighborhoodName
});




}
/// @nodoc
class _$ResidentialDensityCellCopyWithImpl<$Res>
    implements $ResidentialDensityCellCopyWith<$Res> {
  _$ResidentialDensityCellCopyWithImpl(this._self, this._then);

  final ResidentialDensityCell _self;
  final $Res Function(ResidentialDensityCell) _then;

/// Create a copy of ResidentialDensityCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? geohashCell = null,Object? centerLat = null,Object? centerLng = null,Object? radiusMeters = null,Object? normalizedDensity = null,Object? neighborhoodName = null,}) {
  return _then(_self.copyWith(
geohashCell: null == geohashCell ? _self.geohashCell : geohashCell // ignore: cast_nullable_to_non_nullable
as String,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,normalizedDensity: null == normalizedDensity ? _self.normalizedDensity : normalizedDensity // ignore: cast_nullable_to_non_nullable
as double,neighborhoodName: null == neighborhoodName ? _self.neighborhoodName : neighborhoodName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResidentialDensityCell].
extension ResidentialDensityCellPatterns on ResidentialDensityCell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResidentialDensityCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResidentialDensityCell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResidentialDensityCell value)  $default,){
final _that = this;
switch (_that) {
case _ResidentialDensityCell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResidentialDensityCell value)?  $default,){
final _that = this;
switch (_that) {
case _ResidentialDensityCell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String geohashCell,  double centerLat,  double centerLng,  double radiusMeters,  double normalizedDensity,  String neighborhoodName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResidentialDensityCell() when $default != null:
return $default(_that.geohashCell,_that.centerLat,_that.centerLng,_that.radiusMeters,_that.normalizedDensity,_that.neighborhoodName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String geohashCell,  double centerLat,  double centerLng,  double radiusMeters,  double normalizedDensity,  String neighborhoodName)  $default,) {final _that = this;
switch (_that) {
case _ResidentialDensityCell():
return $default(_that.geohashCell,_that.centerLat,_that.centerLng,_that.radiusMeters,_that.normalizedDensity,_that.neighborhoodName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String geohashCell,  double centerLat,  double centerLng,  double radiusMeters,  double normalizedDensity,  String neighborhoodName)?  $default,) {final _that = this;
switch (_that) {
case _ResidentialDensityCell() when $default != null:
return $default(_that.geohashCell,_that.centerLat,_that.centerLng,_that.radiusMeters,_that.normalizedDensity,_that.neighborhoodName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResidentialDensityCell implements ResidentialDensityCell {
  const _ResidentialDensityCell({required this.geohashCell, required this.centerLat, required this.centerLng, required this.radiusMeters, required this.normalizedDensity, required this.neighborhoodName});
  factory _ResidentialDensityCell.fromJson(Map<String, dynamic> json) => _$ResidentialDensityCellFromJson(json);

@override final  String geohashCell;
@override final  double centerLat;
@override final  double centerLng;
@override final  double radiusMeters;
@override final  double normalizedDensity;
@override final  String neighborhoodName;

/// Create a copy of ResidentialDensityCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentialDensityCellCopyWith<_ResidentialDensityCell> get copyWith => __$ResidentialDensityCellCopyWithImpl<_ResidentialDensityCell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentialDensityCellToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentialDensityCell&&(identical(other.geohashCell, geohashCell) || other.geohashCell == geohashCell)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.normalizedDensity, normalizedDensity) || other.normalizedDensity == normalizedDensity)&&(identical(other.neighborhoodName, neighborhoodName) || other.neighborhoodName == neighborhoodName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,geohashCell,centerLat,centerLng,radiusMeters,normalizedDensity,neighborhoodName);

@override
String toString() {
  return 'ResidentialDensityCell(geohashCell: $geohashCell, centerLat: $centerLat, centerLng: $centerLng, radiusMeters: $radiusMeters, normalizedDensity: $normalizedDensity, neighborhoodName: $neighborhoodName)';
}


}

/// @nodoc
abstract mixin class _$ResidentialDensityCellCopyWith<$Res> implements $ResidentialDensityCellCopyWith<$Res> {
  factory _$ResidentialDensityCellCopyWith(_ResidentialDensityCell value, $Res Function(_ResidentialDensityCell) _then) = __$ResidentialDensityCellCopyWithImpl;
@override @useResult
$Res call({
 String geohashCell, double centerLat, double centerLng, double radiusMeters, double normalizedDensity, String neighborhoodName
});




}
/// @nodoc
class __$ResidentialDensityCellCopyWithImpl<$Res>
    implements _$ResidentialDensityCellCopyWith<$Res> {
  __$ResidentialDensityCellCopyWithImpl(this._self, this._then);

  final _ResidentialDensityCell _self;
  final $Res Function(_ResidentialDensityCell) _then;

/// Create a copy of ResidentialDensityCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? geohashCell = null,Object? centerLat = null,Object? centerLng = null,Object? radiusMeters = null,Object? normalizedDensity = null,Object? neighborhoodName = null,}) {
  return _then(_ResidentialDensityCell(
geohashCell: null == geohashCell ? _self.geohashCell : geohashCell // ignore: cast_nullable_to_non_nullable
as String,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,normalizedDensity: null == normalizedDensity ? _self.normalizedDensity : normalizedDensity // ignore: cast_nullable_to_non_nullable
as double,neighborhoodName: null == neighborhoodName ? _self.neighborhoodName : neighborhoodName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CameraAlertSettings {

 bool get enabled; bool get audioChime; double get radiusMeters; bool get showResidentialDensityHeatmap;
/// Create a copy of CameraAlertSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraAlertSettingsCopyWith<CameraAlertSettings> get copyWith => _$CameraAlertSettingsCopyWithImpl<CameraAlertSettings>(this as CameraAlertSettings, _$identity);

  /// Serializes this CameraAlertSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.audioChime, audioChime) || other.audioChime == audioChime)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.showResidentialDensityHeatmap, showResidentialDensityHeatmap) || other.showResidentialDensityHeatmap == showResidentialDensityHeatmap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,audioChime,radiusMeters,showResidentialDensityHeatmap);

@override
String toString() {
  return 'CameraAlertSettings(enabled: $enabled, audioChime: $audioChime, radiusMeters: $radiusMeters, showResidentialDensityHeatmap: $showResidentialDensityHeatmap)';
}


}

/// @nodoc
abstract mixin class $CameraAlertSettingsCopyWith<$Res>  {
  factory $CameraAlertSettingsCopyWith(CameraAlertSettings value, $Res Function(CameraAlertSettings) _then) = _$CameraAlertSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool audioChime, double radiusMeters, bool showResidentialDensityHeatmap
});




}
/// @nodoc
class _$CameraAlertSettingsCopyWithImpl<$Res>
    implements $CameraAlertSettingsCopyWith<$Res> {
  _$CameraAlertSettingsCopyWithImpl(this._self, this._then);

  final CameraAlertSettings _self;
  final $Res Function(CameraAlertSettings) _then;

/// Create a copy of CameraAlertSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? audioChime = null,Object? radiusMeters = null,Object? showResidentialDensityHeatmap = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,audioChime: null == audioChime ? _self.audioChime : audioChime // ignore: cast_nullable_to_non_nullable
as bool,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,showResidentialDensityHeatmap: null == showResidentialDensityHeatmap ? _self.showResidentialDensityHeatmap : showResidentialDensityHeatmap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CameraAlertSettings].
extension CameraAlertSettingsPatterns on CameraAlertSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CameraAlertSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraAlertSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CameraAlertSettings value)  $default,){
final _that = this;
switch (_that) {
case _CameraAlertSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CameraAlertSettings value)?  $default,){
final _that = this;
switch (_that) {
case _CameraAlertSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool audioChime,  double radiusMeters,  bool showResidentialDensityHeatmap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraAlertSettings() when $default != null:
return $default(_that.enabled,_that.audioChime,_that.radiusMeters,_that.showResidentialDensityHeatmap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool audioChime,  double radiusMeters,  bool showResidentialDensityHeatmap)  $default,) {final _that = this;
switch (_that) {
case _CameraAlertSettings():
return $default(_that.enabled,_that.audioChime,_that.radiusMeters,_that.showResidentialDensityHeatmap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool audioChime,  double radiusMeters,  bool showResidentialDensityHeatmap)?  $default,) {final _that = this;
switch (_that) {
case _CameraAlertSettings() when $default != null:
return $default(_that.enabled,_that.audioChime,_that.radiusMeters,_that.showResidentialDensityHeatmap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CameraAlertSettings implements CameraAlertSettings {
  const _CameraAlertSettings({this.enabled = true, this.audioChime = true, this.radiusMeters = 250.0, this.showResidentialDensityHeatmap = false});
  factory _CameraAlertSettings.fromJson(Map<String, dynamic> json) => _$CameraAlertSettingsFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool audioChime;
@override@JsonKey() final  double radiusMeters;
@override@JsonKey() final  bool showResidentialDensityHeatmap;

/// Create a copy of CameraAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraAlertSettingsCopyWith<_CameraAlertSettings> get copyWith => __$CameraAlertSettingsCopyWithImpl<_CameraAlertSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CameraAlertSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.audioChime, audioChime) || other.audioChime == audioChime)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.showResidentialDensityHeatmap, showResidentialDensityHeatmap) || other.showResidentialDensityHeatmap == showResidentialDensityHeatmap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,audioChime,radiusMeters,showResidentialDensityHeatmap);

@override
String toString() {
  return 'CameraAlertSettings(enabled: $enabled, audioChime: $audioChime, radiusMeters: $radiusMeters, showResidentialDensityHeatmap: $showResidentialDensityHeatmap)';
}


}

/// @nodoc
abstract mixin class _$CameraAlertSettingsCopyWith<$Res> implements $CameraAlertSettingsCopyWith<$Res> {
  factory _$CameraAlertSettingsCopyWith(_CameraAlertSettings value, $Res Function(_CameraAlertSettings) _then) = __$CameraAlertSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool audioChime, double radiusMeters, bool showResidentialDensityHeatmap
});




}
/// @nodoc
class __$CameraAlertSettingsCopyWithImpl<$Res>
    implements _$CameraAlertSettingsCopyWith<$Res> {
  __$CameraAlertSettingsCopyWithImpl(this._self, this._then);

  final _CameraAlertSettings _self;
  final $Res Function(_CameraAlertSettings) _then;

/// Create a copy of CameraAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? audioChime = null,Object? radiusMeters = null,Object? showResidentialDensityHeatmap = null,}) {
  return _then(_CameraAlertSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,audioChime: null == audioChime ? _self.audioChime : audioChime // ignore: cast_nullable_to_non_nullable
as bool,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,showResidentialDensityHeatmap: null == showResidentialDensityHeatmap ? _self.showResidentialDensityHeatmap : showResidentialDensityHeatmap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CameraProximityAlert {

 PublicCamera get camera; double get distanceMeters; DateTime get triggeredAt;
/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraProximityAlertCopyWith<CameraProximityAlert> get copyWith => _$CameraProximityAlertCopyWithImpl<CameraProximityAlert>(this as CameraProximityAlert, _$identity);

  /// Serializes this CameraProximityAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraProximityAlert&&(identical(other.camera, camera) || other.camera == camera)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,camera,distanceMeters,triggeredAt);

@override
String toString() {
  return 'CameraProximityAlert(camera: $camera, distanceMeters: $distanceMeters, triggeredAt: $triggeredAt)';
}


}

/// @nodoc
abstract mixin class $CameraProximityAlertCopyWith<$Res>  {
  factory $CameraProximityAlertCopyWith(CameraProximityAlert value, $Res Function(CameraProximityAlert) _then) = _$CameraProximityAlertCopyWithImpl;
@useResult
$Res call({
 PublicCamera camera, double distanceMeters, DateTime triggeredAt
});


$PublicCameraCopyWith<$Res> get camera;

}
/// @nodoc
class _$CameraProximityAlertCopyWithImpl<$Res>
    implements $CameraProximityAlertCopyWith<$Res> {
  _$CameraProximityAlertCopyWithImpl(this._self, this._then);

  final CameraProximityAlert _self;
  final $Res Function(CameraProximityAlert) _then;

/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? camera = null,Object? distanceMeters = null,Object? triggeredAt = null,}) {
  return _then(_self.copyWith(
camera: null == camera ? _self.camera : camera // ignore: cast_nullable_to_non_nullable
as PublicCamera,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicCameraCopyWith<$Res> get camera {
  
  return $PublicCameraCopyWith<$Res>(_self.camera, (value) {
    return _then(_self.copyWith(camera: value));
  });
}
}


/// Adds pattern-matching-related methods to [CameraProximityAlert].
extension CameraProximityAlertPatterns on CameraProximityAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CameraProximityAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraProximityAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CameraProximityAlert value)  $default,){
final _that = this;
switch (_that) {
case _CameraProximityAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CameraProximityAlert value)?  $default,){
final _that = this;
switch (_that) {
case _CameraProximityAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PublicCamera camera,  double distanceMeters,  DateTime triggeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraProximityAlert() when $default != null:
return $default(_that.camera,_that.distanceMeters,_that.triggeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PublicCamera camera,  double distanceMeters,  DateTime triggeredAt)  $default,) {final _that = this;
switch (_that) {
case _CameraProximityAlert():
return $default(_that.camera,_that.distanceMeters,_that.triggeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PublicCamera camera,  double distanceMeters,  DateTime triggeredAt)?  $default,) {final _that = this;
switch (_that) {
case _CameraProximityAlert() when $default != null:
return $default(_that.camera,_that.distanceMeters,_that.triggeredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CameraProximityAlert implements CameraProximityAlert {
  const _CameraProximityAlert({required this.camera, required this.distanceMeters, required this.triggeredAt});
  factory _CameraProximityAlert.fromJson(Map<String, dynamic> json) => _$CameraProximityAlertFromJson(json);

@override final  PublicCamera camera;
@override final  double distanceMeters;
@override final  DateTime triggeredAt;

/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraProximityAlertCopyWith<_CameraProximityAlert> get copyWith => __$CameraProximityAlertCopyWithImpl<_CameraProximityAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CameraProximityAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraProximityAlert&&(identical(other.camera, camera) || other.camera == camera)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,camera,distanceMeters,triggeredAt);

@override
String toString() {
  return 'CameraProximityAlert(camera: $camera, distanceMeters: $distanceMeters, triggeredAt: $triggeredAt)';
}


}

/// @nodoc
abstract mixin class _$CameraProximityAlertCopyWith<$Res> implements $CameraProximityAlertCopyWith<$Res> {
  factory _$CameraProximityAlertCopyWith(_CameraProximityAlert value, $Res Function(_CameraProximityAlert) _then) = __$CameraProximityAlertCopyWithImpl;
@override @useResult
$Res call({
 PublicCamera camera, double distanceMeters, DateTime triggeredAt
});


@override $PublicCameraCopyWith<$Res> get camera;

}
/// @nodoc
class __$CameraProximityAlertCopyWithImpl<$Res>
    implements _$CameraProximityAlertCopyWith<$Res> {
  __$CameraProximityAlertCopyWithImpl(this._self, this._then);

  final _CameraProximityAlert _self;
  final $Res Function(_CameraProximityAlert) _then;

/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? camera = null,Object? distanceMeters = null,Object? triggeredAt = null,}) {
  return _then(_CameraProximityAlert(
camera: null == camera ? _self.camera : camera // ignore: cast_nullable_to_non_nullable
as PublicCamera,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CameraProximityAlert
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicCameraCopyWith<$Res> get camera {
  
  return $PublicCameraCopyWith<$Res>(_self.camera, (value) {
    return _then(_self.copyWith(camera: value));
  });
}
}


/// @nodoc
mixin _$CameraSubmissionRequest {

 PublicCameraType get type; String get operatorName; double get latitude; double get longitude; String get citySlug; String get stateCode; bool get isPrivateResidence; String? get streetNotes;
/// Create a copy of CameraSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraSubmissionRequestCopyWith<CameraSubmissionRequest> get copyWith => _$CameraSubmissionRequestCopyWithImpl<CameraSubmissionRequest>(this as CameraSubmissionRequest, _$identity);

  /// Serializes this CameraSubmissionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraSubmissionRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.isPrivateResidence, isPrivateResidence) || other.isPrivateResidence == isPrivateResidence)&&(identical(other.streetNotes, streetNotes) || other.streetNotes == streetNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,operatorName,latitude,longitude,citySlug,stateCode,isPrivateResidence,streetNotes);

@override
String toString() {
  return 'CameraSubmissionRequest(type: $type, operatorName: $operatorName, latitude: $latitude, longitude: $longitude, citySlug: $citySlug, stateCode: $stateCode, isPrivateResidence: $isPrivateResidence, streetNotes: $streetNotes)';
}


}

/// @nodoc
abstract mixin class $CameraSubmissionRequestCopyWith<$Res>  {
  factory $CameraSubmissionRequestCopyWith(CameraSubmissionRequest value, $Res Function(CameraSubmissionRequest) _then) = _$CameraSubmissionRequestCopyWithImpl;
@useResult
$Res call({
 PublicCameraType type, String operatorName, double latitude, double longitude, String citySlug, String stateCode, bool isPrivateResidence, String? streetNotes
});




}
/// @nodoc
class _$CameraSubmissionRequestCopyWithImpl<$Res>
    implements $CameraSubmissionRequestCopyWith<$Res> {
  _$CameraSubmissionRequestCopyWithImpl(this._self, this._then);

  final CameraSubmissionRequest _self;
  final $Res Function(CameraSubmissionRequest) _then;

/// Create a copy of CameraSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? operatorName = null,Object? latitude = null,Object? longitude = null,Object? citySlug = null,Object? stateCode = null,Object? isPrivateResidence = null,Object? streetNotes = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PublicCameraType,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,isPrivateResidence: null == isPrivateResidence ? _self.isPrivateResidence : isPrivateResidence // ignore: cast_nullable_to_non_nullable
as bool,streetNotes: freezed == streetNotes ? _self.streetNotes : streetNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CameraSubmissionRequest].
extension CameraSubmissionRequestPatterns on CameraSubmissionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CameraSubmissionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CameraSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CameraSubmissionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CameraSubmissionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CameraSubmissionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CameraSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String citySlug,  String stateCode,  bool isPrivateResidence,  String? streetNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CameraSubmissionRequest() when $default != null:
return $default(_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.citySlug,_that.stateCode,_that.isPrivateResidence,_that.streetNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String citySlug,  String stateCode,  bool isPrivateResidence,  String? streetNotes)  $default,) {final _that = this;
switch (_that) {
case _CameraSubmissionRequest():
return $default(_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.citySlug,_that.stateCode,_that.isPrivateResidence,_that.streetNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PublicCameraType type,  String operatorName,  double latitude,  double longitude,  String citySlug,  String stateCode,  bool isPrivateResidence,  String? streetNotes)?  $default,) {final _that = this;
switch (_that) {
case _CameraSubmissionRequest() when $default != null:
return $default(_that.type,_that.operatorName,_that.latitude,_that.longitude,_that.citySlug,_that.stateCode,_that.isPrivateResidence,_that.streetNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CameraSubmissionRequest implements CameraSubmissionRequest {
  const _CameraSubmissionRequest({required this.type, required this.operatorName, required this.latitude, required this.longitude, required this.citySlug, required this.stateCode, required this.isPrivateResidence, this.streetNotes});
  factory _CameraSubmissionRequest.fromJson(Map<String, dynamic> json) => _$CameraSubmissionRequestFromJson(json);

@override final  PublicCameraType type;
@override final  String operatorName;
@override final  double latitude;
@override final  double longitude;
@override final  String citySlug;
@override final  String stateCode;
@override final  bool isPrivateResidence;
@override final  String? streetNotes;

/// Create a copy of CameraSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CameraSubmissionRequestCopyWith<_CameraSubmissionRequest> get copyWith => __$CameraSubmissionRequestCopyWithImpl<_CameraSubmissionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CameraSubmissionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CameraSubmissionRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.isPrivateResidence, isPrivateResidence) || other.isPrivateResidence == isPrivateResidence)&&(identical(other.streetNotes, streetNotes) || other.streetNotes == streetNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,operatorName,latitude,longitude,citySlug,stateCode,isPrivateResidence,streetNotes);

@override
String toString() {
  return 'CameraSubmissionRequest(type: $type, operatorName: $operatorName, latitude: $latitude, longitude: $longitude, citySlug: $citySlug, stateCode: $stateCode, isPrivateResidence: $isPrivateResidence, streetNotes: $streetNotes)';
}


}

/// @nodoc
abstract mixin class _$CameraSubmissionRequestCopyWith<$Res> implements $CameraSubmissionRequestCopyWith<$Res> {
  factory _$CameraSubmissionRequestCopyWith(_CameraSubmissionRequest value, $Res Function(_CameraSubmissionRequest) _then) = __$CameraSubmissionRequestCopyWithImpl;
@override @useResult
$Res call({
 PublicCameraType type, String operatorName, double latitude, double longitude, String citySlug, String stateCode, bool isPrivateResidence, String? streetNotes
});




}
/// @nodoc
class __$CameraSubmissionRequestCopyWithImpl<$Res>
    implements _$CameraSubmissionRequestCopyWith<$Res> {
  __$CameraSubmissionRequestCopyWithImpl(this._self, this._then);

  final _CameraSubmissionRequest _self;
  final $Res Function(_CameraSubmissionRequest) _then;

/// Create a copy of CameraSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? operatorName = null,Object? latitude = null,Object? longitude = null,Object? citySlug = null,Object? stateCode = null,Object? isPrivateResidence = null,Object? streetNotes = freezed,}) {
  return _then(_CameraSubmissionRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PublicCameraType,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,isPrivateResidence: null == isPrivateResidence ? _self.isPrivateResidence : isPrivateResidence // ignore: cast_nullable_to_non_nullable
as bool,streetNotes: freezed == streetNotes ? _self.streetNotes : streetNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
