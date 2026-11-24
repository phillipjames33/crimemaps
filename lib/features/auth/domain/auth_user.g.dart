// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  isArtist: json['isArtist'] as bool? ?? false,
  isPro: json['isPro'] as bool? ?? false,
  provider:
      $enumDecodeNullable(_$AuthProviderTypeEnumMap, json['provider']) ??
      AuthProviderType.email,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'isArtist': instance.isArtist,
  'isPro': instance.isPro,
  'provider': _$AuthProviderTypeEnumMap[instance.provider]!,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$AuthProviderTypeEnumMap = {
  AuthProviderType.email: 'email',
  AuthProviderType.google: 'google',
  AuthProviderType.apple: 'apple',
  AuthProviderType.demo: 'demo',
};
