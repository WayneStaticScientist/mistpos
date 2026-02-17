// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unsaved_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemUnsavedModelCollection on Isar {
  IsarCollection<int, ItemUnsavedModel> get itemUnsavedModels =>
      this.collection();
}

final ItemUnsavedModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemUnsavedModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'miniItems', type: IsarType.double),
      IsarPropertySchema(name: 'wholesalePrice', type: IsarType.double),
      IsarPropertySchema(name: 'wholesaleActivated', type: IsarType.bool),
      IsarPropertySchema(name: 'sku', type: IsarType.string),
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
  converter: IsarObjectConverter<int, ItemUnsavedModel>(
    serialize: serializeItemUnsavedModel,
    deserialize: deserializeItemUnsavedModel,
    deserializeProperty: deserializeItemUnsavedModelProp,
  ),
  getEmbeddedSchemas: () => [InvItemSchema],
);

@isarProtected
int serializeItemUnsavedModel(IsarWriter writer, ItemUnsavedModel object) {
  IsarCore.writeDouble(writer, 1, object.miniItems);
  IsarCore.writeDouble(writer, 2, object.wholesalePrice);
  IsarCore.writeBool(writer, 3, value: object.wholesaleActivated);
  IsarCore.writeString(writer, 4, object.sku);
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
ItemUnsavedModel deserializeItemUnsavedModel(IsarReader reader) {
  final double _miniItems;
  {
    final value = IsarCore.readDouble(reader, 1);
    if (value.isNaN) {
      _miniItems = 0;
    } else {
      _miniItems = value;
    }
  }
  final double _wholesalePrice;
  {
    final value = IsarCore.readDouble(reader, 2);
    if (value.isNaN) {
      _wholesalePrice = 0;
    } else {
      _wholesalePrice = value;
    }
  }
  final bool _wholesaleActivated;
  _wholesaleActivated = IsarCore.readBool(reader, 3);
  final String _sku;
  _sku = IsarCore.readString(reader, 4) ?? '';
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
  final object = ItemUnsavedModel(
    miniItems: _miniItems,
    wholesalePrice: _wholesalePrice,
    wholesaleActivated: _wholesaleActivated,
    sku: _sku,
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
dynamic deserializeItemUnsavedModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      {
        final value = IsarCore.readDouble(reader, 1);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
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
      return IsarCore.readBool(reader, 3);
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
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

sealed class _ItemUnsavedModelUpdate {
  bool call({
    required int id,
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    String? sku,
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

class _ItemUnsavedModelUpdateImpl implements _ItemUnsavedModelUpdate {
  const _ItemUnsavedModelUpdateImpl(this.collection);

  final IsarCollection<int, ItemUnsavedModel> collection;

  @override
  bool call({
    required int id,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? sku = ignore,
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
            if (miniItems != ignore) 1: miniItems as double?,
            if (wholesalePrice != ignore) 2: wholesalePrice as double?,
            if (wholesaleActivated != ignore) 3: wholesaleActivated as bool?,
            if (sku != ignore) 4: sku as String?,
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

sealed class _ItemUnsavedModelUpdateAll {
  int call({
    required List<int> id,
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    String? sku,
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

class _ItemUnsavedModelUpdateAllImpl implements _ItemUnsavedModelUpdateAll {
  const _ItemUnsavedModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemUnsavedModel> collection;

  @override
  int call({
    required List<int> id,
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? sku = ignore,
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
      if (miniItems != ignore) 1: miniItems as double?,
      if (wholesalePrice != ignore) 2: wholesalePrice as double?,
      if (wholesaleActivated != ignore) 3: wholesaleActivated as bool?,
      if (sku != ignore) 4: sku as String?,
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

extension ItemUnsavedModelUpdate on IsarCollection<int, ItemUnsavedModel> {
  _ItemUnsavedModelUpdate get update => _ItemUnsavedModelUpdateImpl(this);

  _ItemUnsavedModelUpdateAll get updateAll =>
      _ItemUnsavedModelUpdateAllImpl(this);
}

sealed class _ItemUnsavedModelQueryUpdate {
  int call({
    double? miniItems,
    double? wholesalePrice,
    bool? wholesaleActivated,
    String? sku,
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

class _ItemUnsavedModelQueryUpdateImpl implements _ItemUnsavedModelQueryUpdate {
  const _ItemUnsavedModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemUnsavedModel> query;
  final int? limit;

  @override
  int call({
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? sku = ignore,
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
      if (miniItems != ignore) 1: miniItems as double?,
      if (wholesalePrice != ignore) 2: wholesalePrice as double?,
      if (wholesaleActivated != ignore) 3: wholesaleActivated as bool?,
      if (sku != ignore) 4: sku as String?,
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

extension ItemUnsavedModelQueryUpdate on IsarQuery<ItemUnsavedModel> {
  _ItemUnsavedModelQueryUpdate get updateFirst =>
      _ItemUnsavedModelQueryUpdateImpl(this, limit: 1);

  _ItemUnsavedModelQueryUpdate get updateAll =>
      _ItemUnsavedModelQueryUpdateImpl(this);
}

class _ItemUnsavedModelQueryBuilderUpdateImpl
    implements _ItemUnsavedModelQueryUpdate {
  const _ItemUnsavedModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? miniItems = ignore,
    Object? wholesalePrice = ignore,
    Object? wholesaleActivated = ignore,
    Object? sku = ignore,
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
        if (miniItems != ignore) 1: miniItems as double?,
        if (wholesalePrice != ignore) 2: wholesalePrice as double?,
        if (wholesaleActivated != ignore) 3: wholesaleActivated as bool?,
        if (sku != ignore) 4: sku as String?,
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

extension ItemUnsavedModelQueryBuilderUpdate
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QOperations> {
  _ItemUnsavedModelQueryUpdate get updateFirst =>
      _ItemUnsavedModelQueryBuilderUpdateImpl(this, limit: 1);

  _ItemUnsavedModelQueryUpdate get updateAll =>
      _ItemUnsavedModelQueryBuilderUpdateImpl(this);
}

extension ItemUnsavedModelQueryFilter
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QFilterCondition> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 1, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 1, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 1, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  miniItemsBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 2, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesalePriceBetween(
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  wholesaleActivatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorGreaterThan(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorGreaterThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorLessThan(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorLessThanOrEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  colorBetween(int? lower, int? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  costEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  costGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  costGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  costLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  costLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  priceBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  shapeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  soldByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  avatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 13, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 14, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 14, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  barcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 14, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  trackStockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 15, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 16, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  stockQuantityBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 16, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 17, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  lowStockThresholdBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 17, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersElementLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 18, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
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

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 18, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 18, value: ''),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersIsEmpty() {
    return not().group((q) => q.modifiersIsNull().or().modifiersIsNotEmpty());
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  modifiersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 18, value: null),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  syncOnlineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 19, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  useProductionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 20, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  isCompositeItemEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 21, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  isForSaleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 22, value: value),
      );
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  compositeItemsIsEmpty() {
    return not().compositeItemsIsNotEmpty();
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterFilterCondition>
  compositeItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 23, value: null),
      );
    });
  }
}

extension ItemUnsavedModelQueryObject
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QFilterCondition> {}

extension ItemUnsavedModelQuerySortBy
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QSortBy> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortBySkuDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByHexIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByShapeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortBySoldBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortBySoldByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByAvatarDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByCategoryDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> sortByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByBarcodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  sortByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }
}

extension ItemUnsavedModelQuerySortThenBy
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QSortThenBy> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByMiniItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByWholesalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByWholesaleActivatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenBySkuDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByHexIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByShape({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByShapeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenBySoldBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenBySoldByDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByAvatarDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByCategoryDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy> thenByBarcode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByBarcodeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByTrackStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByStockQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByLowStockThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenBySyncOnlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByUseProductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByIsCompositeItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterSortBy>
  thenByIsForSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }
}

extension ItemUnsavedModelQueryWhereDistinct
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QDistinct> {
  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByMiniItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByWholesalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByWholesaleActivated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctBySku({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByHexId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByShape({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctBySoldBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByAvatar({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByBarcode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByTrackStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByStockQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByLowStockThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByModifiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctBySyncOnline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByUseProduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByIsCompositeItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QAfterDistinct>
  distinctByIsForSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22);
    });
  }
}

extension ItemUnsavedModelQueryProperty1
    on QueryBuilder<ItemUnsavedModel, ItemUnsavedModel, QProperty> {
  QueryBuilder<ItemUnsavedModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QAfterProperty> miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QAfterProperty>
  wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty>
  wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemUnsavedModel, int?, QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemUnsavedModel, double, QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, String?, QAfterProperty> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemUnsavedModel, String?, QAfterProperty> avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemUnsavedModel, String, QAfterProperty> barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty> trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, int, QAfterProperty> stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, int, QAfterProperty>
  lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, List<String>?, QAfterProperty>
  modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty> syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty> useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty>
  isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, bool, QAfterProperty> isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemUnsavedModel, List<InvItem>, QAfterProperty>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension ItemUnsavedModelQueryProperty2<R>
    on QueryBuilder<ItemUnsavedModel, R, QAfterProperty> {
  QueryBuilder<ItemUnsavedModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, double), QAfterProperty>
  miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, double), QAfterProperty>
  wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, int?), QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, double), QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, double), QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String?), QAfterProperty> shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty> soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String?), QAfterProperty>
  avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, String), QAfterProperty>
  barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, int), QAfterProperty>
  stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, int), QAfterProperty>
  lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, List<String>?), QAfterProperty>
  modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, bool), QAfterProperty>
  isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R, List<InvItem>), QAfterProperty>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension ItemUnsavedModelQueryProperty3<R1, R2>
    on QueryBuilder<ItemUnsavedModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemUnsavedModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, double), QOperations>
  miniItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, double), QOperations>
  wholesalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  wholesaleActivatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, int?), QOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, double), QOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations>
  hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, double), QOperations>
  priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String?), QOperations>
  shapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations>
  soldByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String?), QOperations>
  avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, String), QOperations>
  barcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  trackStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, int), QOperations>
  stockQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, int), QOperations>
  lowStockThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, List<String>?), QOperations>
  modifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  syncOnlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  useProductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  isCompositeItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, bool), QOperations>
  isForSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<ItemUnsavedModel, (R1, R2, List<InvItem>), QOperations>
  compositeItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}
