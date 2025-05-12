import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/photo_grid.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/gallery_app_bar.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/gallery_fab.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/error_view.dart';

class ThunderGalleryScreen extends ConsumerWidget {
  const ThunderGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(galleryNotifierProvider);

    return Scaffold(
      appBar: GalleryAppBar(
        selectedCount: state.selectedPhotos.length,
        onSelectionCancel: () => ref.read(galleryNotifierProvider.notifier)
            .clearSelection(),
      ),
      body: _buildContent(state),
      floatingActionButton: const GalleryFAB(),
    );
  }

  Widget _buildContent(GalleryState state) {
    switch (state.status) {
      case GalleryLoadingStatus.initial:
      case GalleryLoadingStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case GalleryLoadingStatus.error:
        return ErrorView(message: state.errorMessage ?? 'An error occurred');
      case GalleryLoadingStatus.loaded:
        return const PhotoGrid();
    }
  }
}