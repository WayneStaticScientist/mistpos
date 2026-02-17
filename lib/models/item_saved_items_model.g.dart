// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_saved_items_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemSavedItemsModelCollection on Isar {
  IsarCollection<int, ItemSavedItemsModel> get itemSavedItemsModels =>
      this.collection();
}

final ItemSavedItemsModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemSavedItemsModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(
        name: 'dataMap',
        type: IsarType.objectList,
        target: 'ItemSavedModel',
      ),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ItemSavedItemsModel>(
    serialize: serializeItemSavedItemsModel,
    deserialize: deserializeItemSavedItemsModel,
    deserializeProperty: deserializeItemSavedItemsModelProp,
  ),
  getEmbeddedSchemas: () => [ItemSavedModelSchema],
);

@isarProtected
int serializeItemSavedItemsModel(
  IsarWriter writer,
  ItemSavedItemsModel object,
) {
  IsarCore.writeString(writer, 1, object.name);
  {
    final list = object.dataMap;
    final listWriter = IsarCore.beginList(writer, 2, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeItemSavedModel(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  IsarCore.writeLong(
    writer,
    3,
    object.createdAt.toUtc().microsecondsSinceEpoch,
  );
  return object.id;
}

@isarProtected
ItemSavedItemsModel deserializeItemSavedItemsModel(IsarReader reader) {
  final String _name;
  _name = IsarCore.readString(reader, 1) ?? '';
  final List<ItemSavedModel> _dataMap;
  {
    final length = IsarCore.readList(reader, 2, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _dataMap = const <ItemSavedModel>[];
      } else {
        final list = List<ItemSavedModel>.filled(
          length,
          ItemSavedModel(),
          growable: true,
        );
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = ItemSavedModel();
            } else {
              final embedded = deserializeItemSavedModel(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _dataMap = list;
      }
    }
  }
  final DateTime _createdAt;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _createdAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _createdAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final object = ItemSavedItemsModel(
    name: _name,
    dataMap: _dataMap,
    createdAt: _createdAt,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeItemSavedItemsModelProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 0:
      return IsarCore.readId(reader);
    case 2:
      {
        final length = IsarCore.readList(reader, 2, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <ItemSavedModel>[];
          } else {
            final list = List<ItemSavedModel>.filled(
              length,
              ItemSavedModel(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = ItemSavedModel();
                } else {
                  final embedded = deserializeItemSavedModel(objectReader);
                  IsarCore.freeReader(objectReader);
                  list[i] = embedded;
                }
              }
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ItemSavedItemsModelUpdate {
  bool call({required int id, String? name, DateTime? createdAt});
}

class _ItemSavedItemsModelUpdateImpl implements _ItemSavedItemsModelUpdate {
  const _ItemSavedItemsModelUpdateImpl(this.collection);

  final IsarCollection<int, ItemSavedItemsModel> collection;

  @override
  bool call({
    required int id,
    Object? name = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (createdAt != ignore) 3: createdAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _ItemSavedItemsModelUpdateAll {
  int call({required List<int> id, String? name, DateTime? createdAt});
}

class _ItemSavedItemsModelUpdateAllImpl
    implements _ItemSavedItemsModelUpdateAll {
  const _ItemSavedItemsModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemSavedItemsModel> collection;

  @override
  int call({
    required List<int> id,
    Object? name = ignore,
    Object? createdAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (createdAt != ignore) 3: createdAt as DateTime?,
    });
  }
}

extension ItemSavedItemsModelUpdate
    on IsarCollection<int, ItemSavedItemsModel> {
  _ItemSavedItemsModelUpdate get update => _ItemSavedItemsModelUpdateImpl(this);

  _ItemSavedItemsModelUpdateAll get updateAll =>
      _ItemSavedItemsModelUpdateAllImpl(this);
}

sealed class _ItemSavedItemsModelQueryUpdate {
  int call({String? name, DateTime? createdAt});
}

class _ItemSavedItemsModelQueryUpdateImpl
    implements _ItemSavedItemsModelQueryUpdate {
  const _ItemSavedItemsModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemSavedItemsModel> query;
  final int? limit;

  @override
  int call({Object? name = ignore, Object? createdAt = ignore}) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (createdAt != ignore) 3: createdAt as DateTime?,
    });
  }
}

extension ItemSavedItemsModelQueryUpdate on IsarQuery<ItemSavedItemsModel> {
  _ItemSavedItemsModelQueryUpdate get updateFirst =>
      _ItemSavedItemsModelQueryUpdateImpl(this, limit: 1);

  _ItemSavedItemsModelQueryUpdate get updateAll =>
      _ItemSavedItemsModelQueryUpdateImpl(this);
}

class _ItemSavedItemsModelQueryBuilderUpdateImpl
    implements _ItemSavedItemsModelQueryUpdate {
  const _ItemSavedItemsModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QOperations>
  query;
  final int? limit;

  @override
  int call({Object? name = ignore, Object? createdAt = ignore}) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (createdAt != ignore) 3: createdAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension ItemSavedItemsModelQueryBuilderUpdate
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QOperations> {
  _ItemSavedItemsModelQueryUpdate get updateFirst =>
      _ItemSavedItemsModelQueryBuilderUpdateImpl(this, limit: 1);

  _ItemSavedItemsModelQueryUpdate get updateAll =>
      _ItemSavedItemsModelQueryBuilderUpdateImpl(this);
}

extension ItemSavedItemsModelQueryFilter
    on
        QueryBuilder<
          ItemSavedItemsModel,
          ItemSavedItemsModel,
          QFilterCondition
        > {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  dataMapIsEmpty() {
    return not().dataMapIsNotEmpty();
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  dataMapIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 2, value: null),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterFilterCondition>
  createdAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }
}

extension ItemSavedItemsModelQueryObject
    on
        QueryBuilder<
          ItemSavedItemsModel,
          ItemSavedItemsModel,
          QFilterCondition
        > {}

extension ItemSavedItemsModelQuerySortBy
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QSortBy> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension ItemSavedItemsModelQuerySortThenBy
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QSortThenBy> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension ItemSavedItemsModelQueryWhereDistinct
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QDistinct> {
  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }
}

extension ItemSavedItemsModelQueryProperty1
    on QueryBuilder<ItemSavedItemsModel, ItemSavedItemsModel, QProperty> {
  QueryBuilder<ItemSavedItemsModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemSavedItemsModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemSavedItemsModel, List<ItemSavedModel>, QAfterProperty>
  dataMapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemSavedItemsModel, DateTime, QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemSavedItemsModelQueryProperty2<R>
    on QueryBuilder<ItemSavedItemsModel, R, QAfterProperty> {
  QueryBuilder<ItemSavedItemsModel, (R, String), QAfterProperty>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R, List<ItemSavedModel>), QAfterProperty>
  dataMapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R, DateTime), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemSavedItemsModelQueryProperty3<R1, R2>
    on QueryBuilder<ItemSavedItemsModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemSavedItemsModel, (R1, R2, String), QOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R1, R2, List<ItemSavedModel>), QOperations>
  dataMapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemSavedItemsModel, (R1, R2, DateTime), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
