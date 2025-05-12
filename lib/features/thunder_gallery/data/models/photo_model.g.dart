// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) => PhotoModel(
  id: json['id'] as String,
  path: json['path'] as String,
  created: DateTime.parse(json['created_at'] as String),
  size: (json['size'] as num).toInt(),
  albumId: json['album_id'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$PhotoModelToJson(PhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'created_at': instance.created.toIso8601String(),
      'size': instance.size,
      'album_id': instance.albumId,
      'metadata': instance.metadata,
    };
