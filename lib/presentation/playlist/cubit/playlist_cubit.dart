import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/audio_source.dart';
import '../../../domain/entities/night_playlist.dart';
import '../../../domain/repositories/content_item_repository.dart';
import '../../../domain/usecases/playlist/playlist_usecases.dart';
import 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final WatchPlaylistUseCase _watch;
  final RemoveFromPlaylistUseCase _remove;
  final ReorderPlaylistUseCase _reorder;
  final UpdatePlaylistSettingsUseCase _updateSettings;
  final ContentItemRepository _contentRepo;
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<NightPlaylist?>? _playlistSub;

  PlaylistCubit({
    required WatchPlaylistUseCase watch,
    required RemoveFromPlaylistUseCase remove,
    required ReorderPlaylistUseCase reorder,
    required UpdatePlaylistSettingsUseCase updateSettings,
    required ContentItemRepository contentRepo,
  }) : _watch = watch,
       _remove = remove,
       _reorder = reorder,
       _updateSettings = updateSettings,
       _contentRepo = contentRepo,
       super(const PlaylistLoading());

  void init() {
    _playlistSub = _watch().listen((playlist) async {
      if (playlist == null) {
        emit(
          PlaylistLoaded(
            playlist: NightPlaylist(id: 'main_playlist', name: 'Ночной плейлист', entries: const [], updatedAt: _epoch),
            resolvedItems: const [],
          ),
        );
        return;
      }
      await _resolve(playlist);
    }, onError: (e) => emit(PlaylistError(e.toString())));

    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _clearPlaying();
      }
    });
  }

  Future<void> _resolve(NightPlaylist playlist) async {
    final current = state;
    final currentPlayingId = current is PlaylistLoaded ? current.playingItemId : null;

    // Загружаем все ContentItem-ы в порядке entries
    final items = <ContentItem>[];
    for (final entry in playlist.entries) {
      final item = await _contentRepo.getById(entry.contentItemId);
      if (item != null) items.add(item);
    }

    emit(PlaylistLoaded(playlist: playlist, resolvedItems: items, playingItemId: currentPlayingId));
  }

  Future<void> removeItem(String contentItemId) async {
    final s = state;
    if (s is PlaylistLoaded && s.playingItemId == contentItemId) {
      await _player.stop();
    }
    await _remove(contentItemId);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final s = state;
    if (s is! PlaylistLoaded) return;

    final ids = s.resolvedItems.map((i) => i.id).toList();
    final moved = ids.removeAt(oldIndex);
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    ids.insert(insertAt, moved);
    await _reorder(ids);
  }

  Future<void> playItem(String itemId) async {
    final s = state;
    if (s is! PlaylistLoaded) return;

    if (s.playingItemId == itemId) {
      await stopPlayback();
      return;
    }

    final item = s.resolvedItems.where((i) => i.id == itemId).firstOrNull;
    if (item == null || item.audioSource is! OwnRecording) return;

    final path = (item.audioSource as OwnRecording).localPath;
    await _player.stop();
    await _player.setFilePath(path);
    await _player.play();

    emit(PlaylistLoaded(playlist: s.playlist, resolvedItems: s.resolvedItems, playingItemId: itemId));
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    _clearPlaying();
  }

  Future<void> updatePause(int seconds) => _updateSettings(pauseBetweenSeconds: seconds);

  Future<void> updateAffirmationVolume(double v) => _updateSettings(affirmationVolume: v);

  Future<void> updateTriggerVolume(double v) => _updateSettings(triggerVolume: v);

  Future<void> toggleLoop() async {
    final s = state;
    if (s is! PlaylistLoaded) return;
    await _updateSettings(loop: !s.playlist.loop);
  }

  Future<void> updatePlaybackMode(PlaybackMode mode) => _updateSettings(playbackMode: mode);

  void _clearPlaying() {
    final s = state;
    if (s is PlaylistLoaded) {
      emit(PlaylistLoaded(playlist: s.playlist, resolvedItems: s.resolvedItems, playingItemId: null));
    }
  }

  @override
  Future<void> close() async {
    await _playlistSub?.cancel();
    await _player.dispose();
    return super.close();
  }
}

// ignore: constant_identifier_names
final _epoch = DateTime.fromMillisecondsSinceEpoch(0);
