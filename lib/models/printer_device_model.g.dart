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
  final object = PrinterDeviceModel(
    name: _name,
    address: _address,
    isConnected: _isConnected,
    port: _port,
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
  }) {
    return collection.updateProperties(
          [id],
          {
            if (name != ignore) 1: name as String?,
            if (address != ignore) 2: address as String?,
            if (isConnected != ignore) 3: isConnected as bool?,
            if (port != ignore) 4: port as int?,
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
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 1: name as String?,
      if (address != ignore) 2: address as String?,
      if (isConnected != ignore) 3: isConnected as bool?,
      if (port != ignore) 4: port as int?,
    });
  }
}

extension PrinterDeviceModelUpdate on IsarCollection<int, PrinterDeviceModel> {
  _PrinterDeviceModelUpdate get update => _PrinterDeviceModelUpdateImpl(this);

  _PrinterDeviceModelUpdateAll get updateAll =>
      _PrinterDeviceModelUpdateAllImpl(this);
}

sealed class _PrinterDeviceModelQueryUpdate {
  int call({String? name, String? address, bool? isConnected, int? port});
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
  }) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 1: name as String?,
      if (address != ignore) 2: address as String?,
      if (isConnected != ignore) 3: isConnected as bool?,
      if (port != ignore) 4: port as int?,
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
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 1: name as String?,
        if (address != ignore) 2: address as String?,
        if (isConnected != ignore) 3: isConnected as bool?,
        if (port != ignore) 4: port as int?,
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
}
