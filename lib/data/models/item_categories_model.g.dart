// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_categories_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemCategoryModelCollection on Isar {
  IsarCollection<int, ItemCategoryModel> get itemCategoryModels =>
      this.collection();
}

final ItemCategoryModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemCategoryModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'color', type: IsarType.long),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'name',
        properties: ["name"],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, ItemCategoryModel>(
    serialize: serializeItemCategoryModel,
    deserialize: deserializeItemCategoryModel,
    deserializeProperty: deserializeItemCategoryModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeItemCategoryModel(IsarWriter writer, ItemCategoryModel object) {
  IsarCore.writeString(writer, 1, object.name);
  IsarCore.writeLong(writer, 2, object.color ?? -9223372036854775808);
  IsarCore.writeString(writer, 3, object.hexId);
  return object.id;
}

@isarProtected
ItemCategoryModel deserializeItemCategoryModel(IsarReader reader) {
  final String _name;
  _name = IsarCore.readString(reader, 1) ?? '';
  final int? _color;
  {
    final value = IsarCore.readLong(reader, 2);
    if (value == -9223372036854775808) {
      _color = null;
    } else {
      _color = value;
    }
  }
  final String _hexId;
  _hexId = IsarCore.readString(reader, 3) ?? '';
  final object = ItemCategoryModel(name: _name, color: _color, hexId: _hexId);
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeItemCategoryModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        final value = IsarCore.readLong(reader, 2);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ItemCategoryModelUpdate {
  bool call({required int id, String? name, int? color, String? hexId});
}

class _ItemCategoryModelUpdateImpl implements _ItemCategoryModelUpdate {
  const _ItemCategoryModelUpdateImpl(this.collection);

  final IsarCollection<int, ItemCategoryModel> collection;

  @override
  bool call({
    required int id,
    Object? name = ignore,
    Object? color = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (color != ignore) 2: color as int?,
            if (hexId != ignore) 3: hexId as String?,
          },
        ) >
        0;
  }
}

sealed class _ItemCategoryModelUpdateAll {
  int call({required List<int> id, String? name, int? color, String? hexId});
}

class _ItemCategoryModelUpdateAllImpl implements _ItemCategoryModelUpdateAll {
  const _ItemCategoryModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemCategoryModel> collection;

  @override
  int call({
    required List<int> id,
    Object? name = ignore,
    Object? color = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (color != ignore) 2: color as int?,
      if (hexId != ignore) 3: hexId as String?,
    });
  }
}

extension ItemCategoryModelUpdate on IsarCollection<int, ItemCategoryModel> {
  _ItemCategoryModelUpdate get update => _ItemCategoryModelUpdateImpl(this);

  _ItemCategoryModelUpdateAll get updateAll =>
      _ItemCategoryModelUpdateAllImpl(this);
}

sealed class _ItemCategoryModelQueryUpdate {
  int call({String? name, int? color, String? hexId});
}

class _ItemCategoryModelQueryUpdateImpl
    implements _ItemCategoryModelQueryUpdate {
  const _ItemCategoryModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemCategoryModel> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? color = ignore,
    Object? hexId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (color != ignore) 2: color as int?,
      if (hexId != ignore) 3: hexId as String?,
    });
  }
}

extension ItemCategoryModelQueryUpdate on IsarQuery<ItemCategoryModel> {
  _ItemCategoryModelQueryUpdate get updateFirst =>
      _ItemCategoryModelQueryUpdateImpl(this, limit: 1);

  _ItemCategoryModelQueryUpdate get updateAll =>
      _ItemCategoryModelQueryUpdateImpl(this);
}

class _ItemCategoryModelQueryBuilderUpdateImpl
    implements _ItemCategoryModelQueryUpdate {
  const _ItemCategoryModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemCategoryModel, ItemCategoryModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? color = ignore,
    Object? hexId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (color != ignore) 2: color as int?,
        if (hexId != ignore) 3: hexId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension ItemCategoryModelQueryBuilderUpdate
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QOperations> {
  _ItemCategoryModelQueryUpdate get updateFirst =>
      _ItemCategoryModelQueryBuilderUpdateImpl(this, limit: 1);

  _ItemCategoryModelQueryUpdate get updateAll =>
      _ItemCategoryModelQueryBuilderUpdateImpl(this);
}

extension ItemCategoryModelQueryFilter
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QFilterCondition> {
  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorGreaterThan(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorGreaterThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorLessThan(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 2, value: value));
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorLessThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  colorBetween(int? lower, int? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 2, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }
}

extension ItemCategoryModelQueryObject
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QFilterCondition> {}

extension ItemCategoryModelQuerySortBy
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QSortBy> {
  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  sortByHexIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemCategoryModelQuerySortThenBy
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QSortThenBy> {
  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterSortBy>
  thenByHexIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemCategoryModelQueryWhereDistinct
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QDistinct> {
  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterDistinct>
  distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<ItemCategoryModel, ItemCategoryModel, QAfterDistinct>
  distinctByHexId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }
}

extension ItemCategoryModelQueryProperty1
    on QueryBuilder<ItemCategoryModel, ItemCategoryModel, QProperty> {
  QueryBuilder<ItemCategoryModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemCategoryModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemCategoryModel, int?, QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemCategoryModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemCategoryModelQueryProperty2<R>
    on QueryBuilder<ItemCategoryModel, R, QAfterProperty> {
  QueryBuilder<ItemCategoryModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemCategoryModel, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemCategoryModel, (R, int?), QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemCategoryModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemCategoryModelQueryProperty3<R1, R2>
    on QueryBuilder<ItemCategoryModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemCategoryModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemCategoryModel, (R1, R2, String), QOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemCategoryModel, (R1, R2, int?), QOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemCategoryModel, (R1, R2, String), QOperations>
  hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
