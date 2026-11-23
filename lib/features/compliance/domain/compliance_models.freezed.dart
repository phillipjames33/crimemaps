// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compliance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MugshotRemovalRequest {

 String get id; String get incidentId; String get requesterName; String get requesterEmail; RemovalReason get reason; String? get caseNumber; String? get additionalNotes; DateTime get submittedAt; String get status;
/// Create a copy of MugshotRemovalRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MugshotRemovalRequestCopyWith<MugshotRemovalRequest> get copyWith => _$MugshotRemovalRequestCopyWithImpl<MugshotRemovalRequest>(this as MugshotRemovalRequest, _$identity);

  /// Serializes this MugshotRemovalRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MugshotRemovalRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.incidentId, incidentId) || other.incidentId == incidentId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.requesterEmail, requesterEmail) || other.requesterEmail == requesterEmail)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.caseNumber, caseNumber) || other.caseNumber == caseNumber)&&(identical(other.additionalNotes, additionalNotes) || other.additionalNotes == additionalNotes)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,incidentId,requesterName,requesterEmail,reason,caseNumber,additionalNotes,submittedAt,status);

@override
String toString() {
  return 'MugshotRemovalRequest(id: $id, incidentId: $incidentId, requesterName: $requesterName, requesterEmail: $requesterEmail, reason: $reason, caseNumber: $caseNumber, additionalNotes: $additionalNotes, submittedAt: $submittedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $MugshotRemovalRequestCopyWith<$Res>  {
  factory $MugshotRemovalRequestCopyWith(MugshotRemovalRequest value, $Res Function(MugshotRemovalRequest) _then) = _$MugshotRemovalRequestCopyWithImpl;
@useResult
$Res call({
 String id, String incidentId, String requesterName, String requesterEmail, RemovalReason reason, String? caseNumber, String? additionalNotes, DateTime submittedAt, String status
});




}
/// @nodoc
class _$MugshotRemovalRequestCopyWithImpl<$Res>
    implements $MugshotRemovalRequestCopyWith<$Res> {
  _$MugshotRemovalRequestCopyWithImpl(this._self, this._then);

  final MugshotRemovalRequest _self;
  final $Res Function(MugshotRemovalRequest) _then;

/// Create a copy of MugshotRemovalRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? incidentId = null,Object? requesterName = null,Object? requesterEmail = null,Object? reason = null,Object? caseNumber = freezed,Object? additionalNotes = freezed,Object? submittedAt = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,incidentId: null == incidentId ? _self.incidentId : incidentId // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,requesterEmail: null == requesterEmail ? _self.requesterEmail : requesterEmail // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RemovalReason,caseNumber: freezed == caseNumber ? _self.caseNumber : caseNumber // ignore: cast_nullable_to_non_nullable
as String?,additionalNotes: freezed == additionalNotes ? _self.additionalNotes : additionalNotes // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MugshotRemovalRequest].
extension MugshotRemovalRequestPatterns on MugshotRemovalRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MugshotRemovalRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MugshotRemovalRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MugshotRemovalRequest value)  $default,){
final _that = this;
switch (_that) {
case _MugshotRemovalRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MugshotRemovalRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MugshotRemovalRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String incidentId,  String requesterName,  String requesterEmail,  RemovalReason reason,  String? caseNumber,  String? additionalNotes,  DateTime submittedAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MugshotRemovalRequest() when $default != null:
return $default(_that.id,_that.incidentId,_that.requesterName,_that.requesterEmail,_that.reason,_that.caseNumber,_that.additionalNotes,_that.submittedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String incidentId,  String requesterName,  String requesterEmail,  RemovalReason reason,  String? caseNumber,  String? additionalNotes,  DateTime submittedAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _MugshotRemovalRequest():
return $default(_that.id,_that.incidentId,_that.requesterName,_that.requesterEmail,_that.reason,_that.caseNumber,_that.additionalNotes,_that.submittedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String incidentId,  String requesterName,  String requesterEmail,  RemovalReason reason,  String? caseNumber,  String? additionalNotes,  DateTime submittedAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _MugshotRemovalRequest() when $default != null:
return $default(_that.id,_that.incidentId,_that.requesterName,_that.requesterEmail,_that.reason,_that.caseNumber,_that.additionalNotes,_that.submittedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MugshotRemovalRequest implements MugshotRemovalRequest {
  const _MugshotRemovalRequest({required this.id, required this.incidentId, required this.requesterName, required this.requesterEmail, required this.reason, this.caseNumber, this.additionalNotes, required this.submittedAt, this.status = 'redacted_pending_verification'});
  factory _MugshotRemovalRequest.fromJson(Map<String, dynamic> json) => _$MugshotRemovalRequestFromJson(json);

@override final  String id;
@override final  String incidentId;
@override final  String requesterName;
@override final  String requesterEmail;
@override final  RemovalReason reason;
@override final  String? caseNumber;
@override final  String? additionalNotes;
@override final  DateTime submittedAt;
@override@JsonKey() final  String status;

/// Create a copy of MugshotRemovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MugshotRemovalRequestCopyWith<_MugshotRemovalRequest> get copyWith => __$MugshotRemovalRequestCopyWithImpl<_MugshotRemovalRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MugshotRemovalRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MugshotRemovalRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.incidentId, incidentId) || other.incidentId == incidentId)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.requesterEmail, requesterEmail) || other.requesterEmail == requesterEmail)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.caseNumber, caseNumber) || other.caseNumber == caseNumber)&&(identical(other.additionalNotes, additionalNotes) || other.additionalNotes == additionalNotes)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,incidentId,requesterName,requesterEmail,reason,caseNumber,additionalNotes,submittedAt,status);

@override
String toString() {
  return 'MugshotRemovalRequest(id: $id, incidentId: $incidentId, requesterName: $requesterName, requesterEmail: $requesterEmail, reason: $reason, caseNumber: $caseNumber, additionalNotes: $additionalNotes, submittedAt: $submittedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MugshotRemovalRequestCopyWith<$Res> implements $MugshotRemovalRequestCopyWith<$Res> {
  factory _$MugshotRemovalRequestCopyWith(_MugshotRemovalRequest value, $Res Function(_MugshotRemovalRequest) _then) = __$MugshotRemovalRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String incidentId, String requesterName, String requesterEmail, RemovalReason reason, String? caseNumber, String? additionalNotes, DateTime submittedAt, String status
});




}
/// @nodoc
class __$MugshotRemovalRequestCopyWithImpl<$Res>
    implements _$MugshotRemovalRequestCopyWith<$Res> {
  __$MugshotRemovalRequestCopyWithImpl(this._self, this._then);

  final _MugshotRemovalRequest _self;
  final $Res Function(_MugshotRemovalRequest) _then;

/// Create a copy of MugshotRemovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? incidentId = null,Object? requesterName = null,Object? requesterEmail = null,Object? reason = null,Object? caseNumber = freezed,Object? additionalNotes = freezed,Object? submittedAt = null,Object? status = null,}) {
  return _then(_MugshotRemovalRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,incidentId: null == incidentId ? _self.incidentId : incidentId // ignore: cast_nullable_to_non_nullable
as String,requesterName: null == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String,requesterEmail: null == requesterEmail ? _self.requesterEmail : requesterEmail // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as RemovalReason,caseNumber: freezed == caseNumber ? _self.caseNumber : caseNumber // ignore: cast_nullable_to_non_nullable
as String?,additionalNotes: freezed == additionalNotes ? _self.additionalNotes : additionalNotes // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DmcaClaim {

 String get id; String get trackId; String get trackTitle; String get claimantName; String get claimantEmail; String get copyrightedWorkDescription; bool get goodFaithBeliefConfirmed; bool get perjuryStatementConfirmed; String get electronicSignature; DateTime get submittedAt; String get status;
/// Create a copy of DmcaClaim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DmcaClaimCopyWith<DmcaClaim> get copyWith => _$DmcaClaimCopyWithImpl<DmcaClaim>(this as DmcaClaim, _$identity);

  /// Serializes this DmcaClaim to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DmcaClaim&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackTitle, trackTitle) || other.trackTitle == trackTitle)&&(identical(other.claimantName, claimantName) || other.claimantName == claimantName)&&(identical(other.claimantEmail, claimantEmail) || other.claimantEmail == claimantEmail)&&(identical(other.copyrightedWorkDescription, copyrightedWorkDescription) || other.copyrightedWorkDescription == copyrightedWorkDescription)&&(identical(other.goodFaithBeliefConfirmed, goodFaithBeliefConfirmed) || other.goodFaithBeliefConfirmed == goodFaithBeliefConfirmed)&&(identical(other.perjuryStatementConfirmed, perjuryStatementConfirmed) || other.perjuryStatementConfirmed == perjuryStatementConfirmed)&&(identical(other.electronicSignature, electronicSignature) || other.electronicSignature == electronicSignature)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,trackTitle,claimantName,claimantEmail,copyrightedWorkDescription,goodFaithBeliefConfirmed,perjuryStatementConfirmed,electronicSignature,submittedAt,status);

@override
String toString() {
  return 'DmcaClaim(id: $id, trackId: $trackId, trackTitle: $trackTitle, claimantName: $claimantName, claimantEmail: $claimantEmail, copyrightedWorkDescription: $copyrightedWorkDescription, goodFaithBeliefConfirmed: $goodFaithBeliefConfirmed, perjuryStatementConfirmed: $perjuryStatementConfirmed, electronicSignature: $electronicSignature, submittedAt: $submittedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $DmcaClaimCopyWith<$Res>  {
  factory $DmcaClaimCopyWith(DmcaClaim value, $Res Function(DmcaClaim) _then) = _$DmcaClaimCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String trackTitle, String claimantName, String claimantEmail, String copyrightedWorkDescription, bool goodFaithBeliefConfirmed, bool perjuryStatementConfirmed, String electronicSignature, DateTime submittedAt, String status
});




}
/// @nodoc
class _$DmcaClaimCopyWithImpl<$Res>
    implements $DmcaClaimCopyWith<$Res> {
  _$DmcaClaimCopyWithImpl(this._self, this._then);

  final DmcaClaim _self;
  final $Res Function(DmcaClaim) _then;

/// Create a copy of DmcaClaim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackId = null,Object? trackTitle = null,Object? claimantName = null,Object? claimantEmail = null,Object? copyrightedWorkDescription = null,Object? goodFaithBeliefConfirmed = null,Object? perjuryStatementConfirmed = null,Object? electronicSignature = null,Object? submittedAt = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,trackTitle: null == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String,claimantName: null == claimantName ? _self.claimantName : claimantName // ignore: cast_nullable_to_non_nullable
as String,claimantEmail: null == claimantEmail ? _self.claimantEmail : claimantEmail // ignore: cast_nullable_to_non_nullable
as String,copyrightedWorkDescription: null == copyrightedWorkDescription ? _self.copyrightedWorkDescription : copyrightedWorkDescription // ignore: cast_nullable_to_non_nullable
as String,goodFaithBeliefConfirmed: null == goodFaithBeliefConfirmed ? _self.goodFaithBeliefConfirmed : goodFaithBeliefConfirmed // ignore: cast_nullable_to_non_nullable
as bool,perjuryStatementConfirmed: null == perjuryStatementConfirmed ? _self.perjuryStatementConfirmed : perjuryStatementConfirmed // ignore: cast_nullable_to_non_nullable
as bool,electronicSignature: null == electronicSignature ? _self.electronicSignature : electronicSignature // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DmcaClaim].
extension DmcaClaimPatterns on DmcaClaim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DmcaClaim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DmcaClaim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DmcaClaim value)  $default,){
final _that = this;
switch (_that) {
case _DmcaClaim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DmcaClaim value)?  $default,){
final _that = this;
switch (_that) {
case _DmcaClaim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String trackId,  String trackTitle,  String claimantName,  String claimantEmail,  String copyrightedWorkDescription,  bool goodFaithBeliefConfirmed,  bool perjuryStatementConfirmed,  String electronicSignature,  DateTime submittedAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DmcaClaim() when $default != null:
return $default(_that.id,_that.trackId,_that.trackTitle,_that.claimantName,_that.claimantEmail,_that.copyrightedWorkDescription,_that.goodFaithBeliefConfirmed,_that.perjuryStatementConfirmed,_that.electronicSignature,_that.submittedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String trackId,  String trackTitle,  String claimantName,  String claimantEmail,  String copyrightedWorkDescription,  bool goodFaithBeliefConfirmed,  bool perjuryStatementConfirmed,  String electronicSignature,  DateTime submittedAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _DmcaClaim():
return $default(_that.id,_that.trackId,_that.trackTitle,_that.claimantName,_that.claimantEmail,_that.copyrightedWorkDescription,_that.goodFaithBeliefConfirmed,_that.perjuryStatementConfirmed,_that.electronicSignature,_that.submittedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String trackId,  String trackTitle,  String claimantName,  String claimantEmail,  String copyrightedWorkDescription,  bool goodFaithBeliefConfirmed,  bool perjuryStatementConfirmed,  String electronicSignature,  DateTime submittedAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _DmcaClaim() when $default != null:
return $default(_that.id,_that.trackId,_that.trackTitle,_that.claimantName,_that.claimantEmail,_that.copyrightedWorkDescription,_that.goodFaithBeliefConfirmed,_that.perjuryStatementConfirmed,_that.electronicSignature,_that.submittedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DmcaClaim implements DmcaClaim {
  const _DmcaClaim({required this.id, required this.trackId, required this.trackTitle, required this.claimantName, required this.claimantEmail, required this.copyrightedWorkDescription, required this.goodFaithBeliefConfirmed, required this.perjuryStatementConfirmed, required this.electronicSignature, required this.submittedAt, this.status = 'track_soft_hidden'});
  factory _DmcaClaim.fromJson(Map<String, dynamic> json) => _$DmcaClaimFromJson(json);

@override final  String id;
@override final  String trackId;
@override final  String trackTitle;
@override final  String claimantName;
@override final  String claimantEmail;
@override final  String copyrightedWorkDescription;
@override final  bool goodFaithBeliefConfirmed;
@override final  bool perjuryStatementConfirmed;
@override final  String electronicSignature;
@override final  DateTime submittedAt;
@override@JsonKey() final  String status;

/// Create a copy of DmcaClaim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DmcaClaimCopyWith<_DmcaClaim> get copyWith => __$DmcaClaimCopyWithImpl<_DmcaClaim>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DmcaClaimToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DmcaClaim&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackTitle, trackTitle) || other.trackTitle == trackTitle)&&(identical(other.claimantName, claimantName) || other.claimantName == claimantName)&&(identical(other.claimantEmail, claimantEmail) || other.claimantEmail == claimantEmail)&&(identical(other.copyrightedWorkDescription, copyrightedWorkDescription) || other.copyrightedWorkDescription == copyrightedWorkDescription)&&(identical(other.goodFaithBeliefConfirmed, goodFaithBeliefConfirmed) || other.goodFaithBeliefConfirmed == goodFaithBeliefConfirmed)&&(identical(other.perjuryStatementConfirmed, perjuryStatementConfirmed) || other.perjuryStatementConfirmed == perjuryStatementConfirmed)&&(identical(other.electronicSignature, electronicSignature) || other.electronicSignature == electronicSignature)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,trackTitle,claimantName,claimantEmail,copyrightedWorkDescription,goodFaithBeliefConfirmed,perjuryStatementConfirmed,electronicSignature,submittedAt,status);

@override
String toString() {
  return 'DmcaClaim(id: $id, trackId: $trackId, trackTitle: $trackTitle, claimantName: $claimantName, claimantEmail: $claimantEmail, copyrightedWorkDescription: $copyrightedWorkDescription, goodFaithBeliefConfirmed: $goodFaithBeliefConfirmed, perjuryStatementConfirmed: $perjuryStatementConfirmed, electronicSignature: $electronicSignature, submittedAt: $submittedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$DmcaClaimCopyWith<$Res> implements $DmcaClaimCopyWith<$Res> {
  factory _$DmcaClaimCopyWith(_DmcaClaim value, $Res Function(_DmcaClaim) _then) = __$DmcaClaimCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String trackTitle, String claimantName, String claimantEmail, String copyrightedWorkDescription, bool goodFaithBeliefConfirmed, bool perjuryStatementConfirmed, String electronicSignature, DateTime submittedAt, String status
});




}
/// @nodoc
class __$DmcaClaimCopyWithImpl<$Res>
    implements _$DmcaClaimCopyWith<$Res> {
  __$DmcaClaimCopyWithImpl(this._self, this._then);

  final _DmcaClaim _self;
  final $Res Function(_DmcaClaim) _then;

/// Create a copy of DmcaClaim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? trackTitle = null,Object? claimantName = null,Object? claimantEmail = null,Object? copyrightedWorkDescription = null,Object? goodFaithBeliefConfirmed = null,Object? perjuryStatementConfirmed = null,Object? electronicSignature = null,Object? submittedAt = null,Object? status = null,}) {
  return _then(_DmcaClaim(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,trackTitle: null == trackTitle ? _self.trackTitle : trackTitle // ignore: cast_nullable_to_non_nullable
as String,claimantName: null == claimantName ? _self.claimantName : claimantName // ignore: cast_nullable_to_non_nullable
as String,claimantEmail: null == claimantEmail ? _self.claimantEmail : claimantEmail // ignore: cast_nullable_to_non_nullable
as String,copyrightedWorkDescription: null == copyrightedWorkDescription ? _self.copyrightedWorkDescription : copyrightedWorkDescription // ignore: cast_nullable_to_non_nullable
as String,goodFaithBeliefConfirmed: null == goodFaithBeliefConfirmed ? _self.goodFaithBeliefConfirmed : goodFaithBeliefConfirmed // ignore: cast_nullable_to_non_nullable
as bool,perjuryStatementConfirmed: null == perjuryStatementConfirmed ? _self.perjuryStatementConfirmed : perjuryStatementConfirmed // ignore: cast_nullable_to_non_nullable
as bool,electronicSignature: null == electronicSignature ? _self.electronicSignature : electronicSignature // ignore: cast_nullable_to_non_nullable
as String,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
