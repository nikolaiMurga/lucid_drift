// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_item_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContentItemModelCollection on Isar {
  IsarCollection<ContentItemModel> get contentItemModels => this.collection();
}

const ContentItemModelSchema = CollectionSchema(
  name: r'ContentItemModel',
  id: -2983021699326847337,
  properties: {
    r'affirmationCategoryIndex': PropertySchema(
      id: 0,
      name: r'affirmationCategoryIndex',
      type: IsarType.long,
    ),
    r'audioDurationMs': PropertySchema(
      id: 1,
      name: r'audioDurationMs',
      type: IsarType.long,
    ),
    r'audioLocalPath': PropertySchema(
      id: 2,
      name: r'audioLocalPath',
      type: IsarType.string,
    ),
    r'audioSourceTypeIndex': PropertySchema(
      id: 3,
      name: r'audioSourceTypeIndex',
      type: IsarType.long,
    ),
    r'contentType': PropertySchema(
      id: 4,
      name: r'contentType',
      type: IsarType.byte,
      enumMap: _ContentItemModelcontentTypeEnumValueMap,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 7,
      name: r'text',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 8,
      name: r'title',
      type: IsarType.string,
    ),
    r'triggerTechniqueIndex': PropertySchema(
      id: 9,
      name: r'triggerTechniqueIndex',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _contentItemModelEstimateSize,
  serialize: _contentItemModelSerialize,
  deserialize: _contentItemModelDeserialize,
  deserializeProp: _contentItemModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _contentItemModelGetId,
  getLinks: _contentItemModelGetLinks,
  attach: _contentItemModelAttach,
  version: '3.1.0+1',
);

int _contentItemModelEstimateSize(
  ContentItemModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.audioLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _contentItemModelSerialize(
  ContentItemModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.affirmationCategoryIndex);
  writer.writeLong(offsets[1], object.audioDurationMs);
  writer.writeString(offsets[2], object.audioLocalPath);
  writer.writeLong(offsets[3], object.audioSourceTypeIndex);
  writer.writeByte(offsets[4], object.contentType.index);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.id);
  writer.writeString(offsets[7], object.text);
  writer.writeString(offsets[8], object.title);
  writer.writeLong(offsets[9], object.triggerTechniqueIndex);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

ContentItemModel _contentItemModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContentItemModel();
  object.affirmationCategoryIndex = reader.readLongOrNull(offsets[0]);
  object.audioDurationMs = reader.readLongOrNull(offsets[1]);
  object.audioLocalPath = reader.readStringOrNull(offsets[2]);
  object.audioSourceTypeIndex = reader.readLongOrNull(offsets[3]);
  object.contentType = _ContentItemModelcontentTypeValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      ContentTypeEnum.affirmation;
  object.createdAt = reader.readDateTime(offsets[5]);
  object.id = reader.readString(offsets[6]);
  object.text = reader.readString(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.triggerTechniqueIndex = reader.readLongOrNull(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _contentItemModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (_ContentItemModelcontentTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ContentTypeEnum.affirmation) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ContentItemModelcontentTypeEnumValueMap = {
  'affirmation': 0,
  'lucidTrigger': 1,
};
const _ContentItemModelcontentTypeValueEnumMap = {
  0: ContentTypeEnum.affirmation,
  1: ContentTypeEnum.lucidTrigger,
};

Id _contentItemModelGetId(ContentItemModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _contentItemModelGetLinks(ContentItemModel object) {
  return [];
}

void _contentItemModelAttach(
    IsarCollection<dynamic> col, Id id, ContentItemModel object) {}

extension ContentItemModelQueryWhereSort
    on QueryBuilder<ContentItemModel, ContentItemModel, QWhere> {
  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ContentItemModelQueryWhere
    on QueryBuilder<ContentItemModel, ContentItemModel, QWhereClause> {
  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ContentItemModelQueryFilter
    on QueryBuilder<ContentItemModel, ContentItemModel, QFilterCondition> {
  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'affirmationCategoryIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'affirmationCategoryIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'affirmationCategoryIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'affirmationCategoryIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'affirmationCategoryIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      affirmationCategoryIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'affirmationCategoryIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioDurationMs',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioDurationMs',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioDurationMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioDurationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioLocalPath',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioLocalPath',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioSourceTypeIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioSourceTypeIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioSourceTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioSourceTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioSourceTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      audioSourceTypeIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioSourceTypeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      contentTypeEqualTo(ContentTypeEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentType',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      contentTypeGreaterThan(
    ContentTypeEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentType',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      contentTypeLessThan(
    ContentTypeEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentType',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      contentTypeBetween(
    ContentTypeEnum lower,
    ContentTypeEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggerTechniqueIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggerTechniqueIndex',
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerTechniqueIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerTechniqueIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerTechniqueIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      triggerTechniqueIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerTechniqueIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ContentItemModelQueryObject
    on QueryBuilder<ContentItemModel, ContentItemModel, QFilterCondition> {}

extension ContentItemModelQueryLinks
    on QueryBuilder<ContentItemModel, ContentItemModel, QFilterCondition> {}

extension ContentItemModelQuerySortBy
    on QueryBuilder<ContentItemModel, ContentItemModel, QSortBy> {
  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAffirmationCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationCategoryIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAffirmationCategoryIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationCategoryIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioDurationMs', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioDurationMs', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioSourceTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSourceTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByAudioSourceTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSourceTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByTriggerTechniqueIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTechniqueIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByTriggerTechniqueIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTechniqueIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ContentItemModelQuerySortThenBy
    on QueryBuilder<ContentItemModel, ContentItemModel, QSortThenBy> {
  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAffirmationCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationCategoryIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAffirmationCategoryIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationCategoryIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioDurationMs', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioDurationMs', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioLocalPath', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioSourceTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSourceTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByAudioSourceTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioSourceTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByContentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentType', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByTriggerTechniqueIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTechniqueIndex', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByTriggerTechniqueIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerTechniqueIndex', Sort.desc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ContentItemModelQueryWhereDistinct
    on QueryBuilder<ContentItemModel, ContentItemModel, QDistinct> {
  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByAffirmationCategoryIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'affirmationCategoryIndex');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByAudioDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioDurationMs');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByAudioLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByAudioSourceTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioSourceTypeIndex');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByContentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentType');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByTriggerTechniqueIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerTechniqueIndex');
    });
  }

  QueryBuilder<ContentItemModel, ContentItemModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ContentItemModelQueryProperty
    on QueryBuilder<ContentItemModel, ContentItemModel, QQueryProperty> {
  QueryBuilder<ContentItemModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ContentItemModel, int?, QQueryOperations>
      affirmationCategoryIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'affirmationCategoryIndex');
    });
  }

  QueryBuilder<ContentItemModel, int?, QQueryOperations>
      audioDurationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioDurationMs');
    });
  }

  QueryBuilder<ContentItemModel, String?, QQueryOperations>
      audioLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioLocalPath');
    });
  }

  QueryBuilder<ContentItemModel, int?, QQueryOperations>
      audioSourceTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioSourceTypeIndex');
    });
  }

  QueryBuilder<ContentItemModel, ContentTypeEnum, QQueryOperations>
      contentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentType');
    });
  }

  QueryBuilder<ContentItemModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ContentItemModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ContentItemModel, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<ContentItemModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<ContentItemModel, int?, QQueryOperations>
      triggerTechniqueIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerTechniqueIndex');
    });
  }

  QueryBuilder<ContentItemModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
