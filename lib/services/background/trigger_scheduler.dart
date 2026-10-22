import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../notifications/notification_service.dart';
import 'rem_trigger_service.dart';

class TriggerScheduler {
  /// Останавливает REM-движок и отменяет все уведомления.
  static Future<void> cancel() async {
    RemTriggerService.stop();
    await _cancelNotifications();
  }

  static Future<void> _cancelNotifications() async {
    final plugin = FlutterLocalNotificationsPlugin();
    try {
      if (Platform.isIOS) await plugin.cancel(88);
      await plugin.cancel(NotificationIds.morningDebrief);
    } catch (e) {
      debugPrint('[TriggerScheduler] _cancelNotifications error (ignored): $e');
    }
  }
}
