import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark, system }

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system);

  void toggleTheme() {
    state = state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
  }
}