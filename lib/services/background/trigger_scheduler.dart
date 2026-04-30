import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../notifications/notification_service.dart';
import 'rem_trigger_service.dart';

class TriggerScheduler {
  /// Запускает фоновый REM-движок и планирует утренний дебриф.
  /// На Android — foreground service живёт всю ночь.
  /// На iOS — то же самое через BackgroundFetch.
  static Future<void> schedule({
    required DateTime triggerAt,
    required DateTime wakeTime,
  }) async {
    // Запускаем постоянный фоновый сервис
    await RemTriggerService.start();

    // Резервное тихое уведомление (iOS wake-up hint)
    if (Platform.isIOS) {
      await _scheduleLocalNotificationTrigger(triggerAt);
    }

    // Утренний дебриф
    await NotificationService.scheduleMorningDebrief(
      wakeTime: wakeTime,
      triggerAt: triggerAt,
    );
  }

  /// Останавливает REM-движок и отменяет все уведомления.
  static Future<void> cancel() async {
    RemTriggerService.stop();
    await _cancelNotifications();
  }

  // ── iOS: тихое уведомление как wake-up hint ────────────────────────────

  static Future<void> _scheduleLocalNotificationTrigger(
      DateTime triggerAt) async {
    final plugin = FlutterLocalNotificationsPlugin();
    // Удаляем старую запись перед повторным планированием
    await plugin.cancel(88);
    final scheduledDate = tz.TZDateTime.from(triggerAt, tz.local);

    await plugin.zonedSchedule(
      88,
      null,
      null,
      scheduledDate,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: false,
          presentSound: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> _cancelNotifications() async {
    final plugin = FlutterLocalNotificationsPlugin();
    try {
      // id 88 используется только на iOS как wake-up hint
      if (Platform.isIOS) await plugin.cancel(88);
      await plugin.cancel(NotificationIds.morningDebrief);
    } catch (e) {
      debugPrint('[TriggerScheduler] _cancelNotifications error (ignored): $e');
    }
  }
}
