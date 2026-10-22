// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'night_playlist_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNightPlaylistModelCollection on Isar {
  IsarCollection<NightPlaylistModel> get nightPlaylistModels =>
      this.collection();
}

const NightPlaylistModelSchema = CollectionSchema(
  name: r'NightPlaylistModel',
  id: 3675973644856959496,
  properties: {
    r'affirmationVolume': PropertySchema(
      id: 0,
      name: r'affirmationVolume',
      type: IsarType.double,
    ),
    r'entryItemIds': PropertySchema(
      id: 1,
      name: r'entryItemIds',
      type: IsarType.stringList,
    ),
    r'entryOrders': PropertySchema(
      id: 2,
      name: r'entryOrders',
      type: IsarType.longList,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 4,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'loop': PropertySchema(
      id: 5,
      name: r'loop',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'pauseBetweenSeconds': PropertySchema(
      id: 7,
      name: r'pauseBetweenSeconds',
      type: IsarType.long,
    ),
    r'playbackModeIndex': PropertySchema(
      id: 8,
      name: r'playbackModeIndex',
      type: IsarType.long,
    ),
    r'triggerVolume': PropertySchema(
      id: 9,
      name: r'triggerVolume',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _nightPlaylistModelEstimateSize,
  serialize: _nightPlaylistModelSerialize,
  deserialize: _nightPlaylistModelDeserialize,
  deserializeProp: _nightPlaylistModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _nightPlaylistModelGetId,
  getLinks: _nightPlaylistModelGetLinks,
  attach: _nightPlaylistModelAttach,
  version: '3.1.0+1',
);

int _nightPlaylistModelEstimateSize(
  NightPlaylistModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entryItemIds.length * 3;
  {
    for (var i = 0; i < object.entryItemIds.length; i++) {
      final value = object.entryItemIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.entryOrders.length * 8;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _nightPlaylistModelSerialize(
  NightPlaylistModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.affirmationVolume);
  writer.writeStringList(offsets[1], object.entryItemIds);
  writer.writeLongList(offsets[2], object.entryOrders);
  writer.writeString(offsets[3], object.id);
  writer.writeBool(offsets[4], object.isActive);
  writer.writeBool(offsets[5], object.loop);
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.pauseBetweenSeconds);
  writer.writeLong(offsets[8], object.playbackModeIndex);
  writer.writeDouble(offsets[9], object.triggerVolume);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

NightPlaylistModel _nightPlaylistModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NightPlaylistModel();
  object.affirmationVolume = reader.readDouble(offsets[0]);
  object.entryItemIds = reader.readStringList(offsets[1]) ?? [];
  object.entryOrders = reader.readLongList(offsets[2]) ?? [];
  object.id = reader.readString(offsets[3]);
  object.isActive = reader.readBool(offsets[4]);
  object.loop = reader.readBool(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.pauseBetweenSeconds = reader.readLong(offsets[7]);
  object.playbackModeIndex = reader.readLong(offsets[8]);
  object.triggerVolume = reader.readDouble(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _nightPlaylistModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nightPlaylistModelGetId(NightPlaylistModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _nightPlaylistModelGetLinks(
    NightPlaylistModel object) {
  return [];
}

void _nightPlaylistModelAttach(
    IsarCollection<dynamic> col, Id id, NightPlaylistModel object) {}

extension NightPlaylistModelQueryWhereSort
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QWhere> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NightPlaylistModelQueryWhere
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QWhereClause> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhereClause>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterWhereClause>
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

extension NightPlaylistModelQueryFilter
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QFilterCondition> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      affirmationVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'affirmationVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      affirmationVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'affirmationVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      affirmationVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'affirmationVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      affirmationVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'affirmationVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryItemIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entryItemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entryItemIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryItemIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entryItemIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryItemIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryItemIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryOrders',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryOrders',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      entryOrdersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryOrders',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      loopEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loop',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      pauseBetweenSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pauseBetweenSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      pauseBetweenSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pauseBetweenSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      pauseBetweenSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pauseBetweenSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      pauseBetweenSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pauseBetweenSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      playbackModeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playbackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      playbackModeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playbackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      playbackModeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playbackModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      playbackModeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playbackModeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      triggerVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      triggerVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      triggerVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      triggerVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterFilterCondition>
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

extension NightPlaylistModelQueryObject
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QFilterCondition> {}

extension NightPlaylistModelQueryLinks
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QFilterCondition> {}

extension NightPlaylistModelQuerySortBy
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QSortBy> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByAffirmationVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationVolume', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByAffirmationVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationVolume', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByLoopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByPauseBetweenSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseBetweenSeconds', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByPauseBetweenSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseBetweenSeconds', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playbackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playbackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByTriggerVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerVolume', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByTriggerVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerVolume', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NightPlaylistModelQuerySortThenBy
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QSortThenBy> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByAffirmationVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationVolume', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByAffirmationVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'affirmationVolume', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByLoopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loop', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByPauseBetweenSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseBetweenSeconds', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByPauseBetweenSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseBetweenSeconds', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playbackModeIndex', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByPlaybackModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playbackModeIndex', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByTriggerVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerVolume', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByTriggerVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerVolume', Sort.desc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NightPlaylistModelQueryWhereDistinct
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct> {
  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByAffirmationVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'affirmationVolume');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByEntryItemIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryItemIds');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByEntryOrders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryOrders');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByLoop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loop');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByPauseBetweenSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pauseBetweenSeconds');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByPlaybackModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playbackModeIndex');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByTriggerVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerVolume');
    });
  }

  QueryBuilder<NightPlaylistModel, NightPlaylistModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension NightPlaylistModelQueryProperty
    on QueryBuilder<NightPlaylistModel, NightPlaylistModel, QQueryProperty> {
  QueryBuilder<NightPlaylistModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<NightPlaylistModel, double, QQueryOperations>
      affirmationVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'affirmationVolume');
    });
  }

  QueryBuilder<NightPlaylistModel, List<String>, QQueryOperations>
      entryItemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryItemIds');
    });
  }

  QueryBuilder<NightPlaylistModel, List<int>, QQueryOperations>
      entryOrdersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryOrders');
    });
  }

  QueryBuilder<NightPlaylistModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NightPlaylistModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<NightPlaylistModel, bool, QQueryOperations> loopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loop');
    });
  }

  QueryBuilder<NightPlaylistModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<NightPlaylistModel, int, QQueryOperations>
      pauseBetweenSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pauseBetweenSeconds');
    });
  }

  QueryBuilder<NightPlaylistModel, int, QQueryOperations>
      playbackModeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playbackModeIndex');
    });
  }

  QueryBuilder<NightPlaylistModel, double, QQueryOperations>
      triggerVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerVolume');
    });
  }

  QueryBuilder<NightPlaylistModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
