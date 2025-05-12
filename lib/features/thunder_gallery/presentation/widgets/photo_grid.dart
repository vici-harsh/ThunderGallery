import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';

class PhotoGrid extends ConsumerStatefulWidget {
  final List<Photo> photos;
  final bool showFavoritesOnly;
  final bool enableSelection;
  final bool enableFavorites;
  final bool sortByDate;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.showFavoritesOnly = false,
    this.enableSelection = true,
    this.enableFavorites = true,
    this.sortByDate = true,
  });

  @override
  ConsumerState<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends ConsumerState<PhotoGrid> {
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(galleryNotifierProvider);
    final notifier = ref.read(galleryNotifierProvider.notifier);

    // Filter and sort photos
    List<Photo> displayPhotos = widget.photos.where((photo) {
      return !widget.showFavoritesOnly || state.favoritePhotos.contains(photo.id);
    }).toList();

    if (widget.sortByDate) {
      displayPhotos.sort((a, b) => b.created.compareTo(a.created));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: displayPhotos.length,
      itemBuilder: (context, index) {
        final photo = displayPhotos[index];
        final isSelected = state.selectedPhotos.contains(photo.id);
        final isFavorite = state.favoritePhotos.contains(photo.id);

        return GestureDetector(
          onTap: () => _handleTap(notifier, photo),
          onLongPress: () => _handleLongPress(notifier, photo),
          child: Stack(
            children: [
              // Photo thumbnail with error handling
              _buildPhotoWidget(photo),

              // Selection overlay
              if (isSelected && widget.enableSelection)
                _buildSelectionOverlay(),

              // Favorite badge
              if (isFavorite && widget.enableFavorites)
                _buildFavoriteBadge(),

              // Date indicator
              if (widget.sortByDate)
                _buildDateIndicator(photo.created),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoWidget(Photo photo) {
    try {
      return kIsWeb
          ? Image.network(
        photo.path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      )
          : Image.file(
        File(photo.path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildSelectionOverlay() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Icon(Icons.check_circle, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildFavoriteBadge() {
    return const Positioned(
      top: 4,
      right: 4,
      child: Icon(Icons.favorite, color: Colors.red, size: 20),
    );
  }

  Widget _buildDateIndicator(DateTime date) {
    return Positioned(
      bottom: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${date.day}/${date.month}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const ColoredBox(
      color: Colors.grey,
      child: Center(
        child: Icon(Icons.broken_image, color: Colors.white, size: 40),
      ),
    );
  }

  void _handleTap(GalleryNotifier notifier, Photo photo) {
    if (_isSelectionMode || ref.read(galleryNotifierProvider).selectedPhotos.isNotEmpty) {
      notifier.togglePhotoSelection(photo.id);
      setState(() => _isSelectionMode = true);
    } else {
      context.push('/photo/${photo.id}');
    }
  }

  void _handleLongPress(GalleryNotifier notifier, Photo photo) {
    notifier.togglePhotoSelection(photo.id);
    setState(() => _isSelectionMode = true);
  }
}