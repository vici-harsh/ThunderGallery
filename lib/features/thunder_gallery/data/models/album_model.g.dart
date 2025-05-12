// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
  id: json['id'] as String,
  name: json['name'] as String,
  created: DateTime.parse(json['created'] as String),
  coverPhotoId: json['coverPhotoId'] as String,
  assetCount: (json['assetCount'] as num).toInt(),
);

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created': instance.created.toIso8601String(),
  'coverPhotoId': instance.coverPhotoId,
  'assetCount': instance.assetCount,
};
