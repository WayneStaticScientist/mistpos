// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDiscountModelCollection on Isar {
  IsarCollection<int, DiscountModel> get discountModels => this.collection();
}

final DiscountModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'DiscountModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'value', type: IsarType.double),
      IsarPropertySchema(name: 'company', type: IsarType.string),
      IsarPropertySchema(name: 'percentage', type: IsarType.bool),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, DiscountModel>(
    serialize: serializeDiscountModel,
    deserialize: deserializeDiscountModel,
    deserializeProperty: deserializeDiscountModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeDiscountModel(IsarWriter writer, DiscountModel object) {
  IsarCore.writeString(writer, 1, object.name);
  IsarCore.writeDouble(writer, 2, object.value);
  IsarCore.writeString(writer, 3, object.company);
  IsarCore.writeBool(writer, 4, value: object.percentage);
  IsarCore.writeString(writer, 5, object.hexId);
  return object.id;
}

@isarProtected
DiscountModel deserializeDiscountModel(IsarReader reader) {
  final String _name;
  _name = IsarCore.readString(reader, 1) ?? '';
  final double _value;
  _value = IsarCore.readDouble(reader, 2);
  final String _company;
  _company = IsarCore.readString(reader, 3) ?? '';
  final bool _percentage;
  _percentage = IsarCore.readBool(reader, 4);
  final String _hexId;
  _hexId = IsarCore.readString(reader, 5) ?? '';
  final object = DiscountModel(
    name: _name,
    value: _value,
    company: _company,
    percentage: _percentage,
    hexId: _hexId,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeDiscountModelProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readDouble(reader, 2);
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readBool(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 0:
      return IsarCore.readId(reader);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DiscountModelUpdate {
  bool call({
    required int id,
    String? name,
    double? value,
    String? company,
    bool? percentage,
    String? hexId,
  });
}

class _DiscountModelUpdateImpl implements _DiscountModelUpdate {
  const _DiscountModelUpdateImpl(this.collection);

  final IsarCollection<int, DiscountModel> collection;

  @override
  bool call({
    required int id,
    Object? name = ignore,
    Object? value = ignore,
    Object? company = ignore,
    Object? percentage = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (value != ignore) 2: value as double?,
            if (company != ignore) 3: company as String?,
            if (percentage != ignore) 4: percentage as bool?,
            if (hexId != ignore) 5: hexId as String?,
          },
        ) >
        0;
  }
}

sealed class _DiscountModelUpdateAll {
  int call({
    required List<int> id,
    String? name,
    double? value,
    String? company,
    bool? percentage,
    String? hexId,
  });
}

class _DiscountModelUpdateAllImpl implements _DiscountModelUpdateAll {
  const _DiscountModelUpdateAllImpl(this.collection);

  final IsarCollection<int, DiscountModel> collection;

  @override
  int call({
    required List<int> id,
    Object? name = ignore,
    Object? value = ignore,
    Object? company = ignore,
    Object? percentage = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (value != ignore) 2: value as double?,
      if (company != ignore) 3: company as String?,
      if (percentage != ignore) 4: percentage as bool?,
      if (hexId != ignore) 5: hexId as String?,
    });
  }
}

extension DiscountModelUpdate on IsarCollection<int, DiscountModel> {
  _DiscountModelUpdate get update => _DiscountModelUpdateImpl(this);

  _DiscountModelUpdateAll get updateAll => _DiscountModelUpdateAllImpl(this);
}

sealed class _DiscountModelQueryUpdate {
  int call({
    String? name,
    double? value,
    String? company,
    bool? percentage,
    String? hexId,
  });
}

class _DiscountModelQueryUpdateImpl implements _DiscountModelQueryUpdate {
  const _DiscountModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<DiscountModel> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? value = ignore,
    Object? company = ignore,
    Object? percentage = ignore,
    Object? hexId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (value != ignore) 2: value as double?,
      if (company != ignore) 3: company as String?,
      if (percentage != ignore) 4: percentage as bool?,
      if (hexId != ignore) 5: hexId as String?,
    });
  }
}

extension DiscountModelQueryUpdate on IsarQuery<DiscountModel> {
  _DiscountModelQueryUpdate get updateFirst =>
      _DiscountModelQueryUpdateImpl(this, limit: 1);

  _DiscountModelQueryUpdate get updateAll =>
      _DiscountModelQueryUpdateImpl(this);
}

class _DiscountModelQueryBuilderUpdateImpl
    implements _DiscountModelQueryUpdate {
  const _DiscountModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<DiscountModel, DiscountModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? value = ignore,
    Object? company = ignore,
    Object? percentage = ignore,
    Object? hexId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (value != ignore) 2: value as double?,
        if (company != ignore) 3: company as String?,
        if (percentage != ignore) 4: percentage as bool?,
        if (hexId != ignore) 5: hexId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DiscountModelQueryBuilderUpdate
    on QueryBuilder<DiscountModel, DiscountModel, QOperations> {
  _DiscountModelQueryUpdate get updateFirst =>
      _DiscountModelQueryBuilderUpdateImpl(this, limit: 1);

  _DiscountModelQueryUpdate get updateAll =>
      _DiscountModelQueryBuilderUpdateImpl(this);
}

extension DiscountModelQueryFilter
    on QueryBuilder<DiscountModel, DiscountModel, QFilterCondition> {
  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  valueBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  companyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  percentageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }
}

extension DiscountModelQueryObject
    on QueryBuilder<DiscountModel, DiscountModel, QFilterCondition> {}

extension DiscountModelQuerySortBy
    on QueryBuilder<DiscountModel, DiscountModel, QSortBy> {
  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByCompanyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy>
  sortByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }
}

extension DiscountModelQuerySortThenBy
    on QueryBuilder<DiscountModel, DiscountModel, QSortThenBy> {
  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByCompanyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy>
  thenByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }
}

extension DiscountModelQueryWhereDistinct
    on QueryBuilder<DiscountModel, DiscountModel, QDistinct> {
  QueryBuilder<DiscountModel, DiscountModel, QAfterDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterDistinct> distinctByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterDistinct>
  distinctByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<DiscountModel, DiscountModel, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }
}

extension DiscountModelQueryProperty1
    on QueryBuilder<DiscountModel, DiscountModel, QProperty> {
  QueryBuilder<DiscountModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiscountModel, double, QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiscountModel, String, QAfterProperty> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiscountModel, bool, QAfterProperty> percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiscountModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiscountModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}

extension DiscountModelQueryProperty2<R>
    on QueryBuilder<DiscountModel, R, QAfterProperty> {
  QueryBuilder<DiscountModel, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiscountModel, (R, double), QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiscountModel, (R, String), QAfterProperty> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiscountModel, (R, bool), QAfterProperty> percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiscountModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiscountModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}

extension DiscountModelQueryProperty3<R1, R2>
    on QueryBuilder<DiscountModel, (R1, R2), QAfterProperty> {
  QueryBuilder<DiscountModel, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<DiscountModel, (R1, R2, double), QOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<DiscountModel, (R1, R2, String), QOperations> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<DiscountModel, (R1, R2, bool), QOperations>
  percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<DiscountModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<DiscountModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }
}
