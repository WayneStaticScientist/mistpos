// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shifts_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetShiftsModelCollection on Isar {
  IsarCollection<int, ShiftsModel> get shiftsModels => this.collection();
}

final ShiftsModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ShiftsModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'synced', type: IsarType.bool),
      IsarPropertySchema(name: 'shiftIsClosed', type: IsarType.bool),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
      IsarPropertySchema(name: 'userId', type: IsarType.string),
      IsarPropertySchema(name: 'shiftLabel', type: IsarType.string),
      IsarPropertySchema(name: 'totalSales', type: IsarType.double),
      IsarPropertySchema(name: 'salesQuantity', type: IsarType.long),
      IsarPropertySchema(name: 'totalCustomers', type: IsarType.long),
      IsarPropertySchema(name: 'cashDrawerEnd', type: IsarType.double),
      IsarPropertySchema(name: 'cashDrawerStart', type: IsarType.double),
      IsarPropertySchema(name: 'openShiftTime', type: IsarType.dateTime),
      IsarPropertySchema(name: 'closeShiftTime', type: IsarType.dateTime),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ShiftsModel>(
    serialize: serializeShiftsModel,
    deserialize: deserializeShiftsModel,
    deserializeProperty: deserializeShiftsModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeShiftsModel(IsarWriter writer, ShiftsModel object) {
  IsarCore.writeBool(writer, 1, value: object.synced);
  IsarCore.writeBool(writer, 2, value: object.shiftIsClosed);
  IsarCore.writeString(writer, 3, object.hexId);
  IsarCore.writeString(writer, 4, object.userId);
  IsarCore.writeString(writer, 5, object.shiftLabel);
  IsarCore.writeDouble(writer, 6, object.totalSales);
  IsarCore.writeLong(writer, 7, object.salesQuantity);
  IsarCore.writeLong(writer, 8, object.totalCustomers);
  IsarCore.writeDouble(writer, 9, object.cashDrawerEnd);
  IsarCore.writeDouble(writer, 10, object.cashDrawerStart);
  IsarCore.writeLong(
    writer,
    11,
    object.openShiftTime.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeLong(
    writer,
    12,
    object.closeShiftTime.toUtc().microsecondsSinceEpoch,
  );
  return object.id;
}

@isarProtected
ShiftsModel deserializeShiftsModel(IsarReader reader) {
  final bool _synced;
  _synced = IsarCore.readBool(reader, 1);
  final bool _shiftIsClosed;
  _shiftIsClosed = IsarCore.readBool(reader, 2);
  final String _hexId;
  _hexId = IsarCore.readString(reader, 3) ?? '';
  final String _userId;
  _userId = IsarCore.readString(reader, 4) ?? '';
  final String _shiftLabel;
  _shiftLabel = IsarCore.readString(reader, 5) ?? '';
  final double _totalSales;
  {
    final value = IsarCore.readDouble(reader, 6);
    if (value.isNaN) {
      _totalSales = 0;
    } else {
      _totalSales = value;
    }
  }
  final int _salesQuantity;
  {
    final value = IsarCore.readLong(reader, 7);
    if (value == -9223372036854775808) {
      _salesQuantity = 0;
    } else {
      _salesQuantity = value;
    }
  }
  final int _totalCustomers;
  {
    final value = IsarCore.readLong(reader, 8);
    if (value == -9223372036854775808) {
      _totalCustomers = 0;
    } else {
      _totalCustomers = value;
    }
  }
  final double _cashDrawerEnd;
  _cashDrawerEnd = IsarCore.readDouble(reader, 9);
  final double _cashDrawerStart;
  _cashDrawerStart = IsarCore.readDouble(reader, 10);
  final DateTime _openShiftTime;
  {
    final value = IsarCore.readLong(reader, 11);
    if (value == -9223372036854775808) {
      _openShiftTime = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _openShiftTime = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final DateTime _closeShiftTime;
  {
    final value = IsarCore.readLong(reader, 12);
    if (value == -9223372036854775808) {
      _closeShiftTime = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _closeShiftTime = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final object = ShiftsModel(
    synced: _synced,
    shiftIsClosed: _shiftIsClosed,
    hexId: _hexId,
    userId: _userId,
    shiftLabel: _shiftLabel,
    totalSales: _totalSales,
    salesQuantity: _salesQuantity,
    totalCustomers: _totalCustomers,
    cashDrawerEnd: _cashDrawerEnd,
    cashDrawerStart: _cashDrawerStart,
    openShiftTime: _openShiftTime,
    closeShiftTime: _closeShiftTime,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeShiftsModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readBool(reader, 1);
    case 2:
      return IsarCore.readBool(reader, 2);
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 6:
      {
        final value = IsarCore.readDouble(reader, 6);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
    case 7:
      {
        final value = IsarCore.readLong(reader, 7);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 8:
      {
        final value = IsarCore.readLong(reader, 8);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 9:
      return IsarCore.readDouble(reader, 9);
    case 10:
      return IsarCore.readDouble(reader, 10);
    case 11:
      {
        final value = IsarCore.readLong(reader, 11);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 12:
      {
        final value = IsarCore.readLong(reader, 12);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ShiftsModelUpdate {
  bool call({
    required int id,
    bool? synced,
    bool? shiftIsClosed,
    String? hexId,
    String? userId,
    String? shiftLabel,
    double? totalSales,
    int? salesQuantity,
    int? totalCustomers,
    double? cashDrawerEnd,
    double? cashDrawerStart,
    DateTime? openShiftTime,
    DateTime? closeShiftTime,
  });
}

class _ShiftsModelUpdateImpl implements _ShiftsModelUpdate {
  const _ShiftsModelUpdateImpl(this.collection);

  final IsarCollection<int, ShiftsModel> collection;

  @override
  bool call({
    required int id,
    Object? synced = ignore,
    Object? shiftIsClosed = ignore,
    Object? hexId = ignore,
    Object? userId = ignore,
    Object? shiftLabel = ignore,
    Object? totalSales = ignore,
    Object? salesQuantity = ignore,
    Object? totalCustomers = ignore,
    Object? cashDrawerEnd = ignore,
    Object? cashDrawerStart = ignore,
    Object? openShiftTime = ignore,
    Object? closeShiftTime = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (synced != ignore) 1: synced as bool?,
            if (shiftIsClosed != ignore) 2: shiftIsClosed as bool?,
            if (hexId != ignore) 3: hexId as String?,
            if (userId != ignore) 4: userId as String?,
            if (shiftLabel != ignore) 5: shiftLabel as String?,
            if (totalSales != ignore) 6: totalSales as double?,
            if (salesQuantity != ignore) 7: salesQuantity as int?,
            if (totalCustomers != ignore) 8: totalCustomers as int?,
            if (cashDrawerEnd != ignore) 9: cashDrawerEnd as double?,
            if (cashDrawerStart != ignore) 10: cashDrawerStart as double?,
            if (openShiftTime != ignore) 11: openShiftTime as DateTime?,
            if (closeShiftTime != ignore) 12: closeShiftTime as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _ShiftsModelUpdateAll {
  int call({
    required List<int> id,
    bool? synced,
    bool? shiftIsClosed,
    String? hexId,
    String? userId,
    String? shiftLabel,
    double? totalSales,
    int? salesQuantity,
    int? totalCustomers,
    double? cashDrawerEnd,
    double? cashDrawerStart,
    DateTime? openShiftTime,
    DateTime? closeShiftTime,
  });
}

class _ShiftsModelUpdateAllImpl implements _ShiftsModelUpdateAll {
  const _ShiftsModelUpdateAllImpl(this.collection);

  final IsarCollection<int, ShiftsModel> collection;

  @override
  int call({
    required List<int> id,
    Object? synced = ignore,
    Object? shiftIsClosed = ignore,
    Object? hexId = ignore,
    Object? userId = ignore,
    Object? shiftLabel = ignore,
    Object? totalSales = ignore,
    Object? salesQuantity = ignore,
    Object? totalCustomers = ignore,
    Object? cashDrawerEnd = ignore,
    Object? cashDrawerStart = ignore,
    Object? openShiftTime = ignore,
    Object? closeShiftTime = ignore,
  }) {
    return collection.updateProperties(id, {
      if (synced != ignore) 1: synced as bool?,
      if (shiftIsClosed != ignore) 2: shiftIsClosed as bool?,
      if (hexId != ignore) 3: hexId as String?,
      if (userId != ignore) 4: userId as String?,
      if (shiftLabel != ignore) 5: shiftLabel as String?,
      if (totalSales != ignore) 6: totalSales as double?,
      if (salesQuantity != ignore) 7: salesQuantity as int?,
      if (totalCustomers != ignore) 8: totalCustomers as int?,
      if (cashDrawerEnd != ignore) 9: cashDrawerEnd as double?,
      if (cashDrawerStart != ignore) 10: cashDrawerStart as double?,
      if (openShiftTime != ignore) 11: openShiftTime as DateTime?,
      if (closeShiftTime != ignore) 12: closeShiftTime as DateTime?,
    });
  }
}

extension ShiftsModelUpdate on IsarCollection<int, ShiftsModel> {
  _ShiftsModelUpdate get update => _ShiftsModelUpdateImpl(this);

  _ShiftsModelUpdateAll get updateAll => _ShiftsModelUpdateAllImpl(this);
}

sealed class _ShiftsModelQueryUpdate {
  int call({
    bool? synced,
    bool? shiftIsClosed,
    String? hexId,
    String? userId,
    String? shiftLabel,
    double? totalSales,
    int? salesQuantity,
    int? totalCustomers,
    double? cashDrawerEnd,
    double? cashDrawerStart,
    DateTime? openShiftTime,
    DateTime? closeShiftTime,
  });
}

class _ShiftsModelQueryUpdateImpl implements _ShiftsModelQueryUpdate {
  const _ShiftsModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ShiftsModel> query;
  final int? limit;

  @override
  int call({
    Object? synced = ignore,
    Object? shiftIsClosed = ignore,
    Object? hexId = ignore,
    Object? userId = ignore,
    Object? shiftLabel = ignore,
    Object? totalSales = ignore,
    Object? salesQuantity = ignore,
    Object? totalCustomers = ignore,
    Object? cashDrawerEnd = ignore,
    Object? cashDrawerStart = ignore,
    Object? openShiftTime = ignore,
    Object? closeShiftTime = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (synced != ignore) 1: synced as bool?,
      if (shiftIsClosed != ignore) 2: shiftIsClosed as bool?,
      if (hexId != ignore) 3: hexId as String?,
      if (userId != ignore) 4: userId as String?,
      if (shiftLabel != ignore) 5: shiftLabel as String?,
      if (totalSales != ignore) 6: totalSales as double?,
      if (salesQuantity != ignore) 7: salesQuantity as int?,
      if (totalCustomers != ignore) 8: totalCustomers as int?,
      if (cashDrawerEnd != ignore) 9: cashDrawerEnd as double?,
      if (cashDrawerStart != ignore) 10: cashDrawerStart as double?,
      if (openShiftTime != ignore) 11: openShiftTime as DateTime?,
      if (closeShiftTime != ignore) 12: closeShiftTime as DateTime?,
    });
  }
}

extension ShiftsModelQueryUpdate on IsarQuery<ShiftsModel> {
  _ShiftsModelQueryUpdate get updateFirst =>
      _ShiftsModelQueryUpdateImpl(this, limit: 1);

  _ShiftsModelQueryUpdate get updateAll => _ShiftsModelQueryUpdateImpl(this);
}

class _ShiftsModelQueryBuilderUpdateImpl implements _ShiftsModelQueryUpdate {
  const _ShiftsModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ShiftsModel, ShiftsModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? synced = ignore,
    Object? shiftIsClosed = ignore,
    Object? hexId = ignore,
    Object? userId = ignore,
    Object? shiftLabel = ignore,
    Object? totalSales = ignore,
    Object? salesQuantity = ignore,
    Object? totalCustomers = ignore,
    Object? cashDrawerEnd = ignore,
    Object? cashDrawerStart = ignore,
    Object? openShiftTime = ignore,
    Object? closeShiftTime = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (synced != ignore) 1: synced as bool?,
        if (shiftIsClosed != ignore) 2: shiftIsClosed as bool?,
        if (hexId != ignore) 3: hexId as String?,
        if (userId != ignore) 4: userId as String?,
        if (shiftLabel != ignore) 5: shiftLabel as String?,
        if (totalSales != ignore) 6: totalSales as double?,
        if (salesQuantity != ignore) 7: salesQuantity as int?,
        if (totalCustomers != ignore) 8: totalCustomers as int?,
        if (cashDrawerEnd != ignore) 9: cashDrawerEnd as double?,
        if (cashDrawerStart != ignore) 10: cashDrawerStart as double?,
        if (openShiftTime != ignore) 11: openShiftTime as DateTime?,
        if (closeShiftTime != ignore) 12: closeShiftTime as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension ShiftsModelQueryBuilderUpdate
    on QueryBuilder<ShiftsModel, ShiftsModel, QOperations> {
  _ShiftsModelQueryUpdate get updateFirst =>
      _ShiftsModelQueryBuilderUpdateImpl(this, limit: 1);

  _ShiftsModelQueryUpdate get updateAll =>
      _ShiftsModelQueryBuilderUpdateImpl(this);
}

extension ShiftsModelQueryFilter
    on QueryBuilder<ShiftsModel, ShiftsModel, QFilterCondition> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> syncedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftIsClosedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition> userIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  shiftLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalSalesBetween(
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 7, value: value));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 7, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  salesQuantityBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 7, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  totalCustomersBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerEndBetween(
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 10, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  cashDrawerStartBetween(
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

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 11, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 11, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 11, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 11, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  openShiftTimeBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 11, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 12, value: value),
      );
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterFilterCondition>
  closeShiftTimeBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 12, lower: lower, upper: upper),
      );
    });
  }
}

extension ShiftsModelQueryObject
    on QueryBuilder<ShiftsModel, ShiftsModel, QFilterCondition> {}

extension ShiftsModelQuerySortBy
    on QueryBuilder<ShiftsModel, ShiftsModel, QSortBy> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByShiftIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByUserIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByShiftLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortBySalesQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByTotalCustomersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByCashDrawerEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByCashDrawerStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByOpenShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> sortByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  sortByCloseShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension ShiftsModelQuerySortThenBy
    on QueryBuilder<ShiftsModel, ShiftsModel, QSortThenBy> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByShiftIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByUserIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByShiftLabelDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenBySalesQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByTotalCustomersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByCashDrawerEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByCashDrawerStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByOpenShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy> thenByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterSortBy>
  thenByCloseShiftTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }
}

extension ShiftsModelQueryWhereDistinct
    on QueryBuilder<ShiftsModel, ShiftsModel, QDistinct> {
  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct> distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByShiftIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct> distinctByShiftLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByTotalSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctBySalesQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByTotalCustomers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByCashDrawerEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByCashDrawerStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByOpenShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11);
    });
  }

  QueryBuilder<ShiftsModel, ShiftsModel, QAfterDistinct>
  distinctByCloseShiftTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }
}

extension ShiftsModelQueryProperty1
    on QueryBuilder<ShiftsModel, ShiftsModel, QProperty> {
  QueryBuilder<ShiftsModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ShiftsModel, bool, QAfterProperty> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ShiftsModel, bool, QAfterProperty> shiftIsClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ShiftsModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ShiftsModel, String, QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ShiftsModel, String, QAfterProperty> shiftLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ShiftsModel, double, QAfterProperty> totalSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ShiftsModel, int, QAfterProperty> salesQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ShiftsModel, int, QAfterProperty> totalCustomersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ShiftsModel, double, QAfterProperty> cashDrawerEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ShiftsModel, double, QAfterProperty> cashDrawerStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ShiftsModel, DateTime, QAfterProperty> openShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ShiftsModel, DateTime, QAfterProperty> closeShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension ShiftsModelQueryProperty2<R>
    on QueryBuilder<ShiftsModel, R, QAfterProperty> {
  QueryBuilder<ShiftsModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ShiftsModel, (R, bool), QAfterProperty> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ShiftsModel, (R, bool), QAfterProperty> shiftIsClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ShiftsModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ShiftsModel, (R, String), QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ShiftsModel, (R, String), QAfterProperty> shiftLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ShiftsModel, (R, double), QAfterProperty> totalSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ShiftsModel, (R, int), QAfterProperty> salesQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ShiftsModel, (R, int), QAfterProperty> totalCustomersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ShiftsModel, (R, double), QAfterProperty>
  cashDrawerEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ShiftsModel, (R, double), QAfterProperty>
  cashDrawerStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ShiftsModel, (R, DateTime), QAfterProperty>
  openShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ShiftsModel, (R, DateTime), QAfterProperty>
  closeShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}

extension ShiftsModelQueryProperty3<R1, R2>
    on QueryBuilder<ShiftsModel, (R1, R2), QAfterProperty> {
  QueryBuilder<ShiftsModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, bool), QOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, bool), QOperations>
  shiftIsClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, String), QOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, String), QOperations>
  shiftLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, double), QOperations>
  totalSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, int), QOperations>
  salesQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, int), QOperations>
  totalCustomersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, double), QOperations>
  cashDrawerEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, double), QOperations>
  cashDrawerStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, DateTime), QOperations>
  openShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<ShiftsModel, (R1, R2, DateTime), QOperations>
  closeShiftTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }
}
