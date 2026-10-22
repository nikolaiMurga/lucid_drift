// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepSessionModelCollection on Isar {
  IsarCollection<SleepSessionModel> get sleepSessionModels => this.collection();
}

const SleepSessionModelSchema = CollectionSchema(
  name: r'SleepSessionModel',
  id: -3504377838175565604,
  properties: {
    r'affirmationsPlayedCount': PropertySchema(
      id: 0,
      name: r'affirmationsPlayedCount',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'lucidityLevel': PropertySchema(
      id: 3,
      name: r'lucidityLevel',
      type: IsarType.byte,
      enumMap: _SleepSessionModellucidityLevelEnumValueMap,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'totalPlaybackMs': PropertySchema(
      id: 5,
      name: r'totalPlaybackMs',
      type: IsarType.long,
    ),
    r'triggeredAt': PropertySchema(
      id: 6,
      name: r'triggeredAt',
      type: IsarType.dateTime,
    ),
    r'triggersPlayedCount': PropertySchema(
      id: 7,
      name: r'triggersPlayedCount',
      type: IsarType.long,
    )
  },
  estimateSize: _sleepSessionModelEstimateSize,
  serialize: _sleepSessionModelSerialize,
  deserialize: _sleepSessionModelDeserialize,
  deserializeProp: _sleepSessionModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sleepSessionModelGetId,
  getLinks: _sleepSessionModelGetLinks,
  attach: _sleepSessionModelAttach,
  version: '3.1.0+1',
);

int _sleepSessionModelEstimateSize(
  SleepSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sleepSessionModelSerialize(
  SleepSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.affirmationsPlayedCount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.id);
  writer.writeByte(offsets[3], object.lucidityLevel.index);
  writer.writeString(offsets[4], object.notes);
  writer.writeLong(offsets[5], object.totalPlaybackMs);
  writer.writeDateTime(offsets[6], object.triggeredAt);
  writer.writeLong(offsets[7], object.triggersPlayedCount);
}

SleepSessionModel _sleepSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepSessionModel();
  object.affirmationsPlayedCount = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.lucidityLevel = _SleepSessionModellucidityLevelValueEnumMap[
          reader.readByteOrNull(offsets[3])] ??
      LucidityLevelEnum.none;
  object.notes = reader.readStringOrNull(offsets[4]);
  object.totalPlaybackMs = reader.readLong(offsets[5]);
  object.triggeredAt = reader.readDateTimeOrNull(offsets[6]);
  object.triggersPlayedCount = reader.readLong(offsets[7]);
  return object;
}

P _sleepSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_SleepSessionModellucidityLevelValueEnumMap[
              reader.readByteOrNull(offset)] ??
          LucidityLevelEnum.none) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SleepSessionModellucidityLevelEnumValueMap = {
  'none': 0,
  'partial': 1,
  'lucid': 2,
};
const _SleepSessionModellucidityLevelValueEnumMap = {
  0: LucidityLevelEnum.none,
  1: LucidityLevelEnum.partial,
  2: LucidityLevelEnum.lucid,
};

Id _sleepSessionModelGetId(SleepSessionModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sleepSessionModelGetLinks(
    SleepSessionModel object) {
  return [];
}

void _sleepSessionModelAttach(
    IsarCollection<dynamic> col, Id id, SleepSessionModel object) {}

extension SleepSessionModelQueryWhereSort
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QWhere> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SleepSessionModelQueryWhere
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QWhereClause> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhereClause>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterWhereClause>
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
}

extension SleepSessionModelQueryFilter
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QFilterCondition> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      affirmationsPlayedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'affirmationsPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      affirmationsPlayedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'affirmationsPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      affirmationsPlayedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'affirmationsPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      affirmationsPlayedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'affirmationsPlayedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
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

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      lucidityLevelEqualTo(LucidityLevelEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lucidityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      lucidityLevelGreaterThan(
    LucidityLevelEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lucidityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      lucidityLevelLessThan(
    LucidityLevelEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lucidityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      lucidityLevelBetween(
    LucidityLevelEnum lower,
    LucidityLevelEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lucidityLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      totalPlaybackMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPlaybackMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      totalPlaybackMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPlaybackMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      totalPlaybackMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPlaybackMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      totalPlaybackMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPlaybackMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggeredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggeredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggersPlayedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggersPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggersPlayedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggersPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggersPlayedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggersPlayedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterFilterCondition>
      triggersPlayedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggersPlayedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SleepSessionModelQueryObject
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QFilterCondition> {}

extension SleepSessionModelQueryLinks
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QFilterCondition> {}

extension SleepSessionModelQuerySortBy
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QSortBy> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByAffirmationsPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationsPlayedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByAffirmationsPlayedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationsPlayedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByLucidityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lucidityLevel', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByLucidityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lucidityLevel', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTotalPlaybackMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlaybackMs', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTotalPlaybackMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlaybackMs', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTriggersPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggersPlayedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      sortByTriggersPlayedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggersPlayedCount', Sort.desc);
    });
  }
}

extension SleepSessionModelQuerySortThenBy
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QSortThenBy> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByAffirmationsPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationsPlayedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByAffirmationsPlayedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationsPlayedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByLucidityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lucidityLevel', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByLucidityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lucidityLevel', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTotalPlaybackMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlaybackMs', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTotalPlaybackMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPlaybackMs', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTriggersPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggersPlayedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QAfterSortBy>
      thenByTriggersPlayedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggersPlayedCount', Sort.desc);
    });
  }
}

extension SleepSessionModelQueryWhereDistinct
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct> {
  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByAffirmationsPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'affirmationsPlayedCount');
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByLucidityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lucidityLevel');
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByTotalPlaybackMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPlaybackMs');
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggeredAt');
    });
  }

  QueryBuilder<SleepSessionModel, SleepSessionModel, QDistinct>
      distinctByTriggersPlayedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggersPlayedCount');
    });
  }
}

extension SleepSessionModelQueryProperty
    on QueryBuilder<SleepSessionModel, SleepSessionModel, QQueryProperty> {
  QueryBuilder<SleepSessionModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SleepSessionModel, int, QQueryOperations>
      affirmationsPlayedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'affirmationsPlayedCount');
    });
  }

  QueryBuilder<SleepSessionModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepSessionModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepSessionModel, LucidityLevelEnum, QQueryOperations>
      lucidityLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lucidityLevel');
    });
  }

  QueryBuilder<SleepSessionModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SleepSessionModel, int, QQueryOperations>
      totalPlaybackMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPlaybackMs');
    });
  }

  QueryBuilder<SleepSessionModel, DateTime?, QQueryOperations>
      triggeredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggeredAt');
    });
  }

  QueryBuilder<SleepSessionModel, int, QQueryOperations>
      triggersPlayedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggersPlayedCount');
    });
  }
}
