// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetNotificationModelCollection on Isar {
  IsarCollection<int, NotificationModel> get notificationModels =>
      this.collection();
}

final NotificationModelSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'NotificationModel',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'title', type: IsarType.string),
      IsarPropertySchema(name: 'message', type: IsarType.string),
      IsarPropertySchema(name: 'updatedAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'read', type: IsarType.bool),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, NotificationModel>(
    serialize: serializeNotificationModel,
    deserialize: deserializeNotificationModel,
    deserializeProperty: deserializeNotificationModelProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeNotificationModel(IsarWriter writer, NotificationModel object) {
  IsarCore.writeString(writer, 1, object.title);
  IsarCore.writeString(writer, 2, object.message);
  IsarCore.writeLong(
    writer,
    3,
    object.updatedAt.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeBool(writer, 4, value: object.read);
  return object.id;
}

@isarProtected
NotificationModel deserializeNotificationModel(IsarReader reader) {
  final String _title;
  _title = IsarCore.readString(reader, 1) ?? '';
  final String _message;
  _message = IsarCore.readString(reader, 2) ?? '';
  final DateTime _updatedAt;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _updatedAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      _updatedAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  final bool _read;
  _read = IsarCore.readBool(reader, 4);
  final object = NotificationModel(
    title: _title,
    message: _message,
    updatedAt: _updatedAt,
    read: _read,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeNotificationModelProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 4:
      return IsarCore.readBool(reader, 4);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _NotificationModelUpdate {
  bool call({
    required int id,
    String? title,
    String? message,
    DateTime? updatedAt,
    bool? read,
  });
}

class _NotificationModelUpdateImpl implements _NotificationModelUpdate {
  const _NotificationModelUpdateImpl(this.collection);

  final IsarCollection<int, NotificationModel> collection;

  @override
  bool call({
    required int id,
    Object? title = ignore,
    Object? message = ignore,
    Object? updatedAt = ignore,
    Object? read = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (title != ignore) 1: title as String?,
            if (message != ignore) 2: message as String?,
            if (updatedAt != ignore) 3: updatedAt as DateTime?,
            if (read != ignore) 4: read as bool?,
          },
        ) >
        0;
  }
}

sealed class _NotificationModelUpdateAll {
  int call({
    required List<int> id,
    String? title,
    String? message,
    DateTime? updatedAt,
    bool? read,
  });
}

class _NotificationModelUpdateAllImpl implements _NotificationModelUpdateAll {
  const _NotificationModelUpdateAllImpl(this.collection);

  final IsarCollection<int, NotificationModel> collection;

  @override
  int call({
    required List<int> id,
    Object? title = ignore,
    Object? message = ignore,
    Object? updatedAt = ignore,
    Object? read = ignore,
  }) {
    return collection.updateProperties(id, {
      if (title != ignore) 1: title as String?,
      if (message != ignore) 2: message as String?,
      if (updatedAt != ignore) 3: updatedAt as DateTime?,
      if (read != ignore) 4: read as bool?,
    });
  }
}

extension NotificationModelUpdate on IsarCollection<int, NotificationModel> {
  _NotificationModelUpdate get update => _NotificationModelUpdateImpl(this);

  _NotificationModelUpdateAll get updateAll =>
      _NotificationModelUpdateAllImpl(this);
}

sealed class _NotificationModelQueryUpdate {
  int call({String? title, String? message, DateTime? updatedAt, bool? read});
}

class _NotificationModelQueryUpdateImpl
    implements _NotificationModelQueryUpdate {
  const _NotificationModelQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<NotificationModel> query;
  final int? limit;

  @override
  int call({
    Object? title = ignore,
    Object? message = ignore,
    Object? updatedAt = ignore,
    Object? read = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (title != ignore) 1: title as String?,
      if (message != ignore) 2: message as String?,
      if (updatedAt != ignore) 3: updatedAt as DateTime?,
      if (read != ignore) 4: read as bool?,
    });
  }
}

extension NotificationModelQueryUpdate on IsarQuery<NotificationModel> {
  _NotificationModelQueryUpdate get updateFirst =>
      _NotificationModelQueryUpdateImpl(this, limit: 1);

  _NotificationModelQueryUpdate get updateAll =>
      _NotificationModelQueryUpdateImpl(this);
}

class _NotificationModelQueryBuilderUpdateImpl
    implements _NotificationModelQueryUpdate {
  const _NotificationModelQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<NotificationModel, NotificationModel, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? title = ignore,
    Object? message = ignore,
    Object? updatedAt = ignore,
    Object? read = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (title != ignore) 1: title as String?,
        if (message != ignore) 2: message as String?,
        if (updatedAt != ignore) 3: updatedAt as DateTime?,
        if (read != ignore) 4: read as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension NotificationModelQueryBuilderUpdate
    on QueryBuilder<NotificationModel, NotificationModel, QOperations> {
  _NotificationModelQueryUpdate get updateFirst =>
      _NotificationModelQueryBuilderUpdateImpl(this, limit: 1);

  _NotificationModelQueryUpdate get updateAll =>
      _NotificationModelQueryBuilderUpdateImpl(this);
}

extension NotificationModelQueryFilter
    on QueryBuilder<NotificationModel, NotificationModel, QFilterCondition> {
  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  idBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 1, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 1, value: ''),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageGreaterThan(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageBetween(String lower, String upper, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  updatedAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterFilterCondition>
  readEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value),
      );
    });
  }
}

extension NotificationModelQueryObject
    on QueryBuilder<NotificationModel, NotificationModel, QFilterCondition> {}

extension NotificationModelQuerySortBy
    on QueryBuilder<NotificationModel, NotificationModel, QSortBy> {
  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy> sortByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByMessageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }
}

extension NotificationModelQuerySortThenBy
    on QueryBuilder<NotificationModel, NotificationModel, QSortThenBy> {
  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy> thenByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByMessageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterSortBy>
  thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }
}

extension NotificationModelQueryWhereDistinct
    on QueryBuilder<NotificationModel, NotificationModel, QDistinct> {
  QueryBuilder<NotificationModel, NotificationModel, QAfterDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterDistinct>
  distinctByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<NotificationModel, NotificationModel, QAfterDistinct>
  distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }
}

extension NotificationModelQueryProperty1
    on QueryBuilder<NotificationModel, NotificationModel, QProperty> {
  QueryBuilder<NotificationModel, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<NotificationModel, String, QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<NotificationModel, String, QAfterProperty> messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<NotificationModel, DateTime, QAfterProperty>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<NotificationModel, bool, QAfterProperty> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}

extension NotificationModelQueryProperty2<R>
    on QueryBuilder<NotificationModel, R, QAfterProperty> {
  QueryBuilder<NotificationModel, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<NotificationModel, (R, String), QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<NotificationModel, (R, String), QAfterProperty>
  messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<NotificationModel, (R, DateTime), QAfterProperty>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<NotificationModel, (R, bool), QAfterProperty> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}

extension NotificationModelQueryProperty3<R1, R2>
    on QueryBuilder<NotificationModel, (R1, R2), QAfterProperty> {
  QueryBuilder<NotificationModel, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<NotificationModel, (R1, R2, String), QOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<NotificationModel, (R1, R2, String), QOperations>
  messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<NotificationModel, (R1, R2, DateTime), QOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<NotificationModel, (R1, R2, bool), QOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }
}
