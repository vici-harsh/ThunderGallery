// features/thunder_gallery/presentation/widgets/gallery_fab.dart
import 'package:flutter/material.dart';

class GalleryFAB extends StatelessWidget {
  const GalleryFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {}, // Add your FAB action
      child: const Icon(Icons.add),
    );
  }
}