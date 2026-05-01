import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:isar/isar.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart' hide fastHash;
import '../../domain/entities/night_playlist.dart';
import '../../domain/entities/sleep_schedule.dart';

/// Результат воспроизведения — передаётся в RemTriggerService для лога
class PlaybackResult {
  final int affirmationsPlayed;
  final int triggersPlayed;
  final Duration totalDuration;
  final DateTime startedAt;
  final DateTime endedAt;

  const PlaybackResult({
    required this.affirmationsPlayed,
    required this.triggersPlayed,
    required this.totalDuration,
    required this.startedAt,
    required this.endedAt,
  });
}

class NightAudioPlayer {
  final AudioPlayer _player = AudioPlayer();
  bool _stopped = false;

  /// Запускает воспроизведение плейлиста в заданном режиме.
  /// Работает в фоновом изоляте — читает Isar напрямую.
  ///
  /// [cycle] — целевой цикл сна (определяет длительность REM).
  /// [scheduleMode] — fullPhase: петля до конца окна; midPhase3x: ждём середины, потом 3 прохода.
  Future<PlaybackResult?> play(
    Isar isar, {
    required SleepCycle cycle,
    required SchedulePlaybackMode scheduleMode,
  }) async {
    // 1. Читаем плейлист
    final playlistModel = await _loadPlaylist(isar);
    if (playlistModel == null) {
      debugPrint('[NightAudioPlayer] Плейлист не найден.');
      return null;
    }
    if (playlistModel.entryItemIds.isEmpty) {
      debugPrint('[NightAudioPlayer] Плейлист пустой (нет треков).');
      return null;
    }
    debugPrint('[NightAudioPlayer] Плейлист загружен: ${playlistModel.entryItemIds.length} треков. '
        'Режим: $scheduleMode, цикл: $cycle (REM ${cycle.remDurationMinutes} мин).');

    // 2. Конфигурируем аудио-сессию
    await _configureAudioSession();

    // 3. Собираем очередь треков
    final queue = await _buildQueue(isar, playlistModel);
    if (queue.isEmpty) {
      debugPrint('[NightAudioPlayer] Очередь пуста — у треков нет аудио-файлов.');
      return null;
    }
    debugPrint('[NightAudioPlayer] Очередь: ${queue.length} треков.');

    final startedAt = DateTime.now();
    int affirmationsPlayed = 0;
    int triggersPlayed = 0;
    Duration totalDuration = Duration.zero;

    // 4. Выбираем стратегию воспроизведения
    switch (scheduleMode) {
      case SchedulePlaybackMode.fullPhase:
        // Воспроизводим в цикле всё REM-окно + 10 мин (мягкий фон для аффирмаций)
        final deadline = startedAt.add(Duration(minutes: cycle.remDurationMinutes + 10));
        while (!_stopped && DateTime.now().isBefore(deadline)) {
          final r = await _playQueueOnce(queue, playlistModel);
          affirmationsPlayed += r.affirmations;
          triggersPlayed += r.triggers;
          totalDuration += r.duration;
        }

      case SchedulePlaybackMode.midPhase3x:
        // Ждём середины REM-окна, затем 3 прохода (точечный сигнал для триггеров)
        final waitMins = cycle.remDurationMinutes ~/ 2;
        debugPrint('[NightAudioPlayer] midPhase3x: ждём $waitMins мин до середины REM.');
        await Future.delayed(Duration(minutes: waitMins));
        if (_stopped) break;
        for (int i = 0; i < 3 && !_stopped; i++) {
          debugPrint('[NightAudioPlayer] midPhase3x: проход ${i + 1}/3.');
          final r = await _playQueueOnce(queue, playlistModel);
          affirmationsPlayed += r.affirmations;
          triggersPlayed += r.triggers;
          totalDuration += r.duration;
        }
    }

    await _player.stop();
    await _player.dispose();

    return PlaybackResult(
      affirmationsPlayed: affirmationsPlayed,
      triggersPlayed: triggersPlayed,
      totalDuration: totalDuration,
      startedAt: startedAt,
      endedAt: DateTime.now(),
    );
  }

  void stop() {
    _stopped = true;
    _player.stop();
  }

  // ── private ───────────────────────────────────────────────────────────────

  /// Проигрывает очередь треков один раз и возвращает статистику прохода.
  Future<_PlayResult> _playQueueOnce(
    List<_TrackEntry> queue,
    NightPlaylistModel playlistModel,
  ) async {
    int affirmations = 0;
    int triggers = 0;
    Duration duration = Duration.zero;

    for (final entry in queue) {
      if (_stopped) break;

      final file = File(entry.localPath);
      if (!file.existsSync()) {
        debugPrint('[NightAudioPlayer] Файл не найден: ${entry.localPath}');
        continue;
      }

      try {
        _player.setVolume(0.0);
        await _player.setFilePath(entry.localPath);
        await _player.setVolume(entry.volume);

        final trackDuration = _player.duration ?? Duration.zero;
        _player.play();

        await _player.playerStateStream.firstWhere(
          (s) => s.processingState == ProcessingState.completed || _stopped,
        );

        duration += trackDuration;
        if (entry.isAffirmation) {
          affirmations++;
        } else {
          triggers++;
        }

        if (!_stopped && entry != queue.last) {
          await Future.delayed(Duration(seconds: playlistModel.pauseBetweenSeconds));
        }
      } catch (_) {
        continue;
      }
    }

    return _PlayResult(affirmations: affirmations, triggers: triggers, duration: duration);
  }

  /// Загружает плейлист — приоритет у 'main_playlist' (синглтон репозитория),
  /// затем любой активный, затем первый попавшийся.
  Future<NightPlaylistModel?> _loadPlaylist(Isar isar) async {
    // Сначала пробуем синглтон по известному id
    final main = await isar.nightPlaylistModels.get(fastHash('main_playlist'));
    if (main != null && main.entryItemIds.isNotEmpty) return main;

    // Fallback: любой активный с треками
    final models = await isar.nightPlaylistModels.where().findAll();
    return models.where((m) => m.isActive && m.entryItemIds.isNotEmpty).firstOrNull
        ?? models.where((m) => m.entryItemIds.isNotEmpty).firstOrNull;
  }

  Future<List<_TrackEntry>> _buildQueue(
      Isar isar, NightPlaylistModel playlist) async {
    final result = <_TrackEntry>[];

    for (int i = 0; i < playlist.entryItemIds.length; i++) {
      final itemId = playlist.entryItemIds[i];
      final model = await isar.contentItemModels.get(fastHash(itemId));
      if (model == null || model.audioLocalPath == null) continue;

      final isAffirmation =
          model.contentType == ContentTypeEnum.affirmation;
      final volume = isAffirmation
          ? playlist.affirmationVolume
          : playlist.triggerVolume;

      result.add(_TrackEntry(
        localPath: model.audioLocalPath!,
        volume: volume,
        isAffirmation: isAffirmation,
      ));
    }

    // Сортировка по playbackMode
    final mode = PlaybackMode.values[playlist.playbackModeIndex];
    if (mode == PlaybackMode.affirmationsFirst) {
      result.sort((a, b) => a.isAffirmation == b.isAffirmation
          ? 0
          : a.isAffirmation ? -1 : 1);
    } else if (mode == PlaybackMode.triggersFirst) {
      result.sort((a, b) => a.isAffirmation == b.isAffirmation
          ? 0
          : a.isAffirmation ? 1 : -1);
    }
    // interleaved — оставляем как есть

    return result;
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    ));
  }
}

class _TrackEntry {
  final String localPath;
  final double volume;
  final bool isAffirmation;
  const _TrackEntry({
    required this.localPath,
    required this.volume,
    required this.isAffirmation,
  });
}

class _PlayResult {
  final int affirmations;
  final int triggers;
  final Duration duration;
  const _PlayResult({required this.affirmations, required this.triggers, required this.duration});
}
