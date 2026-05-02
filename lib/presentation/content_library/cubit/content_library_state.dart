import 'package:equatable/equatable.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/sleep_schedule.dart';

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

  /// Громкость аффирмаций (0.0–1.0)
  final double affirmationVolume;

  /// Громкость триггеров (0.0–1.0)
  final double triggerVolume;

  /// Режим воспроизведения для аффирмаций (фазы 1–3)
  final SchedulePlaybackMode affirmationPlaybackMode;

  /// Режим воспроизведения для триггеров (фазы 4–5)
  final SchedulePlaybackMode triggerPlaybackMode;

  const ContentLibraryLoaded(
    super.activeTab, {
    required this.affirmations,
    required this.lucidTriggers,
    this.playingItemId,
    this.playlistItemIds = const {},
    this.affirmationVolume = 0.3,
    this.triggerVolume = 0.45,
    this.affirmationPlaybackMode = SchedulePlaybackMode.fullPhase,
    this.triggerPlaybackMode = SchedulePlaybackMode.midPhase3x,
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
    double? affirmationVolume,
    double? triggerVolume,
    SchedulePlaybackMode? affirmationPlaybackMode,
    SchedulePlaybackMode? triggerPlaybackMode,
  }) =>
      ContentLibraryLoaded(
        activeTab ?? this.activeTab,
        affirmations: affirmations ?? this.affirmations,
        lucidTriggers: lucidTriggers ?? this.lucidTriggers,
        playingItemId: clearPlaying ? null : (playingItemId ?? this.playingItemId),
        playlistItemIds: playlistItemIds ?? this.playlistItemIds,
        affirmationVolume: affirmationVolume ?? this.affirmationVolume,
        triggerVolume: triggerVolume ?? this.triggerVolume,
        affirmationPlaybackMode: affirmationPlaybackMode ?? this.affirmationPlaybackMode,
        triggerPlaybackMode: triggerPlaybackMode ?? this.triggerPlaybackMode,
      );

  @override
  List<Object?> get props => [
        activeTab, affirmations, lucidTriggers, playingItemId, playlistItemIds,
        affirmationVolume, triggerVolume, affirmationPlaybackMode, triggerPlaybackMode,
      ];
}

class ContentLibraryError extends ContentLibraryState {
  final String message;
  const ContentLibraryError(super.activeTab, this.message);
  @override
  List<Object?> get props => [activeTab, message];
}
