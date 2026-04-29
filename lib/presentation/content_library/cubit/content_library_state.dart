import 'package:equatable/equatable.dart';
import '../../../domain/entities/content_item.dart';

enum ContentTab { affirmations, lucidTriggers }

extension ContentTabExt on ContentTab {
  String get label => switch (this) {
        ContentTab.affirmations => 'Аффирмации',
        ContentTab.lucidTriggers => 'Триггеры осознанности',
      };
}

sealed class ContentLibraryState extends Equatable {
  final ContentTab activeTab;
  const ContentLibraryState(this.activeTab);
  @override
  List<Object?> get props => [activeTab];
}

class ContentLibraryLoading extends ContentLibraryState {
  const ContentLibraryLoading(super.activeTab);
}

class ContentLibraryLoaded extends ContentLibraryState {
  final List<ContentItem> affirmations;
  final List<ContentItem> lucidTriggers;
  final String? playingItemId;

  /// ids треков которые уже в плейлисте
  final Set<String> playlistItemIds;

  const ContentLibraryLoaded(
    super.activeTab, {
    required this.affirmations,
    required this.lucidTriggers,
    this.playingItemId,
    this.playlistItemIds = const {},
  });

  List<ContentItem> get activeList => switch (activeTab) {
        ContentTab.affirmations => affirmations,
        ContentTab.lucidTriggers => lucidTriggers,
      };

  bool isInPlaylist(String id) => playlistItemIds.contains(id);

  ContentLibraryLoaded copyWith({
    ContentTab? activeTab,
    List<ContentItem>? affirmations,
    List<ContentItem>? lucidTriggers,
    String? playingItemId,
    bool clearPlaying = false,
    Set<String>? playlistItemIds,
  }) =>
      ContentLibraryLoaded(
        activeTab ?? this.activeTab,
        affirmations: affirmations ?? this.affirmations,
        lucidTriggers: lucidTriggers ?? this.lucidTriggers,
        playingItemId: clearPlaying ? null : (playingItemId ?? this.playingItemId),
        playlistItemIds: playlistItemIds ?? this.playlistItemIds,
      );

  @override
  List<Object?> get props =>
      [activeTab, affirmations, lucidTriggers, playingItemId, playlistItemIds];
}

class ContentLibraryError extends ContentLibraryState {
  final String message;
  const ContentLibraryError(super.activeTab, this.message);
  @override
  List<Object?> get props => [activeTab, message];
}
