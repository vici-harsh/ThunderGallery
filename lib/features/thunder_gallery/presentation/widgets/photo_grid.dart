import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';
import 'package:thundergallery/features/thunder_gallery/domain/notifiers/gallery_notifier.dart';
import 'package:thundergallery/features/thunder_gallery/domain/providers/gallery_providers.dart';
import 'package:thundergallery/features/thunder_gallery/domain/state/gallery_state.dart';

class PhotoGrid extends ConsumerStatefulWidget {
  final List<Photo> photos;
  final bool showFavoritesOnly;
  final bool enableSelection;
  final bool enableFavorites;
  final bool sortByDate;
  final bool showDates;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.showFavoritesOnly = false,
    this.enableSelection = true,
    this.enableFavorites = true,
    this.sortByDate = true,
    this.showDates = true,
  });

  @override
  ConsumerState<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends ConsumerState<PhotoGrid> {
  bool _isInSelectionMode = false;

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
          onTap: () => _handleTap(context, notifier, photo, state),
          onLongPress: () => _handleLongPress(notifier, photo),
          child: Stack(
            children: [
              _buildPhotoWidget(photo),
              if (isSelected && widget.enableSelection) _buildSelectionOverlay(),
              if (isFavorite && widget.enableFavorites) _buildFavoriteBadge(),
              if (widget.showDates) _buildDateIndicator(photo.created),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoWidget(Photo photo) {
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
  }

  Widget _buildSelectionOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.check_circle, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFavoriteBadge() {
    return const Positioned(
      top: 4,
      right: 4,
      child: Icon(Icons.favorite, color: Colors.red),
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
        child: Icon(Icons.broken_image, color: Colors.white),
      ),
    );
  }

  void _handleTap(
      BuildContext context,
      GalleryNotifier notifier,
      Photo photo,
      GalleryState state,
      ) {
    if (_isInSelectionMode || state.selectedPhotos.isNotEmpty) {
      notifier.togglePhotoSelection(photo.id);
      setState(() {
        _isInSelectionMode = state.selectedPhotos.isNotEmpty;
      });
    } else {
      context.push('/photo/${photo.id}');
    }
  }

  void _handleLongPress(GalleryNotifier notifier, Photo photo) {
    notifier.togglePhotoSelection(photo.id);
    setState(() {
      _isInSelectionMode = true;
    });
  }
}