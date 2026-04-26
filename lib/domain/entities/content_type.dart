import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_type.freezed.dart';
part 'content_type.g.dart';

enum AffirmationCategory {
  confidence,
  health,
  abundance,
  relationships,
  custom,
}

enum TriggerTechnique {
  mild,       // «это сон, я осознаю что сплю»
  wild,       // счёт 1–10, удержание осознанности
  realityCheck, // «посмотри на руки»
}

@freezed
sealed class ContentType with _$ContentType {
  const factory ContentType.affirmation({
    required AffirmationCategory category,
  }) = AffirmationContent;

  const factory ContentType.lucidTrigger({
    required TriggerTechnique technique,
  }) = LucidTriggerContent;

  factory ContentType.fromJson(Map<String, dynamic> json) =>
      _$ContentTypeFromJson(json);
}
