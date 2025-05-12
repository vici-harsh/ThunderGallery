// features/thunder_gallery/domain/notifiers/gallery_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';
import 'package:thundergallery/features/thunder_gallery/domain/usecases/fetch_photos_usecase.dart';

class GalleryNotifier extends StateNotifier<GalleryState> {
  final FetchPhotosUseCase fetchPhotosUseCase;

  GalleryNotifier(this.fetchPhotosUseCase) : super(const GalleryState()) {
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    try {
      state = state.copyWith(status: GalleryLoadingStatus.loading);
      final photos = await fetchPhotosUseCase.execute();
      state = state.copyWith(
        status: GalleryLoadingStatus.loaded,
        photos: photos,
      );
    } catch (e) {
      state = state.copyWith(
        status: GalleryLoadingStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void togglePhotoSelection(String photoId) {
    final newSelection = Set<String>.from(state.selectedPhotos);
    if (newSelection.contains(photoId)) {
      newSelection.remove(photoId);
    } else {
      newSelection.add(photoId);
    }
    state = state.copyWith(selectedPhotos: newSelection);
  }

  void toggleFavorite(String photoId) {
    final newFavorites = Set<String>.from(state.favoritePhotos);
    if (newFavorites.contains(photoId)) {
      newFavorites.remove(photoId);
    } else {
      newFavorites.add(photoId);
    }
    state = state.copyWith(favoritePhotos: newFavorites);
  }

  void clearSelection() {
    state = state.copyWith(selectedPhotos: const {});
  }

  Future<void> deleteSelectedPhotos() async {
    if (state.selectedPhotos.isEmpty) return;

    try {
      state = state.copyWith(status: GalleryLoadingStatus.loading);
      final remainingPhotos = state.photos.where(
              (photo) => !state.selectedPhotos.contains(photo.id)
      ).toList();

      state = state.copyWith(
        status: GalleryLoadingStatus.loaded,
        photos: remainingPhotos,
        selectedPhotos: const {},
      );
    } catch (e) {
      state = state.copyWith(
        status: GalleryLoadingStatus.error,
        errorMessage: 'Failed to delete photos: ${e.toString()}',
      );
    }
  }

  Future<void> addPhotos(List<Photo> newPhotos) async {
    try {
      state = state.copyWith(status: GalleryLoadingStatus.loading);
      state = state.copyWith(
        status: GalleryLoadingStatus.loaded,
        photos: [...state.photos, ...newPhotos],
      );
    } catch (e) {
      state = state.copyWith(
        status: GalleryLoadingStatus.error,
        errorMessage: 'Failed to add photos: ${e.toString()}',
      );
    }
  }
}