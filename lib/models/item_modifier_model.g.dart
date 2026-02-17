// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_modifier_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemModifierCollection on Isar {
  IsarCollection<int, ItemModifier> get itemModifiers => this.collection();
}

final ItemModifierSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemModifier',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
      IsarPropertySchema(
        name: 'list',
        type: IsarType.objectList,
        target: 'ModifierEmbedder',
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'name',
        properties: ["name"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, ItemModifier>(
    serialize: serializeItemModifier,
    deserialize: deserializeItemModifier,
    deserializeProperty: deserializeItemModifierProp,
  ),
  getEmbeddedSchemas: () => [ModifierEmbedderSchema],
);

@isarProtected
int serializeItemModifier(IsarWriter writer, ItemModifier object) {
  IsarCore.writeString(writer, 1, object.name);
  IsarCore.writeString(writer, 2, object.hexId);
  {
    final list = object.list;
    final listWriter = IsarCore.beginList(writer, 3, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeModifierEmbedder(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  return object.id;
}

@isarProtected
ItemModifier deserializeItemModifier(IsarReader reader) {
  final String _name;
  _name = IsarCore.readString(reader, 1) ?? '';
  final String _hexId;
  _hexId = IsarCore.readString(reader, 2) ?? '';
  final List<ModifierEmbedder> _list;
  {
    final length = IsarCore.readList(reader, 3, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _list = const <ModifierEmbedder>[];
      } else {
        final list = List<ModifierEmbedder>.filled(
          length,
          ModifierEmbedder(),
          growable: true,
        );
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = ModifierEmbedder();
            } else {
              final embedded = deserializeModifierEmbedder(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _list = list;
      }
    }
  }
  final object = ItemModifier(name: _name, hexId: _hexId, list: _list);
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeItemModifierProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      {
        final length = IsarCore.readList(reader, 3, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <ModifierEmbedder>[];
          } else {
            final list = List<ModifierEmbedder>.filled(
              length,
              ModifierEmbedder(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = ModifierEmbedder();
                } else {
                  final embedded = deserializeModifierEmbedder(objectReader);
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
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ItemModifierUpdate {
  bool call({required int id, String? name, String? hexId});
}

class _ItemModifierUpdateImpl implements _ItemModifierUpdate {
  const _ItemModifierUpdateImpl(this.collection);

  final IsarCollection<int, ItemModifier> collection;

  @override
  bool call({required int id, Object? name = ignore, Object? hexId = ignore}) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (hexId != ignore) 2: hexId as String?,
          },
        ) >
        0;
  }
}

sealed class _ItemModifierUpdateAll {
  int call({required List<int> id, String? name, String? hexId});
}

class _ItemModifierUpdateAllImpl implements _ItemModifierUpdateAll {
  const _ItemModifierUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemModifier> collection;

  @override
  int call({
    required List<int> id,
    Object? name = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (hexId != ignore) 2: hexId as String?,
    });
  }
}

extension ItemModifierUpdate on IsarCollection<int, ItemModifier> {
  _ItemModifierUpdate get update => _ItemModifierUpdateImpl(this);

  _ItemModifierUpdateAll get updateAll => _ItemModifierUpdateAllImpl(this);
}

sealed class _ItemModifierQueryUpdate {
  int call({String? name, String? hexId});
}

class _ItemModifierQueryUpdateImpl implements _ItemModifierQueryUpdate {
  const _ItemModifierQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemModifier> query;
  final int? limit;

  @override
  int call({Object? name = ignore, Object? hexId = ignore}) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (hexId != ignore) 2: hexId as String?,
    });
  }
}

extension ItemModifierQueryUpdate on IsarQuery<ItemModifier> {
  _ItemModifierQueryUpdate get updateFirst =>
      _ItemModifierQueryUpdateImpl(this, limit: 1);

  _ItemModifierQueryUpdate get updateAll => _ItemModifierQueryUpdateImpl(this);
}

class _ItemModifierQueryBuilderUpdateImpl implements _ItemModifierQueryUpdate {
  const _ItemModifierQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemModifier, ItemModifier, QOperations> query;
  final int? limit;

  @override
  int call({Object? name = ignore, Object? hexId = ignore}) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (hexId != ignore) 2: hexId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension ItemModifierQueryBuilderUpdate
    on QueryBuilder<ItemModifier, ItemModifier, QOperations> {
  _ItemModifierQueryUpdate get updateFirst =>
      _ItemModifierQueryBuilderUpdateImpl(this, limit: 1);

  _ItemModifierQueryUpdate get updateAll =>
      _ItemModifierQueryBuilderUpdateImpl(this);
}

extension ItemModifierQueryFilter
    on QueryBuilder<ItemModifier, ItemModifier, QFilterCondition> {
  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition> hexIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  listIsEmpty() {
    return not().listIsNotEmpty();
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterFilterCondition>
  listIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 3, value: null),
      );
    });
  }
}

extension ItemModifierQueryObject
    on QueryBuilder<ItemModifier, ItemModifier, QFilterCondition> {}

extension ItemModifierQuerySortBy
    on QueryBuilder<ItemModifier, ItemModifier, QSortBy> {
  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemModifierQuerySortThenBy
    on QueryBuilder<ItemModifier, ItemModifier, QSortThenBy> {
  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemModifierQueryWhereDistinct
    on QueryBuilder<ItemModifier, ItemModifier, QDistinct> {
  QueryBuilder<ItemModifier, ItemModifier, QAfterDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModifier, ItemModifier, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }
}

extension ItemModifierQueryProperty1
    on QueryBuilder<ItemModifier, ItemModifier, QProperty> {
  QueryBuilder<ItemModifier, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModifier, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModifier, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModifier, List<ModifierEmbedder>, QAfterProperty>
  listProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemModifierQueryProperty2<R>
    on QueryBuilder<ItemModifier, R, QAfterProperty> {
  QueryBuilder<ItemModifier, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModifier, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModifier, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModifier, (R, List<ModifierEmbedder>), QAfterProperty>
  listProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension ItemModifierQueryProperty3<R1, R2>
    on QueryBuilder<ItemModifier, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemModifier, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModifier, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModifier, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModifier, (R1, R2, List<ModifierEmbedder>), QOperations>
  listProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
