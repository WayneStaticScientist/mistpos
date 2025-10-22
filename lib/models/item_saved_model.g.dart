// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_saved_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ItemSavedModelSchema = Schema(
  name: r'ItemSavedModel',
  id: 6921338431040609099,
  properties: {
    r'addenum': PropertySchema(
      id: 0,
      name: r'addenum',
      type: IsarType.double,
    ),
    r'count': PropertySchema(
      id: 1,
      name: r'count',
      type: IsarType.long,
    ),
    r'dataMap': PropertySchema(
      id: 2,
      name: r'dataMap',
      type: IsarType.stringList,
    ),
    r'qouted': PropertySchema(
      id: 3,
      name: r'qouted',
      type: IsarType.double,
    )
  },
  estimateSize: _itemSavedModelEstimateSize,
  serialize: _itemSavedModelSerialize,
  deserialize: _itemSavedModelDeserialize,
  deserializeProp: _itemSavedModelDeserializeProp,
);

int _itemSavedModelEstimateSize(
  ItemSavedModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataMap.length * 3;
  {
    for (var i = 0; i < object.dataMap.length; i++) {
      final value = object.dataMap[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _itemSavedModelSerialize(
  ItemSavedModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.addenum);
  writer.writeLong(offsets[1], object.count);
  writer.writeStringList(offsets[2], object.dataMap);
  writer.writeDouble(offsets[3], object.qouted);
}

ItemSavedModel _itemSavedModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemSavedModel();
  object.addenum = reader.readDouble(offsets[0]);
  object.count = reader.readLong(offsets[1]);
  object.dataMap = reader.readStringList(offsets[2]) ?? [];
  object.qouted = reader.readDouble(offsets[3]);
  return object;
}

P _itemSavedModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ItemSavedModelQueryFilter
    on QueryBuilder<ItemSavedModel, ItemSavedModel, QFilterCondition> {
  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      addenumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addenum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      addenumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addenum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      addenumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addenum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      addenumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addenum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataMap',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataMap',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataMap',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataMap',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataMap',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      dataMapLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dataMap',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      qoutedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qouted',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      qoutedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qouted',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      qoutedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qouted',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
      qoutedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qouted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ItemSavedModelQueryObject
    on QueryBuilder<ItemSavedModel, ItemSavedModel, QFilterCondition> {}
