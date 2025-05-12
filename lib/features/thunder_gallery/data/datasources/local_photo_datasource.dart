import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:file_picker/file_picker.dart';
import '../models/photo_model.dart';
import '../models/album_model.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocalPhotoDataSource {
  Future<List<PhotoModel>> getDevicePhotos();
  Future<List<Album>> getDeviceAlbums();
  Future<bool> requestPermission();
}

class LocalPhotoDataSourceImpl implements LocalPhotoDataSource {

  @override
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;

    try {
      if (Platform.isAndroid) {
        // For Android 13+
        if (await Permission.photos.isGranted) {
          return true;
        }

        final status = await Permission.photos.request();
        return status.isGranted;
      }
      // For iOS
      final status = await Permission.photos.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  @override
  Future<List<PhotoModel>> getDevicePhotos() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        debugPrint('Permission not granted');
        return []; // Return empty list instead of throwing
      }
      if (kIsWeb) return await _getWebPhotos();
      return await _getMobilePhotos();
    } catch (e) {
      debugPrint('Error loading photos: $e');
      return []; // Return empty list on error
    }
  }

  Future<List<PhotoModel>> _getWebPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return [];

    return result.files.map((file) => PhotoModel(
      id: file.name,
      path: file.path ?? file.name,
      created: DateTime.now(),
      size: file.size,
      metadata: {
        'source': 'web_upload',
        'width': 0,  // Web doesn't provide these
        'height': 0,
      },
    )).toList();
  }

  Future<List<PhotoModel>> _getMobilePhotos() async {
    final permitted = await requestPermission();
    if (!permitted) throw Exception('Storage permission denied');

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
        ),
        orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (albums.isEmpty) return [];

    final allPhotos = <PhotoModel>[];
    for (final album in albums) {
      final media = await album.getAssetListRange(start: 0, end: await album.assetCountAsync);
      final photos = await Future.wait(media.map((asset) async {
        final file = await asset.file;
        return PhotoModel(
          id: asset.id,
          path: file?.path ?? '',
          created: asset.createDateTime,
          size: await file?.length() ?? 0,
          albumId: album.id,
          metadata: {
            'width': asset.width,
            'height': asset.height,
            'latitude': asset.latitude,
            'longitude': asset.longitude,
            'isFavorite': asset.isFavorite,
          },
        );
      }));
      allPhotos.addAll(photos);
    }
    return allPhotos;
  }

  @override
  Future<List<Album>> getDeviceAlbums() async {
    if (kIsWeb) {
      return []; // Web doesn't have album concept
    }

    try {
      final permitted = await requestPermission();
      if (!permitted) throw Exception('Storage permission denied');

      final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      return await Future.wait(albums.map((album) async {
        final cover = await album.getAssetListRange(start: 0, end: 1);
        return Album(
          id: album.id,
          name: album.name,
          created: DateTime.now(),
          coverPhotoId: cover.isNotEmpty ? cover.first.id : '',
          assetCount: await album.assetCountAsync,
        );
      }));
    } catch (e) {
      debugPrint('Album load error: $e');
      rethrow;
    }
  }
}