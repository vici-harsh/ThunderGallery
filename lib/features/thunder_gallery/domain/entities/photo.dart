import 'package:meta/meta.dart';

@immutable
class Photo {
  final String id;
  final String path;
  final DateTime created;
  final int size;
  final String? albumId;
  final Map<String, dynamic> metadata;

  const Photo({
    required this.id,
    required this.path,
    required this.created,
    required this.size,
    this.albumId,
    this.metadata = const {},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Photo &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Photo(id: $id, path: $path)';
  }

  Photo copyWith({
    String? id,
    String? path,
    DateTime? created,
    int? size,
    String? albumId,
    Map<String, dynamic>? metadata,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      created: created ?? this.created,
      size: size ?? this.size,
      albumId: albumId ?? this.albumId,
      metadata: metadata ?? Map.from(this.metadata),
    );
  }
}