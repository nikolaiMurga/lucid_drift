import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// ID каналов и уведомлений
abstract final class NotificationIds {
  static const int morningDebrief = 1;
  static const int triggerFired   = 2;
  static const int foreground     = 99; // foreground service notification
}

abstract final class NotificationChannels {
  static const String sleep = 'lucid_drift_sleep';
  static const String debrief = 'lucid_drift_debrief';
}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// true если пользователь тапнул дебриф-уведомление (а не смахнул).
  /// Читается кубитом при инициализации, после чего сбрасывается.
  static bool debriefTapped = false;

  static void clearDebriefTap() => debriefTapped = false;

  /// Вызывать один раз при старте приложения
  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );

    // Проверяем был ли апп запущен тапом на уведомление (когда апп был убит)
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true &&
        launch?.notificationResponse?.id == NotificationIds.morningDebrief) {
      debriefTapped = true;
    }

    await _clearNotificationCacheOnFirstRun();

    _initialized = true;
  }

  static void _onTap(NotificationResponse response) {
    if (response.id == NotificationIds.morningDebrief) debriefTapped = true;
  }

  /// Запрашивает разрешения (iOS + Android 13+)
  static Future<bool> requestPermissions() async {
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: false);
    return (android ?? true) && (ios ?? true);
  }

  /// Планирует утреннее уведомление-дебриф.
  /// Сначала отменяем старую запись, чтобы не получить «Missing type parameter»
  /// при десериализации устаревших данных из SharedPreferences.
  static Future<void> scheduleMorningDebrief({
    required DateTime wakeTime,
    required DateTime firedAt,
  }) async {
    await _plugin.cancel(NotificationIds.morningDebrief);

    final scheduledDate = tz.TZDateTime.from(wakeTime, tz.local);

    final h = firedAt.hour.toString().padLeft(2, '0');
    final m = firedAt.minute.toString().padLeft(2, '0');

    await _plugin.zonedSchedule(
      NotificationIds.morningDebrief,
      '🌙 Как прошла ночь?',
      'Триггер сработал в $h:$m. Запиши свои сны!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.debrief,
          'Утренний дебриф',
          channelDescription: 'Напоминание записать сон',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Немедленное уведомление что триггер сработал (показывается ночью тихо)
  static Future<void> showTriggerFired(DateTime firedAt) async {
    final h = firedAt.hour.toString().padLeft(2, '0');
    final m = firedAt.minute.toString().padLeft(2, '0');

    await _plugin.show(
      NotificationIds.triggerFired,
      'LucidDrift',
      'Аффирмации воспроизводятся... $h:$m',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.sleep,
          'Ночной триггер',
          channelDescription: 'Статус воспроизведения аффирмаций',
          importance: Importance.low,
          priority: Priority.low,
          silent: true,
          ongoing: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: false,
          presentSound: false,
        ),
      ),
    );
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  static Future<void> cancel(int id) => _plugin.cancel(id);

  /// Очищает SharedPreferences-кэш уведомлений при первом запуске новой версии.
  /// Обходит плагин напрямую — cancelAll/cancel тоже вызывают loadScheduledNotifications
  /// и упадут с "Missing type parameter" на битых данных.
  static Future<void> _clearNotificationCacheOnFirstRun() async {
    const flagKey = 'lucid_drift_notifications_cache_cleared_v2';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(flagKey) == true) return;

    // flutter_local_notifications хранит кэш под этим ключом
    await prefs.remove('scheduled_notifications');

    await prefs.setBool(flagKey, true);
  }
}