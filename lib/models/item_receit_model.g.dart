// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_receit_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItemReceitModelCollection on Isar {
  IsarCollection<ItemReceitModel> get itemReceitModels => this.collection();
}

const ItemReceitModelSchema = CollectionSchema(
  name: r'ItemReceitModel',
  id: -5130466161688939431,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'cashier': PropertySchema(
      id: 1,
      name: r'cashier',
      type: IsarType.string,
    ),
    r'change': PropertySchema(
      id: 2,
      name: r'change',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 4,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'discounts': PropertySchema(
      id: 5,
      name: r'discounts',
      type: IsarType.objectList,
      target: r'EmbeddedDiscountModel',
    ),
    r'hexId': PropertySchema(
      id: 6,
      name: r'hexId',
      type: IsarType.string,
    ),
    r'items': PropertySchema(
      id: 7,
      name: r'items',
      type: IsarType.objectList,
      target: r'ItemReceitItem',
    ),
    r'label': PropertySchema(
      id: 8,
      name: r'label',
      type: IsarType.string,
    ),
    r'miniTax': PropertySchema(
      id: 9,
      name: r'miniTax',
      type: IsarType.objectList,
      target: r'MiniTax',
    ),
    r'payment': PropertySchema(
      id: 10,
      name: r'payment',
      type: IsarType.string,
    ),
    r'synced': PropertySchema(
      id: 11,
      name: r'synced',
      type: IsarType.bool,
    ),
    r'tax': PropertySchema(
      id: 12,
      name: r'tax',
      type: IsarType.double,
    ),
    r'total': PropertySchema(
      id: 13,
      name: r'total',
      type: IsarType.double,
    )
  },
  estimateSize: _itemReceitModelEstimateSize,
  serialize: _itemReceitModelSerialize,
  deserialize: _itemReceitModelDeserialize,
  deserializeProp: _itemReceitModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'MiniTax': MiniTaxSchema,
    r'ItemReceitItem': ItemReceitItemSchema,
    r'EmbeddedDiscountModel': EmbeddedDiscountModelSchema
  },
  getId: _itemReceitModelGetId,
  getLinks: _itemReceitModelGetLinks,
  attach: _itemReceitModelAttach,
  version: '3.1.0+1',
);

int _itemReceitModelEstimateSize(
  ItemReceitModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cashier.length * 3;
  {
    final value = object.customerId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.discounts.length * 3;
  {
    final offsets = allOffsets[EmbeddedDiscountModel]!;
    for (var i = 0; i < object.discounts.length; i++) {
      final value = object.discounts[i];
      bytesCount +=
          EmbeddedDiscountModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.hexId.length * 3;
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[ItemReceitItem]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount +=
          ItemReceitItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.miniTax.length * 3;
  {
    final offsets = allOffsets[MiniTax]!;
    for (var i = 0; i < object.miniTax.length; i++) {
      final value = object.miniTax[i];
      bytesCount += MiniTaxSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.payment.length * 3;
  return bytesCount;
}

void _itemReceitModelSerialize(
  ItemReceitModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.cashier);
  writer.writeDouble(offsets[2], object.change);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.customerId);
  writer.writeObjectList<EmbeddedDiscountModel>(
    offsets[5],
    allOffsets,
    EmbeddedDiscountModelSchema.serialize,
    object.discounts,
  );
  writer.writeString(offsets[6], object.hexId);
  writer.writeObjectList<ItemReceitItem>(
    offsets[7],
    allOffsets,
    ItemReceitItemSchema.serialize,
    object.items,
  );
  writer.writeString(offsets[8], object.label);
  writer.writeObjectList<MiniTax>(
    offsets[9],
    allOffsets,
    MiniTaxSchema.serialize,
    object.miniTax,
  );
  writer.writeString(offsets[10], object.payment);
  writer.writeBool(offsets[11], object.synced);
  writer.writeDouble(offsets[12], object.tax);
  writer.writeDouble(offsets[13], object.total);
}

ItemReceitModel _itemReceitModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemReceitModel(
    amount: reader.readDouble(offsets[0]),
    cashier: reader.readString(offsets[1]),
    change: reader.readDouble(offsets[2]),
    createdAt: reader.readDateTime(offsets[3]),
    customerId: reader.readStringOrNull(offsets[4]),
    discounts: reader.readObjectList<EmbeddedDiscountModel>(
          offsets[5],
          EmbeddedDiscountModelSchema.deserialize,
          allOffsets,
          EmbeddedDiscountModel(),
        ) ??
        const [],
    hexId: reader.readString(offsets[6]),
    items: reader.readObjectList<ItemReceitItem>(
          offsets[7],
          ItemReceitItemSchema.deserialize,
          allOffsets,
          ItemReceitItem(),
        ) ??
        [],
    label: reader.readStringOrNull(offsets[8]) ?? "",
    miniTax: reader.readObjectList<MiniTax>(
          offsets[9],
          MiniTaxSchema.deserialize,
          allOffsets,
          MiniTax(),
        ) ??
        const [],
    payment: reader.readString(offsets[10]),
    synced: reader.readBoolOrNull(offsets[11]) ?? false,
    tax: reader.readDoubleOrNull(offsets[12]) ?? 0,
    total: reader.readDouble(offsets[13]),
  );
  object.id = id;
  return object;
}

P _itemReceitModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<EmbeddedDiscountModel>(
            offset,
            EmbeddedDiscountModelSchema.deserialize,
            allOffsets,
            EmbeddedDiscountModel(),
          ) ??
          const []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readObjectList<ItemReceitItem>(
            offset,
            ItemReceitItemSchema.deserialize,
            allOffsets,
            ItemReceitItem(),
          ) ??
          []) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 9:
      return (reader.readObjectList<MiniTax>(
            offset,
            MiniTaxSchema.deserialize,
            allOffsets,
            MiniTax(),
          ) ??
          const []) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 12:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemReceitModelGetId(ItemReceitModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemReceitModelGetLinks(ItemReceitModel object) {
  return [];
}

void _itemReceitModelAttach(
    IsarCollection<dynamic> col, Id id, ItemReceitModel object) {
  object.id = id;
}

extension ItemReceitModelQueryWhereSort
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QWhere> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemReceitModelQueryWhere
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QWhereClause> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterWhereClause> idBetween(
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

extension ItemReceitModelQueryFilter
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QFilterCondition> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cashier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cashier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashier',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      cashierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cashier',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      changeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'change',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      changeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'change',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      changeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'change',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      changeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'change',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discounts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdEqualTo(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdGreaterThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdLessThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdBetween(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdStartsWith(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdEndsWith(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelEqualTo(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelGreaterThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelLessThan(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelBetween(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelStartsWith(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelEndsWith(
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'miniTax',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payment',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      paymentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payment',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      syncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'synced',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      taxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      taxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      taxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      taxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      totalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      totalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      totalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      totalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ItemReceitModelQueryObject
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QFilterCondition> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      discountsElement(FilterQuery<EmbeddedDiscountModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'discounts');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      itemsElement(FilterQuery<ItemReceitItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
      miniTaxElement(FilterQuery<MiniTax> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'miniTax');
    });
  }
}

extension ItemReceitModelQueryLinks
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QFilterCondition> {}

extension ItemReceitModelQuerySortBy
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QSortBy> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByCashier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashier', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByCashierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashier', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payment', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payment', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension ItemReceitModelQuerySortThenBy
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QSortThenBy> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByCashier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashier', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByCashierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashier', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'change', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payment', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payment', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tax', Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
      thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension ItemReceitModelQueryWhereDistinct
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByCashier(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashier', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'change');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct>
      distinctByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByHexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByPayment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tax');
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }
}

extension ItemReceitModelQueryProperty
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QQueryProperty> {
  QueryBuilder<ItemReceitModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemReceitModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<ItemReceitModel, String, QQueryOperations> cashierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashier');
    });
  }

  QueryBuilder<ItemReceitModel, double, QQueryOperations> changeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'change');
    });
  }

  QueryBuilder<ItemReceitModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ItemReceitModel, String?, QQueryOperations>
      customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<ItemReceitModel, List<EmbeddedDiscountModel>, QQueryOperations>
      discountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discounts');
    });
  }

  QueryBuilder<ItemReceitModel, String, QQueryOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexId');
    });
  }

  QueryBuilder<ItemReceitModel, List<ItemReceitItem>, QQueryOperations>
      itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<ItemReceitModel, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<ItemReceitModel, List<MiniTax>, QQueryOperations>
      miniTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'miniTax');
    });
  }

  QueryBuilder<ItemReceitModel, String, QQueryOperations> paymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payment');
    });
  }

  QueryBuilder<ItemReceitModel, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<ItemReceitModel, double, QQueryOperations> taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tax');
    });
  }

  QueryBuilder<ItemReceitModel, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }
}
