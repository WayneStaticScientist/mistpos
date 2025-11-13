// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shifts_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShiftsModelCollection on Isar {
  IsarCollection<ShiftsModel> get shiftsModels => this.collection();
}

const ShiftsModelSchema = CollectionSchema(
  name: r'ShiftsModel',
  id: 7685666414399568096,
  properties: {
    r'cashDrawerEnd': PropertySchema(
      id: 0,
      name: r'cashDrawerEnd',
      type: IsarType.double,
    ),
    r'cashDrawerStart': PropertySchema(
      id: 1,
      name: r'cashDrawerStart',
      type: IsarType.double,
    ),
    r'closeShiftTime': PropertySchema(
      id: 2,
      name: r'closeShiftTime',
      type: IsarType.dateTime,
    ),
    r'hexId': PropertySchema(
      id: 3,
      name: r'hexId',
      type: IsarType.string,
    ),
    r'openShiftTime': PropertySchema(
      id: 4,
      name: r'openShiftTime',
      type: IsarType.dateTime,
    ),
    r'salesQuantity': PropertySchema(
      id: 5,
      name: r'salesQuantity',
      type: IsarType.long,
    ),
    r'shiftIsClosed': PropertySchema(
      id: 6,
      name: r'shiftIsClosed',
      type: IsarType.bool,
    ),
    r'shiftLabel': PropertySchema(
      id: 7,
      name: r'shiftLabel',
      type: IsarType.string,
    ),
    r'synced': PropertySchema(
      id: 8,
      name: r'synced',
      type: IsarType.bool,
    ),
    r'totalCustomers': PropertySchema(
      id: 9,
      name: r'totalCustomers',
      type: IsarType.long,
    ),
    r'totalSales': PropertySchema(
      id: 10,
      name: r'totalSales',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(
      id: 11,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _shiftsModelEstimateSize,
  serialize: _shiftsModelSerialize,
  deserialize: _shiftsModelDeserialize,
  deserializeProp: _shiftsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _shiftsModelGetId,
  getLinks: _shiftsModelGetLinks,
  attach: _shiftsModelAttach,
  version: '3.1.0+1',
);

int _shiftsModelEstimateSize(
  ShiftsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hexId.length * 3;
  bytesCount += 3 + object.shiftLabel.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _shiftsModelSerialize(
  ShiftsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.cashDrawerEnd);
  writer.writeDouble(offsets[1], object.cashDrawerStart);
  writer.writeDateTime(offsets[2], object.closeShiftTime);
  writer.writeString(offsets[3], object.hexId);
  writer.writeDateTime(offsets[4], object.openShiftTime);
  writer.writeLong(offsets[5], object.salesQuantity);
  writer.writeBool(offsets[6], object.shiftIsClosed);
  writer.writeString(offsets[7], object.shiftLabel);
  writer.writeBool(offsets[8], object.synced);
  writer.writeLong(offsets[9], object.totalCustomers);
  writer.writeDouble(offsets[10], object.totalSales);
  writer.writeString(offsets[11], object.userId);
}

ShiftsModel _shiftsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShiftsModel(
    cashDrawerEnd: reader.readDouble(offsets[0]),
    cashDrawerStart: reader.readDouble(offsets[1]),
    closeShiftTime: reader.readDateTime(offsets[2]),
    hexId: reader.readStringOrNull(offsets[3]) ?? '',
    openShiftTime: reader.readDateTime(offsets[4]),
    salesQuantity: reader.readLongOrNull(offsets[5]) ?? 0,
    shiftIsClosed: reader.readBoolOrNull(offsets[6]) ?? false,
    shiftLabel: reader.readString(offsets[7]),
    synced: reader.readBoolOrNull(offsets[8]) ?? false,
    totalCustomers: reader.readLongOrNull(offsets[9]) ?? 0,
    totalSales: reader.readDoubleOrNull(offsets[10]) ?? 0,
    userId: reader.readString(offsets[11]),
  );
  object.id = id;
  return object;
}

P _shiftsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shiftsModelGetId(ShiftsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shiftsModelGetLinks(ShiftsModel object) {
  return [];
}

void _shiftsModelAttach(
    IsarCollection<dynamic> col, Id id, ShiftsModel object) {
  object.id = id;
}

extension ShiftsModelQueryWhereSort
    on QueryBuilder<ShiftsModel, ShiftsModel, QWhere> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShiftsModelQueryWhere
    on QueryBuilder<ShiftsModel, ShiftsModel, QWhereClause> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShiftsModelQueryFilter
    on QueryBuilder<ShiftsModel, ShiftsModel, QFilterCondition> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerEndEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashDrawerEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerEndGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashDrawerEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerEndLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashDrawerEnd',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerEndBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashDrawerEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerStartEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashDrawerStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerStartGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashDrawerStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerStartLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashDrawerStart',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      cashDrawerStartBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashDrawerStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      closeShiftTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closeShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      closeShiftTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'closeShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      closeShiftTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'closeShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      closeShiftTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closeShiftTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      hexIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hexId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      openShiftTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      openShiftTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      openShiftTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openShiftTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      openShiftTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openShiftTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      salesQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salesQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      salesQuantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salesQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      salesQuantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salesQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      salesQuantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salesQuantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftIsClosedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shiftIsClosed',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shiftLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shiftLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shiftLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shiftLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      shiftLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shiftLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> syncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'synced',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalCustomersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCustomers',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalCustomersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCustomers',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalCustomersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCustomers',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalCustomersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCustomers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalSalesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalSalesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalSalesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSales',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      totalSalesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension ShiftsModelQueryObject
    on QueryBuilder<ShiftsModel, ShiftsModel, QFilterCondition> {}

extension ShiftsModelQueryLinks
    on QueryBuilder<ShiftsModel, ShiftsModel, QFilterCondition> {}

extension ShiftsModelQuerySortBy
    on QueryBuilder<ShiftsModel, ShiftsModel, QSortBy> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerEnd', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByCashDrawerEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerEnd', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerStart', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByCashDrawerStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerStart', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closeShiftTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByCloseShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closeShiftTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openShiftTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByOpenShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openShiftTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesQuantity', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortBySalesQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesQuantity', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftIsClosed', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByShiftIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftIsClosed', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftLabel', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftLabel', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCustomers', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      sortByTotalCustomersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCustomers', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSales', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSales', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ShiftsModelQuerySortThenBy
    on QueryBuilder<ShiftsModel, ShiftsModel, QSortThenBy> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerEnd', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByCashDrawerEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerEnd', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerStart', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByCashDrawerStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashDrawerStart', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closeShiftTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByCloseShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closeShiftTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openShiftTime', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByOpenShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openShiftTime', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesQuantity', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenBySalesQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salesQuantity', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftIsClosed', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByShiftIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftIsClosed', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftLabel', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftLabel', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCustomers', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
      thenByTotalCustomersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCustomers', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSales', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSales', Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension ShiftsModelQueryWhereDistinct
    on QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> {
  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashDrawerEnd');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct>
      distinctByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashDrawerStart');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closeShiftTime');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByHexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openShiftTime');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salesQuantity');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftIsClosed');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByShiftLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCustomers');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSales');
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension ShiftsModelQueryProperty
    on QueryBuilder<ShiftsModel, ShiftsModel, QQueryProperty> {
  QueryBuilder<ShiftsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShiftsModel, double, QQueryOperations> cashDrawerEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashDrawerEnd');
    });
  }

  QueryBuilder<ShiftsModel, double, QQueryOperations>
      cashDrawerStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashDrawerStart');
    });
  }

  QueryBuilder<ShiftsModel, DateTime, QQueryOperations>
      closeShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closeShiftTime');
    });
  }

  QueryBuilder<ShiftsModel, String, QQueryOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexId');
    });
  }

  QueryBuilder<ShiftsModel, DateTime, QQueryOperations>
      openShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openShiftTime');
    });
  }

  QueryBuilder<ShiftsModel, int, QQueryOperations> salesQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salesQuantity');
    });
  }

  QueryBuilder<ShiftsModel, bool, QQueryOperations> shiftIsClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftIsClosed');
    });
  }

  QueryBuilder<ShiftsModel, String, QQueryOperations> shiftLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftLabel');
    });
  }

  QueryBuilder<ShiftsModel, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<ShiftsModel, int, QQueryOperations> totalCustomersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCustomers');
    });
  }

  QueryBuilder<ShiftsModel, double, QQueryOperations> totalSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSales');
    });
  }

  QueryBuilder<ShiftsModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
