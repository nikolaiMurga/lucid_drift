import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/sleep_schedule.dart';
import '../notifications/notification_service.dart';

abstract final class TriggerTaskNames {
  static const String remTrigger = 'rem_trigger_task';
  static const String inputKey   = 'trigger_at_ms';
}

class TriggerScheduler {
  /// Планирует REM-триггер на [triggerAt].
  /// Использует WorkManager (Android) + Local Notification (iOS + резерв Android).
  static Future<void> schedule({
    required DateTime triggerAt,
    required DateTime wakeTime,
  }) async {
    await _cancelExisting();

    final delay = triggerAt.difference(DateTime.now());
    if (delay.isNegative) return; // уже прошло

    if (Platform.isAndroid) {
      await _scheduleAndroid(triggerAt: triggerAt, delay: delay);
    }

    // Local notification — работает на обеих платформах как резерв
    await _scheduleLocalNotificationTrigger(triggerAt);

    // Утренний дебриф планируем сразу
    await NotificationService.scheduleMorningDebrief(
      wakeTime: wakeTime,
      triggerAt: triggerAt,
    );
  }

  static Future<void> cancel() => _cancelExisting();

  // ── Android ───────────────────────────────────────────────────────────────

  static Future<void> _scheduleAndroid({
    required DateTime triggerAt,
    required Duration delay,
  }) async {
    await Workmanager().registerOneOffTask(
      TriggerTaskNames.remTrigger,
      TriggerTaskNames.remTrigger,
      initialDelay: delay,
      inputData: {
        TriggerTaskNames.inputKey: triggerAt.millisecondsSinceEpoch,
      },
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  }

  // ── Local notification как триггер (iOS + Android резерв) ─────────────────

  static Future<void> _scheduleLocalNotificationTrigger(
      DateTime triggerAt) async {
    final plugin = FlutterLocalNotificationsPlugin();

    final scheduledDate = tz.TZDateTime.from(triggerAt, tz.local);

    await plugin.zonedSchedule(
      88, // специальный id для триггера
      null,
      null,
      scheduledDate,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'lucid_drift_trigger',
          'REM Триггер',
          channelDescription: 'Внутреннее уведомление для запуска аффирмаций',
          importance: Importance.min,
          priority: Priority.min,
          silent: true,
          showWhen: false,
          visibility: NotificationVisibility.secret,
        ),
        iOS: const DarwinNotificationDetails(
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

  static Future<void> _cancelExisting() async {
    if (Platform.isAndroid) {
      await Workmanager().cancelByUniqueName(TriggerTaskNames.remTrigger);
    }
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.cancel(88);
    await plugin.cancel(NotificationIds.morningDebrief);
  }
}
