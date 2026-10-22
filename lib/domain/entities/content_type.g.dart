// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AffirmationContentImpl _$$AffirmationContentImplFromJson(
        Map<String, dynamic> json) =>
    _$AffirmationContentImpl(
      category: $enumDecode(_$AffirmationCategoryEnumMap, json['category']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AffirmationContentImplToJson(
        _$AffirmationContentImpl instance) =>
    <String, dynamic>{
      'category': _$AffirmationCategoryEnumMap[instance.category]!,
      'runtimeType': instance.$type,
    };

const _$AffirmationCategoryEnumMap = {
  AffirmationCategory.confidence: 'confidence',
  AffirmationCategory.health: 'health',
  AffirmationCategory.abundance: 'abundance',
  AffirmationCategory.relationships: 'relationships',
  AffirmationCategory.custom: 'custom',
};

_$LucidTriggerContentImpl _$$LucidTriggerContentImplFromJson(
        Map<String, dynamic> json) =>
    _$LucidTriggerContentImpl(
      technique: $enumDecode(_$TriggerTechniqueEnumMap, json['technique']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LucidTriggerContentImplToJson(
        _$LucidTriggerContentImpl instance) =>
    <String, dynamic>{
      'technique': _$TriggerTechniqueEnumMap[instance.technique]!,
      'runtimeType': instance.$type,
    };

const _$TriggerTechniqueEnumMap = {
  TriggerTechnique.mild: 'mild',
  TriggerTechnique.wild: 'wild',
  TriggerTechnique.realityCheck: 'realityCheck',
};
