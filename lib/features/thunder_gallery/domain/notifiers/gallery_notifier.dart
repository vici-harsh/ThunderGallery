// features/thunder_gallery/domain/notifiers/gallery_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';
import 'package:thundergallery/features/thunder_gallery/domain/usecases/fetch_photos_usecase.dart';

class GalleryNotifier extends StateNotifier<GalleryState> {
  final FetchPhotosUseCase fetchPhotosUseCase;

  GalleryNotifier(this.fetchPhotosUseCase) : super(const GalleryState(
    status: GalleryLoadingStatus.initial,
    photos: [],
    selectedPhotos: {},
  ));

  void clearSelection() {
    state = state.copyWith(selectedPhotos: {});
  }

  Future<void> fetchPhotos() async {
    state = state.copyWith(status: GalleryLoadingStatus.loading);
    try {
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
}