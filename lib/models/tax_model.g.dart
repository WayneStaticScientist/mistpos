// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaxModelCollection on Isar {
  IsarCollection<TaxModel> get taxModels => this.collection();
}

const TaxModelSchema = CollectionSchema(
  name: r'TaxModel',
  id: -3753743766418626748,
  properties: {
    r'activated': PropertySchema(
      id: 0,
      name: r'activated',
      type: IsarType.bool,
    ),
    r'hexId': PropertySchema(
      id: 1,
      name: r'hexId',
      type: IsarType.string,
    ),
    r'label': PropertySchema(
      id: 2,
      name: r'label',
      type: IsarType.string,
    ),
    r'selectedIds': PropertySchema(
      id: 3,
      name: r'selectedIds',
      type: IsarType.stringList,
    ),
    r'value': PropertySchema(
      id: 4,
      name: r'value',
      type: IsarType.double,
    )
  },
  estimateSize: _taxModelEstimateSize,
  serialize: _taxModelSerialize,
  deserialize: _taxModelDeserialize,
  deserializeProp: _taxModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _taxModelGetId,
  getLinks: _taxModelGetLinks,
  attach: _taxModelAttach,
  version: '3.1.0+1',
);

int _taxModelEstimateSize(
  TaxModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hexId.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.selectedIds.length * 3;
  {
    for (var i = 0; i < object.selectedIds.length; i++) {
      final value = object.selectedIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _taxModelSerialize(
  TaxModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.activated);
  writer.writeString(offsets[1], object.hexId);
  writer.writeString(offsets[2], object.label);
  writer.writeStringList(offsets[3], object.selectedIds);
  writer.writeDouble(offsets[4], object.value);
}

TaxModel _taxModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaxModel(
    activated: reader.readBool(offsets[0]),
    hexId: reader.readStringOrNull(offsets[1]) ?? '',
    label: reader.readString(offsets[2]),
    selectedIds: reader.readStringList(offsets[3]) ?? [],
    value: reader.readDouble(offsets[4]),
  );
  object.id = id;
  return object;
}

P _taxModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taxModelGetId(TaxModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taxModelGetLinks(TaxModel object) {
  return [];
}

void _taxModelAttach(IsarCollection<dynamic> col, Id id, TaxModel object) {
  object.id = id;
}

extension TaxModelQueryWhereSort on QueryBuilder<TaxModel, TaxModel, QWhere> {
  QueryBuilder<TaxModel, TaxModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaxModelQueryWhere on QueryBuilder<TaxModel, TaxModel, QWhereClause> {
  QueryBuilder<TaxModel, TaxModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaxModelQueryFilter
    on QueryBuilder<TaxModel, TaxModel, QFilterCondition> {
  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> activatedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activated',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hexId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedIds',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedIds',
        value: '',
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> selectedIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition>
      selectedIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TaxModelQueryObject
    on QueryBuilder<TaxModel, TaxModel, QFilterCondition> {}

extension TaxModelQueryLinks
    on QueryBuilder<TaxModel, TaxModel, QFilterCondition> {}

extension TaxModelQuerySortBy on QueryBuilder<TaxModel, TaxModel, QSortBy> {
  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activated', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activated', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension TaxModelQuerySortThenBy
    on QueryBuilder<TaxModel, TaxModel, QSortThenBy> {
  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activated', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activated', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension TaxModelQueryWhereDistinct
    on QueryBuilder<TaxModel, TaxModel, QDistinct> {
  QueryBuilder<TaxModel, TaxModel, QDistinct> distinctByActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activated');
    });
  }

  QueryBuilder<TaxModel, TaxModel, QDistinct> distinctByHexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaxModel, TaxModel, QDistinct> distinctBySelectedIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedIds');
    });
  }

  QueryBuilder<TaxModel, TaxModel, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension TaxModelQueryProperty
    on QueryBuilder<TaxModel, TaxModel, QQueryProperty> {
  QueryBuilder<TaxModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaxModel, bool, QQueryOperations> activatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activated');
    });
  }

  QueryBuilder<TaxModel, String, QQueryOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexId');
    });
  }

  QueryBuilder<TaxModel, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<TaxModel, List<String>, QQueryOperations> selectedIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedIds');
    });
  }

  QueryBuilder<TaxModel, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
