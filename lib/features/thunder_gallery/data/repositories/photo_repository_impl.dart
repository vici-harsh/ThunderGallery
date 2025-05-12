import 'package:flutter/foundation.dart';
import 'package:thundergallery/features/thunder_gallery/data/datasources/local_photo_datasource.dart';
import 'package:thundergallery/features/thunder_gallery/data/datasources/remote_photo_datasource.dart';
import 'package:thundergallery/features/thunder_gallery/data/models/photo_model.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final LocalPhotoDataSource localDataSource;
  final RemotePhotoDataSource remoteDataSource;

  PhotoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Photo>> fetchPhotos() async {
    try {
      debugPrint(kIsWeb ? '🖥️ Loading web photos' : '📱 Loading mobile photos');

      final localFuture = localDataSource.getDevicePhotos();
      final remoteFuture = remoteDataSource.getCloudPhotos();

      final results = await Future.wait([localFuture, remoteFuture]);

      // Cast the results to List<PhotoModel> explicitly
      final localPhotos = (results[0] as List<PhotoModel>).map((m) => m.toEntity()).toList();
      final remotePhotos = (results[1] as List<PhotoModel>).map((m) => m.toEntity()).toList();

      return [...localPhotos, ...remotePhotos];
    } catch (e) {
      debugPrint('❌ Photo load error: $e');
      try {
        // Fallback to just local
        final localPhotos = await localDataSource.getDevicePhotos();
        return (localPhotos).map((m) => m.toEntity()).toList();
      } catch (e) {
        debugPrint('❌ Fallback failed: $e');
        return [];
      }
    }
  }
}