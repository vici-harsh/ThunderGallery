import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';

part 'photo_model.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class PhotoModel {
  final String id;
  final String path;
  @JsonKey(name: 'created_at')
  final DateTime created;
  final int size;
  @JsonKey(name: 'album_id')
  final String? albumId;
  final Map<String, dynamic> metadata;

  const PhotoModel({
    required this.id,
    required this.path,
    required this.created,
    required this.size,
    this.albumId,
    this.metadata = const {},
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);

  // Convert single PhotoModel to Photo
  Photo toPhoto() {
    return Photo(
      id: id,
      path: path,
      created: created,
      size: size,
      albumId: albumId,
      metadata: Map.from(metadata),
    );
  }

  // Convert list of PhotoModels to Photos
  static List<Photo> toPhotoList(List<PhotoModel> models) {
    return models.map((model) => model.toPhoto()).toList();
  }

  @override
  String toString() {
    return 'PhotoModel(id: $id, path: $path, created: $created, size: $size, '
        'albumId: $albumId, metadata: $metadata)';
  }

  PhotoModel copyWith({
    String? id,
    String? path,
    DateTime? created,
    int? size,
    String? albumId,
    Map<String, dynamic>? metadata,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      path: path ?? this.path,
      created: created ?? this.created,
      size: size ?? this.size,
      albumId: albumId ?? this.albumId,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }
}

// Extension for converting lists
extension PhotoModelListExtension on List<PhotoModel> {
  List<Photo> toPhotos() {
    return map((model) => model.toPhoto()).toList();
  }
}