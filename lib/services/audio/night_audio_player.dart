import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:isar/isar.dart';

import '../../data/models/content_item_model.dart';
import '../../data/models/night_playlist_model.dart' hide fastHash;
import '../../domain/entities/night_playlist.dart';

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

  /// Запускает воспроизведение плейлиста.
  /// Работает в фоновом изоляте — читает Isar напрямую.
  Future<PlaybackResult?> play(Isar isar) async {
    // 1. Читаем плейлист
    final playlistModel = await _loadPlaylist(isar);
    if (playlistModel == null || playlistModel.entryItemIds.isEmpty) return null;

    // 2. Конфигурируем аудио-сессию
    await _configureAudioSession();

    // 3. Собираем очередь треков по порядку плейлиста
    final queue = await _buildQueue(isar, playlistModel);
    if (queue.isEmpty) return null;

    final startedAt = DateTime.now();
    int affirmationsPlayed = 0;
    int triggersPlayed = 0;
    Duration totalDuration = Duration.zero;

    // 4. Воспроизводим треки по очереди
    for (final entry in queue) {
      if (_stopped) break;

      final file = File(entry.localPath);
      if (!file.existsSync()) continue;

      try {
        // Fade-in
        _player.setVolume(0.0);
        await _player.setFilePath(entry.localPath);
        await _player.setVolume(entry.volume);

        final duration = _player.duration ?? Duration.zero;
        _player.play();

        // Ждём окончания трека
        await _player.playerStateStream.firstWhere(
          (s) => s.processingState == ProcessingState.completed || _stopped,
        );

        totalDuration += duration;
        if (entry.isAffirmation) {
          affirmationsPlayed++;
        } else {
          triggersPlayed++;
        }

        // Пауза между треками
        if (!_stopped && entry != queue.last) {
          await Future.delayed(
            Duration(seconds: playlistModel.pauseBetweenSeconds),
          );
        }
      } catch (_) {
        // Пропускаем трек с ошибкой
        continue;
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

  Future<NightPlaylistModel?> _loadPlaylist(Isar isar) async {
    final models = await isar.nightPlaylistModels.where().findAll();
    return models.where((m) => m.isActive).firstOrNull ?? models.firstOrNull;
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
