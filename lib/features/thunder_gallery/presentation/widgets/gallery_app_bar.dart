import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/view_mode_provider.dart';

class GalleryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GalleryAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(galleryNotifierProvider
        .select((state) => state.selectedPhotos.length));
    final viewMode = ref.watch(viewModeProvider);

    return AppBar(
      title: selectedCount > 0
          ? Text('$selectedCount selected')
          : const Text('Thunder Gallery'),
      actions: [
        if (selectedCount == 0)
          IconButton(
            icon: Icon(viewMode == ViewMode.favorites
                ? Icons.photo_library
                : Icons.favorite),
            onPressed: () => ref.read(viewModeProvider.notifier).state =
            viewMode == ViewMode.favorites ? ViewMode.all : ViewMode.favorites,
          ),
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
        title: const Text('Delete selected photos?'),
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