import 'package:equatable/equatable.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/content_type.dart';

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

  const ContentLibraryLoaded(super.activeTab, {required this.affirmations, required this.lucidTriggers, this.playingItemId});

  List<ContentItem> get activeList => switch (activeTab) {
    ContentTab.affirmations => affirmations,
    ContentTab.lucidTriggers => lucidTriggers,
  };

  ContentLibraryLoaded copyWithPlaying(String? id) =>
      ContentLibraryLoaded(activeTab, affirmations: affirmations, lucidTriggers: lucidTriggers, playingItemId: id);

  @override
  List<Object?> get props => [activeTab, affirmations, lucidTriggers, playingItemId];
}

class ContentLibraryError extends ContentLibraryState {
  final String message;

  const ContentLibraryError(super.activeTab, this.message);

  @override
  List<Object?> get props => [activeTab, message];
}
