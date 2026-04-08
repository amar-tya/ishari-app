// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppVersionModel _$AppVersionModelFromJson(Map<String, dynamic> json) =>
    _AppVersionModel(
      minVersion: json['min_version'] as String,
      latestVersion: json['latest_version'] as String,
      storeUrl: json['store_url'] as String,
      releaseNotes: json['release_notes'] as String,
    );

Map<String, dynamic> _$AppVersionModelToJson(_AppVersionModel instance) =>
    <String, dynamic>{
      'min_version': instance.minVersion,
      'latest_version': instance.latestVersion,
      'store_url': instance.storeUrl,
      'release_notes': instance.releaseNotes,
    };
