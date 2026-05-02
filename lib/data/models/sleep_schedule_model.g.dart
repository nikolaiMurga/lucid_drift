// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_schedule_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepScheduleModelCollection on Isar {
  IsarCollection<SleepScheduleModel> get sleepScheduleModels =>
      this.collection();
}

const SleepScheduleModelSchema = CollectionSchema(
  name: r'SleepScheduleModel',
  id: 9106026428375216609,
  properties: {
    r'activeDays': PropertySchema(
      id: 0,
      name: r'activeDays',
      type: IsarType.longList,
    ),
    r'affirmationPlaybackModeIndex': PropertySchema(
      id: 1,
      name: r'affirmationPlaybackModeIndex',
      type: IsarType.long,
    ),
    r'bedTimeHour': PropertySchema(
      id: 2,
      name: r'bedTimeHour',
      type: IsarType.long,
    ),
    r'bedTimeMinute': PropertySchema(
      id: 3,
      name: r'bedTimeMinute',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 5,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'targetCycleIndices': PropertySchema(
      id: 6,
      name: r'targetCycleIndices',
      type: IsarType.longList,
    ),
    r'triggerPlaybackModeIndex': PropertySchema(
      id: 7,
      name: r'triggerPlaybackModeIndex',
      type: IsarType.long,
    ),
    r'wakeTimeHour': PropertySchema(
      id: 8,
      name: r'wakeTimeHour',
      type: IsarType.long,
    ),
    r'wakeTimeMinute': PropertySchema(
      id: 9,
      name: r'wakeTimeMinute',
      type: IsarType.long,
    ),
    r'wbtbAwakeMins': PropertySchema(
      id: 10,
      name: r'wbtbAwakeMins',
      type: IsarType.long,
    ),
    r'wbtbMode': PropertySchema(
      id: 11,
      name: r'wbtbMode',
      type: IsarType.bool,
    )
  },
  estimateSize: _sleepScheduleModelEstimateSize,
  serialize: _sleepScheduleModelSerialize,
  deserialize: _sleepScheduleModelDeserialize,
  deserializeProp: _sleepScheduleModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sleepScheduleModelGetId,
  getLinks: _sleepScheduleModelGetLinks,
  attach: _sleepScheduleModelAttach,
  version: '3.1.0+1',
);

int _sleepScheduleModelEstimateSize(
  SleepScheduleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activeDays.length * 8;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.targetCycleIndices.length * 8;
  return bytesCount;
}

void _sleepScheduleModelSerialize(
  SleepScheduleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.activeDays);
  writer.writeLong(offsets[1], object.affirmationPlaybackModeIndex);
  writer.writeLong(offsets[2], object.bedTimeHour);
  writer.writeLong(offsets[3], object.bedTimeMinute);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeLongList(offsets[6], object.targetCycleIndices);
  writer.writeLong(offsets[7], object.triggerPlaybackModeIndex);
  writer.writeLong(offsets[8], object.wakeTimeHour);
  writer.writeLong(offsets[9], object.wakeTimeMinute);
  writer.writeLong(offsets[10], object.wbtbAwakeMins);
  writer.writeBool(offsets[11], object.wbtbMode);
}

SleepScheduleModel _sleepScheduleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepScheduleModel();
  object.activeDays = reader.readLongList(offsets[0]) ?? [];
  object.affirmationPlaybackModeIndex = reader.readLong(offsets[1]);
  object.bedTimeHour = reader.readLong(offsets[2]);
  object.bedTimeMinute = reader.readLong(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isActive = reader.readBool(offsets[5]);
  object.targetCycleIndices = reader.readLongList(offsets[6]) ?? [];
  object.triggerPlaybackModeIndex = reader.readLong(offsets[7]);
  object.wakeTimeHour = reader.readLong(offsets[8]);
  object.wakeTimeMinute = reader.readLong(offsets[9]);
  object.wbtbAwakeMins = reader.readLong(offsets[10]);
  object.wbtbMode = reader.readBool(offsets[11]);
  return object;
}

P _sleepScheduleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepScheduleModelGetId(SleepScheduleModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sleepScheduleModelGetLinks(
    SleepScheduleModel object) {
  return [];
}

void _sleepScheduleModelAttach(
    IsarCollection<dynamic> col, Id id, SleepScheduleModel object) {}

extension SleepScheduleModelQueryWhereSort
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QWhere> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SleepScheduleModelQueryWhere
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QWhereClause> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhereClause>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterWhereClause>
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

extension SleepScheduleModelQueryFilter
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QFilterCondition> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      activeDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      affirmationPlaybackModeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'affirmationPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      affirmationPlaybackModeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'affirmationPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      affirmationPlaybackModeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'affirmationPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      affirmationPlaybackModeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'affirmationPlaybackModeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedTimeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      bedTimeMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedTimeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
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

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCycleIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCycleIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCycleIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCycleIndices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      targetCycleIndicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetCycleIndices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      triggerPlaybackModeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      triggerPlaybackModeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      triggerPlaybackModeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerPlaybackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      triggerPlaybackModeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerPlaybackModeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTimeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wakeTimeMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTimeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wbtbAwakeMinsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wbtbAwakeMins',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wbtbAwakeMinsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wbtbAwakeMins',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wbtbAwakeMinsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wbtbAwakeMins',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wbtbAwakeMinsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wbtbAwakeMins',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterFilterCondition>
      wbtbModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wbtbMode',
        value: value,
      ));
    });
  }
}

extension SleepScheduleModelQueryObject
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QFilterCondition> {}

extension SleepScheduleModelQueryLinks
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QFilterCondition> {}

extension SleepScheduleModelQuerySortBy
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QSortBy> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByAffirmationPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationPlaybackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByAffirmationPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationPlaybackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByBedTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeHour', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByBedTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeHour', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByBedTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByBedTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeMinute', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByTriggerPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerPlaybackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByTriggerPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerPlaybackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWakeTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWakeTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWbtbAwakeMins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbAwakeMins', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWbtbAwakeMinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbAwakeMins', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWbtbMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbMode', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      sortByWbtbModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbMode', Sort.desc);
    });
  }
}

extension SleepScheduleModelQuerySortThenBy
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QSortThenBy> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByAffirmationPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationPlaybackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByAffirmationPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationPlaybackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByBedTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeHour', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByBedTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeHour', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByBedTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByBedTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTimeMinute', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByTriggerPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerPlaybackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByTriggerPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerPlaybackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWakeTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWakeTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWbtbAwakeMins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbAwakeMins', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWbtbAwakeMinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbAwakeMins', Sort.desc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWbtbMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbMode', Sort.asc);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QAfterSortBy>
      thenByWbtbModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wbtbMode', Sort.desc);
    });
  }
}

extension SleepScheduleModelQueryWhereDistinct
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct> {
  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByActiveDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeDays');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByAffirmationPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'affirmationPlaybackModeIndex');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByBedTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedTimeHour');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByBedTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedTimeMinute');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByTargetCycleIndices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetCycleIndices');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByTriggerPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerPlaybackModeIndex');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTimeHour');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTimeMinute');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByWbtbAwakeMins() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wbtbAwakeMins');
    });
  }

  QueryBuilder<SleepScheduleModel, SleepScheduleModel, QDistinct>
      distinctByWbtbMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wbtbMode');
    });
  }
}

extension SleepScheduleModelQueryProperty
    on QueryBuilder<SleepScheduleModel, SleepScheduleModel, QQueryProperty> {
  QueryBuilder<SleepScheduleModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SleepScheduleModel, List<int>, QQueryOperations>
      activeDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeDays');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      affirmationPlaybackModeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'affirmationPlaybackModeIndex');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      bedTimeHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedTimeHour');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      bedTimeMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedTimeMinute');
    });
  }

  QueryBuilder<SleepScheduleModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepScheduleModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<SleepScheduleModel, List<int>, QQueryOperations>
      targetCycleIndicesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetCycleIndices');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      triggerPlaybackModeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerPlaybackModeIndex');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      wakeTimeHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTimeHour');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      wakeTimeMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTimeMinute');
    });
  }

  QueryBuilder<SleepScheduleModel, int, QQueryOperations>
      wbtbAwakeMinsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wbtbAwakeMins');
    });
  }

  QueryBuilder<SleepScheduleModel, bool, QQueryOperations> wbtbModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wbtbMode');
    });
  }
}
