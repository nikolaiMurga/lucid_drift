import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart' hide TimeOfDay;
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
import '../../domain/entities/sleep_schedule.dart';
import '../../domain/entities/sleep_session.dart';
import '../audio/night_audio_player.dart';
import '../notifications/notification_service.dart';

abstract final class RemServiceCommands {
  static const String stop        = 'stopService';
  static const String testTrigger = 'testTrigger';
  static const String update      = 'update';
}

// ── Точки входа (требование flutter_background_service) ───────────────────────

@pragma('vm:entry-point')
void remServiceOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  debugPrint('[REM] onStart: изолят инициализирован.');

  Timer? checkTimer;
  Isar? isar;
  NightAudioPlayer? currentPlayer;

  // ── Стоп ──────────────────────────────────────────────────────────────────
  service.on(RemServiceCommands.stop).listen((_) async {
    debugPrint('[REM] Команда stop.');
    checkTimer?.cancel();
    currentPlayer?.stop();
    await isar?.close();
    service.stopSelf();
  });

  // ── Ручной тест ───────────────────────────────────────────────────────────
  service.on(RemServiceCommands.testTrigger).listen((_) async {
    debugPrint('[REM] Команда testTrigger.');
    if (isar == null || !isar.isOpen) {
      debugPrint('[REM] testTrigger: Isar ещё не готов.');
      return;
    }

    final model = await isar.sleepScheduleModels.get(1);
    if (model == null) {
      debugPrint('[REM] testTrigger: расписание не найдено.');
      return;
    }
    final schedule = model.toDomain();

    // Ищем первый цикл с непустым таймлайном
    int? testIndex;
    for (int i = 0; i < schedule.cycleTimelines.length; i++) {
      if (schedule.cycleTimelines[i].modules.isNotEmpty) {
        testIndex = i;
        break;
      }
    }

    if (testIndex == null) {
      debugPrint('[REM] testTrigger: нет циклов с модулями.');
      return;
    }

    debugPrint('[REM] testTrigger: запуск цикла ${testIndex + 1}.');
    currentPlayer = await _fireSequence(
      service, isar, schedule,
      cycleIndex: testIndex,
      isTest: true,
    );
  });

  // ── Android foreground/background ─────────────────────────────────────────
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((_) => service.setAsForegroundService());
    service.on('setAsBackground').listen((_) => service.setAsBackgroundService());
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
    debugPrint('[REM] Isar открыт.');

    // Немедленная проверка — чтобы не пропустить триггер в первую минуту
    final player = await _checkAndFire(service, isar);
    if (player != null) currentPlayer = player;

    // Основной цикл — каждую минуту
    checkTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (isar == null || !isar.isOpen) return;
      final p = await _checkAndFire(service, isar);
      if (p != null) currentPlayer = p;
    });
  } catch (e, st) {
    debugPrint('[REM] FATAL: $e\n$st');
  }
}

@pragma('vm:entry-point')
Future<bool> remServiceOnIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

// ── Приватная логика ───────────────────────────────────────────────────────────

/// Возвращает DateTime момента засыпания если мы сейчас в окне сна (≤ 12 ч),
/// иначе null. Не использует хрупкие эвристики по часу — просто перебирает
/// кандидатов (сегодня / вчера).
DateTime? _resolveRecentBed(TimeOfDay bedTime, DateTime now) {
  final candidates = [
    DateTime(now.year, now.month, now.day, bedTime.hour, bedTime.minute),
    DateTime(now.year, now.month, now.day, bedTime.hour, bedTime.minute)
        .subtract(const Duration(days: 1)),
  ];

  for (final bed in candidates) {
    if (bed.isAfter(now)) continue; // ещё не ложились
    final minutesSlept = now.difference(bed).inMinutes;
    if (minutesSlept <= 12 * 60) return bed; // в окне сна
  }
  return null; // сейчас не в окне сна
}

/// Проверяет все 5 циклов. Срабатывает на первый совпавший цикл
/// с непустым таймлайном. Возвращает плеер или null.
Future<NightAudioPlayer?> _checkAndFire(ServiceInstance service, Isar isar) async {
  final scheduleModel = await isar.sleepScheduleModels.get(1);
  if (scheduleModel == null) {
    debugPrint('[REM] _checkAndFire: расписание не найдено.');
    return null;
  }
  if (!scheduleModel.isActive) return null;

  final schedule = scheduleModel.toDomain();
  final now = DateTime.now();

  final bed = _resolveRecentBed(schedule.bedTime, now);
  if (bed == null) return null; // не в окне сна

  // Активные дни проверяем по дню засыпания
  if (!schedule.activeDays.contains(bed.weekday)) return null;

  for (int i = 0; i < schedule.cycleTimelines.length; i++) {
    final config = schedule.cycleTimelines[i];
    if (config.modules.isEmpty) continue;

    final triggerTime = bed.add(Duration(
      minutes: SleepCycle.values[i].minutesFromBed + config.startOffsetMins,
    ));

    debugPrint('[REM] Цикл ${i + 1}: '
        'bed=${bed.hour}:${bed.minute.toString().padLeft(2, '0')}, '
        'trigger=${triggerTime.hour}:${triggerTime.minute.toString().padLeft(2, '0')}, '
        'now=${now.hour}:${now.minute.toString().padLeft(2, '0')}');

    if (now.year   == triggerTime.year  &&
        now.month  == triggerTime.month &&
        now.day    == triggerTime.day   &&
        now.hour   == triggerTime.hour  &&
        now.minute == triggerTime.minute) {
      debugPrint('[REM] !!! ТРИГГЕР цикл ${i + 1} !!!');
      return await _fireSequence(service, isar, schedule, cycleIndex: i);
    }
  }
  return null;
}

/// Запускает аудио-последовательность для указанного цикла.
/// [isTest] = true: без вибрации, без уведомлений, без сохранения сессии.
Future<NightAudioPlayer?> _fireSequence(
  ServiceInstance service,
  Isar isar,
  SleepSchedule schedule, {
  required int cycleIndex,
  bool isTest = false,
}) async {
  final config = schedule.cycleTimelines[cycleIndex];

  if (config.modules.isEmpty) {
    debugPrint('[REM] _fireSequence: таймлайн цикла ${cycleIndex + 1} пустой.');
    return null;
  }

  final firedAt = DateTime.now();

  if (!isTest) {
    await NotificationService.init();
    await NotificationService.showTriggerFired(firedAt);
    await _vibrateMild();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'LucidDrift — REM активен',
        content: 'Цикл ${cycleIndex + 1} · воспроизведение...',
      );
    }
    service.invoke(RemServiceCommands.update, {
      'title': 'REM активен',
      'content': 'Цикл ${cycleIndex + 1} · воспроизведение...',
    });
  }

  final player = NightAudioPlayer();
  final result = await player.play(isar, config: config, isTest: isTest);

  if (!isTest) {
    await NotificationService.cancel(NotificationIds.triggerFired);

    final now = DateTime.now();
    final wakeCandidate = DateTime(
      now.year, now.month, now.day,
      schedule.wakeTime.hour, schedule.wakeTime.minute,
    );
    final wakeTime = wakeCandidate.isBefore(now)
        ? wakeCandidate.add(const Duration(days: 1))
        : wakeCandidate;
    await NotificationService.scheduleMorningDebrief(
      wakeTime: wakeTime,
      firedAt: firedAt,
    );

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

    debugPrint('[REM] Сессия сохранена: '
        'аффирмации=${session.affirmationsPlayedCount}, '
        'триггеры=${session.triggersPlayedCount}.');
  }

  return player;
}

Future<void> _vibrateMild() async {
  final hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator != true) return;
  await Vibration.vibrate(duration: 200);
  await Future.delayed(const Duration(milliseconds: 400));
  await Vibration.vibrate(duration: 200);
}

// ── Публичный API ──────────────────────────────────────────────────────────────

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
