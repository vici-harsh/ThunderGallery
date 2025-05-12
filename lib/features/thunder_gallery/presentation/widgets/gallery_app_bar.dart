// features/thunder_gallery/presentation/widgets/gallery_app_bar.dart
import 'package:flutter/material.dart';

class GalleryAppBar extends AppBar {
  GalleryAppBar({
    super.key,
    required int selectedCount,
    required VoidCallback onSelectionCancel,
  }) : super(
    title: Text('$selectedCount selected'),
    leading: IconButton(
      icon: const Icon(Icons.close),
      onPressed: onSelectionCancel,
    ),
    actions: [
      if (selectedCount > 0)
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {}, // Add delete functionality
        ),
    ],
  );
}