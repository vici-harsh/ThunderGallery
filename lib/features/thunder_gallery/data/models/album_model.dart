// features/thunder_gallery/data/models/album_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'album_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Album {
  final String id;
  final String name;
  final DateTime created;
  final String coverPhotoId;
  final int assetCount;

  const Album({
    required this.id,
    required this.name,
    required this.created,
    required this.coverPhotoId,
    required this.assetCount,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  @override
  String toString() {
    return 'Album(id: $id, name: $name, assetCount: $assetCount)';
  }
}