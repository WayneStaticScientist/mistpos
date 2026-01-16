// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unsaved_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItemUnsavedModelCollection on Isar {
  IsarCollection<ItemUnsavedModel> get itemUnsavedModels => this.collection();
}

const ItemUnsavedModelSchema = CollectionSchema(
  name: r'ItemUnsavedModel',
  id: 4231373690183285565,
  properties: {
    r'avatar': PropertySchema(
      id: 0,
      name: r'avatar',
      type: IsarType.string,
    ),
    r'barcode': PropertySchema(
      id: 1,
      name: r'barcode',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 3,
      name: r'color',
      type: IsarType.long,
    ),
    r'compositeItems': PropertySchema(
      id: 4,
      name: r'compositeItems',
      type: IsarType.objectList,
      target: r'InvItem',
    ),
    r'cost': PropertySchema(
      id: 5,
      name: r'cost',
      type: IsarType.double,
    ),
    r'hexId': PropertySchema(
      id: 6,
      name: r'hexId',
      type: IsarType.string,
    ),
    r'isCompositeItem': PropertySchema(
      id: 7,
      name: r'isCompositeItem',
      type: IsarType.bool,
    ),
    r'isForSale': PropertySchema(
      id: 8,
      name: r'isForSale',
      type: IsarType.bool,
    ),
    r'lowStockThreshold': PropertySchema(
      id: 9,
      name: r'lowStockThreshold',
      type: IsarType.long,
    ),
    r'miniItems': PropertySchema(
      id: 10,
      name: r'miniItems',
      type: IsarType.double,
    ),
    r'modifiers': PropertySchema(
      id: 11,
      name: r'modifiers',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(
      id: 12,
      name: r'name',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 13,
      name: r'price',
      type: IsarType.double,
    ),
    r'shape': PropertySchema(
      id: 14,
      name: r'shape',
      type: IsarType.string,
    ),
    r'sku': PropertySchema(
      id: 15,
      name: r'sku',
      type: IsarType.string,
    ),
    r'soldBy': PropertySchema(
      id: 16,
      name: r'soldBy',
      type: IsarType.string,
    ),
    r'stockQuantity': PropertySchema(
      id: 17,
      name: r'stockQuantity',
      type: IsarType.long,
    ),
    r'syncOnline': PropertySchema(
      id: 18,
      name: r'syncOnline',
      type: IsarType.bool,
    ),
    r'trackStock': PropertySchema(
      id: 19,
      name: r'trackStock',
      type: IsarType.bool,
    ),
    r'useProduction': PropertySchema(
      id: 20,
      name: r'useProduction',
      type: IsarType.bool,
    ),
    r'wholesaleActivated': PropertySchema(
      id: 21,
      name: r'wholesaleActivated',
      type: IsarType.bool,
    ),
    r'wholesalePrice': PropertySchema(
      id: 22,
      name: r'wholesalePrice',
      type: IsarType.double,
    )
  },
  estimateSize: _itemUnsavedModelEstimateSize,
  serialize: _itemUnsavedModelSerialize,
  deserialize: _itemUnsavedModelDeserialize,
  deserializeProp: _itemUnsavedModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'InvItem': InvItemSchema},
  getId: _itemUnsavedModelGetId,
  getLinks: _itemUnsavedModelGetLinks,
  attach: _itemUnsavedModelAttach,
  version: '3.1.0+1',
);

int _itemUnsavedModelEstimateSize(
  ItemUnsavedModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.barcode.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.compositeItems.length * 3;
  {
    final offsets = allOffsets[InvItem]!;
    for (var i = 0; i < object.compositeItems.length; i++) {
      final value = object.compositeItems[i];
      bytesCount += InvItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.hexId.length * 3;
  {
    final list = object.modifiers;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.shape;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sku.length * 3;
  bytesCount += 3 + object.soldBy.length * 3;
  return bytesCount;
}

void _itemUnsavedModelSerialize(
  ItemUnsavedModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.avatar);
  writer.writeString(offsets[1], object.barcode);
  writer.writeString(offsets[2], object.category);
  writer.writeLong(offsets[3], object.color);
  writer.writeObjectList<InvItem>(
    offsets[4],
    allOffsets,
    InvItemSchema.serialize,
    object.compositeItems,
  );
  writer.writeDouble(offsets[5], object.cost);
  writer.writeString(offsets[6], object.hexId);
  writer.writeBool(offsets[7], object.isCompositeItem);
  writer.writeBool(offsets[8], object.isForSale);
  writer.writeLong(offsets[9], object.lowStockThreshold);
  writer.writeDouble(offsets[10], object.miniItems);
  writer.writeStringList(offsets[11], object.modifiers);
  writer.writeString(offsets[12], object.name);
  writer.writeDouble(offsets[13], object.price);
  writer.writeString(offsets[14], object.shape);
  writer.writeString(offsets[15], object.sku);
  writer.writeString(offsets[16], object.soldBy);
  writer.writeLong(offsets[17], object.stockQuantity);
  writer.writeBool(offsets[18], object.syncOnline);
  writer.writeBool(offsets[19], object.trackStock);
  writer.writeBool(offsets[20], object.useProduction);
  writer.writeBool(offsets[21], object.wholesaleActivated);
  writer.writeDouble(offsets[22], object.wholesalePrice);
}

ItemUnsavedModel _itemUnsavedModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemUnsavedModel(
    avatar: reader.readStringOrNull(offsets[0]),
    barcode: reader.readString(offsets[1]),
    category: reader.readString(offsets[2]),
    color: reader.readLongOrNull(offsets[3]),
    compositeItems: reader.readObjectList<InvItem>(
          offsets[4],
          InvItemSchema.deserialize,
          allOffsets,
          InvItem(),
        ) ??
        const [],
    cost: reader.readDouble(offsets[5]),
    hexId: reader.readStringOrNull(offsets[6]) ?? "",
    isCompositeItem: reader.readBoolOrNull(offsets[7]) ?? false,
    isForSale: reader.readBoolOrNull(offsets[8]) ?? true,
    lowStockThreshold: reader.readLong(offsets[9]),
    miniItems: reader.readDoubleOrNull(offsets[10]) ?? 0,
    modifiers: reader.readStringList(offsets[11]),
    name: reader.readString(offsets[12]),
    price: reader.readDouble(offsets[13]),
    shape: reader.readStringOrNull(offsets[14]),
    sku: reader.readString(offsets[15]),
    soldBy: reader.readString(offsets[16]),
    stockQuantity: reader.readLong(offsets[17]),
    syncOnline: reader.readBoolOrNull(offsets[18]) ?? false,
    trackStock: reader.readBool(offsets[19]),
    useProduction: reader.readBoolOrNull(offsets[20]) ?? false,
    wholesaleActivated: reader.readBoolOrNull(offsets[21]) ?? false,
    wholesalePrice: reader.readDoubleOrNull(offsets[22]) ?? 0,
  );
  object.id = id;
  return object;
}

P _itemUnsavedModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readObjectList<InvItem>(
            offset,
            InvItemSchema.deserialize,
            allOffsets,
            InvItem(),
          ) ??
          const []) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readStringList(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 21:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 22:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemUnsavedModelGetId(ItemUnsavedModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemUnsavedModelGetLinks(ItemUnsavedModel object) {
  return [];
}

void _itemUnsavedModelAttach(
    IsarCollection<dynamic> col, Id id, ItemUnsavedModel object) {
  object.id = id;
}

extension ItemUnsavedModelQueryWhereSort
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QWhere> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemUnsavedModelQueryWhere
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QWhereClause> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhereClause>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterWhereClause> idBetween(
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

extension ItemUnsavedModelQueryFilter
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QFilterCondition> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatar',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatar',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatar',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatar',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      avatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatar',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'barcode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'barcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'barcode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcode',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      barcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'barcode',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      colorBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compositeItems',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      costEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      costGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      costLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      costBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      hexIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      hexIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      isCompositeItemEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompositeItem',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      isForSaleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isForSale',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      lowStockThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowStockThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      lowStockThresholdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowStockThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      lowStockThresholdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowStockThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      lowStockThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowStockThreshold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      miniItemsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'miniItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      miniItemsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'miniItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      miniItemsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'miniItems',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      miniItemsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'miniItems',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modifiers',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modifiers',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifiers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modifiers',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      modifiersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'modifiers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shape',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shape',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shape',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shape',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shape',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shape',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      shapeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shape',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sku',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sku',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sku',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'soldBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'soldBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'soldBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'soldBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      soldByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'soldBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      stockQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stockQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      stockQuantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stockQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      stockQuantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stockQuantity',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      stockQuantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stockQuantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      syncOnlineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncOnline',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      trackStockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackStock',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      useProductionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useProduction',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      wholesaleActivatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wholesaleActivated',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      wholesalePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      wholesalePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      wholesalePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wholesalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      wholesalePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wholesalePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ItemUnsavedModelQueryObject
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QFilterCondition> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
      compositeItemsElement(FilterQuery<InvItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'compositeItems');
    });
  }
}

extension ItemUnsavedModelQueryLinks
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QFilterCondition> {}

extension ItemUnsavedModelQuerySortBy
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QSortBy> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompositeItem', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompositeItem', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSale', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSale', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockThreshold', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockThreshold', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'miniItems', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'miniItems', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortBySoldBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldBy', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortBySoldByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldBy', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockQuantity', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockQuantity', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOnline', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOnline', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProduction', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProduction', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesaleActivated', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesaleActivated', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      sortByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.desc);
    });
  }
}

extension ItemUnsavedModelQuerySortThenBy
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QSortThenBy> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcode', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByHexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByHexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexId', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompositeItem', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompositeItem', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSale', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSale', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockThreshold', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockThreshold', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'miniItems', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'miniItems', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByShape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByShapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shape', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenBySoldBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldBy', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenBySoldByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soldBy', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockQuantity', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockQuantity', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOnline', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOnline', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackStock', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProduction', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useProduction', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesaleActivated', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesaleActivated', Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.asc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
      thenByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wholesalePrice', Sort.desc);
    });
  }
}

extension ItemUnsavedModelQueryWhereDistinct
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByAvatar(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatar', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByBarcode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cost');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByHexId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompositeItem');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isForSale');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowStockThreshold');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'miniItems');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByModifiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiers');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctByShape(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shape', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> distinctBySoldBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soldBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockQuantity');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncOnline');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackStock');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useProduction');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wholesaleActivated');
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct>
      distinctByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wholesalePrice');
    });
  }
}

extension ItemUnsavedModelQueryProperty
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QQueryProperty> {
  QueryBuilder<ItemUnsavedModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemUnsavedModel, String?, QQueryOperations> avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatar');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcode');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<ItemUnsavedModel, int?, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<ItemUnsavedModel, List<InvItem>, QQueryOperations>
      compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compositeItems');
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QQueryOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cost');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexId');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations>
      isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompositeItem');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations> isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isForSale');
    });
  }

  QueryBuilder<ItemUnsavedModel, int, QQueryOperations>
      lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowStockThreshold');
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QQueryOperations> miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'miniItems');
    });
  }

  QueryBuilder<ItemUnsavedModel, List<String>?, QQueryOperations>
      modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiers');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<ItemUnsavedModel, String?, QQueryOperations> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shape');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sku');
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QQueryOperations> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soldBy');
    });
  }

  QueryBuilder<ItemUnsavedModel, int, QQueryOperations>
      stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockQuantity');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations> syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncOnline');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackStock');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations>
      useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useProduction');
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QQueryOperations>
      wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wholesaleActivated');
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QQueryOperations>
      wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wholesalePrice');
    });
  }
}
