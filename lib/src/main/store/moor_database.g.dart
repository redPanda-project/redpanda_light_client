// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final String privateKey;
  final Uint8List kademliaId;
  LocalSetting(
      {@required this.id,
      @required this.privateKey,
      @required this.kademliaId});
  factory LocalSetting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return LocalSetting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      privateKey: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}private_key']),
      kademliaId: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
    );
  }
  factory LocalSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalSetting(
      id: serializer.fromJson<int>(json['id']),
      privateKey: serializer.fromJson<String>(json['privateKey']),
      kademliaId: serializer.fromJson<Uint8List>(json['kademliaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'privateKey': serializer.toJson<String>(privateKey),
      'kademliaId': serializer.toJson<Uint8List>(kademliaId),
    };
  }

  @override
  LocalSettingsCompanion createCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      privateKey: privateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(privateKey),
      kademliaId: kademliaId == null && nullToAbsent
          ? const Value.absent()
          : Value(kademliaId),
    );
  }

  LocalSetting copyWith({int id, String privateKey, Uint8List kademliaId}) =>
      LocalSetting(
        id: id ?? this.id,
        privateKey: privateKey ?? this.privateKey,
        kademliaId: kademliaId ?? this.kademliaId,
      );
  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('id: $id, ')
          ..write('privateKey: $privateKey, ')
          ..write('kademliaId: $kademliaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(privateKey.hashCode, kademliaId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.id == this.id &&
          other.privateKey == this.privateKey &&
          other.kademliaId == this.kademliaId);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<int> id;
  final Value<String> privateKey;
  final Value<Uint8List> kademliaId;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.kademliaId = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String privateKey,
    @required Uint8List kademliaId,
  })  : privateKey = Value(privateKey),
        kademliaId = Value(kademliaId);
  LocalSettingsCompanion copyWith(
      {Value<int> id, Value<String> privateKey, Value<Uint8List> kademliaId}) {
    return LocalSettingsCompanion(
      id: id ?? this.id,
      privateKey: privateKey ?? this.privateKey,
      kademliaId: kademliaId ?? this.kademliaId,
    );
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalSettingsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _privateKeyMeta = const VerificationMeta('privateKey');
  GeneratedTextColumn _privateKey;
  @override
  GeneratedTextColumn get privateKey => _privateKey ??= _constructPrivateKey();
  GeneratedTextColumn _constructPrivateKey() {
    return GeneratedTextColumn(
      'private_key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _kademliaIdMeta = const VerificationMeta('kademliaId');
  GeneratedBlobColumn _kademliaId;
  @override
  GeneratedBlobColumn get kademliaId => _kademliaId ??= _constructKademliaId();
  GeneratedBlobColumn _constructKademliaId() {
    return GeneratedBlobColumn(
      'kademlia_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, privateKey, kademliaId];
  @override
  $LocalSettingsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_settings';
  @override
  final String actualTableName = 'local_settings';
  @override
  VerificationContext validateIntegrity(LocalSettingsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.privateKey.present) {
      context.handle(_privateKeyMeta,
          privateKey.isAcceptableValue(d.privateKey.value, _privateKeyMeta));
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (d.kademliaId.present) {
      context.handle(_kademliaIdMeta,
          kademliaId.isAcceptableValue(d.kademliaId.value, _kademliaIdMeta));
    } else if (isInserting) {
      context.missing(_kademliaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSetting map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalSetting.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalSettingsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.privateKey.present) {
      map['private_key'] = Variable<String, StringType>(d.privateKey.value);
    }
    if (d.kademliaId.present) {
      map['kademlia_id'] = Variable<Uint8List, BlobType>(d.kademliaId.value);
    }
    return map;
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(_db, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final int id;
  final String name;
  final String lastMessage_text;
  final String lastMessage_user;
  Channel(
      {@required this.id,
      @required this.name,
      @required this.lastMessage_text,
      @required this.lastMessage_user});
  factory Channel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Channel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      lastMessage_text: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_text']),
      lastMessage_user: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_user']),
    );
  }
  factory Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Channel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastMessage_text: serializer.fromJson<String>(json['lastMessage_text']),
      lastMessage_user: serializer.fromJson<String>(json['lastMessage_user']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lastMessage_text': serializer.toJson<String>(lastMessage_text),
      'lastMessage_user': serializer.toJson<String>(lastMessage_user),
    };
  }

  @override
  ChannelsCompanion createCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      lastMessage_text: lastMessage_text == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage_text),
      lastMessage_user: lastMessage_user == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage_user),
    );
  }

  Channel copyWith(
          {int id,
          String name,
          String lastMessage_text,
          String lastMessage_user}) =>
      Channel(
        id: id ?? this.id,
        name: name ?? this.name,
        lastMessage_text: lastMessage_text ?? this.lastMessage_text,
        lastMessage_user: lastMessage_user ?? this.lastMessage_user,
      );
  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastMessage_text: $lastMessage_text, ')
          ..write('lastMessage_user: $lastMessage_user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(lastMessage_text.hashCode, lastMessage_user.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Channel &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastMessage_text == this.lastMessage_text &&
          other.lastMessage_user == this.lastMessage_user);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> lastMessage_text;
  final Value<String> lastMessage_user;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastMessage_text = const Value.absent(),
    this.lastMessage_user = const Value.absent(),
  });
  ChannelsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String lastMessage_text,
    @required String lastMessage_user,
  })  : name = Value(name),
        lastMessage_text = Value(lastMessage_text),
        lastMessage_user = Value(lastMessage_user);
  ChannelsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> lastMessage_text,
      Value<String> lastMessage_user}) {
    return ChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage_text: lastMessage_text ?? this.lastMessage_text,
      lastMessage_user: lastMessage_user ?? this.lastMessage_user,
    );
  }
}

class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  final GeneratedDatabase _db;
  final String _alias;
  $ChannelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 3, maxTextLength: 32);
  }

  final VerificationMeta _lastMessage_textMeta =
      const VerificationMeta('lastMessage_text');
  GeneratedTextColumn _lastMessage_text;
  @override
  GeneratedTextColumn get lastMessage_text =>
      _lastMessage_text ??= _constructLastMessageText();
  GeneratedTextColumn _constructLastMessageText() {
    return GeneratedTextColumn(
      'last_message_text',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastMessage_userMeta =
      const VerificationMeta('lastMessage_user');
  GeneratedTextColumn _lastMessage_user;
  @override
  GeneratedTextColumn get lastMessage_user =>
      _lastMessage_user ??= _constructLastMessageUser();
  GeneratedTextColumn _constructLastMessageUser() {
    return GeneratedTextColumn(
      'last_message_user',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, lastMessage_text, lastMessage_user];
  @override
  $ChannelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channels';
  @override
  final String actualTableName = 'channels';
  @override
  VerificationContext validateIntegrity(ChannelsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.lastMessage_text.present) {
      context.handle(
          _lastMessage_textMeta,
          lastMessage_text.isAcceptableValue(
              d.lastMessage_text.value, _lastMessage_textMeta));
    } else if (isInserting) {
      context.missing(_lastMessage_textMeta);
    }
    if (d.lastMessage_user.present) {
      context.handle(
          _lastMessage_userMeta,
          lastMessage_user.isAcceptableValue(
              d.lastMessage_user.value, _lastMessage_userMeta));
    } else if (isInserting) {
      context.missing(_lastMessage_userMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Channel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Channel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ChannelsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.lastMessage_text.present) {
      map['last_message_text'] =
          Variable<String, StringType>(d.lastMessage_text.value);
    }
    if (d.lastMessage_user.present) {
      map['last_message_user'] =
          Variable<String, StringType>(d.lastMessage_user.value);
    }
    return map;
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LocalSettingsTable _localSettings;
  $LocalSettingsTable get localSettings =>
      _localSettings ??= $LocalSettingsTable(this);
  $ChannelsTable _channels;
  $ChannelsTable get channels => _channels ??= $ChannelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localSettings, channels];
}
