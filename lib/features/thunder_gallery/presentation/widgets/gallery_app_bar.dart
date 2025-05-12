import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';

class GalleryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GalleryAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(galleryNotifierProvider
        .select((state) => state.selectedPhotos.length));

    return AppBar(
      title: selectedCount > 0
          ? Text('$selectedCount selected')
          : const Text('Thunder Gallery'),
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
            onPressed: () => _confirmDelete(context, ref),
          ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete selected?'),
        content: const Text('This will permanently remove selected photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(galleryNotifierProvider.notifier).deleteSelectedPhotos();
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}