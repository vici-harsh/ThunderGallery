// features/thunder_gallery/presentation/widgets/photo_grid.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';

class PhotoGrid extends ConsumerWidget {
  const PhotoGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(galleryNotifierProvider);
    final photos = state.photos;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () {
            // Handle photo selection
          },
          child: Image.file(
            File(photo.path), // Make sure to import 'dart:io'
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}