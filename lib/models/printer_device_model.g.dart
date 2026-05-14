// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_device_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetPrinterDeviceModelCollection on Isar {
  IsarCollection<int, PrinterDeviceModel> get printerDeviceModels =>
      this.collection();
}

final PrinterDeviceModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'PrinterDeviceModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'name', type: IsarType.string),
      IsarPropertySchema(name: 'address', type: IsarType.string),
      IsarPropertySchema(name: 'isConnected', type: IsarType.bool),
      IsarPropertySchema(name: 'port', type: IsarType.long),
      IsarPropertySchema(name: 'isSelectedForMultiPrint', type: IsarType.bool),
      IsarPropertySchema(name: 'connectionType', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, PrinterDeviceModel>(
    serialize: serializePrinterDeviceModel,
    deserialize: deserializePrinterDeviceModel,
    deserializeProperty: deserializePrinterDeviceModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializePrinterDeviceModel(IsarWriter writer, PrinterDeviceModel object) {
  IsarCore.writeString(writer, 1, object.name);
  IsarCore.writeString(writer, 2, object.address);
  IsarCore.writeBool(writer, 3, value: object.isConnected);
  IsarCore.writeLong(writer, 4, object.port);
  IsarCore.writeBool(writer, 5, value: object.isSelectedForMultiPrint);
  IsarCore.writeString(writer, 6, object.connectionType);
  return object.id;
}

@isarProtected
PrinterDeviceModel deserializePrinterDeviceModel(IsarReader reader) {
  final String _name;
  _name = IsarCore.readString(reader, 1) ?? '';
  final String _address;
  _address = IsarCore.readString(reader, 2) ?? '';
  final bool _isConnected;
  _isConnected = IsarCore.readBool(reader, 3);
  final int _port;
  {
    final value = IsarCore.readLong(reader, 4);
    if (value == -9223372036854775808) {
      _port = 9100;
    } else {
      _port = value;
    }
  }
  final bool _isSelectedForMultiPrint;
  {
    if (IsarCore.readNull(reader, 5)) {
      _isSelectedForMultiPrint = true;
    } else {
      _isSelectedForMultiPrint = IsarCore.readBool(reader, 5);
    }
  }
  final String _connectionType;
  _connectionType = IsarCore.readString(reader, 6) ?? "bluetooth";
  final object = PrinterDeviceModel(
    name: _name,
    address: _address,
    isConnected: _isConnected,
    port: _port,
    isSelectedForMultiPrint: _isSelectedForMultiPrint,
    connectionType: _connectionType,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializePrinterDeviceModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readBool(reader, 3);
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return 9100;
        } else {
          return value;
        }
      }
    case 5:
      {
        if (IsarCore.readNull(reader, 5)) {
          return true;
        } else {
          return IsarCore.readBool(reader, 5);
        }
      }
    case 6:
      return IsarCore.readString(reader, 6) ?? "bluetooth";
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _PrinterDeviceModelUpdate {
  bool call({
    required int id,
    String? name,
    String? address,
    bool? isConnected,
    int? port,
    bool? isSelectedForMultiPrint,
    String? connectionType,
  });
}

class _PrinterDeviceModelUpdateImpl implements _PrinterDeviceModelUpdate {
  const _PrinterDeviceModelUpdateImpl(this.collection);

  final IsarCollection<int, PrinterDeviceModel> collection;

  @override
  bool call({
    required int id,
    Object? name = ignore,
    Object? address = ignore,
    Object? isConnected = ignore,
    Object? port = ignore,
    Object? isSelectedForMultiPrint = ignore,
    Object? connectionType = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (address != ignore) 2: address as String?,
            if (isConnected != ignore) 3: isConnected as bool?,
            if (port != ignore) 4: port as int?,
            if (isSelectedForMultiPrint != ignore)
              5: isSelectedForMultiPrint as bool?,
            if (connectionType != ignore) 6: connectionType as String?,
          },
        ) >
        0;
  }
}

sealed class _PrinterDeviceModelUpdateAll {
  int call({
    required List<int> id,
    String? name,
    String? address,
    bool? isConnected,
    int? port,
    bool? isSelectedForMultiPrint,
    String? connectionType,
  });
}

class _PrinterDeviceModelUpdateAllImpl implements _PrinterDeviceModelUpdateAll {
  const _PrinterDeviceModelUpdateAllImpl(this.collection);

  final IsarCollection<int, PrinterDeviceModel> collection;

  @override
  int call({
    required List<int> id,
    Object? name = ignore,
    Object? address = ignore,
    Object? isConnected = ignore,
    Object? port = ignore,
    Object? isSelectedForMultiPrint = ignore,
    Object? connectionType = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (address != ignore) 2: address as String?,
      if (isConnected != ignore) 3: isConnected as bool?,
      if (port != ignore) 4: port as int?,
      if (isSelectedForMultiPrint != ignore)
        5: isSelectedForMultiPrint as bool?,
      if (connectionType != ignore) 6: connectionType as String?,
    });
  }
}

extension PrinterDeviceModelUpdate on IsarCollection<int, PrinterDeviceModel> {
  _PrinterDeviceModelUpdate get update => _PrinterDeviceModelUpdateImpl(this);

  _PrinterDeviceModelUpdateAll get updateAll =>
      _PrinterDeviceModelUpdateAllImpl(this);
}

sealed class _PrinterDeviceModelQueryUpdate {
  int call({
    String? name,
    String? address,
    bool? isConnected,
    int? port,
    bool? isSelectedForMultiPrint,
    String? connectionType,
  });
}

class _PrinterDeviceModelQueryUpdateImpl
    implements _PrinterDeviceModelQueryUpdate {
  const _PrinterDeviceModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<PrinterDeviceModel> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? address = ignore,
    Object? isConnected = ignore,
    Object? port = ignore,
    Object? isSelectedForMultiPrint = ignore,
    Object? connectionType = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (address != ignore) 2: address as String?,
      if (isConnected != ignore) 3: isConnected as bool?,
      if (port != ignore) 4: port as int?,
      if (isSelectedForMultiPrint != ignore)
        5: isSelectedForMultiPrint as bool?,
      if (connectionType != ignore) 6: connectionType as String?,
    });
  }
}

extension PrinterDeviceModelQueryUpdate on IsarQuery<PrinterDeviceModel> {
  _PrinterDeviceModelQueryUpdate get updateFirst =>
      _PrinterDeviceModelQueryUpdateImpl(this, limit: 1);

  _PrinterDeviceModelQueryUpdate get updateAll =>
      _PrinterDeviceModelQueryUpdateImpl(this);
}

class _PrinterDeviceModelQueryBuilderUpdateImpl
    implements _PrinterDeviceModelQueryUpdate {
  const _PrinterDeviceModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? address = ignore,
    Object? isConnected = ignore,
    Object? port = ignore,
    Object? isSelectedForMultiPrint = ignore,
    Object? connectionType = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (address != ignore) 2: address as String?,
        if (isConnected != ignore) 3: isConnected as bool?,
        if (port != ignore) 4: port as int?,
        if (isSelectedForMultiPrint != ignore)
          5: isSelectedForMultiPrint as bool?,
        if (connectionType != ignore) 6: connectionType as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension PrinterDeviceModelQueryBuilderUpdate
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QOperations> {
  _PrinterDeviceModelQueryUpdate get updateFirst =>
      _PrinterDeviceModelQueryBuilderUpdateImpl(this, limit: 1);

  _PrinterDeviceModelQueryUpdate get updateAll =>
      _PrinterDeviceModelQueryBuilderUpdateImpl(this);
}

extension PrinterDeviceModelQueryFilter
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QFilterCondition> {
  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  isConnectedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 4, value: value));
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  portBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 4, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  isSelectedForMultiPrintEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterFilterCondition>
  connectionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }
}

extension PrinterDeviceModelQueryObject
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QFilterCondition> {}

extension PrinterDeviceModelQuerySortBy
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QSortBy> {
  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByAddressDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByIsConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByIsSelectedForMultiPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByIsSelectedForMultiPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByConnectionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  sortByConnectionTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension PrinterDeviceModelQuerySortThenBy
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QSortThenBy> {
  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByNameDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByAddressDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByIsConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByIsSelectedForMultiPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByIsSelectedForMultiPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByConnectionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterSortBy>
  thenByConnectionTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension PrinterDeviceModelQueryWhereDistinct
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QDistinct> {
  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByIsConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByIsSelectedForMultiPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QAfterDistinct>
  distinctByConnectionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }
}

extension PrinterDeviceModelQueryProperty1
    on QueryBuilder<PrinterDeviceModel, PrinterDeviceModel, QProperty> {
  QueryBuilder<PrinterDeviceModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PrinterDeviceModel, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PrinterDeviceModel, String, QAfterProperty> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PrinterDeviceModel, bool, QAfterProperty> isConnectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, int, QAfterProperty> portProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, bool, QAfterProperty>
  isSelectedForMultiPrintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, String, QAfterProperty>
  connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}

extension PrinterDeviceModelQueryProperty2<R>
    on QueryBuilder<PrinterDeviceModel, R, QAfterProperty> {
  QueryBuilder<PrinterDeviceModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, String), QAfterProperty>
  addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, bool), QAfterProperty>
  isConnectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, int), QAfterProperty> portProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, bool), QAfterProperty>
  isSelectedForMultiPrintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R, String), QAfterProperty>
  connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}

extension PrinterDeviceModelQueryProperty3<R1, R2>
    on QueryBuilder<PrinterDeviceModel, (R1, R2), QAfterProperty> {
  QueryBuilder<PrinterDeviceModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, String), QOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, String), QOperations>
  addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, bool), QOperations>
  isConnectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, int), QOperations> portProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, bool), QOperations>
  isSelectedForMultiPrintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<PrinterDeviceModel, (R1, R2, String), QOperations>
  connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }
}
