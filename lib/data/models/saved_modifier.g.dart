// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_modifier.dart';

// **************************************************************************
// _IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

final SavedDataEntrySchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SavedDataEntry',

    embedded: true,
    properties: [
      IsarPropertySchema(name: 'key', type: IsarType.string),
      IsarPropertySchema(name: 'value', type: IsarType.bool),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<void, SavedDataEntry>(
    serialize: serializeSavedDataEntry,
    deserialize: deserializeSavedDataEntry,
  ),
);

@isarProtected
int serializeSavedDataEntry(IsarWriter writer, SavedDataEntry object) {
  IsarCore.writeString(writer, 1, object.key);
  IsarCore.writeBool(writer, 2, value: object.value);
  return 0;
}

@isarProtected
SavedDataEntry deserializeSavedDataEntry(IsarReader reader) {
  final object = SavedDataEntry();
  object.key = IsarCore.readString(reader, 1) ?? '';
  object.value = IsarCore.readBool(reader, 2);
  return object;
}

extension SavedDataEntryQueryFilter
    on QueryBuilder<SavedDataEntry, SavedDataEntry, QFilterCondition> {
  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
  keyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
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

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SavedDataEntry, SavedDataEntry, QAfterFilterCondition>
  valueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value),
      );
    });
  }
}

extension SavedDataEntryQueryObject
    on QueryBuilder<SavedDataEntry, SavedDataEntry, QFilterCondition> {}
