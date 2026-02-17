// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_receit_item.dart';

// **************************************************************************
// _IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

final ItemReceitItemSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemReceitItem',

    embedded: true,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'count', type: IsarType.long),
      IsarPropertySchema(name: 'price', type: IsarType.double),
      IsarPropertySchema(name: 'cost', type: IsarType.double),
      IsarPropertySchema(name: 'addenum', type: IsarType.double),
      IsarPropertySchema(name: 'itemId', type: IsarType.string),
      IsarPropertySchema(name: 'rejectedReason', type: IsarType.string),
      IsarPropertySchema(name: 'refunded', type: IsarType.bool),
      IsarPropertySchema(name: 'originalCount', type: IsarType.long),
      IsarPropertySchema(name: 'discount', type: IsarType.double),
      IsarPropertySchema(name: 'discountId', type: IsarType.string),
      IsarPropertySchema(name: 'percentageDiscount', type: IsarType.bool),
      IsarPropertySchema(name: 'baseId', type: IsarType.long),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<void, ItemReceitItem>(
    serialize: serializeItemReceitItem,
    deserialize: deserializeItemReceitItem,
  ),
);

@isarProtected
int serializeItemReceitItem(IsarWriter writer, ItemReceitItem object) {
  IsarCore.writeString(writer, 1, object.name);
  IsarCore.writeLong(writer, 2, object.count);
  IsarCore.writeDouble(writer, 3, object.price);
  IsarCore.writeDouble(writer, 4, object.cost);
  IsarCore.writeDouble(writer, 5, object.addenum);
  IsarCore.writeString(writer, 6, object.itemId);
  IsarCore.writeString(writer, 7, object.rejectedReason);
  IsarCore.writeBool(writer, 8, value: object.refunded);
  IsarCore.writeLong(writer, 9, object.originalCount);
  IsarCore.writeDouble(writer, 10, object.discount);
  {
    final value = object.discountId;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  IsarCore.writeBool(writer, 12, value: object.percentageDiscount);
  IsarCore.writeLong(writer, 13, object.baseId);
  return 0;
}

@isarProtected
ItemReceitItem deserializeItemReceitItem(IsarReader reader) {
  final object = ItemReceitItem();
  object.name = IsarCore.readString(reader, 1) ?? '';
  object.count = IsarCore.readLong(reader, 2);
  object.price = IsarCore.readDouble(reader, 3);
  object.cost = IsarCore.readDouble(reader, 4);
  object.addenum = IsarCore.readDouble(reader, 5);
  object.itemId = IsarCore.readString(reader, 6) ?? '';
  object.rejectedReason = IsarCore.readString(reader, 7) ?? '';
  object.refunded = IsarCore.readBool(reader, 8);
  object.originalCount = IsarCore.readLong(reader, 9);
  object.discount = IsarCore.readDouble(reader, 10);
  object.discountId = IsarCore.readString(reader, 11);
  object.percentageDiscount = IsarCore.readBool(reader, 12);
  object.baseId = IsarCore.readLong(reader, 13);
  return object;
}

extension ItemReceitItemQueryFilter
    on QueryBuilder<ItemReceitItem, ItemReceitItem, QFilterCondition> {
  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 2, value: value));
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  countBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 2, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  priceBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  costBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  addenumBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  rejectedReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  refundedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  originalCountBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  discountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  percentageDiscountEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 13, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 13, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 13, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 13, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 13, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitItem, ItemReceitItem, QAfterFilterCondition>
  baseIdBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 13, lower: lower, upper: upper),
      );
    });
  }
}

extension ItemReceitItemQueryObject
    on QueryBuilder<ItemReceitItem, ItemReceitItem, QFilterCondition> {}
