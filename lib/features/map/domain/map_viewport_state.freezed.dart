// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_viewport_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapViewportState {

 MapScope get scope; double get centerLat; double get centerLng; double get zoom; double get tilt; double get bearing; String get activeCitySlug; String get activeCityName; String get activeStateCode; String get activeZipCode; bool get carFollowMode; bool get showIncidentsLayer; bool get showTerritoriesLayer; bool get showCamerasLayer; bool get showResidentialDensityLayer; String get searchQuery;
/// Create a copy of MapViewportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapViewportStateCopyWith<MapViewportState> get copyWith => _$MapViewportStateCopyWithImpl<MapViewportState>(this as MapViewportState, _$identity);

  /// Serializes this MapViewportState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapViewportState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.activeCitySlug, activeCitySlug) || other.activeCitySlug == activeCitySlug)&&(identical(other.activeCityName, activeCityName) || other.activeCityName == activeCityName)&&(identical(other.activeStateCode, activeStateCode) || other.activeStateCode == activeStateCode)&&(identical(other.activeZipCode, activeZipCode) || other.activeZipCode == activeZipCode)&&(identical(other.carFollowMode, carFollowMode) || other.carFollowMode == carFollowMode)&&(identical(other.showIncidentsLayer, showIncidentsLayer) || other.showIncidentsLayer == showIncidentsLayer)&&(identical(other.showTerritoriesLayer, showTerritoriesLayer) || other.showTerritoriesLayer == showTerritoriesLayer)&&(identical(other.showCamerasLayer, showCamerasLayer) || other.showCamerasLayer == showCamerasLayer)&&(identical(other.showResidentialDensityLayer, showResidentialDensityLayer) || other.showResidentialDensityLayer == showResidentialDensityLayer)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,centerLat,centerLng,zoom,tilt,bearing,activeCitySlug,activeCityName,activeStateCode,activeZipCode,carFollowMode,showIncidentsLayer,showTerritoriesLayer,showCamerasLayer,showResidentialDensityLayer,searchQuery);

@override
String toString() {
  return 'MapViewportState(scope: $scope, centerLat: $centerLat, centerLng: $centerLng, zoom: $zoom, tilt: $tilt, bearing: $bearing, activeCitySlug: $activeCitySlug, activeCityName: $activeCityName, activeStateCode: $activeStateCode, activeZipCode: $activeZipCode, carFollowMode: $carFollowMode, showIncidentsLayer: $showIncidentsLayer, showTerritoriesLayer: $showTerritoriesLayer, showCamerasLayer: $showCamerasLayer, showResidentialDensityLayer: $showResidentialDensityLayer, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $MapViewportStateCopyWith<$Res>  {
  factory $MapViewportStateCopyWith(MapViewportState value, $Res Function(MapViewportState) _then) = _$MapViewportStateCopyWithImpl;
@useResult
$Res call({
 MapScope scope, double centerLat, double centerLng, double zoom, double tilt, double bearing, String activeCitySlug, String activeCityName, String activeStateCode, String activeZipCode, bool carFollowMode, bool showIncidentsLayer, bool showTerritoriesLayer, bool showCamerasLayer, bool showResidentialDensityLayer, String searchQuery
});




}
/// @nodoc
class _$MapViewportStateCopyWithImpl<$Res>
    implements $MapViewportStateCopyWith<$Res> {
  _$MapViewportStateCopyWithImpl(this._self, this._then);

  final MapViewportState _self;
  final $Res Function(MapViewportState) _then;

/// Create a copy of MapViewportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? centerLat = null,Object? centerLng = null,Object? zoom = null,Object? tilt = null,Object? bearing = null,Object? activeCitySlug = null,Object? activeCityName = null,Object? activeStateCode = null,Object? activeZipCode = null,Object? carFollowMode = null,Object? showIncidentsLayer = null,Object? showTerritoriesLayer = null,Object? showCamerasLayer = null,Object? showResidentialDensityLayer = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as MapScope,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,bearing: null == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double,activeCitySlug: null == activeCitySlug ? _self.activeCitySlug : activeCitySlug // ignore: cast_nullable_to_non_nullable
as String,activeCityName: null == activeCityName ? _self.activeCityName : activeCityName // ignore: cast_nullable_to_non_nullable
as String,activeStateCode: null == activeStateCode ? _self.activeStateCode : activeStateCode // ignore: cast_nullable_to_non_nullable
as String,activeZipCode: null == activeZipCode ? _self.activeZipCode : activeZipCode // ignore: cast_nullable_to_non_nullable
as String,carFollowMode: null == carFollowMode ? _self.carFollowMode : carFollowMode // ignore: cast_nullable_to_non_nullable
as bool,showIncidentsLayer: null == showIncidentsLayer ? _self.showIncidentsLayer : showIncidentsLayer // ignore: cast_nullable_to_non_nullable
as bool,showTerritoriesLayer: null == showTerritoriesLayer ? _self.showTerritoriesLayer : showTerritoriesLayer // ignore: cast_nullable_to_non_nullable
as bool,showCamerasLayer: null == showCamerasLayer ? _self.showCamerasLayer : showCamerasLayer // ignore: cast_nullable_to_non_nullable
as bool,showResidentialDensityLayer: null == showResidentialDensityLayer ? _self.showResidentialDensityLayer : showResidentialDensityLayer // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MapViewportState].
extension MapViewportStatePatterns on MapViewportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapViewportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapViewportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapViewportState value)  $default,){
final _that = this;
switch (_that) {
case _MapViewportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapViewportState value)?  $default,){
final _that = this;
switch (_that) {
case _MapViewportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapScope scope,  double centerLat,  double centerLng,  double zoom,  double tilt,  double bearing,  String activeCitySlug,  String activeCityName,  String activeStateCode,  String activeZipCode,  bool carFollowMode,  bool showIncidentsLayer,  bool showTerritoriesLayer,  bool showCamerasLayer,  bool showResidentialDensityLayer,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapViewportState() when $default != null:
return $default(_that.scope,_that.centerLat,_that.centerLng,_that.zoom,_that.tilt,_that.bearing,_that.activeCitySlug,_that.activeCityName,_that.activeStateCode,_that.activeZipCode,_that.carFollowMode,_that.showIncidentsLayer,_that.showTerritoriesLayer,_that.showCamerasLayer,_that.showResidentialDensityLayer,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapScope scope,  double centerLat,  double centerLng,  double zoom,  double tilt,  double bearing,  String activeCitySlug,  String activeCityName,  String activeStateCode,  String activeZipCode,  bool carFollowMode,  bool showIncidentsLayer,  bool showTerritoriesLayer,  bool showCamerasLayer,  bool showResidentialDensityLayer,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _MapViewportState():
return $default(_that.scope,_that.centerLat,_that.centerLng,_that.zoom,_that.tilt,_that.bearing,_that.activeCitySlug,_that.activeCityName,_that.activeStateCode,_that.activeZipCode,_that.carFollowMode,_that.showIncidentsLayer,_that.showTerritoriesLayer,_that.showCamerasLayer,_that.showResidentialDensityLayer,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapScope scope,  double centerLat,  double centerLng,  double zoom,  double tilt,  double bearing,  String activeCitySlug,  String activeCityName,  String activeStateCode,  String activeZipCode,  bool carFollowMode,  bool showIncidentsLayer,  bool showTerritoriesLayer,  bool showCamerasLayer,  bool showResidentialDensityLayer,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _MapViewportState() when $default != null:
return $default(_that.scope,_that.centerLat,_that.centerLng,_that.zoom,_that.tilt,_that.bearing,_that.activeCitySlug,_that.activeCityName,_that.activeStateCode,_that.activeZipCode,_that.carFollowMode,_that.showIncidentsLayer,_that.showTerritoriesLayer,_that.showCamerasLayer,_that.showResidentialDensityLayer,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapViewportState implements MapViewportState {
  const _MapViewportState({this.scope = MapScope.area, this.centerLat = 33.7756, this.centerLng = -84.3963, this.zoom = 13.5, this.tilt = 45.0, this.bearing = 0.0, this.activeCitySlug = 'atlanta', this.activeCityName = 'Atlanta', this.activeStateCode = 'GA', this.activeZipCode = '30308', this.carFollowMode = true, this.showIncidentsLayer = true, this.showTerritoriesLayer = true, this.showCamerasLayer = true, this.showResidentialDensityLayer = false, this.searchQuery = ''});
  factory _MapViewportState.fromJson(Map<String, dynamic> json) => _$MapViewportStateFromJson(json);

@override@JsonKey() final  MapScope scope;
@override@JsonKey() final  double centerLat;
@override@JsonKey() final  double centerLng;
@override@JsonKey() final  double zoom;
@override@JsonKey() final  double tilt;
@override@JsonKey() final  double bearing;
@override@JsonKey() final  String activeCitySlug;
@override@JsonKey() final  String activeCityName;
@override@JsonKey() final  String activeStateCode;
@override@JsonKey() final  String activeZipCode;
@override@JsonKey() final  bool carFollowMode;
@override@JsonKey() final  bool showIncidentsLayer;
@override@JsonKey() final  bool showTerritoriesLayer;
@override@JsonKey() final  bool showCamerasLayer;
@override@JsonKey() final  bool showResidentialDensityLayer;
@override@JsonKey() final  String searchQuery;

/// Create a copy of MapViewportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapViewportStateCopyWith<_MapViewportState> get copyWith => __$MapViewportStateCopyWithImpl<_MapViewportState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapViewportStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapViewportState&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.centerLat, centerLat) || other.centerLat == centerLat)&&(identical(other.centerLng, centerLng) || other.centerLng == centerLng)&&(identical(other.zoom, zoom) || other.zoom == zoom)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.activeCitySlug, activeCitySlug) || other.activeCitySlug == activeCitySlug)&&(identical(other.activeCityName, activeCityName) || other.activeCityName == activeCityName)&&(identical(other.activeStateCode, activeStateCode) || other.activeStateCode == activeStateCode)&&(identical(other.activeZipCode, activeZipCode) || other.activeZipCode == activeZipCode)&&(identical(other.carFollowMode, carFollowMode) || other.carFollowMode == carFollowMode)&&(identical(other.showIncidentsLayer, showIncidentsLayer) || other.showIncidentsLayer == showIncidentsLayer)&&(identical(other.showTerritoriesLayer, showTerritoriesLayer) || other.showTerritoriesLayer == showTerritoriesLayer)&&(identical(other.showCamerasLayer, showCamerasLayer) || other.showCamerasLayer == showCamerasLayer)&&(identical(other.showResidentialDensityLayer, showResidentialDensityLayer) || other.showResidentialDensityLayer == showResidentialDensityLayer)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scope,centerLat,centerLng,zoom,tilt,bearing,activeCitySlug,activeCityName,activeStateCode,activeZipCode,carFollowMode,showIncidentsLayer,showTerritoriesLayer,showCamerasLayer,showResidentialDensityLayer,searchQuery);

@override
String toString() {
  return 'MapViewportState(scope: $scope, centerLat: $centerLat, centerLng: $centerLng, zoom: $zoom, tilt: $tilt, bearing: $bearing, activeCitySlug: $activeCitySlug, activeCityName: $activeCityName, activeStateCode: $activeStateCode, activeZipCode: $activeZipCode, carFollowMode: $carFollowMode, showIncidentsLayer: $showIncidentsLayer, showTerritoriesLayer: $showTerritoriesLayer, showCamerasLayer: $showCamerasLayer, showResidentialDensityLayer: $showResidentialDensityLayer, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$MapViewportStateCopyWith<$Res> implements $MapViewportStateCopyWith<$Res> {
  factory _$MapViewportStateCopyWith(_MapViewportState value, $Res Function(_MapViewportState) _then) = __$MapViewportStateCopyWithImpl;
@override @useResult
$Res call({
 MapScope scope, double centerLat, double centerLng, double zoom, double tilt, double bearing, String activeCitySlug, String activeCityName, String activeStateCode, String activeZipCode, bool carFollowMode, bool showIncidentsLayer, bool showTerritoriesLayer, bool showCamerasLayer, bool showResidentialDensityLayer, String searchQuery
});




}
/// @nodoc
class __$MapViewportStateCopyWithImpl<$Res>
    implements _$MapViewportStateCopyWith<$Res> {
  __$MapViewportStateCopyWithImpl(this._self, this._then);

  final _MapViewportState _self;
  final $Res Function(_MapViewportState) _then;

/// Create a copy of MapViewportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? centerLat = null,Object? centerLng = null,Object? zoom = null,Object? tilt = null,Object? bearing = null,Object? activeCitySlug = null,Object? activeCityName = null,Object? activeStateCode = null,Object? activeZipCode = null,Object? carFollowMode = null,Object? showIncidentsLayer = null,Object? showTerritoriesLayer = null,Object? showCamerasLayer = null,Object? showResidentialDensityLayer = null,Object? searchQuery = null,}) {
  return _then(_MapViewportState(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as MapScope,centerLat: null == centerLat ? _self.centerLat : centerLat // ignore: cast_nullable_to_non_nullable
as double,centerLng: null == centerLng ? _self.centerLng : centerLng // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,bearing: null == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double,activeCitySlug: null == activeCitySlug ? _self.activeCitySlug : activeCitySlug // ignore: cast_nullable_to_non_nullable
as String,activeCityName: null == activeCityName ? _self.activeCityName : activeCityName // ignore: cast_nullable_to_non_nullable
as String,activeStateCode: null == activeStateCode ? _self.activeStateCode : activeStateCode // ignore: cast_nullable_to_non_nullable
as String,activeZipCode: null == activeZipCode ? _self.activeZipCode : activeZipCode // ignore: cast_nullable_to_non_nullable
as String,carFollowMode: null == carFollowMode ? _self.carFollowMode : carFollowMode // ignore: cast_nullable_to_non_nullable
as bool,showIncidentsLayer: null == showIncidentsLayer ? _self.showIncidentsLayer : showIncidentsLayer // ignore: cast_nullable_to_non_nullable
as bool,showTerritoriesLayer: null == showTerritoriesLayer ? _self.showTerritoriesLayer : showTerritoriesLayer // ignore: cast_nullable_to_non_nullable
as bool,showCamerasLayer: null == showCamerasLayer ? _self.showCamerasLayer : showCamerasLayer // ignore: cast_nullable_to_non_nullable
as bool,showResidentialDensityLayer: null == showResidentialDensityLayer ? _self.showResidentialDensityLayer : showResidentialDensityLayer // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
