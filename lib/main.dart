import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/screens/favorites_screen.dart';
import 'package:thundergallery/features/thunder_gallery/presentation/screens/recent_screen.dart';
import 'firebase_options.dart';

// Feature imports
import 'features/thunder_gallery/presentation/screens/thunder_gallery_screen.dart';
import 'features/thunder_gallery/presentation/screens/photo_detail_screen.dart';
import 'features/thunder_gallery/presentation/screens/albums_screen.dart';

// Core imports
import 'core/app_theme.dart';
import 'core/providers/theme_provider.dart' show AppThemeMode, themeProvider;
import 'core/presentation/screens/error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Caught framework error: ${details.exception}');
  };

  runApp(
    const ProviderScope(
      child: ThunderGalleryApp(),
    ),
  );
}

class ThunderGalleryApp extends ConsumerWidget {
  const ThunderGalleryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeProvider);

    // Create router inside build method to avoid const issues
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ThunderGalleryScreen(),
          routes: [
            GoRoute(
              path: 'photo/:id',
              builder: (context, state) => PhotoDetailsScreen(
                photoId: state.pathParameters['id']!,
              ),
            ),
            GoRoute(
              path: 'albums',
              builder: (context, state) => const AlbumsScreen(),
            ),
            GoRoute(
              path: 'favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: 'recent',
              builder: (context, state) => const RecentScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => ErrorScreen(error: state.error!),
    );

    return MaterialApp.router(
      title: 'ThunderGallery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _convertToMaterialThemeMode(appThemeMode),
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }

  ThemeMode _convertToMaterialThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}