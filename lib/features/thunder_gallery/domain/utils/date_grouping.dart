import 'package:thundergallery/features/thunder_gallery/domain/entities/photo.dart';

Map<DateTime, List<Photo>> groupPhotosByDate(List<Photo> photos) {
  final map = <DateTime, List<Photo>>{};

  for (final photo in photos) {
    final date = DateTime(
      photo.created.year,
      photo.created.month,
      photo.created.day,
    );
    map.putIfAbsent(date, () => []).add(photo);
  }

  return map;
}