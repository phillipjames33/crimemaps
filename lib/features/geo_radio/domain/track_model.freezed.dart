// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RightsWarranty {

 bool get owns100Percent; String get signedName; DateTime get signedAt; String get version;
/// Create a copy of RightsWarranty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RightsWarrantyCopyWith<RightsWarranty> get copyWith => _$RightsWarrantyCopyWithImpl<RightsWarranty>(this as RightsWarranty, _$identity);

  /// Serializes this RightsWarranty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RightsWarranty&&(identical(other.owns100Percent, owns100Percent) || other.owns100Percent == owns100Percent)&&(identical(other.signedName, signedName) || other.signedName == signedName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owns100Percent,signedName,signedAt,version);

@override
String toString() {
  return 'RightsWarranty(owns100Percent: $owns100Percent, signedName: $signedName, signedAt: $signedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $RightsWarrantyCopyWith<$Res>  {
  factory $RightsWarrantyCopyWith(RightsWarranty value, $Res Function(RightsWarranty) _then) = _$RightsWarrantyCopyWithImpl;
@useResult
$Res call({
 bool owns100Percent, String signedName, DateTime signedAt, String version
});




}
/// @nodoc
class _$RightsWarrantyCopyWithImpl<$Res>
    implements $RightsWarrantyCopyWith<$Res> {
  _$RightsWarrantyCopyWithImpl(this._self, this._then);

  final RightsWarranty _self;
  final $Res Function(RightsWarranty) _then;

/// Create a copy of RightsWarranty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owns100Percent = null,Object? signedName = null,Object? signedAt = null,Object? version = null,}) {
  return _then(_self.copyWith(
owns100Percent: null == owns100Percent ? _self.owns100Percent : owns100Percent // ignore: cast_nullable_to_non_nullable
as bool,signedName: null == signedName ? _self.signedName : signedName // ignore: cast_nullable_to_non_nullable
as String,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RightsWarranty].
extension RightsWarrantyPatterns on RightsWarranty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RightsWarranty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RightsWarranty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RightsWarranty value)  $default,){
final _that = this;
switch (_that) {
case _RightsWarranty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RightsWarranty value)?  $default,){
final _that = this;
switch (_that) {
case _RightsWarranty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool owns100Percent,  String signedName,  DateTime signedAt,  String version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RightsWarranty() when $default != null:
return $default(_that.owns100Percent,_that.signedName,_that.signedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool owns100Percent,  String signedName,  DateTime signedAt,  String version)  $default,) {final _that = this;
switch (_that) {
case _RightsWarranty():
return $default(_that.owns100Percent,_that.signedName,_that.signedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool owns100Percent,  String signedName,  DateTime signedAt,  String version)?  $default,) {final _that = this;
switch (_that) {
case _RightsWarranty() when $default != null:
return $default(_that.owns100Percent,_that.signedName,_that.signedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RightsWarranty implements RightsWarranty {
  const _RightsWarranty({required this.owns100Percent, required this.signedName, required this.signedAt, required this.version});
  factory _RightsWarranty.fromJson(Map<String, dynamic> json) => _$RightsWarrantyFromJson(json);

@override final  bool owns100Percent;
@override final  String signedName;
@override final  DateTime signedAt;
@override final  String version;

/// Create a copy of RightsWarranty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RightsWarrantyCopyWith<_RightsWarranty> get copyWith => __$RightsWarrantyCopyWithImpl<_RightsWarranty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RightsWarrantyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RightsWarranty&&(identical(other.owns100Percent, owns100Percent) || other.owns100Percent == owns100Percent)&&(identical(other.signedName, signedName) || other.signedName == signedName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owns100Percent,signedName,signedAt,version);

@override
String toString() {
  return 'RightsWarranty(owns100Percent: $owns100Percent, signedName: $signedName, signedAt: $signedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$RightsWarrantyCopyWith<$Res> implements $RightsWarrantyCopyWith<$Res> {
  factory _$RightsWarrantyCopyWith(_RightsWarranty value, $Res Function(_RightsWarranty) _then) = __$RightsWarrantyCopyWithImpl;
@override @useResult
$Res call({
 bool owns100Percent, String signedName, DateTime signedAt, String version
});




}
/// @nodoc
class __$RightsWarrantyCopyWithImpl<$Res>
    implements _$RightsWarrantyCopyWith<$Res> {
  __$RightsWarrantyCopyWithImpl(this._self, this._then);

  final _RightsWarranty _self;
  final $Res Function(_RightsWarranty) _then;

/// Create a copy of RightsWarranty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owns100Percent = null,Object? signedName = null,Object? signedAt = null,Object? version = null,}) {
  return _then(_RightsWarranty(
owns100Percent: null == owns100Percent ? _self.owns100Percent : owns100Percent // ignore: cast_nullable_to_non_nullable
as bool,signedName: null == signedName ? _self.signedName : signedName // ignore: cast_nullable_to_non_nullable
as String,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$IndieTrack {

 String get id; String get artistId; String get artistName; String get title; String get genre; String get audioUrl; String get coverArtUrl; int get durationSec; String get citySlug; String get cityName; String get stateCode; String get zipCode; DateTime? get boostedUntil; String? get boostTargetZip; RightsWarranty get rightsWarranty; TrackStatus get status; int get playCount; int get likeCount;
/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndieTrackCopyWith<IndieTrack> get copyWith => _$IndieTrackCopyWithImpl<IndieTrack>(this as IndieTrack, _$identity);

  /// Serializes this IndieTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndieTrack&&(identical(other.id, id) || other.id == id)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.coverArtUrl, coverArtUrl) || other.coverArtUrl == coverArtUrl)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.boostedUntil, boostedUntil) || other.boostedUntil == boostedUntil)&&(identical(other.boostTargetZip, boostTargetZip) || other.boostTargetZip == boostTargetZip)&&(identical(other.rightsWarranty, rightsWarranty) || other.rightsWarranty == rightsWarranty)&&(identical(other.status, status) || other.status == status)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,artistId,artistName,title,genre,audioUrl,coverArtUrl,durationSec,citySlug,cityName,stateCode,zipCode,boostedUntil,boostTargetZip,rightsWarranty,status,playCount,likeCount);

@override
String toString() {
  return 'IndieTrack(id: $id, artistId: $artistId, artistName: $artistName, title: $title, genre: $genre, audioUrl: $audioUrl, coverArtUrl: $coverArtUrl, durationSec: $durationSec, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, zipCode: $zipCode, boostedUntil: $boostedUntil, boostTargetZip: $boostTargetZip, rightsWarranty: $rightsWarranty, status: $status, playCount: $playCount, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class $IndieTrackCopyWith<$Res>  {
  factory $IndieTrackCopyWith(IndieTrack value, $Res Function(IndieTrack) _then) = _$IndieTrackCopyWithImpl;
@useResult
$Res call({
 String id, String artistId, String artistName, String title, String genre, String audioUrl, String coverArtUrl, int durationSec, String citySlug, String cityName, String stateCode, String zipCode, DateTime? boostedUntil, String? boostTargetZip, RightsWarranty rightsWarranty, TrackStatus status, int playCount, int likeCount
});


$RightsWarrantyCopyWith<$Res> get rightsWarranty;

}
/// @nodoc
class _$IndieTrackCopyWithImpl<$Res>
    implements $IndieTrackCopyWith<$Res> {
  _$IndieTrackCopyWithImpl(this._self, this._then);

  final IndieTrack _self;
  final $Res Function(IndieTrack) _then;

/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? artistId = null,Object? artistName = null,Object? title = null,Object? genre = null,Object? audioUrl = null,Object? coverArtUrl = null,Object? durationSec = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? zipCode = null,Object? boostedUntil = freezed,Object? boostTargetZip = freezed,Object? rightsWarranty = null,Object? status = null,Object? playCount = null,Object? likeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,coverArtUrl: null == coverArtUrl ? _self.coverArtUrl : coverArtUrl // ignore: cast_nullable_to_non_nullable
as String,durationSec: null == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,boostedUntil: freezed == boostedUntil ? _self.boostedUntil : boostedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,boostTargetZip: freezed == boostTargetZip ? _self.boostTargetZip : boostTargetZip // ignore: cast_nullable_to_non_nullable
as String?,rightsWarranty: null == rightsWarranty ? _self.rightsWarranty : rightsWarranty // ignore: cast_nullable_to_non_nullable
as RightsWarranty,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackStatus,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RightsWarrantyCopyWith<$Res> get rightsWarranty {
  
  return $RightsWarrantyCopyWith<$Res>(_self.rightsWarranty, (value) {
    return _then(_self.copyWith(rightsWarranty: value));
  });
}
}


/// Adds pattern-matching-related methods to [IndieTrack].
extension IndieTrackPatterns on IndieTrack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndieTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndieTrack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndieTrack value)  $default,){
final _that = this;
switch (_that) {
case _IndieTrack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndieTrack value)?  $default,){
final _that = this;
switch (_that) {
case _IndieTrack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String artistId,  String artistName,  String title,  String genre,  String audioUrl,  String coverArtUrl,  int durationSec,  String citySlug,  String cityName,  String stateCode,  String zipCode,  DateTime? boostedUntil,  String? boostTargetZip,  RightsWarranty rightsWarranty,  TrackStatus status,  int playCount,  int likeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndieTrack() when $default != null:
return $default(_that.id,_that.artistId,_that.artistName,_that.title,_that.genre,_that.audioUrl,_that.coverArtUrl,_that.durationSec,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.boostedUntil,_that.boostTargetZip,_that.rightsWarranty,_that.status,_that.playCount,_that.likeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String artistId,  String artistName,  String title,  String genre,  String audioUrl,  String coverArtUrl,  int durationSec,  String citySlug,  String cityName,  String stateCode,  String zipCode,  DateTime? boostedUntil,  String? boostTargetZip,  RightsWarranty rightsWarranty,  TrackStatus status,  int playCount,  int likeCount)  $default,) {final _that = this;
switch (_that) {
case _IndieTrack():
return $default(_that.id,_that.artistId,_that.artistName,_that.title,_that.genre,_that.audioUrl,_that.coverArtUrl,_that.durationSec,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.boostedUntil,_that.boostTargetZip,_that.rightsWarranty,_that.status,_that.playCount,_that.likeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String artistId,  String artistName,  String title,  String genre,  String audioUrl,  String coverArtUrl,  int durationSec,  String citySlug,  String cityName,  String stateCode,  String zipCode,  DateTime? boostedUntil,  String? boostTargetZip,  RightsWarranty rightsWarranty,  TrackStatus status,  int playCount,  int likeCount)?  $default,) {final _that = this;
switch (_that) {
case _IndieTrack() when $default != null:
return $default(_that.id,_that.artistId,_that.artistName,_that.title,_that.genre,_that.audioUrl,_that.coverArtUrl,_that.durationSec,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.boostedUntil,_that.boostTargetZip,_that.rightsWarranty,_that.status,_that.playCount,_that.likeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndieTrack implements IndieTrack {
  const _IndieTrack({required this.id, required this.artistId, required this.artistName, required this.title, required this.genre, required this.audioUrl, required this.coverArtUrl, required this.durationSec, required this.citySlug, required this.cityName, required this.stateCode, required this.zipCode, this.boostedUntil, this.boostTargetZip, required this.rightsWarranty, this.status = TrackStatus.active, this.playCount = 0, this.likeCount = 0});
  factory _IndieTrack.fromJson(Map<String, dynamic> json) => _$IndieTrackFromJson(json);

@override final  String id;
@override final  String artistId;
@override final  String artistName;
@override final  String title;
@override final  String genre;
@override final  String audioUrl;
@override final  String coverArtUrl;
@override final  int durationSec;
@override final  String citySlug;
@override final  String cityName;
@override final  String stateCode;
@override final  String zipCode;
@override final  DateTime? boostedUntil;
@override final  String? boostTargetZip;
@override final  RightsWarranty rightsWarranty;
@override@JsonKey() final  TrackStatus status;
@override@JsonKey() final  int playCount;
@override@JsonKey() final  int likeCount;

/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndieTrackCopyWith<_IndieTrack> get copyWith => __$IndieTrackCopyWithImpl<_IndieTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndieTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndieTrack&&(identical(other.id, id) || other.id == id)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.coverArtUrl, coverArtUrl) || other.coverArtUrl == coverArtUrl)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.boostedUntil, boostedUntil) || other.boostedUntil == boostedUntil)&&(identical(other.boostTargetZip, boostTargetZip) || other.boostTargetZip == boostTargetZip)&&(identical(other.rightsWarranty, rightsWarranty) || other.rightsWarranty == rightsWarranty)&&(identical(other.status, status) || other.status == status)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,artistId,artistName,title,genre,audioUrl,coverArtUrl,durationSec,citySlug,cityName,stateCode,zipCode,boostedUntil,boostTargetZip,rightsWarranty,status,playCount,likeCount);

@override
String toString() {
  return 'IndieTrack(id: $id, artistId: $artistId, artistName: $artistName, title: $title, genre: $genre, audioUrl: $audioUrl, coverArtUrl: $coverArtUrl, durationSec: $durationSec, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, zipCode: $zipCode, boostedUntil: $boostedUntil, boostTargetZip: $boostTargetZip, rightsWarranty: $rightsWarranty, status: $status, playCount: $playCount, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class _$IndieTrackCopyWith<$Res> implements $IndieTrackCopyWith<$Res> {
  factory _$IndieTrackCopyWith(_IndieTrack value, $Res Function(_IndieTrack) _then) = __$IndieTrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String artistId, String artistName, String title, String genre, String audioUrl, String coverArtUrl, int durationSec, String citySlug, String cityName, String stateCode, String zipCode, DateTime? boostedUntil, String? boostTargetZip, RightsWarranty rightsWarranty, TrackStatus status, int playCount, int likeCount
});


@override $RightsWarrantyCopyWith<$Res> get rightsWarranty;

}
/// @nodoc
class __$IndieTrackCopyWithImpl<$Res>
    implements _$IndieTrackCopyWith<$Res> {
  __$IndieTrackCopyWithImpl(this._self, this._then);

  final _IndieTrack _self;
  final $Res Function(_IndieTrack) _then;

/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? artistId = null,Object? artistName = null,Object? title = null,Object? genre = null,Object? audioUrl = null,Object? coverArtUrl = null,Object? durationSec = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? zipCode = null,Object? boostedUntil = freezed,Object? boostTargetZip = freezed,Object? rightsWarranty = null,Object? status = null,Object? playCount = null,Object? likeCount = null,}) {
  return _then(_IndieTrack(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,coverArtUrl: null == coverArtUrl ? _self.coverArtUrl : coverArtUrl // ignore: cast_nullable_to_non_nullable
as String,durationSec: null == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,boostedUntil: freezed == boostedUntil ? _self.boostedUntil : boostedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,boostTargetZip: freezed == boostTargetZip ? _self.boostTargetZip : boostTargetZip // ignore: cast_nullable_to_non_nullable
as String?,rightsWarranty: null == rightsWarranty ? _self.rightsWarranty : rightsWarranty // ignore: cast_nullable_to_non_nullable
as RightsWarranty,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TrackStatus,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of IndieTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RightsWarrantyCopyWith<$Res> get rightsWarranty {
  
  return $RightsWarrantyCopyWith<$Res>(_self.rightsWarranty, (value) {
    return _then(_self.copyWith(rightsWarranty: value));
  });
}
}

// dart format on
