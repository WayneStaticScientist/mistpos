// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_receit_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetItemReceitModelCollection on Isar {
  IsarCollection<int, ItemReceitModel> get itemReceitModels =>
      this.collection();
}

final ItemReceitModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ItemReceitModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'cashier', type: IsarType.string),
      IsarPropertySchema(name: 'payment', type: IsarType.string),
      IsarPropertySchema(name: 'change', type: IsarType.double),
      IsarPropertySchema(name: 'creditSale', type: IsarType.bool),
      IsarPropertySchema(name: 'tax', type: IsarType.double),
      IsarPropertySchema(name: 'amount', type: IsarType.double),
      IsarPropertySchema(name: 'total', type: IsarType.double),
      IsarPropertySchema(name: 'synced', type: IsarType.bool),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
      IsarPropertySchema(name: 'customerId', type: IsarType.string),
      IsarPropertySchema(name: 'label', type: IsarType.string),
      IsarPropertySchema(
        name: 'miniTax',
        type: IsarType.objectList,
        target: 'MiniTax',
      ),
      IsarPropertySchema(
        name: 'items',
        type: IsarType.objectList,
        target: 'ItemReceitItem',
      ),
      IsarPropertySchema(
        name: 'discounts',
        type: IsarType.objectList,
        target: 'EmbeddedDiscountModel',
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ItemReceitModel>(
    serialize: serializeItemReceitModel,
    deserialize: deserializeItemReceitModel,
    deserializeProperty: deserializeItemReceitModelProp,
  ),
  getEmbeddedSchemas: () => [
    MiniTaxSchema,
    ItemReceitItemSchema,
    EmbeddedDiscountModelSchema,
  ],
);

@isarProtected
int serializeItemReceitModel(IsarWriter writer, ItemReceitModel object) {
  IsarCore.writeString(writer, 1, object.cashier);
  IsarCore.writeString(writer, 2, object.payment);
  IsarCore.writeDouble(writer, 3, object.change);
  IsarCore.writeBool(writer, 4, value: object.creditSale);
  IsarCore.writeDouble(writer, 5, object.tax);
  IsarCore.writeDouble(writer, 6, object.amount);
  IsarCore.writeDouble(writer, 7, object.total);
  IsarCore.writeBool(writer, 8, value: object.synced);
  IsarCore.writeLong(
    writer,
    9,
    object.createdAt.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeString(writer, 10, object.hexId);
  {
    final value = object.customerId;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  IsarCore.writeString(writer, 12, object.label);
  {
    final list = object.miniTax;
    final listWriter = IsarCore.beginList(writer, 13, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeMiniTax(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  {
    final list = object.items;
    final listWriter = IsarCore.beginList(writer, 14, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeItemReceitItem(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  {
    final list = object.discounts;
    final listWriter = IsarCore.beginList(writer, 15, list.length);
    for (var i = 0; i < list.length; i++) {
      {
        final value = list[i];
        final objectWriter = IsarCore.beginObject(listWriter, i);
        serializeEmbeddedDiscountModel(objectWriter, value);
        IsarCore.endObject(listWriter, objectWriter);
      }
    }
    IsarCore.endList(writer, listWriter);
  }
  return object.id;
}

@isarProtected
ItemReceitModel deserializeItemReceitModel(IsarReader reader) {
  final String _cashier;
  _cashier = IsarCore.readString(reader, 1) ?? '';
  final String _payment;
  _payment = IsarCore.readString(reader, 2) ?? '';
  final double _change;
  _change = IsarCore.readDouble(reader, 3);
  final bool _creditSale;
  _creditSale = IsarCore.readBool(reader, 4);
  final double _tax;
  {
    final value = IsarCore.readDouble(reader, 5);
    if (value.isNaN) {
      _tax = 0;
    } else {
      _tax = value;
    }
  }
  final double _amount;
  _amount = IsarCore.readDouble(reader, 6);
  final double _total;
  _total = IsarCore.readDouble(reader, 7);
  final bool _synced;
  _synced = IsarCore.readBool(reader, 8);
  final DateTime _createdAt;
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      _createdAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _createdAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final String _hexId;
  _hexId = IsarCore.readString(reader, 10) ?? '';
  final String? _customerId;
  _customerId = IsarCore.readString(reader, 11);
  final String _label;
  _label = IsarCore.readString(reader, 12) ?? "";
  final List<MiniTax> _miniTax;
  {
    final length = IsarCore.readList(reader, 13, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _miniTax = const [];
      } else {
        final list = List<MiniTax>.filled(length, MiniTax(), growable: true);
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = MiniTax();
            } else {
              final embedded = deserializeMiniTax(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _miniTax = list;
      }
    }
  }
  final List<ItemReceitItem> _items;
  {
    final length = IsarCore.readList(reader, 14, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _items = const <ItemReceitItem>[];
      } else {
        final list = List<ItemReceitItem>.filled(
          length,
          ItemReceitItem(),
          growable: true,
        );
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = ItemReceitItem();
            } else {
              final embedded = deserializeItemReceitItem(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _items = list;
      }
    }
  }
  final List<EmbeddedDiscountModel> _discounts;
  {
    final length = IsarCore.readList(reader, 15, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _discounts = const [];
      } else {
        final list = List<EmbeddedDiscountModel>.filled(
          length,
          EmbeddedDiscountModel(),
          growable: true,
        );
        for (var i = 0; i < length; i++) {
          {
            final objectReader = IsarCore.readObject(reader, i);
            if (objectReader.isNull) {
              list[i] = EmbeddedDiscountModel();
            } else {
              final embedded = deserializeEmbeddedDiscountModel(objectReader);
              IsarCore.freeReader(objectReader);
              list[i] = embedded;
            }
          }
        }
        IsarCore.freeReader(reader);
        _discounts = list;
      }
    }
  }
  final object = ItemReceitModel(
    cashier: _cashier,
    payment: _payment,
    change: _change,
    creditSale: _creditSale,
    tax: _tax,
    amount: _amount,
    total: _total,
    synced: _synced,
    createdAt: _createdAt,
    hexId: _hexId,
    customerId: _customerId,
    label: _label,
    miniTax: _miniTax,
    items: _items,
    discounts: _discounts,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeItemReceitModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readDouble(reader, 3);
    case 4:
      return IsarCore.readBool(reader, 4);
    case 5:
      {
        final value = IsarCore.readDouble(reader, 5);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
    case 6:
      return IsarCore.readDouble(reader, 6);
    case 7:
      return IsarCore.readDouble(reader, 7);
    case 8:
      return IsarCore.readBool(reader, 8);
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 10:
      return IsarCore.readString(reader, 10) ?? '';
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readString(reader, 12) ?? "";
    case 13:
      {
        final length = IsarCore.readList(reader, 13, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const [];
          } else {
            final list = List<MiniTax>.filled(
              length,
              MiniTax(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = MiniTax();
                } else {
                  final embedded = deserializeMiniTax(objectReader);
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
    case 14:
      {
        final length = IsarCore.readList(reader, 14, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <ItemReceitItem>[];
          } else {
            final list = List<ItemReceitItem>.filled(
              length,
              ItemReceitItem(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = ItemReceitItem();
                } else {
                  final embedded = deserializeItemReceitItem(objectReader);
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
    case 15:
      {
        final length = IsarCore.readList(reader, 15, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const [];
          } else {
            final list = List<EmbeddedDiscountModel>.filled(
              length,
              EmbeddedDiscountModel(),
              growable: true,
            );
            for (var i = 0; i < length; i++) {
              {
                final objectReader = IsarCore.readObject(reader, i);
                if (objectReader.isNull) {
                  list[i] = EmbeddedDiscountModel();
                } else {
                  final embedded = deserializeEmbeddedDiscountModel(
                    objectReader,
                  );
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

sealed class _ItemReceitModelUpdate {
  bool call({
    required int id,
    String? cashier,
    String? payment,
    double? change,
    bool? creditSale,
    double? tax,
    double? amount,
    double? total,
    bool? synced,
    DateTime? createdAt,
    String? hexId,
    String? customerId,
    String? label,
  });
}

class _ItemReceitModelUpdateImpl implements _ItemReceitModelUpdate {
  const _ItemReceitModelUpdateImpl(this.collection);

  final IsarCollection<int, ItemReceitModel> collection;

  @override
  bool call({
    required int id,
    Object? cashier = ignore,
    Object? payment = ignore,
    Object? change = ignore,
    Object? creditSale = ignore,
    Object? tax = ignore,
    Object? amount = ignore,
    Object? total = ignore,
    Object? synced = ignore,
    Object? createdAt = ignore,
    Object? hexId = ignore,
    Object? customerId = ignore,
    Object? label = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (cashier != ignore) 1: cashier as String?,
            if (payment != ignore) 2: payment as String?,
            if (change != ignore) 3: change as double?,
            if (creditSale != ignore) 4: creditSale as bool?,
            if (tax != ignore) 5: tax as double?,
            if (amount != ignore) 6: amount as double?,
            if (total != ignore) 7: total as double?,
            if (synced != ignore) 8: synced as bool?,
            if (createdAt != ignore) 9: createdAt as DateTime?,
            if (hexId != ignore) 10: hexId as String?,
            if (customerId != ignore) 11: customerId as String?,
            if (label != ignore) 12: label as String?,
          },
        ) >
        0;
  }
}

sealed class _ItemReceitModelUpdateAll {
  int call({
    required List<int> id,
    String? cashier,
    String? payment,
    double? change,
    bool? creditSale,
    double? tax,
    double? amount,
    double? total,
    bool? synced,
    DateTime? createdAt,
    String? hexId,
    String? customerId,
    String? label,
  });
}

class _ItemReceitModelUpdateAllImpl implements _ItemReceitModelUpdateAll {
  const _ItemReceitModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ItemReceitModel> collection;

  @override
  int call({
    required List<int> id,
    Object? cashier = ignore,
    Object? payment = ignore,
    Object? change = ignore,
    Object? creditSale = ignore,
    Object? tax = ignore,
    Object? amount = ignore,
    Object? total = ignore,
    Object? synced = ignore,
    Object? createdAt = ignore,
    Object? hexId = ignore,
    Object? customerId = ignore,
    Object? label = ignore,
  }) {
    return collection.updateProperties(id, {
      if (cashier != ignore) 1: cashier as String?,
      if (payment != ignore) 2: payment as String?,
      if (change != ignore) 3: change as double?,
      if (creditSale != ignore) 4: creditSale as bool?,
      if (tax != ignore) 5: tax as double?,
      if (amount != ignore) 6: amount as double?,
      if (total != ignore) 7: total as double?,
      if (synced != ignore) 8: synced as bool?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
      if (hexId != ignore) 10: hexId as String?,
      if (customerId != ignore) 11: customerId as String?,
      if (label != ignore) 12: label as String?,
    });
  }
}

extension ItemReceitModelUpdate on IsarCollection<int, ItemReceitModel> {
  _ItemReceitModelUpdate get update => _ItemReceitModelUpdateImpl(this);

  _ItemReceitModelUpdateAll get updateAll =>
      _ItemReceitModelUpdateAllImpl(this);
}

sealed class _ItemReceitModelQueryUpdate {
  int call({
    String? cashier,
    String? payment,
    double? change,
    bool? creditSale,
    double? tax,
    double? amount,
    double? total,
    bool? synced,
    DateTime? createdAt,
    String? hexId,
    String? customerId,
    String? label,
  });
}

class _ItemReceitModelQueryUpdateImpl implements _ItemReceitModelQueryUpdate {
  const _ItemReceitModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ItemReceitModel> query;
  final int? limit;

  @override
  int call({
    Object? cashier = ignore,
    Object? payment = ignore,
    Object? change = ignore,
    Object? creditSale = ignore,
    Object? tax = ignore,
    Object? amount = ignore,
    Object? total = ignore,
    Object? synced = ignore,
    Object? createdAt = ignore,
    Object? hexId = ignore,
    Object? customerId = ignore,
    Object? label = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (cashier != ignore) 1: cashier as String?,
      if (payment != ignore) 2: payment as String?,
      if (change != ignore) 3: change as double?,
      if (creditSale != ignore) 4: creditSale as bool?,
      if (tax != ignore) 5: tax as double?,
      if (amount != ignore) 6: amount as double?,
      if (total != ignore) 7: total as double?,
      if (synced != ignore) 8: synced as bool?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
      if (hexId != ignore) 10: hexId as String?,
      if (customerId != ignore) 11: customerId as String?,
      if (label != ignore) 12: label as String?,
    });
  }
}

extension ItemReceitModelQueryUpdate on IsarQuery<ItemReceitModel> {
  _ItemReceitModelQueryUpdate get updateFirst =>
      _ItemReceitModelQueryUpdateImpl(this, limit: 1);

  _ItemReceitModelQueryUpdate get updateAll =>
      _ItemReceitModelQueryUpdateImpl(this);
}

class _ItemReceitModelQueryBuilderUpdateImpl
    implements _ItemReceitModelQueryUpdate {
  const _ItemReceitModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ItemReceitModel, ItemReceitModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? cashier = ignore,
    Object? payment = ignore,
    Object? change = ignore,
    Object? creditSale = ignore,
    Object? tax = ignore,
    Object? amount = ignore,
    Object? total = ignore,
    Object? synced = ignore,
    Object? createdAt = ignore,
    Object? hexId = ignore,
    Object? customerId = ignore,
    Object? label = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (cashier != ignore) 1: cashier as String?,
        if (payment != ignore) 2: payment as String?,
        if (change != ignore) 3: change as double?,
        if (creditSale != ignore) 4: creditSale as bool?,
        if (tax != ignore) 5: tax as double?,
        if (amount != ignore) 6: amount as double?,
        if (total != ignore) 7: total as double?,
        if (synced != ignore) 8: synced as bool?,
        if (createdAt != ignore) 9: createdAt as DateTime?,
        if (hexId != ignore) 10: hexId as String?,
        if (customerId != ignore) 11: customerId as String?,
        if (label != ignore) 12: label as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension ItemReceitModelQueryBuilderUpdate
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QOperations> {
  _ItemReceitModelQueryUpdate get updateFirst =>
      _ItemReceitModelQueryBuilderUpdateImpl(this, limit: 1);

  _ItemReceitModelQueryUpdate get updateAll =>
      _ItemReceitModelQueryBuilderUpdateImpl(this);
}

extension ItemReceitModelQueryFilter
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QFilterCondition> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  cashierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  paymentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  changeBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  creditSaleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  taxBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  amountBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  totalBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  syncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  createdAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdGreaterThan(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdBetween(String? lower, String? upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 11, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 12, value: ''),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  miniTaxIsEmpty() {
    return not().miniTaxIsNotEmpty();
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  miniTaxIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 13, value: null),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  itemsIsEmpty() {
    return not().itemsIsNotEmpty();
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 14, value: null),
      );
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  discountsIsEmpty() {
    return not().discountsIsNotEmpty();
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterFilterCondition>
  discountsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 15, value: null),
      );
    });
  }
}

extension ItemReceitModelQueryObject
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QFilterCondition> {}

extension ItemReceitModelQuerySortBy
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QSortBy> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByCashier({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCashierDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByPayment({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByPaymentDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCreditSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCreditSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  sortByCustomerIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> sortByLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemReceitModelQuerySortThenBy
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QSortThenBy> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByCashier({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCashierDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByPayment({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByPaymentDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCreditSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCreditSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy>
  thenByCustomerIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterSortBy> thenByLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension ItemReceitModelQueryWhereDistinct
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QDistinct> {
  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByCashier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByPayment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByCreditSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByHexId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByCustomerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemReceitModel, ItemReceitModel, QAfterDistinct>
  distinctByLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }
}

extension ItemReceitModelQueryProperty1
    on QueryBuilder<ItemReceitModel, ItemReceitModel, QProperty> {
  QueryBuilder<ItemReceitModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemReceitModel, String, QAfterProperty> cashierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemReceitModel, String, QAfterProperty> paymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemReceitModel, double, QAfterProperty> changeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemReceitModel, bool, QAfterProperty> creditSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemReceitModel, double, QAfterProperty> taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemReceitModel, double, QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemReceitModel, double, QAfterProperty> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemReceitModel, bool, QAfterProperty> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemReceitModel, DateTime, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemReceitModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemReceitModel, String?, QAfterProperty> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemReceitModel, String, QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemReceitModel, List<MiniTax>, QAfterProperty>
  miniTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemReceitModel, List<ItemReceitItem>, QAfterProperty>
  itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<ItemReceitModel, List<EmbeddedDiscountModel>, QAfterProperty>
  discountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }
}

extension ItemReceitModelQueryProperty2<R>
    on QueryBuilder<ItemReceitModel, R, QAfterProperty> {
  QueryBuilder<ItemReceitModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemReceitModel, (R, String), QAfterProperty> cashierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemReceitModel, (R, String), QAfterProperty> paymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemReceitModel, (R, double), QAfterProperty> changeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemReceitModel, (R, bool), QAfterProperty>
  creditSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemReceitModel, (R, double), QAfterProperty> taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemReceitModel, (R, double), QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemReceitModel, (R, double), QAfterProperty> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemReceitModel, (R, bool), QAfterProperty> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemReceitModel, (R, DateTime), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemReceitModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemReceitModel, (R, String?), QAfterProperty>
  customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemReceitModel, (R, String), QAfterProperty> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemReceitModel, (R, List<MiniTax>), QAfterProperty>
  miniTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemReceitModel, (R, List<ItemReceitItem>), QAfterProperty>
  itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<
    ItemReceitModel,
    (R, List<EmbeddedDiscountModel>),
    QAfterProperty
  >
  discountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }
}

extension ItemReceitModelQueryProperty3<R1, R2>
    on QueryBuilder<ItemReceitModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ItemReceitModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, String), QOperations>
  cashierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, String), QOperations>
  paymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, double), QOperations>
  changeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, bool), QOperations>
  creditSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, double), QOperations> taxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, double), QOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, double), QOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, bool), QOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, DateTime), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, String?), QOperations>
  customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, String), QOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, List<MiniTax>), QOperations>
  miniTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<ItemReceitModel, (R1, R2, List<ItemReceitItem>), QOperations>
  itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<
    ItemReceitModel,
    (R1, R2, List<EmbeddedDiscountModel>),
    QOperations
  >
  discountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }
}
