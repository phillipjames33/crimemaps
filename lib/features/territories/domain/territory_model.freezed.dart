// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'territory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TerritoryVertex {

 double get latitude; double get longitude;
/// Create a copy of TerritoryVertex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerritoryVertexCopyWith<TerritoryVertex> get copyWith => _$TerritoryVertexCopyWithImpl<TerritoryVertex>(this as TerritoryVertex, _$identity);

  /// Serializes this TerritoryVertex to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerritoryVertex&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'TerritoryVertex(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $TerritoryVertexCopyWith<$Res>  {
  factory $TerritoryVertexCopyWith(TerritoryVertex value, $Res Function(TerritoryVertex) _then) = _$TerritoryVertexCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$TerritoryVertexCopyWithImpl<$Res>
    implements $TerritoryVertexCopyWith<$Res> {
  _$TerritoryVertexCopyWithImpl(this._self, this._then);

  final TerritoryVertex _self;
  final $Res Function(TerritoryVertex) _then;

/// Create a copy of TerritoryVertex
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TerritoryVertex].
extension TerritoryVertexPatterns on TerritoryVertex {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerritoryVertex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerritoryVertex() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerritoryVertex value)  $default,){
final _that = this;
switch (_that) {
case _TerritoryVertex():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerritoryVertex value)?  $default,){
final _that = this;
switch (_that) {
case _TerritoryVertex() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerritoryVertex() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _TerritoryVertex():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _TerritoryVertex() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TerritoryVertex implements TerritoryVertex {
  const _TerritoryVertex({required this.latitude, required this.longitude});
  factory _TerritoryVertex.fromJson(Map<String, dynamic> json) => _$TerritoryVertexFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of TerritoryVertex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerritoryVertexCopyWith<_TerritoryVertex> get copyWith => __$TerritoryVertexCopyWithImpl<_TerritoryVertex>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerritoryVertexToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerritoryVertex&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'TerritoryVertex(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$TerritoryVertexCopyWith<$Res> implements $TerritoryVertexCopyWith<$Res> {
  factory _$TerritoryVertexCopyWith(_TerritoryVertex value, $Res Function(_TerritoryVertex) _then) = __$TerritoryVertexCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$TerritoryVertexCopyWithImpl<$Res>
    implements _$TerritoryVertexCopyWith<$Res> {
  __$TerritoryVertexCopyWithImpl(this._self, this._then);

  final _TerritoryVertex _self;
  final $Res Function(_TerritoryVertex) _then;

/// Create a copy of TerritoryVertex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_TerritoryVertex(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Territory {

 String get id; String get name; String get citySlug; String get stateCode; String get colorHex; List<TerritoryVertex> get polygonPoints; String get citationDate; String get sourceReference; String get contextLabel; String? get historicalNotes; DateTime get updatedAt;
/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerritoryCopyWith<Territory> get copyWith => _$TerritoryCopyWithImpl<Territory>(this as Territory, _$identity);

  /// Serializes this Territory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Territory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other.polygonPoints, polygonPoints)&&(identical(other.citationDate, citationDate) || other.citationDate == citationDate)&&(identical(other.sourceReference, sourceReference) || other.sourceReference == sourceReference)&&(identical(other.contextLabel, contextLabel) || other.contextLabel == contextLabel)&&(identical(other.historicalNotes, historicalNotes) || other.historicalNotes == historicalNotes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,citySlug,stateCode,colorHex,const DeepCollectionEquality().hash(polygonPoints),citationDate,sourceReference,contextLabel,historicalNotes,updatedAt);

@override
String toString() {
  return 'Territory(id: $id, name: $name, citySlug: $citySlug, stateCode: $stateCode, colorHex: $colorHex, polygonPoints: $polygonPoints, citationDate: $citationDate, sourceReference: $sourceReference, contextLabel: $contextLabel, historicalNotes: $historicalNotes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TerritoryCopyWith<$Res>  {
  factory $TerritoryCopyWith(Territory value, $Res Function(Territory) _then) = _$TerritoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String citySlug, String stateCode, String colorHex, List<TerritoryVertex> polygonPoints, String citationDate, String sourceReference, String contextLabel, String? historicalNotes, DateTime updatedAt
});




}
/// @nodoc
class _$TerritoryCopyWithImpl<$Res>
    implements $TerritoryCopyWith<$Res> {
  _$TerritoryCopyWithImpl(this._self, this._then);

  final Territory _self;
  final $Res Function(Territory) _then;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? citySlug = null,Object? stateCode = null,Object? colorHex = null,Object? polygonPoints = null,Object? citationDate = null,Object? sourceReference = null,Object? contextLabel = null,Object? historicalNotes = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,polygonPoints: null == polygonPoints ? _self.polygonPoints : polygonPoints // ignore: cast_nullable_to_non_nullable
as List<TerritoryVertex>,citationDate: null == citationDate ? _self.citationDate : citationDate // ignore: cast_nullable_to_non_nullable
as String,sourceReference: null == sourceReference ? _self.sourceReference : sourceReference // ignore: cast_nullable_to_non_nullable
as String,contextLabel: null == contextLabel ? _self.contextLabel : contextLabel // ignore: cast_nullable_to_non_nullable
as String,historicalNotes: freezed == historicalNotes ? _self.historicalNotes : historicalNotes // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Territory].
extension TerritoryPatterns on Territory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Territory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Territory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Territory value)  $default,){
final _that = this;
switch (_that) {
case _Territory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Territory value)?  $default,){
final _that = this;
switch (_that) {
case _Territory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String citySlug,  String stateCode,  String colorHex,  List<TerritoryVertex> polygonPoints,  String citationDate,  String sourceReference,  String contextLabel,  String? historicalNotes,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Territory() when $default != null:
return $default(_that.id,_that.name,_that.citySlug,_that.stateCode,_that.colorHex,_that.polygonPoints,_that.citationDate,_that.sourceReference,_that.contextLabel,_that.historicalNotes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String citySlug,  String stateCode,  String colorHex,  List<TerritoryVertex> polygonPoints,  String citationDate,  String sourceReference,  String contextLabel,  String? historicalNotes,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Territory():
return $default(_that.id,_that.name,_that.citySlug,_that.stateCode,_that.colorHex,_that.polygonPoints,_that.citationDate,_that.sourceReference,_that.contextLabel,_that.historicalNotes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String citySlug,  String stateCode,  String colorHex,  List<TerritoryVertex> polygonPoints,  String citationDate,  String sourceReference,  String contextLabel,  String? historicalNotes,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Territory() when $default != null:
return $default(_that.id,_that.name,_that.citySlug,_that.stateCode,_that.colorHex,_that.polygonPoints,_that.citationDate,_that.sourceReference,_that.contextLabel,_that.historicalNotes,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Territory implements Territory {
  const _Territory({required this.id, required this.name, required this.citySlug, required this.stateCode, required this.colorHex, required final  List<TerritoryVertex> polygonPoints, required this.citationDate, required this.sourceReference, required this.contextLabel, this.historicalNotes, required this.updatedAt}): _polygonPoints = polygonPoints;
  factory _Territory.fromJson(Map<String, dynamic> json) => _$TerritoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String citySlug;
@override final  String stateCode;
@override final  String colorHex;
 final  List<TerritoryVertex> _polygonPoints;
@override List<TerritoryVertex> get polygonPoints {
  if (_polygonPoints is EqualUnmodifiableListView) return _polygonPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polygonPoints);
}

@override final  String citationDate;
@override final  String sourceReference;
@override final  String contextLabel;
@override final  String? historicalNotes;
@override final  DateTime updatedAt;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerritoryCopyWith<_Territory> get copyWith => __$TerritoryCopyWithImpl<_Territory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerritoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Territory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other._polygonPoints, _polygonPoints)&&(identical(other.citationDate, citationDate) || other.citationDate == citationDate)&&(identical(other.sourceReference, sourceReference) || other.sourceReference == sourceReference)&&(identical(other.contextLabel, contextLabel) || other.contextLabel == contextLabel)&&(identical(other.historicalNotes, historicalNotes) || other.historicalNotes == historicalNotes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,citySlug,stateCode,colorHex,const DeepCollectionEquality().hash(_polygonPoints),citationDate,sourceReference,contextLabel,historicalNotes,updatedAt);

@override
String toString() {
  return 'Territory(id: $id, name: $name, citySlug: $citySlug, stateCode: $stateCode, colorHex: $colorHex, polygonPoints: $polygonPoints, citationDate: $citationDate, sourceReference: $sourceReference, contextLabel: $contextLabel, historicalNotes: $historicalNotes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TerritoryCopyWith<$Res> implements $TerritoryCopyWith<$Res> {
  factory _$TerritoryCopyWith(_Territory value, $Res Function(_Territory) _then) = __$TerritoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String citySlug, String stateCode, String colorHex, List<TerritoryVertex> polygonPoints, String citationDate, String sourceReference, String contextLabel, String? historicalNotes, DateTime updatedAt
});




}
/// @nodoc
class __$TerritoryCopyWithImpl<$Res>
    implements _$TerritoryCopyWith<$Res> {
  __$TerritoryCopyWithImpl(this._self, this._then);

  final _Territory _self;
  final $Res Function(_Territory) _then;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? citySlug = null,Object? stateCode = null,Object? colorHex = null,Object? polygonPoints = null,Object? citationDate = null,Object? sourceReference = null,Object? contextLabel = null,Object? historicalNotes = freezed,Object? updatedAt = null,}) {
  return _then(_Territory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,polygonPoints: null == polygonPoints ? _self._polygonPoints : polygonPoints // ignore: cast_nullable_to_non_nullable
as List<TerritoryVertex>,citationDate: null == citationDate ? _self.citationDate : citationDate // ignore: cast_nullable_to_non_nullable
as String,sourceReference: null == sourceReference ? _self.sourceReference : sourceReference // ignore: cast_nullable_to_non_nullable
as String,contextLabel: null == contextLabel ? _self.contextLabel : contextLabel // ignore: cast_nullable_to_non_nullable
as String,historicalNotes: freezed == historicalNotes ? _self.historicalNotes : historicalNotes // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TerritorySubmission {

 String get id; String? get territoryId; String get proposedName; String get citySlug; String get stateCode; String get sourceCitation; String get notes; String get submittedByUserId; DateTime get submittedAt; String get moderationStatus;
/// Create a copy of TerritorySubmission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerritorySubmissionCopyWith<TerritorySubmission> get copyWith => _$TerritorySubmissionCopyWithImpl<TerritorySubmission>(this as TerritorySubmission, _$identity);

  /// Serializes this TerritorySubmission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerritorySubmission&&(identical(other.id, id) || other.id == id)&&(identical(other.territoryId, territoryId) || other.territoryId == territoryId)&&(identical(other.proposedName, proposedName) || other.proposedName == proposedName)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.sourceCitation, sourceCitation) || other.sourceCitation == sourceCitation)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.submittedByUserId, submittedByUserId) || other.submittedByUserId == submittedByUserId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,territoryId,proposedName,citySlug,stateCode,sourceCitation,notes,submittedByUserId,submittedAt,moderationStatus);

@override
String toString() {
  return 'TerritorySubmission(id: $id, territoryId: $territoryId, proposedName: $proposedName, citySlug: $citySlug, stateCode: $stateCode, sourceCitation: $sourceCitation, notes: $notes, submittedByUserId: $submittedByUserId, submittedAt: $submittedAt, moderationStatus: $moderationStatus)';
}


}

/// @nodoc
abstract mixin class $TerritorySubmissionCopyWith<$Res>  {
  factory $TerritorySubmissionCopyWith(TerritorySubmission value, $Res Function(TerritorySubmission) _then) = _$TerritorySubmissionCopyWithImpl;
@useResult
$Res call({
 String id, String? territoryId, String proposedName, String citySlug, String stateCode, String sourceCitation, String notes, String submittedByUserId, DateTime submittedAt, String moderationStatus
});




}
/// @nodoc
class _$TerritorySubmissionCopyWithImpl<$Res>
    implements $TerritorySubmissionCopyWith<$Res> {
  _$TerritorySubmissionCopyWithImpl(this._self, this._then);

  final TerritorySubmission _self;
  final $Res Function(TerritorySubmission) _then;

/// Create a copy of TerritorySubmission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? territoryId = freezed,Object? proposedName = null,Object? citySlug = null,Object? stateCode = null,Object? sourceCitation = null,Object? notes = null,Object? submittedByUserId = null,Object? submittedAt = null,Object? moderationStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,territoryId: freezed == territoryId ? _self.territoryId : territoryId // ignore: cast_nullable_to_non_nullable
as String?,proposedName: null == proposedName ? _self.proposedName : proposedName // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,sourceCitation: null == sourceCitation ? _self.sourceCitation : sourceCitation // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,submittedByUserId: null == submittedByUserId ? _self.submittedByUserId : submittedByUserId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,moderationStatus: null == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TerritorySubmission].
extension TerritorySubmissionPatterns on TerritorySubmission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerritorySubmission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerritorySubmission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerritorySubmission value)  $default,){
final _that = this;
switch (_that) {
case _TerritorySubmission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerritorySubmission value)?  $default,){
final _that = this;
switch (_that) {
case _TerritorySubmission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? territoryId,  String proposedName,  String citySlug,  String stateCode,  String sourceCitation,  String notes,  String submittedByUserId,  DateTime submittedAt,  String moderationStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerritorySubmission() when $default != null:
return $default(_that.id,_that.territoryId,_that.proposedName,_that.citySlug,_that.stateCode,_that.sourceCitation,_that.notes,_that.submittedByUserId,_that.submittedAt,_that.moderationStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? territoryId,  String proposedName,  String citySlug,  String stateCode,  String sourceCitation,  String notes,  String submittedByUserId,  DateTime submittedAt,  String moderationStatus)  $default,) {final _that = this;
switch (_that) {
case _TerritorySubmission():
return $default(_that.id,_that.territoryId,_that.proposedName,_that.citySlug,_that.stateCode,_that.sourceCitation,_that.notes,_that.submittedByUserId,_that.submittedAt,_that.moderationStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? territoryId,  String proposedName,  String citySlug,  String stateCode,  String sourceCitation,  String notes,  String submittedByUserId,  DateTime submittedAt,  String moderationStatus)?  $default,) {final _that = this;
switch (_that) {
case _TerritorySubmission() when $default != null:
return $default(_that.id,_that.territoryId,_that.proposedName,_that.citySlug,_that.stateCode,_that.sourceCitation,_that.notes,_that.submittedByUserId,_that.submittedAt,_that.moderationStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TerritorySubmission implements TerritorySubmission {
  const _TerritorySubmission({required this.id, this.territoryId, required this.proposedName, required this.citySlug, required this.stateCode, required this.sourceCitation, required this.notes, required this.submittedByUserId, required this.submittedAt, this.moderationStatus = 'pending_review'});
  factory _TerritorySubmission.fromJson(Map<String, dynamic> json) => _$TerritorySubmissionFromJson(json);

@override final  String id;
@override final  String? territoryId;
@override final  String proposedName;
@override final  String citySlug;
@override final  String stateCode;
@override final  String sourceCitation;
@override final  String notes;
@override final  String submittedByUserId;
@override final  DateTime submittedAt;
@override@JsonKey() final  String moderationStatus;

/// Create a copy of TerritorySubmission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerritorySubmissionCopyWith<_TerritorySubmission> get copyWith => __$TerritorySubmissionCopyWithImpl<_TerritorySubmission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerritorySubmissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerritorySubmission&&(identical(other.id, id) || other.id == id)&&(identical(other.territoryId, territoryId) || other.territoryId == territoryId)&&(identical(other.proposedName, proposedName) || other.proposedName == proposedName)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.sourceCitation, sourceCitation) || other.sourceCitation == sourceCitation)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.submittedByUserId, submittedByUserId) || other.submittedByUserId == submittedByUserId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.moderationStatus, moderationStatus) || other.moderationStatus == moderationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,territoryId,proposedName,citySlug,stateCode,sourceCitation,notes,submittedByUserId,submittedAt,moderationStatus);

@override
String toString() {
  return 'TerritorySubmission(id: $id, territoryId: $territoryId, proposedName: $proposedName, citySlug: $citySlug, stateCode: $stateCode, sourceCitation: $sourceCitation, notes: $notes, submittedByUserId: $submittedByUserId, submittedAt: $submittedAt, moderationStatus: $moderationStatus)';
}


}

/// @nodoc
abstract mixin class _$TerritorySubmissionCopyWith<$Res> implements $TerritorySubmissionCopyWith<$Res> {
  factory _$TerritorySubmissionCopyWith(_TerritorySubmission value, $Res Function(_TerritorySubmission) _then) = __$TerritorySubmissionCopyWithImpl;
@override @useResult
$Res call({
 String id, String? territoryId, String proposedName, String citySlug, String stateCode, String sourceCitation, String notes, String submittedByUserId, DateTime submittedAt, String moderationStatus
});




}
/// @nodoc
class __$TerritorySubmissionCopyWithImpl<$Res>
    implements _$TerritorySubmissionCopyWith<$Res> {
  __$TerritorySubmissionCopyWithImpl(this._self, this._then);

  final _TerritorySubmission _self;
  final $Res Function(_TerritorySubmission) _then;

/// Create a copy of TerritorySubmission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? territoryId = freezed,Object? proposedName = null,Object? citySlug = null,Object? stateCode = null,Object? sourceCitation = null,Object? notes = null,Object? submittedByUserId = null,Object? submittedAt = null,Object? moderationStatus = null,}) {
  return _then(_TerritorySubmission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,territoryId: freezed == territoryId ? _self.territoryId : territoryId // ignore: cast_nullable_to_non_nullable
as String?,proposedName: null == proposedName ? _self.proposedName : proposedName // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,sourceCitation: null == sourceCitation ? _self.sourceCitation : sourceCitation // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,submittedByUserId: null == submittedByUserId ? _self.submittedByUserId : submittedByUserId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,moderationStatus: null == moderationStatus ? _self.moderationStatus : moderationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
