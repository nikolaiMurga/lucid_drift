import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart';
import '../../data/models/sleep_schedule_model.dart';
import '../../data/models/sleep_session_model.dart';
import '../../domain/entities/sleep_session.dart';
import '../audio/night_audio_player.dart';
import '../notifications/notification_service.dart';
import 'trigger_scheduler.dart';

/// Точка входа для WorkManager — вызывается в отдельном изоляте.
/// ВАЖНО: не использует GetIt, BLoC, Provider — только чистый Dart + Isar.
@pragma('vm:entry-point')
void workManagerCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != TriggerTaskNames.remTrigger) return true;

    try {
      await RemTriggerService.execute(inputData: inputData ?? {});
    } catch (e) {
      debugPrint('[RemTriggerService] Error: $e');
      return false;
    }

    return true;
  });
}

class RemTriggerService {
  /// Основная логика триггера — запускается WorkManager-ом
  static Future<void> execute({Map<dynamic, dynamic> inputData = const {}}) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Открываем Isar в изоляте (отдельный экземпляр, но тот же файл)
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        ContentItemModelSchema,
        NightPlaylistModelSchema,
        SleepScheduleModelSchema,
        SleepSessionModelSchema,
      ],
      directory: dir.path,
      name: 'default',
    );

    try {
      await _run(isar, inputData);
    } finally {
      await isar.close();
    }
  }

  static Future<void> _run(
      Isar isar, Map<dynamic, dynamic> inputData) async {
    // Anti-spam: проверяем, не было ли триггера сегодня уже
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final existing = await isar.sleepSessionModels
        .filter()
        .dateGreaterThan(todayStart, include: true)
        .findFirst();

    if (existing?.triggeredAt != null) {
      // Уже срабатывало сегодня — пропускаем
      return;
    }

    final triggeredAt = DateTime.now();

    // 1. Показываем тихое уведомление что начали
    await NotificationService.init();
    await NotificationService.showTriggerFired(triggeredAt);

    // 2. Вибрация — MILD паттерн (2 короткие)
    await _vibrateMild();

    // 3. Запускаем аудио
    final player = NightAudioPlayer();
    final result = await player.play(isar);

    // 4. Убираем уведомление о воспроизведении
    await NotificationService.cancel(NotificationIds.triggerFired);

    // 5. Сохраняем сессию
    final session = SleepSession(
      id: const Uuid().v4(),
      date: triggeredAt,
      triggeredAt: triggeredAt,
      affirmationsPlayedCount: result?.affirmationsPlayed ?? 0,
      triggersPlayedCount: result?.triggersPlayed ?? 0,
      totalPlaybackDuration: result?.totalDuration ?? Duration.zero,
      lucidityLevel: LucidityLevel.none, // пользователь выставит утром
    );

    await isar.writeTxn(() async {
      await isar.sleepSessionModels.put(
        SleepSessionModel.fromDomain(session),
      );
    });
  }

  // ── MILD вибро-паттерн ────────────────────────────────────────────────────

  static Future<void> _vibrateMild() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    // 2 короткие с паузой — классический MILD-сигнал
    await Vibration.vibrate(duration: 200);
    await Future.delayed(const Duration(milliseconds: 400));
    await Vibration.vibrate(duration: 200);
  }
}
