import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/view_mode_provider.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/gallery_app_bar.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/widgets/photo_grid.dart';

class ThunderGalleryScreen extends ConsumerWidget {
  const ThunderGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(galleryNotifierProvider);
    final viewMode = ref.watch(viewModeProvider);

    return Scaffold(
      appBar: const GalleryAppBar(),
      body: _buildContent(state, viewMode),
    );
  }

  Widget _buildContent(GalleryState state, ViewMode viewMode) {
    switch (state.status) {
      case GalleryLoadingStatus.initial:
        return const Center(child: CircularProgressIndicator());
      case GalleryLoadingStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case GalleryLoadingStatus.error:
        return Center(child: Text(state.errorMessage ?? 'Error loading photos'));
      case GalleryLoadingStatus.loaded:
        return PhotoGrid(
          photos: state.photos,
          showFavoritesOnly: viewMode == ViewMode.favorites,
        );
    }
  }
}