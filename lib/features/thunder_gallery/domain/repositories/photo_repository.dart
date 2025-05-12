// features/thunder_gallery/domain/repositories/photo_repository.dart
import '../entities/photo.dart';

abstract class PhotoRepository {
  Future<List<Photo>> fetchPhotos();  // Changed to return List<Photo>
}