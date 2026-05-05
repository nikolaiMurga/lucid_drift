import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:isar/isar.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart' hide fastHash;
import '../../domain/entities/cycle_timeline.dart';

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

  /// Воспроизводит таймлайн одного REM-цикла.
  /// [config] — конфигурация из CycleConfig (модули с delaySeconds).
  /// [isTest] — если true, сессия не сохраняется.
  Future<PlaybackResult?> play(
    Isar isar, {
    required CycleConfig config,
    bool isTest = false,
  }) async {
    if (config.modules.isEmpty) {
      debugPrint('[NightAudioPlayer] Таймлайн пустой — нечего воспроизводить.');
      return null;
    }

    final queue = await _buildQueueFromConfig(isar, config);
    if (queue.isEmpty) {
      debugPrint('[NightAudioPlayer] Нет аудио-файлов в модулях таймлайна.');
      return null;
    }
    debugPrint('[NightAudioPlayer] Очередь: ${queue.length} треков (isTest=$isTest).');

    await _configureAudioSession();

    // startOffsetMins уже учтён в времени срабатывания триггера (_checkAndFire),
    // поэтому здесь дополнительная задержка не нужна — начинаем сразу.
    final startedAt = DateTime.now();
    final r = await _playModules(queue);

    await _player.stop();
    await _player.dispose();

    return PlaybackResult(
      affirmationsPlayed: r.affirmations,
      triggersPlayed: r.triggers,
      totalDuration: r.duration,
      startedAt: startedAt,
      endedAt: DateTime.now(),
    );
  }

  void stop() {
    _stopped = true;
    _player.stop();
  }

  // ── private ───────────────────────────────────────────────────────────────

  /// Воспроизводит каждый модуль по очереди с delaySeconds перед ним.
  Future<_PlayResult> _playModules(List<_TrackEntry> queue) async {
    int affirmations = 0;
    int triggers = 0;
    Duration duration = Duration.zero;

    for (final entry in queue) {
      if (_stopped) break;

      // Пауза перед модулем (delaySeconds задаётся в таймлайне)
      if (entry.delaySeconds > 0) {
        debugPrint('[NightAudioPlayer] Пауза ${entry.delaySeconds}с перед треком.');
        final deadline = DateTime.now().add(Duration(seconds: entry.delaySeconds));
        while (!_stopped && DateTime.now().isBefore(deadline)) {
          await Future.delayed(const Duration(seconds: 1));
        }
        if (_stopped) break;
      }

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
        if (entry.isAffirmation) { affirmations++; } else { triggers++; }
      } catch (e) {
        debugPrint('[NightAudioPlayer] Ошибка воспроизведения: $e');
        continue;
      }
    }

    return _PlayResult(affirmations: affirmations, triggers: triggers, duration: duration);
  }

  /// Строит очередь из модулей таймлайна.
  /// Громкость берётся из глобального плейлиста (если есть), иначе — дефолт.
  Future<List<_TrackEntry>> _buildQueueFromConfig(
    Isar isar,
    CycleConfig config,
  ) async {
    final playlist = await _loadPlaylist(isar);
    final affirmationVolume = playlist?.affirmationVolume ?? 0.6;
    final triggerVolume = playlist?.triggerVolume ?? 0.8;

    final result = <_TrackEntry>[];
    for (final module in config.modules) {
      final itemId = module.contentItem?.id;
      if (itemId == null) {
        debugPrint('[NightAudioPlayer] Пропуск модуля: contentItem.id == null.');
        continue;
      }

      final model = await isar.contentItemModels.get(fastHash(itemId));
      if (model == null) {
        debugPrint('[NightAudioPlayer] Пропуск модуля: ContentItemModel не найден (id=$itemId).');
        continue;
      }
      if (model.audioLocalPath == null) {
        debugPrint('[NightAudioPlayer] Пропуск модуля "${model.title}": audioLocalPath == null (файл не скачан).');
        continue;
      }

      final isAffirmation = module.type == RemModuleType.affirmation;
      result.add(_TrackEntry(
        localPath: model.audioLocalPath!,
        volume: isAffirmation ? affirmationVolume : triggerVolume,
        isAffirmation: isAffirmation,
        delaySeconds: module.delaySeconds,
      ));
    }

    return result;
  }

  /// Загружает плейлист для настроек громкости.
  Future<NightPlaylistModel?> _loadPlaylist(Isar isar) async {
    final main = await isar.nightPlaylistModels.get(fastHash('main_playlist'));
    if (main != null) return main;

    final models = await isar.nightPlaylistModels.where().findAll();
    return models.firstOrNull;
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
  final int delaySeconds;

  const _TrackEntry({
    required this.localPath,
    required this.volume,
    required this.isAffirmation,
    this.delaySeconds = 0,
  });
}

class _PlayResult {
  final int affirmations;
  final int triggers;
  final Duration duration;
  const _PlayResult({required this.affirmations, required this.triggers, required this.duration});
}
