// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final Uint8List privateKey;
  final Uint8List kademliaId;
  LocalSetting(
      {@required this.id,
      @required this.privateKey,
      @required this.kademliaId});
  factory LocalSetting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return LocalSetting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      privateKey: uint8ListType
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
      privateKey: serializer.fromJson<Uint8List>(json['privateKey']),
      kademliaId: serializer.fromJson<Uint8List>(json['kademliaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'privateKey': serializer.toJson<Uint8List>(privateKey),
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

  LocalSetting copyWith({int id, Uint8List privateKey, Uint8List kademliaId}) =>
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
  final Value<Uint8List> privateKey;
  final Value<Uint8List> kademliaId;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.kademliaId = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    @required Uint8List privateKey,
    @required Uint8List kademliaId,
  })  : privateKey = Value(privateKey),
        kademliaId = Value(kademliaId);
  LocalSettingsCompanion copyWith(
      {Value<int> id,
      Value<Uint8List> privateKey,
      Value<Uint8List> kademliaId}) {
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
  GeneratedBlobColumn _privateKey;
  @override
  GeneratedBlobColumn get privateKey => _privateKey ??= _constructPrivateKey();
  GeneratedBlobColumn _constructPrivateKey() {
    return GeneratedBlobColumn(
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
      map['private_key'] = Variable<Uint8List, BlobType>(d.privateKey.value);
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

class DBChannel extends DataClass implements Insertable<DBChannel> {
  final int id;
  final String name;
  final Uint8List sharedSecret;
  final Uint8List nodeId;
  final String channelData;
  final String lastMessage_text;
  final String lastMessage_user;
  DBChannel(
      {@required this.id,
      @required this.name,
      @required this.sharedSecret,
      @required this.nodeId,
      this.channelData,
      this.lastMessage_text,
      this.lastMessage_user});
  factory DBChannel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return DBChannel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      sharedSecret: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}shared_secret']),
      nodeId: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      channelData: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_data']),
      lastMessage_text: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_text']),
      lastMessage_user: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_user']),
    );
  }
  factory DBChannel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DBChannel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sharedSecret: serializer.fromJson<Uint8List>(json['sharedSecret']),
      nodeId: serializer.fromJson<Uint8List>(json['nodeId']),
      channelData: serializer.fromJson<String>(json['channelData']),
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
      'sharedSecret': serializer.toJson<Uint8List>(sharedSecret),
      'nodeId': serializer.toJson<Uint8List>(nodeId),
      'channelData': serializer.toJson<String>(channelData),
      'lastMessage_text': serializer.toJson<String>(lastMessage_text),
      'lastMessage_user': serializer.toJson<String>(lastMessage_user),
    };
  }

  @override
  DBChannelsCompanion createCompanion(bool nullToAbsent) {
    return DBChannelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sharedSecret: sharedSecret == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedSecret),
      nodeId:
          nodeId == null && nullToAbsent ? const Value.absent() : Value(nodeId),
      channelData: channelData == null && nullToAbsent
          ? const Value.absent()
          : Value(channelData),
      lastMessage_text: lastMessage_text == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage_text),
      lastMessage_user: lastMessage_user == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage_user),
    );
  }

  DBChannel copyWith(
          {int id,
          String name,
          Uint8List sharedSecret,
          Uint8List nodeId,
          String channelData,
          String lastMessage_text,
          String lastMessage_user}) =>
      DBChannel(
        id: id ?? this.id,
        name: name ?? this.name,
        sharedSecret: sharedSecret ?? this.sharedSecret,
        nodeId: nodeId ?? this.nodeId,
        channelData: channelData ?? this.channelData,
        lastMessage_text: lastMessage_text ?? this.lastMessage_text,
        lastMessage_user: lastMessage_user ?? this.lastMessage_user,
      );
  @override
  String toString() {
    return (StringBuffer('DBChannel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sharedSecret: $sharedSecret, ')
          ..write('nodeId: $nodeId, ')
          ..write('channelData: $channelData, ')
          ..write('lastMessage_text: $lastMessage_text, ')
          ..write('lastMessage_user: $lastMessage_user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              sharedSecret.hashCode,
              $mrjc(
                  nodeId.hashCode,
                  $mrjc(
                      channelData.hashCode,
                      $mrjc(lastMessage_text.hashCode,
                          lastMessage_user.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DBChannel &&
          other.id == this.id &&
          other.name == this.name &&
          other.sharedSecret == this.sharedSecret &&
          other.nodeId == this.nodeId &&
          other.channelData == this.channelData &&
          other.lastMessage_text == this.lastMessage_text &&
          other.lastMessage_user == this.lastMessage_user);
}

class DBChannelsCompanion extends UpdateCompanion<DBChannel> {
  final Value<int> id;
  final Value<String> name;
  final Value<Uint8List> sharedSecret;
  final Value<Uint8List> nodeId;
  final Value<String> channelData;
  final Value<String> lastMessage_text;
  final Value<String> lastMessage_user;
  const DBChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sharedSecret = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.channelData = const Value.absent(),
    this.lastMessage_text = const Value.absent(),
    this.lastMessage_user = const Value.absent(),
  });
  DBChannelsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required Uint8List sharedSecret,
    @required Uint8List nodeId,
    this.channelData = const Value.absent(),
    this.lastMessage_text = const Value.absent(),
    this.lastMessage_user = const Value.absent(),
  })  : name = Value(name),
        sharedSecret = Value(sharedSecret),
        nodeId = Value(nodeId);
  DBChannelsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<Uint8List> sharedSecret,
      Value<Uint8List> nodeId,
      Value<String> channelData,
      Value<String> lastMessage_text,
      Value<String> lastMessage_user}) {
    return DBChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sharedSecret: sharedSecret ?? this.sharedSecret,
      nodeId: nodeId ?? this.nodeId,
      channelData: channelData ?? this.channelData,
      lastMessage_text: lastMessage_text ?? this.lastMessage_text,
      lastMessage_user: lastMessage_user ?? this.lastMessage_user,
    );
  }
}

class $DBChannelsTable extends DBChannels
    with TableInfo<$DBChannelsTable, DBChannel> {
  final GeneratedDatabase _db;
  final String _alias;
  $DBChannelsTable(this._db, [this._alias]);
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

  final VerificationMeta _sharedSecretMeta =
      const VerificationMeta('sharedSecret');
  GeneratedBlobColumn _sharedSecret;
  @override
  GeneratedBlobColumn get sharedSecret =>
      _sharedSecret ??= _constructSharedSecret();
  GeneratedBlobColumn _constructSharedSecret() {
    return GeneratedBlobColumn(
      'shared_secret',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  GeneratedBlobColumn _nodeId;
  @override
  GeneratedBlobColumn get nodeId => _nodeId ??= _constructNodeId();
  GeneratedBlobColumn _constructNodeId() {
    return GeneratedBlobColumn(
      'node_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelDataMeta =
      const VerificationMeta('channelData');
  GeneratedTextColumn _channelData;
  @override
  GeneratedTextColumn get channelData =>
      _channelData ??= _constructChannelData();
  GeneratedTextColumn _constructChannelData() {
    return GeneratedTextColumn(
      'channel_data',
      $tableName,
      true,
    );
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
      true,
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
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        sharedSecret,
        nodeId,
        channelData,
        lastMessage_text,
        lastMessage_user
      ];
  @override
  $DBChannelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'd_b_channels';
  @override
  final String actualTableName = 'd_b_channels';
  @override
  VerificationContext validateIntegrity(DBChannelsCompanion d,
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
    if (d.sharedSecret.present) {
      context.handle(
          _sharedSecretMeta,
          sharedSecret.isAcceptableValue(
              d.sharedSecret.value, _sharedSecretMeta));
    } else if (isInserting) {
      context.missing(_sharedSecretMeta);
    }
    if (d.nodeId.present) {
      context.handle(
          _nodeIdMeta, nodeId.isAcceptableValue(d.nodeId.value, _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (d.channelData.present) {
      context.handle(_channelDataMeta,
          channelData.isAcceptableValue(d.channelData.value, _channelDataMeta));
    }
    if (d.lastMessage_text.present) {
      context.handle(
          _lastMessage_textMeta,
          lastMessage_text.isAcceptableValue(
              d.lastMessage_text.value, _lastMessage_textMeta));
    }
    if (d.lastMessage_user.present) {
      context.handle(
          _lastMessage_userMeta,
          lastMessage_user.isAcceptableValue(
              d.lastMessage_user.value, _lastMessage_userMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DBChannel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DBChannel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DBChannelsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.sharedSecret.present) {
      map['shared_secret'] =
          Variable<Uint8List, BlobType>(d.sharedSecret.value);
    }
    if (d.nodeId.present) {
      map['node_id'] = Variable<Uint8List, BlobType>(d.nodeId.value);
    }
    if (d.channelData.present) {
      map['channel_data'] = Variable<String, StringType>(d.channelData.value);
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
  $DBChannelsTable createAlias(String alias) {
    return $DBChannelsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LocalSettingsTable _localSettings;
  $LocalSettingsTable get localSettings =>
      _localSettings ??= $LocalSettingsTable(this);
  $DBChannelsTable _dBChannels;
  $DBChannelsTable get dBChannels => _dBChannels ??= $DBChannelsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [localSettings, dBChannels];
}
