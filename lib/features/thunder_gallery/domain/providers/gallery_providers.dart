// features/thunder_gallery/domain/providers/gallery_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/data/datasources/local_photo_datasource.dart';
import 'package:thundergallery/features/thunder_gallery/data/datasources/remote_photo_datasource.dart';
import 'package:thundergallery/features/thunder_gallery/data/repositories/photo_repository_impl.dart';
import 'package:thundergallery/features/thunder_gallery/domain/notifiers/gallery_notifier.dart';
import 'package:thundergallery/features/thunder_gallery/domain/repositories/photo_repository.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';
import 'package:thundergallery/features/thunder_gallery/domain/usecases/fetch_photos_usecase.dart';


final galleryNotifierProvider = StateNotifierProvider<GalleryNotifier, GalleryState>((ref) {
  return GalleryNotifier(FetchPhotosUseCase(ref.read(photoRepositoryProvider)))
    ..loadPhotos(); // Immediately load photos
});


final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepositoryImpl(
    localDataSource: LocalPhotoDataSourceImpl(),
    remoteDataSource: FirebasePhotoDataSource(),
  );
});
