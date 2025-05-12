import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViewMode { all, favorites }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.all);