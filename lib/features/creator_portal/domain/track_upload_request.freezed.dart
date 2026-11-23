// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_upload_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackUploadRequest {

 String get artistId; String get artistName; String get title; String get genre; String get citySlug; String get cityName; String get stateCode; String get zipCode; String get audioFileName; String get audioMimeType; int get audioSizeBytes; String? get localAudioPath; String? get localCoverPath; bool get owns100Percent; String get signedName; DateTime get signedAt; String get attestationVersion;
/// Create a copy of TrackUploadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackUploadRequestCopyWith<TrackUploadRequest> get copyWith => _$TrackUploadRequestCopyWithImpl<TrackUploadRequest>(this as TrackUploadRequest, _$identity);

  /// Serializes this TrackUploadRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackUploadRequest&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.audioFileName, audioFileName) || other.audioFileName == audioFileName)&&(identical(other.audioMimeType, audioMimeType) || other.audioMimeType == audioMimeType)&&(identical(other.audioSizeBytes, audioSizeBytes) || other.audioSizeBytes == audioSizeBytes)&&(identical(other.localAudioPath, localAudioPath) || other.localAudioPath == localAudioPath)&&(identical(other.localCoverPath, localCoverPath) || other.localCoverPath == localCoverPath)&&(identical(other.owns100Percent, owns100Percent) || other.owns100Percent == owns100Percent)&&(identical(other.signedName, signedName) || other.signedName == signedName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.attestationVersion, attestationVersion) || other.attestationVersion == attestationVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artistId,artistName,title,genre,citySlug,cityName,stateCode,zipCode,audioFileName,audioMimeType,audioSizeBytes,localAudioPath,localCoverPath,owns100Percent,signedName,signedAt,attestationVersion);

@override
String toString() {
  return 'TrackUploadRequest(artistId: $artistId, artistName: $artistName, title: $title, genre: $genre, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, zipCode: $zipCode, audioFileName: $audioFileName, audioMimeType: $audioMimeType, audioSizeBytes: $audioSizeBytes, localAudioPath: $localAudioPath, localCoverPath: $localCoverPath, owns100Percent: $owns100Percent, signedName: $signedName, signedAt: $signedAt, attestationVersion: $attestationVersion)';
}


}

/// @nodoc
abstract mixin class $TrackUploadRequestCopyWith<$Res>  {
  factory $TrackUploadRequestCopyWith(TrackUploadRequest value, $Res Function(TrackUploadRequest) _then) = _$TrackUploadRequestCopyWithImpl;
@useResult
$Res call({
 String artistId, String artistName, String title, String genre, String citySlug, String cityName, String stateCode, String zipCode, String audioFileName, String audioMimeType, int audioSizeBytes, String? localAudioPath, String? localCoverPath, bool owns100Percent, String signedName, DateTime signedAt, String attestationVersion
});




}
/// @nodoc
class _$TrackUploadRequestCopyWithImpl<$Res>
    implements $TrackUploadRequestCopyWith<$Res> {
  _$TrackUploadRequestCopyWithImpl(this._self, this._then);

  final TrackUploadRequest _self;
  final $Res Function(TrackUploadRequest) _then;

/// Create a copy of TrackUploadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artistId = null,Object? artistName = null,Object? title = null,Object? genre = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? zipCode = null,Object? audioFileName = null,Object? audioMimeType = null,Object? audioSizeBytes = null,Object? localAudioPath = freezed,Object? localCoverPath = freezed,Object? owns100Percent = null,Object? signedName = null,Object? signedAt = null,Object? attestationVersion = null,}) {
  return _then(_self.copyWith(
artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,audioFileName: null == audioFileName ? _self.audioFileName : audioFileName // ignore: cast_nullable_to_non_nullable
as String,audioMimeType: null == audioMimeType ? _self.audioMimeType : audioMimeType // ignore: cast_nullable_to_non_nullable
as String,audioSizeBytes: null == audioSizeBytes ? _self.audioSizeBytes : audioSizeBytes // ignore: cast_nullable_to_non_nullable
as int,localAudioPath: freezed == localAudioPath ? _self.localAudioPath : localAudioPath // ignore: cast_nullable_to_non_nullable
as String?,localCoverPath: freezed == localCoverPath ? _self.localCoverPath : localCoverPath // ignore: cast_nullable_to_non_nullable
as String?,owns100Percent: null == owns100Percent ? _self.owns100Percent : owns100Percent // ignore: cast_nullable_to_non_nullable
as bool,signedName: null == signedName ? _self.signedName : signedName // ignore: cast_nullable_to_non_nullable
as String,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attestationVersion: null == attestationVersion ? _self.attestationVersion : attestationVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackUploadRequest].
extension TrackUploadRequestPatterns on TrackUploadRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackUploadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackUploadRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackUploadRequest value)  $default,){
final _that = this;
switch (_that) {
case _TrackUploadRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackUploadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TrackUploadRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String artistId,  String artistName,  String title,  String genre,  String citySlug,  String cityName,  String stateCode,  String zipCode,  String audioFileName,  String audioMimeType,  int audioSizeBytes,  String? localAudioPath,  String? localCoverPath,  bool owns100Percent,  String signedName,  DateTime signedAt,  String attestationVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackUploadRequest() when $default != null:
return $default(_that.artistId,_that.artistName,_that.title,_that.genre,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.audioFileName,_that.audioMimeType,_that.audioSizeBytes,_that.localAudioPath,_that.localCoverPath,_that.owns100Percent,_that.signedName,_that.signedAt,_that.attestationVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String artistId,  String artistName,  String title,  String genre,  String citySlug,  String cityName,  String stateCode,  String zipCode,  String audioFileName,  String audioMimeType,  int audioSizeBytes,  String? localAudioPath,  String? localCoverPath,  bool owns100Percent,  String signedName,  DateTime signedAt,  String attestationVersion)  $default,) {final _that = this;
switch (_that) {
case _TrackUploadRequest():
return $default(_that.artistId,_that.artistName,_that.title,_that.genre,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.audioFileName,_that.audioMimeType,_that.audioSizeBytes,_that.localAudioPath,_that.localCoverPath,_that.owns100Percent,_that.signedName,_that.signedAt,_that.attestationVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String artistId,  String artistName,  String title,  String genre,  String citySlug,  String cityName,  String stateCode,  String zipCode,  String audioFileName,  String audioMimeType,  int audioSizeBytes,  String? localAudioPath,  String? localCoverPath,  bool owns100Percent,  String signedName,  DateTime signedAt,  String attestationVersion)?  $default,) {final _that = this;
switch (_that) {
case _TrackUploadRequest() when $default != null:
return $default(_that.artistId,_that.artistName,_that.title,_that.genre,_that.citySlug,_that.cityName,_that.stateCode,_that.zipCode,_that.audioFileName,_that.audioMimeType,_that.audioSizeBytes,_that.localAudioPath,_that.localCoverPath,_that.owns100Percent,_that.signedName,_that.signedAt,_that.attestationVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackUploadRequest implements TrackUploadRequest {
  const _TrackUploadRequest({required this.artistId, required this.artistName, required this.title, required this.genre, required this.citySlug, required this.cityName, required this.stateCode, required this.zipCode, required this.audioFileName, required this.audioMimeType, required this.audioSizeBytes, this.localAudioPath, this.localCoverPath, required this.owns100Percent, required this.signedName, required this.signedAt, required this.attestationVersion});
  factory _TrackUploadRequest.fromJson(Map<String, dynamic> json) => _$TrackUploadRequestFromJson(json);

@override final  String artistId;
@override final  String artistName;
@override final  String title;
@override final  String genre;
@override final  String citySlug;
@override final  String cityName;
@override final  String stateCode;
@override final  String zipCode;
@override final  String audioFileName;
@override final  String audioMimeType;
@override final  int audioSizeBytes;
@override final  String? localAudioPath;
@override final  String? localCoverPath;
@override final  bool owns100Percent;
@override final  String signedName;
@override final  DateTime signedAt;
@override final  String attestationVersion;

/// Create a copy of TrackUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackUploadRequestCopyWith<_TrackUploadRequest> get copyWith => __$TrackUploadRequestCopyWithImpl<_TrackUploadRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackUploadRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackUploadRequest&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.title, title) || other.title == title)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.citySlug, citySlug) || other.citySlug == citySlug)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.stateCode, stateCode) || other.stateCode == stateCode)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.audioFileName, audioFileName) || other.audioFileName == audioFileName)&&(identical(other.audioMimeType, audioMimeType) || other.audioMimeType == audioMimeType)&&(identical(other.audioSizeBytes, audioSizeBytes) || other.audioSizeBytes == audioSizeBytes)&&(identical(other.localAudioPath, localAudioPath) || other.localAudioPath == localAudioPath)&&(identical(other.localCoverPath, localCoverPath) || other.localCoverPath == localCoverPath)&&(identical(other.owns100Percent, owns100Percent) || other.owns100Percent == owns100Percent)&&(identical(other.signedName, signedName) || other.signedName == signedName)&&(identical(other.signedAt, signedAt) || other.signedAt == signedAt)&&(identical(other.attestationVersion, attestationVersion) || other.attestationVersion == attestationVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artistId,artistName,title,genre,citySlug,cityName,stateCode,zipCode,audioFileName,audioMimeType,audioSizeBytes,localAudioPath,localCoverPath,owns100Percent,signedName,signedAt,attestationVersion);

@override
String toString() {
  return 'TrackUploadRequest(artistId: $artistId, artistName: $artistName, title: $title, genre: $genre, citySlug: $citySlug, cityName: $cityName, stateCode: $stateCode, zipCode: $zipCode, audioFileName: $audioFileName, audioMimeType: $audioMimeType, audioSizeBytes: $audioSizeBytes, localAudioPath: $localAudioPath, localCoverPath: $localCoverPath, owns100Percent: $owns100Percent, signedName: $signedName, signedAt: $signedAt, attestationVersion: $attestationVersion)';
}


}

/// @nodoc
abstract mixin class _$TrackUploadRequestCopyWith<$Res> implements $TrackUploadRequestCopyWith<$Res> {
  factory _$TrackUploadRequestCopyWith(_TrackUploadRequest value, $Res Function(_TrackUploadRequest) _then) = __$TrackUploadRequestCopyWithImpl;
@override @useResult
$Res call({
 String artistId, String artistName, String title, String genre, String citySlug, String cityName, String stateCode, String zipCode, String audioFileName, String audioMimeType, int audioSizeBytes, String? localAudioPath, String? localCoverPath, bool owns100Percent, String signedName, DateTime signedAt, String attestationVersion
});




}
/// @nodoc
class __$TrackUploadRequestCopyWithImpl<$Res>
    implements _$TrackUploadRequestCopyWith<$Res> {
  __$TrackUploadRequestCopyWithImpl(this._self, this._then);

  final _TrackUploadRequest _self;
  final $Res Function(_TrackUploadRequest) _then;

/// Create a copy of TrackUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artistId = null,Object? artistName = null,Object? title = null,Object? genre = null,Object? citySlug = null,Object? cityName = null,Object? stateCode = null,Object? zipCode = null,Object? audioFileName = null,Object? audioMimeType = null,Object? audioSizeBytes = null,Object? localAudioPath = freezed,Object? localCoverPath = freezed,Object? owns100Percent = null,Object? signedName = null,Object? signedAt = null,Object? attestationVersion = null,}) {
  return _then(_TrackUploadRequest(
artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,citySlug: null == citySlug ? _self.citySlug : citySlug // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,stateCode: null == stateCode ? _self.stateCode : stateCode // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,audioFileName: null == audioFileName ? _self.audioFileName : audioFileName // ignore: cast_nullable_to_non_nullable
as String,audioMimeType: null == audioMimeType ? _self.audioMimeType : audioMimeType // ignore: cast_nullable_to_non_nullable
as String,audioSizeBytes: null == audioSizeBytes ? _self.audioSizeBytes : audioSizeBytes // ignore: cast_nullable_to_non_nullable
as int,localAudioPath: freezed == localAudioPath ? _self.localAudioPath : localAudioPath // ignore: cast_nullable_to_non_nullable
as String?,localCoverPath: freezed == localCoverPath ? _self.localCoverPath : localCoverPath // ignore: cast_nullable_to_non_nullable
as String?,owns100Percent: null == owns100Percent ? _self.owns100Percent : owns100Percent // ignore: cast_nullable_to_non_nullable
as bool,signedName: null == signedName ? _self.signedName : signedName // ignore: cast_nullable_to_non_nullable
as String,signedAt: null == signedAt ? _self.signedAt : signedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attestationVersion: null == attestationVersion ? _self.attestationVersion : attestationVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
