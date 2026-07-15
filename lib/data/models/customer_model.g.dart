// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetCustomerModelCollection on Isar {
  IsarCollection<int, CustomerModel> get customerModels => this.collection();
}

final CustomerModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'CustomerModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'email', type: IsarType.string),
      IsarPropertySchema(name: 'city', type: IsarType.string),
      IsarPropertySchema(name: 'notes', type: IsarType.string),
      IsarPropertySchema(name: 'points', type: IsarType.double),
      IsarPropertySchema(name: 'visits', type: IsarType.long),
      IsarPropertySchema(name: 'company', type: IsarType.string),
      IsarPropertySchema(name: 'country', type: IsarType.string),
      IsarPropertySchema(name: 'address', type: IsarType.string),
      IsarPropertySchema(name: 'fullName', type: IsarType.string),
      IsarPropertySchema(name: 'phoneNumber', type: IsarType.string),
      IsarPropertySchema(name: 'purchaseValue', type: IsarType.double),
      IsarPropertySchema(name: 'inboundProfit', type: IsarType.double),
      IsarPropertySchema(name: 'hexId', type: IsarType.string),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, CustomerModel>(
    serialize: serializeCustomerModel,
    deserialize: deserializeCustomerModel,
    deserializeProperty: deserializeCustomerModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeCustomerModel(IsarWriter writer, CustomerModel object) {
  IsarCore.writeString(writer, 1, object.email);
  IsarCore.writeString(writer, 2, object.city);
  IsarCore.writeString(writer, 3, object.notes);
  IsarCore.writeDouble(writer, 4, object.points);
  IsarCore.writeLong(writer, 5, object.visits);
  IsarCore.writeString(writer, 6, object.company);
  IsarCore.writeString(writer, 7, object.country);
  IsarCore.writeString(writer, 8, object.address);
  IsarCore.writeString(writer, 9, object.fullName);
  IsarCore.writeString(writer, 10, object.phoneNumber);
  IsarCore.writeDouble(writer, 11, object.purchaseValue);
  IsarCore.writeDouble(writer, 12, object.inboundProfit);
  IsarCore.writeString(writer, 13, object.hexId);
  return object.id;
}

@isarProtected
CustomerModel deserializeCustomerModel(IsarReader reader) {
  final String _email;
  _email = IsarCore.readString(reader, 1) ?? '';
  final String _city;
  _city = IsarCore.readString(reader, 2) ?? '';
  final String _notes;
  _notes = IsarCore.readString(reader, 3) ?? '';
  final double _points;
  _points = IsarCore.readDouble(reader, 4);
  final int _visits;
  _visits = IsarCore.readLong(reader, 5);
  final String _company;
  _company = IsarCore.readString(reader, 6) ?? '';
  final String _country;
  _country = IsarCore.readString(reader, 7) ?? '';
  final String _address;
  _address = IsarCore.readString(reader, 8) ?? '';
  final String _fullName;
  _fullName = IsarCore.readString(reader, 9) ?? '';
  final String _phoneNumber;
  _phoneNumber = IsarCore.readString(reader, 10) ?? '';
  final double _purchaseValue;
  _purchaseValue = IsarCore.readDouble(reader, 11);
  final double _inboundProfit;
  _inboundProfit = IsarCore.readDouble(reader, 12);
  final String _hexId;
  _hexId = IsarCore.readString(reader, 13) ?? '';
  final object = CustomerModel(
    email: _email,
    city: _city,
    notes: _notes,
    points: _points,
    visits: _visits,
    company: _company,
    country: _country,
    address: _address,
    fullName: _fullName,
    phoneNumber: _phoneNumber,
    purchaseValue: _purchaseValue,
    inboundProfit: _inboundProfit,
    hexId: _hexId,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeCustomerModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readDouble(reader, 4);
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    case 8:
      return IsarCore.readString(reader, 8) ?? '';
    case 9:
      return IsarCore.readString(reader, 9) ?? '';
    case 10:
      return IsarCore.readString(reader, 10) ?? '';
    case 11:
      return IsarCore.readDouble(reader, 11);
    case 12:
      return IsarCore.readDouble(reader, 12);
    case 13:
      return IsarCore.readString(reader, 13) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _CustomerModelUpdate {
  bool call({
    required int id,
    String? email,
    String? city,
    String? notes,
    double? points,
    int? visits,
    String? company,
    String? country,
    String? address,
    String? fullName,
    String? phoneNumber,
    double? purchaseValue,
    double? inboundProfit,
    String? hexId,
  });
}

class _CustomerModelUpdateImpl implements _CustomerModelUpdate {
  const _CustomerModelUpdateImpl(this.collection);

  final IsarCollection<int, CustomerModel> collection;

  @override
  bool call({
    required int id,
    Object? email = ignore,
    Object? city = ignore,
    Object? notes = ignore,
    Object? points = ignore,
    Object? visits = ignore,
    Object? company = ignore,
    Object? country = ignore,
    Object? address = ignore,
    Object? fullName = ignore,
    Object? phoneNumber = ignore,
    Object? purchaseValue = ignore,
    Object? inboundProfit = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (email != ignore) 1: email as String?,
            if (city != ignore) 2: city as String?,
            if (notes != ignore) 3: notes as String?,
            if (points != ignore) 4: points as double?,
            if (visits != ignore) 5: visits as int?,
            if (company != ignore) 6: company as String?,
            if (country != ignore) 7: country as String?,
            if (address != ignore) 8: address as String?,
            if (fullName != ignore) 9: fullName as String?,
            if (phoneNumber != ignore) 10: phoneNumber as String?,
            if (purchaseValue != ignore) 11: purchaseValue as double?,
            if (inboundProfit != ignore) 12: inboundProfit as double?,
            if (hexId != ignore) 13: hexId as String?,
          },
        ) >
        0;
  }
}

sealed class _CustomerModelUpdateAll {
  int call({
    required List<int> id,
    String? email,
    String? city,
    String? notes,
    double? points,
    int? visits,
    String? company,
    String? country,
    String? address,
    String? fullName,
    String? phoneNumber,
    double? purchaseValue,
    double? inboundProfit,
    String? hexId,
  });
}

class _CustomerModelUpdateAllImpl implements _CustomerModelUpdateAll {
  const _CustomerModelUpdateAllImpl(this.collection);

  final IsarCollection<int, CustomerModel> collection;

  @override
  int call({
    required List<int> id,
    Object? email = ignore,
    Object? city = ignore,
    Object? notes = ignore,
    Object? points = ignore,
    Object? visits = ignore,
    Object? company = ignore,
    Object? country = ignore,
    Object? address = ignore,
    Object? fullName = ignore,
    Object? phoneNumber = ignore,
    Object? purchaseValue = ignore,
    Object? inboundProfit = ignore,
    Object? hexId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (email != ignore) 1: email as String?,
      if (city != ignore) 2: city as String?,
      if (notes != ignore) 3: notes as String?,
      if (points != ignore) 4: points as double?,
      if (visits != ignore) 5: visits as int?,
      if (company != ignore) 6: company as String?,
      if (country != ignore) 7: country as String?,
      if (address != ignore) 8: address as String?,
      if (fullName != ignore) 9: fullName as String?,
      if (phoneNumber != ignore) 10: phoneNumber as String?,
      if (purchaseValue != ignore) 11: purchaseValue as double?,
      if (inboundProfit != ignore) 12: inboundProfit as double?,
      if (hexId != ignore) 13: hexId as String?,
    });
  }
}

extension CustomerModelUpdate on IsarCollection<int, CustomerModel> {
  _CustomerModelUpdate get update => _CustomerModelUpdateImpl(this);

  _CustomerModelUpdateAll get updateAll => _CustomerModelUpdateAllImpl(this);
}

sealed class _CustomerModelQueryUpdate {
  int call({
    String? email,
    String? city,
    String? notes,
    double? points,
    int? visits,
    String? company,
    String? country,
    String? address,
    String? fullName,
    String? phoneNumber,
    double? purchaseValue,
    double? inboundProfit,
    String? hexId,
  });
}

class _CustomerModelQueryUpdateImpl implements _CustomerModelQueryUpdate {
  const _CustomerModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<CustomerModel> query;
  final int? limit;

  @override
  int call({
    Object? email = ignore,
    Object? city = ignore,
    Object? notes = ignore,
    Object? points = ignore,
    Object? visits = ignore,
    Object? company = ignore,
    Object? country = ignore,
    Object? address = ignore,
    Object? fullName = ignore,
    Object? phoneNumber = ignore,
    Object? purchaseValue = ignore,
    Object? inboundProfit = ignore,
    Object? hexId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (email != ignore) 1: email as String?,
      if (city != ignore) 2: city as String?,
      if (notes != ignore) 3: notes as String?,
      if (points != ignore) 4: points as double?,
      if (visits != ignore) 5: visits as int?,
      if (company != ignore) 6: company as String?,
      if (country != ignore) 7: country as String?,
      if (address != ignore) 8: address as String?,
      if (fullName != ignore) 9: fullName as String?,
      if (phoneNumber != ignore) 10: phoneNumber as String?,
      if (purchaseValue != ignore) 11: purchaseValue as double?,
      if (inboundProfit != ignore) 12: inboundProfit as double?,
      if (hexId != ignore) 13: hexId as String?,
    });
  }
}

extension CustomerModelQueryUpdate on IsarQuery<CustomerModel> {
  _CustomerModelQueryUpdate get updateFirst =>
      _CustomerModelQueryUpdateImpl(this, limit: 1);

  _CustomerModelQueryUpdate get updateAll =>
      _CustomerModelQueryUpdateImpl(this);
}

class _CustomerModelQueryBuilderUpdateImpl
    implements _CustomerModelQueryUpdate {
  const _CustomerModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<CustomerModel, CustomerModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? email = ignore,
    Object? city = ignore,
    Object? notes = ignore,
    Object? points = ignore,
    Object? visits = ignore,
    Object? company = ignore,
    Object? country = ignore,
    Object? address = ignore,
    Object? fullName = ignore,
    Object? phoneNumber = ignore,
    Object? purchaseValue = ignore,
    Object? inboundProfit = ignore,
    Object? hexId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (email != ignore) 1: email as String?,
        if (city != ignore) 2: city as String?,
        if (notes != ignore) 3: notes as String?,
        if (points != ignore) 4: points as double?,
        if (visits != ignore) 5: visits as int?,
        if (company != ignore) 6: company as String?,
        if (country != ignore) 7: country as String?,
        if (address != ignore) 8: address as String?,
        if (fullName != ignore) 9: fullName as String?,
        if (phoneNumber != ignore) 10: phoneNumber as String?,
        if (purchaseValue != ignore) 11: purchaseValue as double?,
        if (inboundProfit != ignore) 12: inboundProfit as double?,
        if (hexId != ignore) 13: hexId as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension CustomerModelQueryBuilderUpdate
    on QueryBuilder<CustomerModel, CustomerModel, QOperations> {
  _CustomerModelQueryUpdate get updateFirst =>
      _CustomerModelQueryBuilderUpdateImpl(this, limit: 1);

  _CustomerModelQueryUpdate get updateAll =>
      _CustomerModelQueryBuilderUpdateImpl(this);
}

extension CustomerModelQueryFilter
    on QueryBuilder<CustomerModel, CustomerModel, QFilterCondition> {
  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> cityBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition> cityMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsGreaterThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsLessThanOrEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 4, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  pointsBetween(double lower, double upper, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 5, value: value));
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  visitsBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 5, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  companyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 8, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 8, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 9, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 9,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 9, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 10, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 10, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 11, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 11, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 11, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 11, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 11, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  purchaseValueBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitEqualTo(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 12, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitGreaterThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 12, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 12, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitLessThan(double value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 12, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 12, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  inboundProfitBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 13, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 13, value: ''),
      );
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterFilterCondition>
  hexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 13, value: ''),
      );
    });
  }
}

extension CustomerModelQueryObject
    on QueryBuilder<CustomerModel, CustomerModel, QFilterCondition> {}

extension CustomerModelQuerySortBy
    on QueryBuilder<CustomerModel, CustomerModel, QSortBy> {
  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByEmailDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCity({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCityDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByNotesDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByVisits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByVisitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCompanyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCountry({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByCountryDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByAddressDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByFullNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByPhoneNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  sortByPhoneNumberDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  sortByPurchaseValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  sortByPurchaseValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  sortByInboundProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  sortByInboundProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> sortByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension CustomerModelQuerySortThenBy
    on QueryBuilder<CustomerModel, CustomerModel, QSortThenBy> {
  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByEmailDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCity({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCityDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByNotesDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByVisits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByVisitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCompanyDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCountry({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByCountryDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByAddressDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByFullNameDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByPhoneNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  thenByPhoneNumberDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  thenByPurchaseValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  thenByPurchaseValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  thenByInboundProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy>
  thenByInboundProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterSortBy> thenByHexIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension CustomerModelQueryWhereDistinct
    on QueryBuilder<CustomerModel, CustomerModel, QDistinct> {
  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByCity({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByVisits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByCompany({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByCountry({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByFullName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByPhoneNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByPurchaseValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct>
  distinctByInboundProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }

  QueryBuilder<CustomerModel, CustomerModel, QAfterDistinct> distinctByHexId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }
}

extension CustomerModelQueryProperty1
    on QueryBuilder<CustomerModel, CustomerModel, QProperty> {
  QueryBuilder<CustomerModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<CustomerModel, double, QAfterProperty> pointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<CustomerModel, int, QAfterProperty> visitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<CustomerModel, double, QAfterProperty> purchaseValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<CustomerModel, double, QAfterProperty> inboundProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<CustomerModel, String, QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }
}

extension CustomerModelQueryProperty2<R>
    on QueryBuilder<CustomerModel, R, QAfterProperty> {
  QueryBuilder<CustomerModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<CustomerModel, (R, double), QAfterProperty> pointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<CustomerModel, (R, int), QAfterProperty> visitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty>
  phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<CustomerModel, (R, double), QAfterProperty>
  purchaseValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<CustomerModel, (R, double), QAfterProperty>
  inboundProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<CustomerModel, (R, String), QAfterProperty> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }
}

extension CustomerModelQueryProperty3<R1, R2>
    on QueryBuilder<CustomerModel, (R1, R2), QAfterProperty> {
  QueryBuilder<CustomerModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, double), QOperations> pointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, int), QOperations> visitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> companyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations>
  fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations>
  phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, double), QOperations>
  purchaseValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, double), QOperations>
  inboundProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<CustomerModel, (R1, R2, String), QOperations> hexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }
}
