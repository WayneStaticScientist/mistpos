// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_embedder.dart';

// **************************************************************************
// _IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

final ModifierEmbedderSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ModifierEmbedder',

    embedded: true,
    properties: [
      IsarPropertySchema(name: 'key', type: IsarType.string),
      IsarPropertySchema(name: 'value', type: IsarType.double),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<void, ModifierEmbedder>(
    serialize: serializeModifierEmbedder,
    deserialize: deserializeModifierEmbedder,
  ),
);

@isarProtected
int serializeModifierEmbedder(IsarWriter writer, ModifierEmbedder object) {
  IsarCore.writeString(writer, 1, object.key);
  IsarCore.writeDouble(writer, 2, object.value);
  return 0;
}

@isarProtected
ModifierEmbedder deserializeModifierEmbedder(IsarReader reader) {
  final object = ModifierEmbedder();
  object.key = IsarCore.readString(reader, 1) ?? '';
  object.value = IsarCore.readDouble(reader, 2);
  return object;
}

extension ModifierEmbedderQueryFilter
    on QueryBuilder<ModifierEmbedder, ModifierEmbedder, QFilterCondition> {
  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  valueEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  valueGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  valueGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  valueLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
  valueLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ModifierEmbedder, ModifierEmbedder, QAfterFilterCondition>
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
}

extension ModifierEmbedderQueryObject
    on QueryBuilder<ModifierEmbedder, ModifierEmbedder, QFilterCondition> {}
