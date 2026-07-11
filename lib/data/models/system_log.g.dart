// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetSystemLogCollection on Isar {
  IsarCollection<int, SystemLog> get systemLogs => this.collection();
}

final SystemLogSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SystemLog',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'actionType', type: IsarType.string),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'appVersion', type: IsarType.string),
      IsarPropertySchema(name: 'userId', type: IsarType.string),
      IsarPropertySchema(name: 'deviceId', type: IsarType.string),
      IsarPropertySchema(name: 'occurredAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'metadata', type: IsarType.string),
      IsarPropertySchema(name: 'syncedToServer', type: IsarType.bool),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, SystemLog>(
    serialize: serializeSystemLog,
    deserialize: deserializeSystemLog,
    deserializeProperty: deserializeSystemLogProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeSystemLog(IsarWriter writer, SystemLog object) {
  IsarCore.writeString(writer, 1, object.actionType);
  IsarCore.writeString(writer, 2, object.description);
  IsarCore.writeString(writer, 3, object.appVersion);
  {
    final value = object.userId;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  {
    final value = object.deviceId;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  IsarCore.writeLong(
    writer,
    6,
    object.occurredAt.toUtc().microsecondsSinceEpoch,
  );
  {
    final value = object.metadata;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeBool(writer, 8, value: object.syncedToServer);
  return object.id;
}

@isarProtected
SystemLog deserializeSystemLog(IsarReader reader) {
  final String _actionType;
  _actionType = IsarCore.readString(reader, 1) ?? '';
  final String _description;
  _description = IsarCore.readString(reader, 2) ?? '';
  final String _appVersion;
  _appVersion = IsarCore.readString(reader, 3) ?? '';
  final String? _userId;
  _userId = IsarCore.readString(reader, 4);
  final String? _deviceId;
  _deviceId = IsarCore.readString(reader, 5);
  final DateTime _occurredAt;
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      _occurredAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _occurredAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final String? _metadata;
  _metadata = IsarCore.readString(reader, 7);
  final bool _syncedToServer;
  _syncedToServer = IsarCore.readBool(reader, 8);
  final object = SystemLog(
    actionType: _actionType,
    description: _description,
    appVersion: _appVersion,
    userId: _userId,
    deviceId: _deviceId,
    occurredAt: _occurredAt,
    metadata: _metadata,
    syncedToServer: _syncedToServer,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeSystemLogProp(IsarReader reader, int property) {
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
      return IsarCore.readString(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      return IsarCore.readBool(reader, 8);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _SystemLogUpdate {
  bool call({
    required int id,
    String? actionType,
    String? description,
    String? appVersion,
    String? userId,
    String? deviceId,
    DateTime? occurredAt,
    String? metadata,
    bool? syncedToServer,
  });
}

class _SystemLogUpdateImpl implements _SystemLogUpdate {
  const _SystemLogUpdateImpl(this.collection);

  final IsarCollection<int, SystemLog> collection;

  @override
  bool call({
    required int id,
    Object? actionType = ignore,
    Object? description = ignore,
    Object? appVersion = ignore,
    Object? userId = ignore,
    Object? deviceId = ignore,
    Object? occurredAt = ignore,
    Object? metadata = ignore,
    Object? syncedToServer = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (actionType != ignore) 1: actionType as String?,
            if (description != ignore) 2: description as String?,
            if (appVersion != ignore) 3: appVersion as String?,
            if (userId != ignore) 4: userId as String?,
            if (deviceId != ignore) 5: deviceId as String?,
            if (occurredAt != ignore) 6: occurredAt as DateTime?,
            if (metadata != ignore) 7: metadata as String?,
            if (syncedToServer != ignore) 8: syncedToServer as bool?,
          },
        ) >
        0;
  }
}

sealed class _SystemLogUpdateAll {
  int call({
    required List<int> id,
    String? actionType,
    String? description,
    String? appVersion,
    String? userId,
    String? deviceId,
    DateTime? occurredAt,
    String? metadata,
    bool? syncedToServer,
  });
}

class _SystemLogUpdateAllImpl implements _SystemLogUpdateAll {
  const _SystemLogUpdateAllImpl(this.collection);

  final IsarCollection<int, SystemLog> collection;

  @override
  int call({
    required List<int> id,
    Object? actionType = ignore,
    Object? description = ignore,
    Object? appVersion = ignore,
    Object? userId = ignore,
    Object? deviceId = ignore,
    Object? occurredAt = ignore,
    Object? metadata = ignore,
    Object? syncedToServer = ignore,
  }) {
    return collection.updateProperties(id, {
      if (actionType != ignore) 1: actionType as String?,
      if (description != ignore) 2: description as String?,
      if (appVersion != ignore) 3: appVersion as String?,
      if (userId != ignore) 4: userId as String?,
      if (deviceId != ignore) 5: deviceId as String?,
      if (occurredAt != ignore) 6: occurredAt as DateTime?,
      if (metadata != ignore) 7: metadata as String?,
      if (syncedToServer != ignore) 8: syncedToServer as bool?,
    });
  }
}

extension SystemLogUpdate on IsarCollection<int, SystemLog> {
  _SystemLogUpdate get update => _SystemLogUpdateImpl(this);

  _SystemLogUpdateAll get updateAll => _SystemLogUpdateAllImpl(this);
}

sealed class _SystemLogQueryUpdate {
  int call({
    String? actionType,
    String? description,
    String? appVersion,
    String? userId,
    String? deviceId,
    DateTime? occurredAt,
    String? metadata,
    bool? syncedToServer,
  });
}

class _SystemLogQueryUpdateImpl implements _SystemLogQueryUpdate {
  const _SystemLogQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<SystemLog> query;
  final int? limit;

  @override
  int call({
    Object? actionType = ignore,
    Object? description = ignore,
    Object? appVersion = ignore,
    Object? userId = ignore,
    Object? deviceId = ignore,
    Object? occurredAt = ignore,
    Object? metadata = ignore,
    Object? syncedToServer = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (actionType != ignore) 1: actionType as String?,
      if (description != ignore) 2: description as String?,
      if (appVersion != ignore) 3: appVersion as String?,
      if (userId != ignore) 4: userId as String?,
      if (deviceId != ignore) 5: deviceId as String?,
      if (occurredAt != ignore) 6: occurredAt as DateTime?,
      if (metadata != ignore) 7: metadata as String?,
      if (syncedToServer != ignore) 8: syncedToServer as bool?,
    });
  }
}

extension SystemLogQueryUpdate on IsarQuery<SystemLog> {
  _SystemLogQueryUpdate get updateFirst =>
      _SystemLogQueryUpdateImpl(this, limit: 1);

  _SystemLogQueryUpdate get updateAll => _SystemLogQueryUpdateImpl(this);
}

class _SystemLogQueryBuilderUpdateImpl implements _SystemLogQueryUpdate {
  const _SystemLogQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<SystemLog, SystemLog, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? actionType = ignore,
    Object? description = ignore,
    Object? appVersion = ignore,
    Object? userId = ignore,
    Object? deviceId = ignore,
    Object? occurredAt = ignore,
    Object? metadata = ignore,
    Object? syncedToServer = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (actionType != ignore) 1: actionType as String?,
        if (description != ignore) 2: description as String?,
        if (appVersion != ignore) 3: appVersion as String?,
        if (userId != ignore) 4: userId as String?,
        if (deviceId != ignore) 5: deviceId as String?,
        if (occurredAt != ignore) 6: occurredAt as DateTime?,
        if (metadata != ignore) 7: metadata as String?,
        if (syncedToServer != ignore) 8: syncedToServer as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension SystemLogQueryBuilderUpdate
    on QueryBuilder<SystemLog, SystemLog, QOperations> {
  _SystemLogQueryUpdate get updateFirst =>
      _SystemLogQueryBuilderUpdateImpl(this, limit: 1);

  _SystemLogQueryUpdate get updateAll => _SystemLogQueryBuilderUpdateImpl(this);
}

extension SystemLogQueryFilter
    on QueryBuilder<SystemLog, SystemLog, QFilterCondition> {
  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeBetween(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeEndsWith(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeContains(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> actionTypeMatches(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  actionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionBetween(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> descriptionMatches(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionBetween(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionEndsWith(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionContains(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> appVersionMatches(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  appVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  userIdGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  userIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdEndsWith(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdContains(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdMatches(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  deviceIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  deviceIdGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  deviceIdLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 5, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> occurredAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  occurredAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  occurredAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> occurredAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 6, value: value));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  occurredAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 6, value: value),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> occurredAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 6, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  metadataIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataGreaterThan(
    String? value, {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  metadataGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  metadataLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataStartsWith(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataEndsWith(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataContains(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataMatches(
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

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition> metadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  metadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterFilterCondition>
  syncedToServerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }
}

extension SystemLogQueryObject
    on QueryBuilder<SystemLog, SystemLog, QFilterCondition> {}

extension SystemLogQuerySortBy on QueryBuilder<SystemLog, SystemLog, QSortBy> {
  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByActionType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByActionTypeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByDescriptionDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByAppVersion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByAppVersionDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByUserIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByDeviceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByDeviceIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByMetadata({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortByMetadataDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortBySyncedToServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> sortBySyncedToServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension SystemLogQuerySortThenBy
    on QueryBuilder<SystemLog, SystemLog, QSortThenBy> {
  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByActionType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByActionTypeDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByDescriptionDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByAppVersion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByAppVersionDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByUserIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByDeviceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByDeviceIdDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByMetadata({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenByMetadataDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenBySyncedToServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterSortBy> thenBySyncedToServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }
}

extension SystemLogQueryWhereDistinct
    on QueryBuilder<SystemLog, SystemLog, QDistinct> {
  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByActionType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByAppVersion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByDeviceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct> distinctByMetadata({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SystemLog, SystemLog, QAfterDistinct>
  distinctBySyncedToServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }
}

extension SystemLogQueryProperty1
    on QueryBuilder<SystemLog, SystemLog, QProperty> {
  QueryBuilder<SystemLog, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SystemLog, String, QAfterProperty> actionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SystemLog, String, QAfterProperty> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SystemLog, String, QAfterProperty> appVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SystemLog, String?, QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SystemLog, String?, QAfterProperty> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SystemLog, DateTime, QAfterProperty> occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SystemLog, String?, QAfterProperty> metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SystemLog, bool, QAfterProperty> syncedToServerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension SystemLogQueryProperty2<R>
    on QueryBuilder<SystemLog, R, QAfterProperty> {
  QueryBuilder<SystemLog, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SystemLog, (R, String), QAfterProperty> actionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SystemLog, (R, String), QAfterProperty> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SystemLog, (R, String), QAfterProperty> appVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SystemLog, (R, String?), QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SystemLog, (R, String?), QAfterProperty> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SystemLog, (R, DateTime), QAfterProperty> occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SystemLog, (R, String?), QAfterProperty> metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SystemLog, (R, bool), QAfterProperty> syncedToServerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}

extension SystemLogQueryProperty3<R1, R2>
    on QueryBuilder<SystemLog, (R1, R2), QAfterProperty> {
  QueryBuilder<SystemLog, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String), QOperations> actionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String), QOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String), QOperations> appVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String?), QOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String?), QOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, DateTime), QOperations>
  occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, String?), QOperations> metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SystemLog, (R1, R2, bool), QOperations>
  syncedToServerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }
}
