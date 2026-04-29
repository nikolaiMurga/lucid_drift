import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../domain/entities/content_item.dart';
import '../../../../domain/entities/content_type.dart';
import '../../../../domain/entities/audio_source.dart';
import '../../../../domain/entities/night_playlist.dart';
import '../../../../domain/usecases/content/content_usecases.dart';
import '../../../../domain/usecases/playlist/playlist_usecases.dart';
import 'content_library_state.dart';

class ContentLibraryCubit extends Cubit<ContentLibraryState> {
  final GetContentItemsUseCase _getItems;
  final DeleteContentItemUseCase _deleteItem;
  final AddToPlaylistUseCase _addToPlaylist;
  final RemoveFromPlaylistUseCase _removeFromPlaylist;
  final WatchPlaylistUseCase _watchPlaylist;
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<List<ContentItem>>? _affirmationsSub;
  StreamSubscription<List<ContentItem>>? _triggersSub;
  StreamSubscription<NightPlaylist?>? _playlistSub;

  List<ContentItem> _affirmations = [];
  List<ContentItem> _triggers = [];
  Set<String> _playlistIds = {};

  ContentLibraryCubit({
    required GetContentItemsUseCase getItems,
    required DeleteContentItemUseCase deleteItem,
    required AddToPlaylistUseCase addToPlaylist,
    required RemoveFromPlaylistUseCase removeFromPlaylist,
    required WatchPlaylistUseCase watchPlaylist,
  })  : _getItems = getItems,
        _deleteItem = deleteItem,
        _addToPlaylist = addToPlaylist,
        _removeFromPlaylist = removeFromPlaylist,
        _watchPlaylist = watchPlaylist,
        super(const ContentLibraryLoading(ContentTab.affirmations));

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
      _emitLoaded();
    });

    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _emitLoaded(clearPlaying: true);
      }
    });
  }

  void switchTab(ContentTab tab) {
    if (state.activeTab == tab) return;
    _emitLoaded(tab: tab);
  }

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

  Future<void> stopPlayback() async {
    await _player.stop();
    _emitLoaded(clearPlaying: true);
  }

  Future<void> delete(String itemId) async {
    final s = state;
    if (s is ContentLibraryLoaded && s.playingItemId == itemId) {
      await _player.stop();
    }
    await _deleteItem(itemId);
  }

  Future<void> addToPlaylist(String itemId) => _addToPlaylist(itemId);

  Future<void> removeFromPlaylist(String itemId) => _removeFromPlaylist(itemId);

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
    ));
  }

  @override
  Future<void> close() async {
    await _affirmationsSub?.cancel();
    await _triggersSub?.cancel();
    await _playlistSub?.cancel();
    await _player.dispose();
    return super.close();
  }
}
