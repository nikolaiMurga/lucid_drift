import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart';
import '../../data/models/sleep_schedule_model.dart';
import '../../data/models/sleep_session_model.dart';
import '../../domain/entities/sleep_session.dart';
import '../audio/night_audio_player.dart';
import '../notifications/notification_service.dart';

abstract final class RemServiceCommands {
  static const String stop        = 'stopService';
  static const String testTrigger = 'testTrigger';
  static const String update      = 'update';
}

// ── Топ-левел точки входа (требование flutter_background_service) ─────────────

/// Точка входа фонового изолята — вызывается пакетом по имени.
@pragma('vm:entry-point')
void remServiceOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  debugPrint('[REM Service] onStart: фоновый изолят инициализирован.');

  Timer? checkTimer;
  Isar? isar;
  NightAudioPlayer? currentPlayer;

  // ── Команда остановки ────────────────────────────────────────────────────
  service.on(RemServiceCommands.stop).listen((_) async {
    debugPrint('[REM Service] Получена команда stopService.');
    checkTimer?.cancel();
    currentPlayer?.stop();
    await isar?.close();
    service.stopSelf();
  });

  // ── Команда ручного теста ────────────────────────────────────────────────
  service.on(RemServiceCommands.testTrigger).listen((_) async {
    debugPrint('[REM Service] Получена команда testTrigger.');
    if (isar == null || !isar.isOpen) return;
    currentPlayer = await _fireSequence(service, isar);
  });

  // ── Android: переключение foreground / background ──────────────────────
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
        (_) => service.setAsForegroundService());
    service.on('setAsBackground').listen(
        (_) => service.setAsBackgroundService());
  }

  try {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        ContentItemModelSchema,
        NightPlaylistModelSchema,
        SleepScheduleModelSchema,
        SleepSessionModelSchema,
      ],
      directory: dir.path,
      name: 'default',
      inspector: false,
    );
    debugPrint('[REM Service] Isar открыт.');

    // ── Основной цикл проверки расписания каждую минуту ──────────────────
    checkTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (isar == null || !isar.isOpen) return;
      await _checkAndFire(service, isar);
    });
  } catch (e) {
    debugPrint('[REM Service] FATAL: $e');
  }
}

/// iOS background fetch callback — требование flutter_background_service.
@pragma('vm:entry-point')
Future<bool> remServiceOnIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

// ── Внутренняя логика (приватные топ-левел функции) ───────────────────────────

/// Проверяет расписание и запускает триггер если время совпало.
Future<void> _checkAndFire(ServiceInstance service, Isar isar) async {
  final scheduleModel = await isar.sleepScheduleModels.get(1);
  if (scheduleModel == null || !scheduleModel.isActive) return;

  final schedule = scheduleModel.toDomain();
  final now = DateTime.now();

  // После полуночи ссылаемся на предыдущий день как дату ночи
  final sleepDate = now.hour < 12
      ? now.subtract(const Duration(days: 1))
      : now;

  final triggerTime = schedule.triggerDateTime(sleepDate);

  final matches = now.year  == triggerTime.year  &&
                  now.month == triggerTime.month &&
                  now.day   == triggerTime.day   &&
                  now.hour  == triggerTime.hour  &&
                  now.minute == triggerTime.minute;

  if (!matches) return;

  // Anti-spam: уже срабатывало сегодня?
  final todayStart = DateTime(now.year, now.month, now.day);
  final existing = await isar.sleepSessionModels
      .filter()
      .dateGreaterThan(todayStart, include: true)
      .findFirst();

  if (existing?.triggeredAt != null) {
    debugPrint('[REM Service] Триггер уже сработал сегодня — пропуск.');
    return;
  }

  debugPrint('[REM Service] !!! ТРИГГЕР СОВПАЛ !!! Запускаем последовательность.');
  await _fireSequence(service, isar);
}

/// Запускает аудио-последовательность и сохраняет сессию в Isar.
Future<NightAudioPlayer?> _fireSequence(ServiceInstance service, Isar isar) async {
  final firedAt = DateTime.now();

  // 1. Уведомление о начале
  await NotificationService.init();
  await NotificationService.showTriggerFired(firedAt);

  // 2. MILD-вибрация
  await _vibrateMild();

  // 3. Обновляем foreground-уведомление
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: 'LucidDrift — REM активен',
      content: 'Воспроизведение аффирмаций...',
    );
  }
  service.invoke(RemServiceCommands.update, {
    'title': 'REM активен',
    'content': 'Воспроизведение аффирмаций...',
  });

  // 4. Воспроизводим плейлист
  final player = NightAudioPlayer();
  final result = await player.play(isar);

  // 5. Убираем уведомление о воспроизведении
  await NotificationService.cancel(NotificationIds.triggerFired);

  // 6. Восстанавливаем стандартный заголовок foreground
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: 'REM Движок',
      content: 'Ожидание следующего цикла...',
    );
  }
  service.invoke(RemServiceCommands.update, {
    'title': 'REM Движок',
    'content': 'Ожидание следующего цикла...',
  });

  // 7. Сохраняем сессию
  final session = SleepSession(
    id: const Uuid().v4(),
    date: firedAt,
    triggeredAt: firedAt,
    affirmationsPlayedCount: result?.affirmationsPlayed ?? 0,
    triggersPlayedCount: result?.triggersPlayed ?? 0,
    totalPlaybackDuration: result?.totalDuration ?? Duration.zero,
    lucidityLevel: LucidityLevel.none,
  );

  await isar.writeTxn(() async {
    await isar.sleepSessionModels.put(SleepSessionModel.fromDomain(session));
  });

  debugPrint('[REM Service] Сессия сохранена. '
      'Аффирмации: ${session.affirmationsPlayedCount}, '
      'Триггеры: ${session.triggersPlayedCount}.');

  return player;
}

Future<void> _vibrateMild() async {
  final hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator != true) return;

  await Vibration.vibrate(duration: 200);
  await Future.delayed(const Duration(milliseconds: 400));
  await Vibration.vibrate(duration: 200);
}

// ── Публичный API управления сервисом ─────────────────────────────────────────

class RemTriggerService {
  static const String _notificationChannelId = 'rem_engine_channel';
  static const int    _notificationId        = 888;

  /// Настраивает FlutterBackgroundService. Вызывать один раз в main().
  static Future<void> initialize() async {
    final service = FlutterBackgroundService();

    const channel = AndroidNotificationChannel(
      _notificationChannelId,
      'REM Engine',
      description: 'Обеспечивает мониторинг сна',
      importance: Importance.low,
    );
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: remServiceOnStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: _notificationChannelId,
        initialNotificationTitle: 'REM Движок',
        initialNotificationContent: 'Ожидание времени сна...',
        foregroundServiceNotificationId: _notificationId,
        foregroundServiceTypes: [AndroidForegroundType.mediaPlayback],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: remServiceOnStart,
        onBackground: remServiceOnIosBackground,
      ),
    );
  }

  /// Запускает фоновый сервис (не дублирует если уже запущен).
  static Future<void> start() async {
    final service = FlutterBackgroundService();
    if (await service.isRunning()) return;
    await service.startService();
  }

  /// Останавливает фоновый сервис.
  static void stop() =>
      FlutterBackgroundService().invoke(RemServiceCommands.stop);

  static Future<bool> isRunning() => FlutterBackgroundService().isRunning();

  /// Ручной тест триггера без ожидания расписания.
  static void testTrigger() =>
      FlutterBackgroundService().invoke(RemServiceCommands.testTrigger);
}
