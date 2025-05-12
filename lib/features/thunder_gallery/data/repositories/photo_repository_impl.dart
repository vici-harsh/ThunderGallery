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
      final local = await localDataSource.getDevicePhotos();
      final remote = await remoteDataSource.getCloudPhotos().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Firestore timeout');
          return <Photo>[];
        },
      );

      return [
        ...local.map((m) => m.toPhoto()),
        ...remote,
      ];
    } catch (e, stackTrace) {
      debugPrint('Error loading photos: $e\n$stackTrace');
      return [];
    }
  }
}