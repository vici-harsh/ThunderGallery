import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
enum GalleryLoadingStatus { initial, loading, loaded, error }

@immutable
class GalleryState {
  final GalleryLoadingStatus status;
  final List<Photo> photos;
  final Set<String> selectedPhotos;
  final String? errorMessage;
  final Set<String> favoritePhotos;

  const GalleryState({
    this.status = GalleryLoadingStatus.initial,
    this.photos = const [],
    this.selectedPhotos = const {},
    this.errorMessage,
    this.favoritePhotos = const {},
  });

  GalleryState copyWith({
    GalleryLoadingStatus? status,
    List<Photo>? photos,
    Set<String>? selectedPhotos,
    String? errorMessage, required Set<String> favoritePhotos,
  }) {
    return GalleryState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryState &&
        other.status == status &&
        listEquals(other.photos, photos) &&
        setEquals(other.selectedPhotos, selectedPhotos) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return status.hashCode ^
    photos.hashCode ^
    selectedPhotos.hashCode ^
    errorMessage.hashCode;
  }
}