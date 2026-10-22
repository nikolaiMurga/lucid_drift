import 'package:equatable/equatable.dart';

import 'content_item.dart';
import 'content_type.dart';

enum RemModuleType { trigger, affirmation }

/// Модуль таймлайна REM-цикла: триггер или аффирмация с паузой перед воспроизведением.
class RemModule extends Equatable {
  final RemModuleType type;
  final ContentItem? contentItem;

  /// Пауза перед воспроизведением этого модуля, в секундах.
  final int delaySeconds;

  const RemModule({required this.type, this.contentItem, this.delaySeconds = 0});

  RemModule copyWith({RemModuleType? type, ContentItem? contentItem, int? delaySeconds}) =>
      RemModule(
        type: type ?? this.type,
        contentItem: contentItem ?? this.contentItem,
        delaySeconds: delaySeconds ?? this.delaySeconds,
      );

  /// Сериализует модуль в Map. ContentItem хранится снэпшотом (id + title + duration).
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'contentItemId': contentItem?.id,
        'contentItemTitle': contentItem?.title,
        'contentItemDurationSeconds': contentItem?.audioDuration?.inSeconds,
        'delaySeconds': delaySeconds,
      };

  /// Восстанавливает модуль из Map. ContentItem реконструируется из снэпшота для отображения.
  static RemModule fromJson(Map<String, dynamic> json) {
    final moduleType =
        json['type'] == 'trigger' ? RemModuleType.trigger : RemModuleType.affirmation;
    final id = json['contentItemId'] as String?;
    final title = json['contentItemTitle'] as String?;
    final durSecs = json['contentItemDurationSeconds'] as int?;

    ContentItem? item;
    if (id != null && title != null) {
      item = ContentItem(
        id: id,
        title: title,
        text: '',
        type: moduleType == RemModuleType.trigger
            ? const ContentType.lucidTrigger(technique: TriggerTechnique.mild)
            : const ContentType.affirmation(category: AffirmationCategory.custom),
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        audioDuration: durSecs != null ? Duration(seconds: durSecs) : null,
      );
    }

    return RemModule(
      type: moduleType,
      contentItem: item,
      delaySeconds: json['delaySeconds'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [type, contentItem?.id, delaySeconds];
}

/// Конфигурация таймлайна одного REM-цикла: задержка старта и список модулей.
class CycleConfig extends Equatable {
  /// Задержка от старта REM-фазы до первого модуля, в минутах (0–30, шаг 5).
  final int startOffsetMins;
  final List<RemModule> modules;

  const CycleConfig({this.startOffsetMins = 0, this.modules = const []});

  CycleConfig copyWith({int? startOffsetMins, List<RemModule>? modules}) => CycleConfig(
        startOffsetMins: startOffsetMins ?? this.startOffsetMins,
        modules: modules ?? this.modules,
      );

  Map<String, dynamic> toJson() => {
        'startOffsetMins': startOffsetMins,
        'modules': modules.map((m) => m.toJson()).toList(),
      };

  static CycleConfig fromJson(Map<String, dynamic> json) => CycleConfig(
        startOffsetMins: json['startOffsetMins'] as int? ?? 0,
        modules: (json['modules'] as List<dynamic>? ?? [])
            .map((m) => RemModule.fromJson(m as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [startOffsetMins, modules];
}
