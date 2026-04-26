import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/content_type.dart';
import '../../../domain/usecases/content/content_usecases.dart';
import 'content_library_state.dart';

class ContentLibraryCubit extends Cubit<ContentLibraryState> {
  final GetContentItemsUseCase _getItems;
  final DeleteContentItemUseCase _deleteItem;

  StreamSubscription<List<ContentItem>>? _affirmationsSub;
  StreamSubscription<List<ContentItem>>? _triggersSub;

  List<ContentItem> _affirmations = [];
  List<ContentItem> _triggers = [];

  ContentLibraryCubit({
    required GetContentItemsUseCase getItems,
    required DeleteContentItemUseCase deleteItem,
  })  : _getItems = getItems,
        _deleteItem = deleteItem,
        super(const ContentLibraryLoading(ContentTab.affirmations));

  void init() {
    _affirmationsSub = _getItems(
      filterType: const ContentType.affirmation(category: AffirmationCategory.custom),
    ).listen((items) {
      _affirmations = items;
      _emitLoaded();
    }, onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())));

    _triggersSub = _getItems(
      filterType: const ContentType.lucidTrigger(technique: TriggerTechnique.mild),
    ).listen((items) {
      _triggers = items;
      _emitLoaded();
    }, onError: (e) => emit(ContentLibraryError(state.activeTab, e.toString())));
  }

  void switchTab(ContentTab tab) {
    if (state.activeTab == tab) return;
    _emitLoaded(tab: tab);
  }

  Future<void> delete(String itemId) async {
    await _deleteItem(itemId);
  }

  void _emitLoaded({ContentTab? tab}) {
    emit(ContentLibraryLoaded(
      activeTab: tab ?? state.activeTab,
      affirmations: _affirmations,
      lucidTriggers: _triggers,
    ));
  }

  @override
  Future<void> close() {
    _affirmationsSub?.cancel();
    _triggersSub?.cancel();
    return super.close();
  }
}
