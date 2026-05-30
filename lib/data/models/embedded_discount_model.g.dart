// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedded_discount_model.dart';

// **************************************************************************
// _IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

final EmbeddedDiscountModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'EmbeddedDiscountModel',

    embedded: true,
    properties: [
      IsarPropertySchema(name: 'discountId', type: IsarType.string),
      IsarPropertySchema(name: 'discount', type: IsarType.double),
      IsarPropertySchema(name: 'percentageDiscount', type: IsarType.bool),
      IsarPropertySchema(name: 'name', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<void, EmbeddedDiscountModel>(
    serialize: serializeEmbeddedDiscountModel,
    deserialize: deserializeEmbeddedDiscountModel,
  ),
);

@isarProtected
int serializeEmbeddedDiscountModel(
  IsarWriter writer,
  EmbeddedDiscountModel object,
) {
  {
    final value = object.discountId;
    if (value == null) {
      IsarCore.writeNull(writer, 1);
    } else {
      IsarCore.writeString(writer, 1, value);
    }
  }
  IsarCore.writeDouble(writer, 2, object.discount ?? double.nan);
  {
    final value = object.percentageDiscount;
    if (value == null) {
      IsarCore.writeNull(writer, 3);
    } else {
      IsarCore.writeBool(writer, 3, value: value);
    }
  }
  {
    final value = object.name;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  return 0;
}

@isarProtected
EmbeddedDiscountModel deserializeEmbeddedDiscountModel(IsarReader reader) {
  final String? _discountId;
  _discountId = IsarCore.readString(reader, 1);
  final double? _discount;
  {
    final value = IsarCore.readDouble(reader, 2);
    if (value.isNaN) {
      _discount = null;
    } else {
      _discount = value;
    }
  }
  final bool? _percentageDiscount;
  {
    if (IsarCore.readNull(reader, 3)) {
      _percentageDiscount = null;
    } else {
      _percentageDiscount = IsarCore.readBool(reader, 3);
    }
  }
  final String? _name;
  _name = IsarCore.readString(reader, 4);
  final object = EmbeddedDiscountModel(
    discountId: _discountId,
    discount: _discount,
    percentageDiscount: _percentageDiscount,
    name: _name,
  );
  return object;
}

extension EmbeddedDiscountModelQueryFilter
    on
        QueryBuilder<
          EmbeddedDiscountModel,
          EmbeddedDiscountModel,
          QFilterCondition
        > {
  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountEqualTo(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountGreaterThan(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountLessThan(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountLessThanOrEqualTo(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  discountBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  percentageDiscountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  percentageDiscountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  percentageDiscountEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<
    EmbeddedDiscountModel,
    EmbeddedDiscountModel,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }
}

extension EmbeddedDiscountModelQueryObject
    on
        QueryBuilder<
          EmbeddedDiscountModel,
          EmbeddedDiscountModel,
          QFilterCondition
        > {}
