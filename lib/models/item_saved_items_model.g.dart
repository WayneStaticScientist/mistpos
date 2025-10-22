// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_saved_items_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItemSavedItemsModelCollection on Isar {
  IsarCollection<ItemSavedItemsModel> get itemSavedItemsModels =>
      this.collection();
}

const ItemSavedItemsModelSchema = CollectionSchema(
  name: r'ItemSavedItemsModel',
  id: -7775464578989841789,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dataMap': PropertySchema(
      id: 1,
      name: r'dataMap',
      type: IsarType.objectList,
      target: r'ItemSavedModel',
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _itemSavedItemsModelEstimateSize,
  serialize: _itemSavedItemsModelSerialize,
  deserialize: _itemSavedItemsModelDeserialize,
  deserializeProp: _itemSavedItemsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'ItemSavedModel': ItemSavedModelSchema},
  getId: _itemSavedItemsModelGetId,
  getLinks: _itemSavedItemsModelGetLinks,
  attach: _itemSavedItemsModelAttach,
  version: '3.1.0+1',
);

int _itemSavedItemsModelEstimateSize(
  ItemSavedItemsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataMap.length * 3;
  {
    final offsets = allOffsets[ItemSavedModel]!;
    for (var i = 0; i < object.dataMap.length; i++) {
      final value = object.dataMap[i];
      bytesCount +=
          ItemSavedModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _itemSavedItemsModelSerialize(
  ItemSavedItemsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeObjectList<ItemSavedModel>(
    offsets[1],
    allOffsets,
    ItemSavedModelSchema.serialize,
    object.dataMap,
  );
  writer.writeString(offsets[2], object.name);
}

ItemSavedItemsModel _itemSavedItemsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemSavedItemsModel(
    createdAt: reader.readDateTime(offsets[0]),
    dataMap: reader.readObjectList<ItemSavedModel>(
          offsets[1],
          ItemSavedModelSchema.deserialize,
          allOffsets,
          ItemSavedModel(),
        ) ??
        [],
    name: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _itemSavedItemsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<ItemSavedModel>(
            offset,
            ItemSavedModelSchema.deserialize,
            allOffsets,
            ItemSavedModel(),
          ) ??
          []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemSavedItemsModelGetId(ItemSavedItemsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemSavedItemsModelGetLinks(
    ItemSavedItemsModel object) {
  return [];
}

void _itemSavedItemsModelAttach(
    IsarCollection<dynamic> col, Id id, ItemSavedItemsModel object) {
  object.id = id;
}

extension ItemSavedItemsModelQueryWhereSort
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QWhere> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemSavedItemsModelQueryWhere
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QWhereClause> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterWhereClause>
      idBetween(
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

extension ItemSavedItemsModelQueryFilter on QueryBuilder<ItemSavedItemsModel,
    ItemSavedItemsModel, QFilterCondition> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
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

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension ItemSavedItemsModelQueryObject on QueryBuilder<ItemSavedItemsModel,
    ItemSavedItemsModel, QFilterCondition> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
      dataMapElement(FilterQuery<ItemSavedModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dataMap');
    });
  }
}

extension ItemSavedItemsModelQueryLinks on QueryBuilder<ItemSavedItemsModel,
    ItemSavedItemsModel, QFilterCondition> {}

extension ItemSavedItemsModelQuerySortBy
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QSortBy> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ItemSavedItemsModelQuerySortThenBy
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QSortThenBy> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ItemSavedItemsModelQueryWhereDistinct
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QDistinct> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension ItemSavedItemsModelQueryProperty
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QQueryProperty> {
  QueryBuilder<ItemSavedItemsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemSavedItemsModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ItemSavedItemsModel, List<ItemSavedModel>, QQueryOperations>
      dataMapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataMap');
    });
  }

  QueryBuilder<ItemSavedItemsModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
