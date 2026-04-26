import 'package:isar/isar.dart';
import '../../domain/entities/content_item.dart';
import '../../domain/entities/content_type.dart';
import '../../domain/entities/audio_source.dart';

part 'content_item_model.g.dart';

// Isar 3 не поддерживает nullable @enumerated —
// опциональные enum-поля хранятся как int? (индекс значения)

enum ContentTypeEnum { affirmation, lucidTrigger }

@collection
class ContentItemModel {
  Id get isarId => fastHash(id);

  @Index()
  late String id;

  late String title;
  late String text;

  @enumerated
  late ContentTypeEnum contentType;

  // nullable enums stored as int? index (Isar 3 limitation)
  int? affirmationCategoryIndex;
  int? triggerTechniqueIndex;
  int? audioSourceTypeIndex;

  String? audioLocalPath;
  int? audioDurationMs;

  late DateTime createdAt;
  late DateTime updatedAt;

  // ---- mapping ----

  ContentItem toDomain() {
    final type = switch (contentType) {
      ContentTypeEnum.affirmation => ContentType.affirmation(
          category: AffirmationCategory.values[affirmationCategoryIndex ?? 0],
        ),
      ContentTypeEnum.lucidTrigger => ContentType.lucidTrigger(
          technique: TriggerTechnique.values[triggerTechniqueIndex ?? 0],
        ),
    };

    AudioSource? source;
    if (audioSourceTypeIndex != null && audioLocalPath != null) {
      source = AudioSource.ownRecording(localPath: audioLocalPath!);
    }

    return ContentItem(
      id: id,
      title: title,
      text: text,
      type: type,
      audioSource: source,
      audioDuration:
          audioDurationMs != null ? Duration(milliseconds: audioDurationMs!) : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ContentItemModel fromDomain(ContentItem item) {
    final model = ContentItemModel()
      ..id = item.id
      ..title = item.title
      ..text = item.text
      ..createdAt = item.createdAt
      ..updatedAt = item.updatedAt;

    switch (item.type) {
      case AffirmationContent(:final category):
        model.contentType = ContentTypeEnum.affirmation;
        model.affirmationCategoryIndex = category.index;
      case LucidTriggerContent(:final technique):
        model.contentType = ContentTypeEnum.lucidTrigger;
        model.triggerTechniqueIndex = technique.index;
    }

    switch (item.audioSource) {
      case OwnRecording(:final localPath):
        model.audioSourceTypeIndex = 0;
        model.audioLocalPath = localPath;
        model.audioDurationMs = item.audioDuration?.inMilliseconds;
      case null:
        break;
    }

    return model;
  }
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
