// features/thunder_gallery/domain/usecases/fetch_photos_usecase.dart
import 'package:flutter/cupertino.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/repositories/photo_repository.dart';

class FetchPhotosUseCase {
  final PhotoRepository repository;

  FetchPhotosUseCase(this.repository);

  Future<List<Photo>> execute() async {
    try {
      final photos = await repository.fetchPhotos();
      return photos; // Don't throw if empty
    } catch (e) {
      debugPrint('UseCase error: $e');
      return []; // Return empty list instead of rethrowing
    }
  }
}