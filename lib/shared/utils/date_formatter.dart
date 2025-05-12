import 'package:intl/intl.dart';
// shared/utils/date_formatter.dart
extension DateFormatter on DateTime {
  String toGalleryFormat() {
    return DateFormat('MMM dd, yyyy – HH:mm').format(this);
  }
}