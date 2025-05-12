// features/thunder_gallery/presentation/widgets/gallery_fab.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';

class GalleryFAB extends ConsumerWidget {
  const GalleryFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _addPhotos(context, ref),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _addPhotos(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newPhotos = result.files.map((file) => Photo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          path: file.path ?? file.name,
          created: DateTime.now(),
          size: file.size,
          metadata: {
            'source': kIsWeb ? 'web_upload' : 'mobile_upload',
            'width': 0,
            'height': 0,
          },
        )).toList();

        await ref.read(galleryNotifierProvider.notifier).addPhotos(newPhotos);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added ${result.files.length} photos')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add photos: ${e.toString()}')),
        );
      }
    }
  }
}