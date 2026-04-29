import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  /// Вызывать один раз при старте приложения
  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false, // не будим звуком
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    _initialized = true;
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

  /// Планирует утреннее уведомление-дебриф
  /// [triggerAt] — время когда сработал триггер (записываем в текст)
  static Future<void> scheduleMorningDebrief({
    required DateTime wakeTime,
    required DateTime triggerAt,
  }) async {
    final scheduledDate = tz.TZDateTime(
      tz.local,
      wakeTime.year,
      wakeTime.month,
      wakeTime.day,
      wakeTime.hour,
      wakeTime.minute,
    );

    final h = triggerAt.hour.toString().padLeft(2, '0');
    final m = triggerAt.minute.toString().padLeft(2, '0');

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
          importance: Importance.low,   // тихое, без звука
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
}
