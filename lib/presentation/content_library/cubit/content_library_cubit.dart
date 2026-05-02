import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../domain/entities/content_item.dart';
import '../../../../domain/entities/content_type.dart';
import '../../../../domain/entities/audio_source.dart';
import '../../../../domain/entities/night_playlist.dart';
import '../../../../domain/entities/sleep_schedule.dart';
import '../../../../domain/usecases/content/content_usecases.dart';
import '../../../../domain/usecases/playlist/playlist_usecases.dart';
import '../../../../domain/usecases/schedule/schedule_usecases.dart';
import 'content_library_state.dart';

class ContentLibraryCubit extends Cubit<ContentLibraryState> {
  final GetContentItemsUseCase _getItems;
  final DeleteContentItemUseCase _deleteItem;
  final AddToPlaylistUseCase _addToPlaylist;
  final RemoveFromPlaylistUseCase _removeFromPlaylist;
  final WatchPlaylistUseCase _watchPlaylist;
  final UpdatePlaylistSettingsUseCase _updatePlaylistSettings;
  final GetSleepScheduleUseCase _getSchedule;
  final SaveSleepScheduleUseCase _saveSchedule;
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<List<ContentItem>>? _affirmationsSub;
  StreamSubscription<List<ContentItem>>? _triggersSub;
  StreamSubscription<NightPlaylist?>? _playlistSub;
  StreamSubscription<SleepSchedule?>? _scheduleSub;

  List<ContentItem> _affirmations = [];
  List<ContentItem> _triggers = [];
  Set<String> _playlistIds = {};
  double _affirmationVolume = 0.3;
  double _triggerVolume = 0.45;
  SchedulePlaybackMode _affirmationPlaybackMode = SchedulePlaybackMode.fullPhase;
  SchedulePlaybackMode _triggerPlaybackMode = SchedulePlaybackMode.midPhase3x;
  SleepSchedule? _currentSchedule;

  ContentLibraryCubit({
    required GetContentItemsUseCase getItems,
    required DeleteContentItemUseCase deleteItem,
    required AddToPlaylistUseCase addToPlaylist,
    required RemoveFromPlaylistUseCase removeFromPlaylist,
    required WatchPlaylistUseCase watchPlaylist,
    required UpdatePlaylistSettingsUseCase updatePlaylistSettings,
    required GetSleepScheduleUseCase getSchedule,
    required SaveSleepScheduleUseCase saveSchedule,
  })  : _getItems = getItems,
        _deleteItem = deleteItem,
        _addToPlaylist = addToPlaylist,
        _removeFromPlaylist = removeFromPlaylist,
        _watchPlaylist = watchPlaylist,
        _updatePlaylistSettings = updatePlaylistSettings,
        _getSchedule = getSchedule,
        _saveSchedule = saveSchedule,
        super(const ContentLibraryLoading(ContentTab.affirmations));

  /// Инициализирует подписки на потоки контента, плейлиста и расписания.
  void init() {
    _affirmationsSub = _getItems(
      filterType: const ContentType.affirmation(category: AffirmationCategory.custom),
    ).listen(
      (items) { _affirmations = items; _emitLoaded(); },
      onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())),
    );

    _triggersSub = _getItems(
      filterType: const ContentType.lucidTrigger(technique: TriggerTechnique.mild),
    ).listen(
      (items) { _triggers = items; _emitLoaded(); },
      onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())),
    );

    _playlistSub = _watchPlaylist().listen((playlist) {
      _playlistIds = playlist?.entries.map((e) => e.contentItemId).toSet() ?? {};
      _affirmationVolume = playlist?.affirmationVolume ?? 0.3;
      _triggerVolume = playlist?.triggerVolume ?? 0.45;
      _emitLoaded();
    });

    _scheduleSub = _getSchedule().listen((schedule) {
      _currentSchedule = schedule;
      if (schedule != null) {
        _affirmationPlaybackMode = schedule.affirmationPlaybackMode;
        _triggerPlaybackMode = schedule.triggerPlaybackMode;
      }
      _emitLoaded();
    });

    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _emitLoaded(clearPlaying: true);
      }
    });
  }

  /// Переключает активную вкладку (аффирмации / триггеры).
  void switchTab(ContentTab tab) {
    if (state.activeTab == tab) return;
    _emitLoaded(tab: tab);
  }

  /// Запускает или останавливает предпрослушивание трека.
  Future<void> playItem(String itemId) async {
    final s = state;
    if (s is! ContentLibraryLoaded) return;

    if (s.playingItemId == itemId) {
      await stopPlayback();
      return;
    }

    final item = [..._affirmations, ..._triggers]
        .where((i) => i.id == itemId)
        .firstOrNull;
    if (item?.audioSource is! OwnRecording) return;

    final path = (item!.audioSource as OwnRecording).localPath;
    await _player.stop();
    await _player.setFilePath(path);
    await _player.play();
    _emitLoaded(playingId: itemId);
  }

  /// Останавливает предпрослушивание.
  Future<void> stopPlayback() async {
    await _player.stop();
    _emitLoaded(clearPlaying: true);
  }

  /// Удаляет элемент контента.
  Future<void> delete(String itemId) async {
    final s = state;
    if (s is ContentLibraryLoaded && s.playingItemId == itemId) {
      await _player.stop();
    }
    await _deleteItem(itemId);
  }

  /// Добавляет трек в плейлист.
  Future<void> addToPlaylist(String itemId) => _addToPlaylist(itemId);

  /// Убирает трек из плейлиста.
  Future<void> removeFromPlaylist(String itemId) => _removeFromPlaylist(itemId);

  /// Обновляет громкость аффирмаций (0.0–1.0) и сохраняет в плейлист.
  Future<void> updateAffirmationVolume(double volume) async {
    _affirmationVolume = volume;
    _emitLoaded();
    await _updatePlaylistSettings(affirmationVolume: volume);
  }

  /// Обновляет громкость триггеров (0.0–1.0) и сохраняет в плейлист.
  Future<void> updateTriggerVolume(double volume) async {
    _triggerVolume = volume;
    _emitLoaded();
    await _updatePlaylistSettings(triggerVolume: volume);
  }

  /// Обновляет режим воспроизведения аффирмаций и сохраняет в расписание.
  Future<void> updateAffirmationPlaybackMode(SchedulePlaybackMode mode) async {
    _affirmationPlaybackMode = mode;
    _emitLoaded();
    final schedule = _currentSchedule;
    if (schedule == null) return;
    await _saveSchedule(SleepSchedule(
      id: schedule.id,
      bedTime: schedule.bedTime,
      wakeTime: schedule.wakeTime,
      activeDays: schedule.activeDays,
      targetCycles: schedule.targetCycles,
      affirmationPlaybackMode: mode,
      triggerPlaybackMode: schedule.triggerPlaybackMode,
      isActive: schedule.isActive,
      wbtbMode: schedule.wbtbMode,
      wbtbAwakeMins: schedule.wbtbAwakeMins,
    ));
  }

  /// Обновляет режим воспроизведения триггеров и сохраняет в расписание.
  Future<void> updateTriggerPlaybackMode(SchedulePlaybackMode mode) async {
    _triggerPlaybackMode = mode;
    _emitLoaded();
    final schedule = _currentSchedule;
    if (schedule == null) return;
    await _saveSchedule(SleepSchedule(
      id: schedule.id,
      bedTime: schedule.bedTime,
      wakeTime: schedule.wakeTime,
      activeDays: schedule.activeDays,
      targetCycles: schedule.targetCycles,
      affirmationPlaybackMode: schedule.affirmationPlaybackMode,
      triggerPlaybackMode: mode,
      isActive: schedule.isActive,
      wbtbMode: schedule.wbtbMode,
      wbtbAwakeMins: schedule.wbtbAwakeMins,
    ));
  }

  String? get playingItemId {
    final s = state;
    return s is ContentLibraryLoaded ? s.playingItemId : null;
  }

  void _emitLoaded({ContentTab? tab, String? playingId, bool clearPlaying = false}) {
    final current = state;
    final currentPlaying =
        current is ContentLibraryLoaded ? current.playingItemId : null;
    emit(ContentLibraryLoaded(
      tab ?? current.activeTab,
      affirmations: _affirmations,
      lucidTriggers: _triggers,
      playingItemId: clearPlaying ? null : (playingId ?? currentPlaying),
      playlistItemIds: _playlistIds,
      affirmationVolume: _affirmationVolume,
      triggerVolume: _triggerVolume,
      affirmationPlaybackMode: _affirmationPlaybackMode,
      triggerPlaybackMode: _triggerPlaybackMode,
    ));
  }

  @override
  Future<void> close() async {
    await _affirmationsSub?.cancel();
    await _triggersSub?.cancel();
    await _playlistSub?.cancel();
    await _scheduleSub?.cancel();
    await _player.dispose();
    return super.close();
  }
}
