// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      content: json['content'] as String?,
      publishedAt: DateTime.parse(json['published_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'image_url': instance.imageUrl,
      'action_url': instance.actionUrl,
      'content': instance.content,
      'published_at': instance.publishedAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
