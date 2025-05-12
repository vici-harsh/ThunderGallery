import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';

class GalleryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final int selectedCount;

  const GalleryAppBar({
    super.key,
    required this.selectedCount,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(selectedCount > 0 ? '$selectedCount selected' : 'Thunder Gallery'),
      leading: selectedCount > 0
          ? IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => ref.read(galleryNotifierProvider.notifier).clearSelection(),
      )
          : null,
      actions: [
        if (selectedCount > 0)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete photos?'),
        content: const Text('This will permanently remove selected photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(galleryNotifierProvider.notifier).deleteSelectedPhotos();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}