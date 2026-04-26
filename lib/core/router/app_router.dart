import 'package:go_router/go_router.dart';
import '../../presentation/content_library/screens/content_library_screen.dart';
import '../../presentation/recorder/screens/recorder_screen.dart';
import '../../presentation/playlist/screens/playlist_screen.dart';
import '../../presentation/schedule/screens/schedule_screen.dart';
import '../../presentation/common/screens/shell_screen.dart';
import '../../domain/entities/content_type.dart';

abstract final class AppRoutes {
  static const shell      = '/';
  static const library    = '/library';
  static const recorder   = '/recorder';
  static const playlist   = '/playlist';
  static const schedule   = '/schedule';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.library,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.library,
          builder: (context, state) => const ContentLibraryScreen(),
        ),
        GoRoute(
          path: AppRoutes.playlist,
          builder: (context, state) => const PlaylistScreen(),
        ),
        GoRoute(
          path: AppRoutes.schedule,
          builder: (context, state) => const ScheduleScreen(),
        ),
      ],
    ),
    // Recorder — fullscreen, вне shell
    GoRoute(
      path: AppRoutes.recorder,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RecorderScreen(
          contentItemId: extra?['contentItemId'] as String?,
          initialType: extra?['type'] as ContentType?,
        );
      },
    ),
  ],
);
