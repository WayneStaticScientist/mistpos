// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetTaxModelCollection on Isar {
  IsarCollection<int, TaxModel> get taxModels => this.collection();
}

final TaxModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'TaxModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'label', type: IsarType.string),
      IsarPropertySchema(name: 'activated', type: IsarType.bool),
      IsarPropertySchema(name: 'value', type: IsarType.double),
      IsarPropertySchema(name: 'selectedIds', type: IsarType.stringList),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, TaxModel>(
    serialize: serializeTaxModel,
    deserialize: deserializeTaxModel,
    deserializeProperty: deserializeTaxModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeTaxModel(IsarWriter writer, TaxModel object) {
  IsarCore.writeString(writer, 1, object.label);
  IsarCore.writeBool(writer, 2, value: object.activated);
  IsarCore.writeDouble(writer, 3, object.value);
  {
    final list = object.selectedIds;
    final listWriter = IsarCore.beginList(writer, 4, list.length);
    for (var i = 0; i < list.length; i++) {
      IsarCore.writeString(listWriter, i, list[i]);
    }
    IsarCore.endList(writer, listWriter);
  }
  IsarCore.writeString(writer, 5, object.hexId);
  return object.id;
}

@isarProtected
TaxModel deserializeTaxModel(IsarReader reader) {
  final String _label;
  _label = IsarCore.readString(reader, 1) ?? '';
  final bool _activated;
  _activated = IsarCore.readBool(reader, 2);
  final double _value;
  _value = IsarCore.readDouble(reader, 3);
  final List<String> _selectedIds;
  {
    final length = IsarCore.readList(reader, 4, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _selectedIds = const <String>[];
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        _selectedIds = list;
      }
    }
  }
  final String _hexId;
  _hexId = IsarCore.readString(reader, 5) ?? '';
  final object = TaxModel(
    label: _label,
    activated: _activated,
    value: _value,
    selectedIds: _selectedIds,
    hexId: _hexId,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeTaxModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readBool(reader, 2);
    case 3:
      return IsarCore.readDouble(reader, 3);
    case 4:
      {
        final length = IsarCore.readList(reader, 4, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <String>[];
          } else {
            final list = List<String>.filled(length, '', growable: true);
            for (var i = 0; i < length; i++) {
              list[i] = IsarCore.readString(reader, i) ?? '';
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _TaxModelUpdate {
  bool call({
    required int id,
    String? label,
    bool? activated,
    double? value,
    String? hexId,
  });
}

class _TaxModelUpdateImpl implements _TaxModelUpdate {
  const _TaxModelUpdateImpl(this.collection);

  final IsarCollection<int, TaxModel> collection;

  @override
  bool call({
    required int id,
    Object? label = ignore,
    Object? activated = ignore,
    Object? value = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (label != ignore) 1: label as String?,
            if (activated != ignore) 2: activated as bool?,
            if (value != ignore) 3: value as double?,
            if (hexId != ignore) 5: hexId as String?,
          },
        ) >
        0;
  }
}

sealed class _TaxModelUpdateAll {
  int call({
    required List<int> id,
    String? label,
    bool? activated,
    double? value,
    String? hexId,
  });
}

class _TaxModelUpdateAllImpl implements _TaxModelUpdateAll {
  const _TaxModelUpdateAllImpl(this.collection);

  final IsarCollection<int, TaxModel> collection;

  @override
  int call({
    required List<int> id,
    Object? label = ignore,
    Object? activated = ignore,
    Object? value = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (label != ignore) 1: label as String?,
      if (activated != ignore) 2: activated as bool?,
      if (value != ignore) 3: value as double?,
      if (hexId != ignore) 5: hexId as String?,
    });
  }
}

extension TaxModelUpdate on IsarCollection<int, TaxModel> {
  _TaxModelUpdate get update => _TaxModelUpdateImpl(this);

  _TaxModelUpdateAll get updateAll => _TaxModelUpdateAllImpl(this);
}

sealed class _TaxModelQueryUpdate {
  int call({String? label, bool? activated, double? value, String? hexId});
}

class _TaxModelQueryUpdateImpl implements _TaxModelQueryUpdate {
  const _TaxModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<TaxModel> query;
  final int? limit;

  @override
  int call({
    Object? label = ignore,
    Object? activated = ignore,
    Object? value = ignore,
    Object? hexId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (label != ignore) 1: label as String?,
      if (activated != ignore) 2: activated as bool?,
      if (value != ignore) 3: value as double?,
      if (hexId != ignore) 5: hexId as String?,
    });
  }
}

extension TaxModelQueryUpdate on IsarQuery<TaxModel> {
  _TaxModelQueryUpdate get updateFirst =>
      _TaxModelQueryUpdateImpl(this, limit: 1);

  _TaxModelQueryUpdate get updateAll => _TaxModelQueryUpdateImpl(this);
}

class _TaxModelQueryBuilderUpdateImpl implements _TaxModelQueryUpdate {
  const _TaxModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<TaxModel, TaxModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? label = ignore,
    Object? activated = ignore,
    Object? value = ignore,
    Object? hexId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (label != ignore) 1: label as String?,
        if (activated != ignore) 2: activated as bool?,
        if (value != ignore) 3: value as double?,
        if (hexId != ignore) 5: hexId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension TaxModelQueryBuilderUpdate
    on QueryBuilder<TaxModel, TaxModel, QOperations> {
  _TaxModelQueryUpdate get updateFirst =>
      _TaxModelQueryBuilderUpdateImpl(this, limit: 1);

  _TaxModelQueryUpdate get updateAll => _TaxModelQueryBuilderUpdateImpl(this);
}

extension TaxModelQueryFilter
    on QueryBuilder<TaxModel, TaxModel, QFilterCondition> {
  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  labelGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  labelLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelBetween(
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelEndsWith(
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelContains(
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelMatches(
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

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> activatedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  valueGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  valueLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> selectedIdsIsEmpty() {
    return not().selectedIdsIsNotEmpty();
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  selectedIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 4, value: null),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }
}

extension TaxModelQueryObject
    on QueryBuilder<TaxModel, TaxModel, QFilterCondition> {}

extension TaxModelQuerySortBy on QueryBuilder<TaxModel, TaxModel, QSortBy> {
  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension TaxModelQuerySortThenBy
    on QueryBuilder<TaxModel, TaxModel, QSortThenBy> {
  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension TaxModelQueryWhereDistinct
    on QueryBuilder<TaxModel, TaxModel, QDistinct> {
  QueryBuilder<TaxModel, TaxModel, QAfterDistinct> distinctByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterDistinct> distinctByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterDistinct> distinctBySelectedIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }
}

extension TaxModelQueryProperty1
    on QueryBuilder<TaxModel, TaxModel, QProperty> {
  QueryBuilder<TaxModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TaxModel, String, QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TaxModel, bool, QAfterProperty> activatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TaxModel, double, QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TaxModel, List<String>, QAfterProperty> selectedIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TaxModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension TaxModelQueryProperty2<R>
    on QueryBuilder<TaxModel, R, QAfterProperty> {
  QueryBuilder<TaxModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TaxModel, (R, String), QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TaxModel, (R, bool), QAfterProperty> activatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TaxModel, (R, double), QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TaxModel, (R, List<String>), QAfterProperty>
  selectedIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TaxModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}

extension TaxModelQueryProperty3<R1, R2>
    on QueryBuilder<TaxModel, (R1, R2), QAfterProperty> {
  QueryBuilder<TaxModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<TaxModel, (R1, R2, String), QOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TaxModel, (R1, R2, bool), QOperations> activatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TaxModel, (R1, R2, double), QOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TaxModel, (R1, R2, List<String>), QOperations>
  selectedIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TaxModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }
}
