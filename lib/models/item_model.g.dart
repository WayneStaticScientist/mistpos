// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemModelCollection on Isar {
  IsarCollection<int, ItemModel> get itemModels => this.collection();
}

final ItemModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'sku', type: IsarType.string),
      IsarPropertySchema(name: 'miniItems', type: IsarType.double),
      IsarPropertySchema(name: 'wholesalePrice', type: IsarType.double),
      IsarPropertySchema(name: 'wholesaleActivated', type: IsarType.bool),
      IsarPropertySchema(name: 'color', type: IsarType.long),
      IsarPropertySchema(name: 'cost', type: IsarType.double),
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
      IsarPropertySchema(name: 'price', type: IsarType.double),
      IsarPropertySchema(name: 'shape', type: IsarType.string),
      IsarPropertySchema(name: 'soldBy', type: IsarType.string),
      IsarPropertySchema(name: 'avatar', type: IsarType.string),
      IsarPropertySchema(name: 'category', type: IsarType.string),
      IsarPropertySchema(name: 'barcode', type: IsarType.string),
      IsarPropertySchema(name: 'trackStock', type: IsarType.bool),
      IsarPropertySchema(name: 'stockQuantity', type: IsarType.long),
      IsarPropertySchema(name: 'lowStockThreshold', type: IsarType.long),
      IsarPropertySchema(name: 'modifiers', type: IsarType.stringList),
      IsarPropertySchema(name: 'syncOnline', type: IsarType.bool),
      IsarPropertySchema(name: 'useProduction', type: IsarType.bool),
      IsarPropertySchema(name: 'isCompositeItem', type: IsarType.bool),
      IsarPropertySchema(name: 'isForSale', type: IsarType.bool),
      IsarPropertySchema(
        name: 'compositeItems',
        type: IsarType.objectList,
        target: 'InvItem',
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ItemModel>(
    serialize: serializeItemModel,
    deserialize: deserializeItemModel,
    deserializeProperty: deserializeItemModelProp,
  ),
  getEmbeddedSchemas: () => [InvItemSchema],
);

@isarProtected
int serializeItemModel(IsarWriter writer, ItemModel object) {
  IsarCore.writeString(writer, 1, object.sku);
  IsarCore.writeDouble(writer, 2, object.miniItems);
  IsarCore.writeDouble(writer, 3, object.wholesalePrice);
  IsarCore.writeBool(writer, 4, value: object.wholesaleActivated);
  IsarCore.writeLong(writer, 5, object.color ?? -9223372036854775808);
  IsarCore.writeDouble(writer, 6, object.cost);
  IsarCore.writeString(writer, 7, object.name);
  IsarCore.writeString(writer, 8, object.hexId);
  IsarCore.writeDouble(writer, 9, object.price);
  {
    final value = object.shape;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  IsarCore.writeString(writer, 11, object.soldBy);
  {
    final value = object.avatar;
    if (value == null) {
      IsarCore.writeNull(writer, 12);
    } else {
      IsarCore.writeString(writer, 12, value);
    }
  }
  IsarCore.writeString(writer, 13, object.category);
  IsarCore.writeString(writer, 14, object.barcode);
  IsarCore.writeBool(writer, 15, value: object.trackStock);
  IsarCore.writeLong(writer, 16, object.stockQuantity);
  IsarCore.writeLong(writer, 17, object.lowStockThreshold);
  {
    final list = object.modifiers;
    if (list == null) {
      IsarCore.writeNull(writer, 18);
    } else {
      final listWriter = IsarCore.beginList(writer, 18, list.length);
      for (var i = 0; i < list.length; i++) {
        IsarCore.writeString(listWriter, i, list[i]);
      }
      IsarCore.endList(writer, listWriter);
    }
  }
  IsarCore.writeBool(writer, 19, value: object.syncOnline);
  IsarCore.writeBool(writer, 20, value: object.useProduction);
  IsarCore.writeBool(writer, 21, value: object.isCompositeItem);
  IsarCore.writeBool(writer, 22, value: object.isForSale);
  {
    final list = object.compositeItems;
    final listWriter = IsarCore.beginList(writer, 23, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeInvItem(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  return object.id;
}

@isarProtected
ItemModel deserializeItemModel(IsarReader reader) {
  final String _sku;
  _sku = IsarCore.readString(reader, 1) ?? '';
  final double _miniItems;
  {
    final value = IsarCore.readDouble(reader, 2);
    if (value.isNaN) {
      _miniItems = 0;
    } else {
      _miniItems = value;
    }
  }
  final double _wholesalePrice;
  {
    final value = IsarCore.readDouble(reader, 3);
    if (value.isNaN) {
      _wholesalePrice = 0;
    } else {
      _wholesalePrice = value;
    }
  }
  final bool _wholesaleActivated;
  _wholesaleActivated = IsarCore.readBool(reader, 4);
  final int? _color;
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      _color = null;
    } else {
      _color = value;
    }
  }
  final double _cost;
  _cost = IsarCore.readDouble(reader, 6);
  final String _name;
  _name = IsarCore.readString(reader, 7) ?? '';
  final String _hexId;
  _hexId = IsarCore.readString(reader, 8) ?? "";
  final double _price;
  _price = IsarCore.readDouble(reader, 9);
  final String? _shape;
  _shape = IsarCore.readString(reader, 10);
  final String _soldBy;
  _soldBy = IsarCore.readString(reader, 11) ?? '';
  final String? _avatar;
  _avatar = IsarCore.readString(reader, 12);
  final String _category;
  _category = IsarCore.readString(reader, 13) ?? '';
  final String _barcode;
  _barcode = IsarCore.readString(reader, 14) ?? '';
  final bool _trackStock;
  _trackStock = IsarCore.readBool(reader, 15);
  final int _stockQuantity;
  _stockQuantity = IsarCore.readLong(reader, 16);
  final int _lowStockThreshold;
  _lowStockThreshold = IsarCore.readLong(reader, 17);
  final List<String>? _modifiers;
  {
    final length = IsarCore.readList(reader, 18, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _modifiers = null;
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        _modifiers = list;
      }
    }
  }
  final bool _syncOnline;
  _syncOnline = IsarCore.readBool(reader, 19);
  final bool _useProduction;
  _useProduction = IsarCore.readBool(reader, 20);
  final bool _isCompositeItem;
  _isCompositeItem = IsarCore.readBool(reader, 21);
  final bool _isForSale;
  {
    if (IsarCore.readNull(reader, 22)) {
      _isForSale = true;
    } else {
      _isForSale = IsarCore.readBool(reader, 22);
    }
  }
  final List<InvItem> _compositeItems;
  {
    final length = IsarCore.readList(reader, 23, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _compositeItems = const [];
      } else {
        final list = List<InvItem>.filled(length, InvItem(), growable: true);
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = InvItem();
            } else {
              final embedded = deserializeInvItem(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _compositeItems = list;
      }
    }
  }
  final object = ItemModel(
    sku: _sku,
    miniItems: _miniItems,
    wholesalePrice: _wholesalePrice,
    wholesaleActivated: _wholesaleActivated,
    color: _color,
    cost: _cost,
    name: _name,
    hexId: _hexId,
    price: _price,
    shape: _shape,
    soldBy: _soldBy,
    avatar: _avatar,
    category: _category,
    barcode: _barcode,
    trackStock: _trackStock,
    stockQuantity: _stockQuantity,
    lowStockThreshold: _lowStockThreshold,
    modifiers: _modifiers,
    syncOnline: _syncOnline,
    useProduction: _useProduction,
    isCompositeItem: _isCompositeItem,
    isForSale: _isForSale,
    compositeItems: _compositeItems,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeItemModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        final value = IsarCore.readDouble(reader, 2);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
    case 3:
      {
        final value = IsarCore.readDouble(reader, 3);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
    case 4:
      return IsarCore.readBool(reader, 4);
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 6:
      return IsarCore.readDouble(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    case 8:
      return IsarCore.readString(reader, 8) ?? "";
    case 9:
      return IsarCore.readDouble(reader, 9);
    case 10:
      return IsarCore.readString(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11) ?? '';
    case 12:
      return IsarCore.readString(reader, 12);
    case 13:
      return IsarCore.readString(reader, 13) ?? '';
    case 14:
      return IsarCore.readString(reader, 14) ?? '';
    case 15:
      return IsarCore.readBool(reader, 15);
    case 16:
      return IsarCore.readLong(reader, 16);
    case 17:
      return IsarCore.readLong(reader, 17);
    case 18:
      {
        final length = IsarCore.readList(reader, 18, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return null;
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
    case 19:
      return IsarCore.readBool(reader, 19);
    case 20:
      return IsarCore.readBool(reader, 20);
    case 21:
      return IsarCore.readBool(reader, 21);
    case 22:
      {
        if (IsarCore.readNull(reader, 22)) {
          return true;
        } else {
          return IsarCore.readBool(reader, 22);
        }
      }
    case 23:
      {
        final length = IsarCore.readList(reader, 23, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const [];
          } else {
            final list = List<InvItem>.filled(
              length,
              InvItem(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = InvItem();
                } else {
                  final embedded = deserializeInvItem(objectReader);
                  IsarCore.freeReader(objectReader);
                  list[i] = embedded;
                }
              }
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ItemModelUpdate {
  bool call({
    required int id,
    String? sku,
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    int? color,
    double? cost,
    String? name,
    String? hexId,
    double? price,
    String? shape,
    String? soldBy,
    String? avatar,
    String? category,
    String? barcode,
    bool? trackStock,
    int? stockQuantity,
    int? lowStockThreshold,
    bool? syncOnline,
    bool? useProduction,
    bool? isCompositeItem,
    bool? isForSale,
  });
}

class _ItemModelUpdateImpl implements _ItemModelUpdate {
  const _ItemModelUpdateImpl(this.collection);

  final IsarCollection<int, ItemModel> collection;

  @override
  bool call({
    required int id,
    Object? sku = ignore,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? color = ignore,
    Object? cost = ignore,
    Object? name = ignore,
    Object? hexId = ignore,
    Object? price = ignore,
    Object? shape = ignore,
    Object? soldBy = ignore,
    Object? avatar = ignore,
    Object? category = ignore,
    Object? barcode = ignore,
    Object? trackStock = ignore,
    Object? stockQuantity = ignore,
    Object? lowStockThreshold = ignore,
    Object? syncOnline = ignore,
    Object? useProduction = ignore,
    Object? isCompositeItem = ignore,
    Object? isForSale = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (sku != ignore) 1: sku as String?,
            if (miniItems != ignore) 2: miniItems as double?,
            if (wholesalePrice != ignore) 3: wholesalePrice as double?,
            if (wholesaleActivated != ignore) 4: wholesaleActivated as bool?,
            if (color != ignore) 5: color as int?,
            if (cost != ignore) 6: cost as double?,
            if (name != ignore) 7: name as String?,
            if (hexId != ignore) 8: hexId as String?,
            if (price != ignore) 9: price as double?,
            if (shape != ignore) 10: shape as String?,
            if (soldBy != ignore) 11: soldBy as String?,
            if (avatar != ignore) 12: avatar as String?,
            if (category != ignore) 13: category as String?,
            if (barcode != ignore) 14: barcode as String?,
            if (trackStock != ignore) 15: trackStock as bool?,
            if (stockQuantity != ignore) 16: stockQuantity as int?,
            if (lowStockThreshold != ignore) 17: lowStockThreshold as int?,
            if (syncOnline != ignore) 19: syncOnline as bool?,
            if (useProduction != ignore) 20: useProduction as bool?,
            if (isCompositeItem != ignore) 21: isCompositeItem as bool?,
            if (isForSale != ignore) 22: isForSale as bool?,
          },
        ) >
        0;
  }
}

sealed class _ItemModelUpdateAll {
  int call({
    required List<int> id,
    String? sku,
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    int? color,
    double? cost,
    String? name,
    String? hexId,
    double? price,
    String? shape,
    String? soldBy,
    String? avatar,
    String? category,
    String? barcode,
    bool? trackStock,
    int? stockQuantity,
    int? lowStockThreshold,
    bool? syncOnline,
    bool? useProduction,
    bool? isCompositeItem,
    bool? isForSale,
  });
}

class _ItemModelUpdateAllImpl implements _ItemModelUpdateAll {
  const _ItemModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemModel> collection;

  @override
  int call({
    required List<int> id,
    Object? sku = ignore,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? color = ignore,
    Object? cost = ignore,
    Object? name = ignore,
    Object? hexId = ignore,
    Object? price = ignore,
    Object? shape = ignore,
    Object? soldBy = ignore,
    Object? avatar = ignore,
    Object? category = ignore,
    Object? barcode = ignore,
    Object? trackStock = ignore,
    Object? stockQuantity = ignore,
    Object? lowStockThreshold = ignore,
    Object? syncOnline = ignore,
    Object? useProduction = ignore,
    Object? isCompositeItem = ignore,
    Object? isForSale = ignore,
  }) {
    return collection.updateProperties(id, {
      if (sku != ignore) 1: sku as String?,
      if (miniItems != ignore) 2: miniItems as double?,
      if (wholesalePrice != ignore) 3: wholesalePrice as double?,
      if (wholesaleActivated != ignore) 4: wholesaleActivated as bool?,
      if (color != ignore) 5: color as int?,
      if (cost != ignore) 6: cost as double?,
      if (name != ignore) 7: name as String?,
      if (hexId != ignore) 8: hexId as String?,
      if (price != ignore) 9: price as double?,
      if (shape != ignore) 10: shape as String?,
      if (soldBy != ignore) 11: soldBy as String?,
      if (avatar != ignore) 12: avatar as String?,
      if (category != ignore) 13: category as String?,
      if (barcode != ignore) 14: barcode as String?,
      if (trackStock != ignore) 15: trackStock as bool?,
      if (stockQuantity != ignore) 16: stockQuantity as int?,
      if (lowStockThreshold != ignore) 17: lowStockThreshold as int?,
      if (syncOnline != ignore) 19: syncOnline as bool?,
      if (useProduction != ignore) 20: useProduction as bool?,
      if (isCompositeItem != ignore) 21: isCompositeItem as bool?,
      if (isForSale != ignore) 22: isForSale as bool?,
    });
  }
}

extension ItemModelUpdate on IsarCollection<int, ItemModel> {
  _ItemModelUpdate get update => _ItemModelUpdateImpl(this);

  _ItemModelUpdateAll get updateAll => _ItemModelUpdateAllImpl(this);
}

sealed class _ItemModelQueryUpdate {
  int call({
    String? sku,
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    int? color,
    double? cost,
    String? name,
    String? hexId,
    double? price,
    String? shape,
    String? soldBy,
    String? avatar,
    String? category,
    String? barcode,
    bool? trackStock,
    int? stockQuantity,
    int? lowStockThreshold,
    bool? syncOnline,
    bool? useProduction,
    bool? isCompositeItem,
    bool? isForSale,
  });
}

class _ItemModelQueryUpdateImpl implements _ItemModelQueryUpdate {
  const _ItemModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemModel> query;
  final int? limit;

  @override
  int call({
    Object? sku = ignore,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? color = ignore,
    Object? cost = ignore,
    Object? name = ignore,
    Object? hexId = ignore,
    Object? price = ignore,
    Object? shape = ignore,
    Object? soldBy = ignore,
    Object? avatar = ignore,
    Object? category = ignore,
    Object? barcode = ignore,
    Object? trackStock = ignore,
    Object? stockQuantity = ignore,
    Object? lowStockThreshold = ignore,
    Object? syncOnline = ignore,
    Object? useProduction = ignore,
    Object? isCompositeItem = ignore,
    Object? isForSale = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (sku != ignore) 1: sku as String?,
      if (miniItems != ignore) 2: miniItems as double?,
      if (wholesalePrice != ignore) 3: wholesalePrice as double?,
      if (wholesaleActivated != ignore) 4: wholesaleActivated as bool?,
      if (color != ignore) 5: color as int?,
      if (cost != ignore) 6: cost as double?,
      if (name != ignore) 7: name as String?,
      if (hexId != ignore) 8: hexId as String?,
      if (price != ignore) 9: price as double?,
      if (shape != ignore) 10: shape as String?,
      if (soldBy != ignore) 11: soldBy as String?,
      if (avatar != ignore) 12: avatar as String?,
      if (category != ignore) 13: category as String?,
      if (barcode != ignore) 14: barcode as String?,
      if (trackStock != ignore) 15: trackStock as bool?,
      if (stockQuantity != ignore) 16: stockQuantity as int?,
      if (lowStockThreshold != ignore) 17: lowStockThreshold as int?,
      if (syncOnline != ignore) 19: syncOnline as bool?,
      if (useProduction != ignore) 20: useProduction as bool?,
      if (isCompositeItem != ignore) 21: isCompositeItem as bool?,
      if (isForSale != ignore) 22: isForSale as bool?,
    });
  }
}

extension ItemModelQueryUpdate on IsarQuery<ItemModel> {
  _ItemModelQueryUpdate get updateFirst =>
      _ItemModelQueryUpdateImpl(this, limit: 1);

  _ItemModelQueryUpdate get updateAll => _ItemModelQueryUpdateImpl(this);
}

class _ItemModelQueryBuilderUpdateImpl implements _ItemModelQueryUpdate {
  const _ItemModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemModel, ItemModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? sku = ignore,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? color = ignore,
    Object? cost = ignore,
    Object? name = ignore,
    Object? hexId = ignore,
    Object? price = ignore,
    Object? shape = ignore,
    Object? soldBy = ignore,
    Object? avatar = ignore,
    Object? category = ignore,
    Object? barcode = ignore,
    Object? trackStock = ignore,
    Object? stockQuantity = ignore,
    Object? lowStockThreshold = ignore,
    Object? syncOnline = ignore,
    Object? useProduction = ignore,
    Object? isCompositeItem = ignore,
    Object? isForSale = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (sku != ignore) 1: sku as String?,
        if (miniItems != ignore) 2: miniItems as double?,
        if (wholesalePrice != ignore) 3: wholesalePrice as double?,
        if (wholesaleActivated != ignore) 4: wholesaleActivated as bool?,
        if (color != ignore) 5: color as int?,
        if (cost != ignore) 6: cost as double?,
        if (name != ignore) 7: name as String?,
        if (hexId != ignore) 8: hexId as String?,
        if (price != ignore) 9: price as double?,
        if (shape != ignore) 10: shape as String?,
        if (soldBy != ignore) 11: soldBy as String?,
        if (avatar != ignore) 12: avatar as String?,
        if (category != ignore) 13: category as String?,
        if (barcode != ignore) 14: barcode as String?,
        if (trackStock != ignore) 15: trackStock as bool?,
        if (stockQuantity != ignore) 16: stockQuantity as int?,
        if (lowStockThreshold != ignore) 17: lowStockThreshold as int?,
        if (syncOnline != ignore) 19: syncOnline as bool?,
        if (useProduction != ignore) 20: useProduction as bool?,
        if (isCompositeItem != ignore) 21: isCompositeItem as bool?,
        if (isForSale != ignore) 22: isForSale as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension ItemModelQueryBuilderUpdate
    on QueryBuilder<ItemModel, ItemModel, QOperations> {
  _ItemModelQueryUpdate get updateFirst =>
      _ItemModelQueryBuilderUpdateImpl(this, limit: 1);

  _ItemModelQueryUpdate get updateAll => _ItemModelQueryBuilderUpdateImpl(this);
}

extension ItemModelQueryFilter
    on QueryBuilder<ItemModel, ItemModel, QFilterCondition> {
  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuGreaterThan(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  skuGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  skuLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuBetween(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuStartsWith(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuEndsWith(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuContains(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuMatches(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> miniItemsEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  miniItemsGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  miniItemsGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> miniItemsLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  miniItemsLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> miniItemsBetween(
    double lower,
    double upper, {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesalePriceBetween(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  wholesaleActivatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  colorGreaterThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  colorLessThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> colorBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> costEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> costGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  costGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> costLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  costLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> costBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  nameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  nameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> priceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> priceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  priceGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> priceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  priceLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> priceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  shapeGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  shapeLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 10,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> shapeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  soldByGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  soldByLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> soldByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  avatarGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  avatarLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 12,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> avatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  categoryGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 13, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  categoryLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 13,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  barcodeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 14, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  barcodeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 14,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 14,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> barcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 14, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  barcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 14, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> trackStockEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 15, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  stockQuantityBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 16, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  lowStockThresholdBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 17, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> modifiersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 18, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 18,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 18, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 18, value: ''),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> modifiersIsEmpty() {
    return not().group((q) => q.modifiersIsNull().or().modifiersIsNotEmpty());
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  modifiersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 18, value: null),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> syncOnlineEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 19, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  useProductionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 20, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  isCompositeItemEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 21, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition> isForSaleEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 22, value: value),
      );
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  compositeItemsIsEmpty() {
    return not().compositeItemsIsNotEmpty();
  }

  QueryBuilder<ItemModel, ItemModel, QAfterFilterCondition>
  compositeItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 23, value: null),
      );
    });
  }
}

extension ItemModelQueryObject
    on QueryBuilder<ItemModel, ItemModel, QFilterCondition> {}

extension ItemModelQuerySortBy on QueryBuilder<ItemModel, ItemModel, QSortBy> {
  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySkuDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy>
  sortByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByShapeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySoldBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySoldByDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByAvatarDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByCategoryDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByBarcodeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy>
  sortByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> sortByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }
}

extension ItemModelQuerySortThenBy
    on QueryBuilder<ItemModel, ItemModel, QSortThenBy> {
  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySkuDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy>
  thenByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByShapeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySoldBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySoldByDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByAvatarDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByCategoryDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByBarcodeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy>
  thenByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterSortBy> thenByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }
}

extension ItemModelQueryWhereDistinct
    on QueryBuilder<ItemModel, ItemModel, QDistinct> {
  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct>
  distinctByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct>
  distinctByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctBySoldBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct>
  distinctByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByModifiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct>
  distinctByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21);
    });
  }

  QueryBuilder<ItemModel, ItemModel, QAfterDistinct> distinctByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22);
    });
  }
}

extension ItemModelQueryProperty1
    on QueryBuilder<ItemModel, ItemModel, QProperty> {
  QueryBuilder<ItemModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModel, double, QAfterProperty> miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModel, double, QAfterProperty> wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemModel, int?, QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemModel, double, QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemModel, double, QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemModel, String?, QAfterProperty> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemModel, String?, QAfterProperty> avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemModel, String, QAfterProperty> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemModel, int, QAfterProperty> stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemModel, int, QAfterProperty> lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemModel, List<String>?, QAfterProperty> modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemModel, bool, QAfterProperty> isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemModel, List<InvItem>, QAfterProperty>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension ItemModelQueryProperty2<R>
    on QueryBuilder<ItemModel, R, QAfterProperty> {
  QueryBuilder<ItemModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModel, (R, double), QAfterProperty> miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModel, (R, double), QAfterProperty>
  wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty>
  wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemModel, (R, int?), QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemModel, (R, double), QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemModel, (R, double), QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemModel, (R, String?), QAfterProperty> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemModel, (R, String?), QAfterProperty> avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemModel, (R, String), QAfterProperty> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemModel, (R, int), QAfterProperty> stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemModel, (R, int), QAfterProperty>
  lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemModel, (R, List<String>?), QAfterProperty>
  modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty> syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty> useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty> isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemModel, (R, bool), QAfterProperty> isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemModel, (R, List<InvItem>), QAfterProperty>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension ItemModelQueryProperty3<R1, R2>
    on QueryBuilder<ItemModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, double), QOperations> miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, double), QOperations>
  wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations>
  wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, int?), QOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, double), QOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, double), QOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String?), QOperations> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String?), QOperations> avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, String), QOperations> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, int), QOperations> stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, int), QOperations>
  lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, List<String>?), QOperations>
  modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations> syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations> useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations>
  isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, bool), QOperations> isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemModel, (R1, R2, List<InvItem>), QOperations>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}
