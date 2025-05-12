// features/thunder_gallery/data/datasources/remote_photo_datasource.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import '../models/photo_model.dart';

abstract class RemotePhotoDataSource {
  Future<List<Photo>> getCloudPhotos();
  Future<String> getDownloadUrl(String path);
}

class FirebasePhotoDataSource implements RemotePhotoDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Photo>> getCloudPhotos() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('photos')
          .orderBy('created_at', descending: true)
          .get();

      return await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return Photo(
          id: doc.id,
          path: await getDownloadUrl(data['storage_path']),
          created: (data['created_at'] as Timestamp).toDate(),
          size: data['size'] ?? 0,
          albumId: data['album_id'],
          metadata: {
            'uploaded_by': data['uploaded_by'],
            'content_type': data['content_type'],
          },
        );
      }));
    } catch (e) {
      throw Exception('Failed to load cloud photos: ${e.toString()}');
    }
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: ${e.toString()}');
    }
  }
}