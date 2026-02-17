// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_saved_model.dart';

// **************************************************************************
// _IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

final ItemSavedModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemSavedModel',

    embedded: true,
    properties: [
      IsarPropertySchema(name: 'dataMap', type: IsarType.stringList),
      IsarPropertySchema(name: 'qouted', type: IsarType.double),
      IsarPropertySchema(name: 'addenum', type: IsarType.double),
      IsarPropertySchema(name: 'count', type: IsarType.long),
      IsarPropertySchema(name: 'baseId', type: IsarType.long),
      IsarPropertySchema(name: 'cost', type: IsarType.double),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<void, ItemSavedModel>(
    serialize: serializeItemSavedModel,
    deserialize: deserializeItemSavedModel,
  ),
);

@isarProtected
int serializeItemSavedModel(IsarWriter writer, ItemSavedModel object) {
  {
    final list = object.dataMap;
    final listWriter = IsarCore.beginList(writer, 1, list.length);
    for (var i = 0; i < list.length; i++) {
      IsarCore.writeString(listWriter, i, list[i]);
    }
    IsarCore.endList(writer, listWriter);
  }
  IsarCore.writeDouble(writer, 2, object.qouted);
  IsarCore.writeDouble(writer, 3, object.addenum);
  IsarCore.writeLong(writer, 4, object.count);
  IsarCore.writeLong(writer, 5, object.baseId);
  IsarCore.writeDouble(writer, 6, object.cost);
  return 0;
}

@isarProtected
ItemSavedModel deserializeItemSavedModel(IsarReader reader) {
  final object = ItemSavedModel();
  {
    final length = IsarCore.readList(reader, 1, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        object.dataMap = const <String>[];
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        object.dataMap = list;
      }
    }
  }
  object.qouted = IsarCore.readDouble(reader, 2);
  object.addenum = IsarCore.readDouble(reader, 3);
  object.count = IsarCore.readLong(reader, 4);
  object.baseId = IsarCore.readLong(reader, 5);
  object.cost = IsarCore.readDouble(reader, 6);
  return object;
}

extension ItemSavedModelQueryFilter
    on QueryBuilder<ItemSavedModel, ItemSavedModel, QFilterCondition> {
  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementBetween(
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapIsEmpty() {
    return not().dataMapIsNotEmpty();
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  dataMapIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 1, value: null),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  qoutedBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  addenumBetween(
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

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  countBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  baseIdBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemSavedModel, ItemSavedModel, QAfterFilterCondition>
  costBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension ItemSavedModelQueryObject
    on QueryBuilder<ItemSavedModel, ItemSavedModel, QFilterCondition> {}
