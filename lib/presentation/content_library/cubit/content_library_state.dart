import 'package:equatable/equatable.dart';
import '../../../domain/entities/content_item.dart';
import '../../../domain/entities/content_type.dart';

enum ContentTab { affirmations, lucidTriggers }

extension ContentTabExt on ContentTab {
  ContentType get contentType => switch (this) {
    ContentTab.affirmations  => const ContentType.affirmation(category: AffirmationCategory.custom),
    ContentTab.lucidTriggers => const ContentType.lucidTrigger(technique: TriggerTechnique.mild),
  };

  String get label => switch (this) {
    ContentTab.affirmations  => 'Аффирмации',
    ContentTab.lucidTriggers => 'Триггеры осознанности',
  };
}

sealed class ContentLibraryState extends Equatable {
  final ContentTab activeTab;
  const ContentLibraryState(this.activeTab);
  @override List<Object?> get props => [activeTab];
}

class ContentLibraryLoading extends ContentLibraryState {
  const ContentLibraryLoading(super.activeTab);
}

class ContentLibraryLoaded extends ContentLibraryState {
  final List<ContentItem> affirmations;
  final List<ContentItem> lucidTriggers;

  const ContentLibraryLoaded({
    required ContentTab activeTab,
    required this.affirmations,
    required this.lucidTriggers,
  }) : super(activeTab);

  List<ContentItem> get activeList => switch (activeTab) {
    ContentTab.affirmations  => affirmations,
    ContentTab.lucidTriggers => lucidTriggers,
  };

  @override
  List<Object?> get props => [activeTab, affirmations, lucidTriggers];
}

class ContentLibraryError extends ContentLibraryState {
  final String message;
  const ContentLibraryError(super.activeTab, this.message);
  @override List<Object?> get props => [activeTab, message];
}
