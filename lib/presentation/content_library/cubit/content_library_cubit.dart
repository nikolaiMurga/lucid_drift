import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../domain/entities/content_item.dart';
import '../../../../domain/entities/content_type.dart';
import '../../../../domain/entities/audio_source.dart';
import '../../../../domain/usecases/content/content_usecases.dart';
import 'content_library_state.dart';

class ContentLibraryCubit extends Cubit<ContentLibraryState> {
  final GetContentItemsUseCase _getItems;
  final DeleteContentItemUseCase _deleteItem;
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<List<ContentItem>>? _affirmationsSub;
  StreamSubscription<List<ContentItem>>? _triggersSub;

  List<ContentItem> _affirmations = [];
  List<ContentItem> _triggers = [];

  ContentLibraryCubit({required GetContentItemsUseCase getItems, required DeleteContentItemUseCase deleteItem})
    : _getItems = getItems,
      _deleteItem = deleteItem,
      super(const ContentLibraryLoading(ContentTab.affirmations));

  void init() {
    _affirmationsSub = _getItems(filterType: const ContentType.affirmation(category: AffirmationCategory.custom)).listen((items) {
      _affirmations = items;
      _emitLoaded();
    }, onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())));

    _triggersSub = _getItems(filterType: const ContentType.lucidTrigger(technique: TriggerTechnique.mild)).listen((items) {
      _triggers = items;
      _emitLoaded();
    }, onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())));

    // Сбрасываем playingItemId когда плеер завершил
    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed) {
        _emitLoaded(playingId: null);
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

    // Если уже играет этот — стоп
    if (s.playingItemId == itemId) {
      await stopPlayback();
      return;
    }

    final allItems = [..._affirmations, ..._triggers];
    final item = allItems.where((i) => i.id == itemId).firstOrNull;
    if (item == null || !item.hasAudio) return;

    final source = item.audioSource;
    if (source is! OwnRecording) return;

    await _player.stop();
    await _player.setFilePath(source.localPath);
    await _player.play();

    _emitLoaded(playingId: itemId);
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    _emitLoaded(playingId: null);
  }

  Future<void> delete(String itemId) async {
    // Если удаляем играющий трек — стоп
    final s = state;
    if (s is ContentLibraryLoaded && s.playingItemId == itemId) {
      await _player.stop();
    }
    await _deleteItem(itemId);
  }

  String? get playingItemId {
    final s = state;
    return s is ContentLibraryLoaded ? s.playingItemId : null;
  }

  void _emitLoaded({ContentTab? tab, String? playingId, bool clearPlaying = false}) {
    final current = state;
    final currentPlaying = current is ContentLibraryLoaded ? current.playingItemId : null;
    emit(
      ContentLibraryLoaded(
        tab ?? current.activeTab,
        affirmations: _affirmations,
        lucidTriggers: _triggers,
        playingItemId: clearPlaying ? null : (playingId ?? currentPlaying),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _affirmationsSub?.cancel();
    await _triggersSub?.cancel();
    await _player.dispose();
    return super.close();
  }
}
