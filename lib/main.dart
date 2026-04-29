import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/background/rem_trigger_service.dart';
import 'services/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI
  await setupDi();

  // Уведомления
  await NotificationService.init();
  await NotificationService.requestPermissions();

  // WorkManager — регистрируем callback dispatcher
  await Workmanager().initialize(
    workManagerCallbackDispatcher,
    isInDebugMode: false,
  );

  runApp(const LucidDriftApp());
}

class LucidDriftApp extends StatelessWidget {
  const LucidDriftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LucidDrift',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
