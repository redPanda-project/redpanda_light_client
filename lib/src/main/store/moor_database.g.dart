// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final String myUserId;
  final Uint8List privateKey;
  final Uint8List kademliaId;
  final String defaultName;
  LocalSetting(
      {@required this.id,
      @required this.myUserId,
      @required this.privateKey,
      @required this.kademliaId,
      @required this.defaultName});
  factory LocalSetting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return LocalSetting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      myUserId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}my_user_id']),
      privateKey: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}private_key']),
      kademliaId: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
      defaultName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}default_name']),
    );
  }
  factory LocalSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalSetting(
      id: serializer.fromJson<int>(json['id']),
      myUserId: serializer.fromJson<String>(json['myUserId']),
      privateKey: serializer.fromJson<Uint8List>(json['privateKey']),
      kademliaId: serializer.fromJson<Uint8List>(json['kademliaId']),
      defaultName: serializer.fromJson<String>(json['defaultName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'myUserId': serializer.toJson<String>(myUserId),
      'privateKey': serializer.toJson<Uint8List>(privateKey),
      'kademliaId': serializer.toJson<Uint8List>(kademliaId),
      'defaultName': serializer.toJson<String>(defaultName),
    };
  }

  @override
  LocalSettingsCompanion createCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      myUserId: myUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(myUserId),
      privateKey: privateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(privateKey),
      kademliaId: kademliaId == null && nullToAbsent
          ? const Value.absent()
          : Value(kademliaId),
      defaultName: defaultName == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultName),
    );
  }

  LocalSetting copyWith(
          {int id,
          String myUserId,
          Uint8List privateKey,
          Uint8List kademliaId,
          String defaultName}) =>
      LocalSetting(
        id: id ?? this.id,
        myUserId: myUserId ?? this.myUserId,
        privateKey: privateKey ?? this.privateKey,
        kademliaId: kademliaId ?? this.kademliaId,
        defaultName: defaultName ?? this.defaultName,
      );
  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('id: $id, ')
          ..write('myUserId: $myUserId, ')
          ..write('privateKey: $privateKey, ')
          ..write('kademliaId: $kademliaId, ')
          ..write('defaultName: $defaultName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          myUserId.hashCode,
          $mrjc(privateKey.hashCode,
              $mrjc(kademliaId.hashCode, defaultName.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.id == this.id &&
          other.myUserId == this.myUserId &&
          other.privateKey == this.privateKey &&
          other.kademliaId == this.kademliaId &&
          other.defaultName == this.defaultName);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<int> id;
  final Value<String> myUserId;
  final Value<Uint8List> privateKey;
  final Value<Uint8List> kademliaId;
  final Value<String> defaultName;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.myUserId = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.kademliaId = const Value.absent(),
    this.defaultName = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    @required String myUserId,
    @required Uint8List privateKey,
    @required Uint8List kademliaId,
    @required String defaultName,
  })  : myUserId = Value(myUserId),
        privateKey = Value(privateKey),
        kademliaId = Value(kademliaId),
        defaultName = Value(defaultName);
  LocalSettingsCompanion copyWith(
      {Value<int> id,
      Value<String> myUserId,
      Value<Uint8List> privateKey,
      Value<Uint8List> kademliaId,
      Value<String> defaultName}) {
    return LocalSettingsCompanion(
      id: id ?? this.id,
      myUserId: myUserId ?? this.myUserId,
      privateKey: privateKey ?? this.privateKey,
      kademliaId: kademliaId ?? this.kademliaId,
      defaultName: defaultName ?? this.defaultName,
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

  final VerificationMeta _myUserIdMeta = const VerificationMeta('myUserId');
  GeneratedTextColumn _myUserId;
  @override
  GeneratedTextColumn get myUserId => _myUserId ??= _constructMyUserId();
  GeneratedTextColumn _constructMyUserId() {
    return GeneratedTextColumn(
      'my_user_id',
      $tableName,
      false,
    );
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

  final VerificationMeta _defaultNameMeta =
      const VerificationMeta('defaultName');
  GeneratedTextColumn _defaultName;
  @override
  GeneratedTextColumn get defaultName =>
      _defaultName ??= _constructDefaultName();
  GeneratedTextColumn _constructDefaultName() {
    return GeneratedTextColumn(
      'default_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, myUserId, privateKey, kademliaId, defaultName];
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
    if (d.myUserId.present) {
      context.handle(_myUserIdMeta,
          myUserId.isAcceptableValue(d.myUserId.value, _myUserIdMeta));
    } else if (isInserting) {
      context.missing(_myUserIdMeta);
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
    if (d.defaultName.present) {
      context.handle(_defaultNameMeta,
          defaultName.isAcceptableValue(d.defaultName.value, _defaultNameMeta));
    } else if (isInserting) {
      context.missing(_defaultNameMeta);
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
    if (d.myUserId.present) {
      map['my_user_id'] = Variable<String, StringType>(d.myUserId.value);
    }
    if (d.privateKey.present) {
      map['private_key'] = Variable<Uint8List, BlobType>(d.privateKey.value);
    }
    if (d.kademliaId.present) {
      map['kademlia_id'] = Variable<Uint8List, BlobType>(d.kademliaId.value);
    }
    if (d.defaultName.present) {
      map['default_name'] = Variable<String, StringType>(d.defaultName.value);
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

class DBPeer extends DataClass implements Insertable<DBPeer> {
  final int id;
  final String ip;
  final int port;
  final int retries;
  final int knownSince;
  final Uint8List kademliaId;
  final Uint8List publicKey;
  DBPeer(
      {@required this.id,
      @required this.ip,
      @required this.port,
      @required this.retries,
      @required this.knownSince,
      @required this.kademliaId,
      @required this.publicKey});
  factory DBPeer.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return DBPeer(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      ip: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      port: intType.mapFromDatabaseResponse(data['${effectivePrefix}port']),
      retries:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}retries']),
      knownSince: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}known_since']),
      kademliaId: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
      publicKey: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}public_key']),
    );
  }
  factory DBPeer.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DBPeer(
      id: serializer.fromJson<int>(json['id']),
      ip: serializer.fromJson<String>(json['ip']),
      port: serializer.fromJson<int>(json['port']),
      retries: serializer.fromJson<int>(json['retries']),
      knownSince: serializer.fromJson<int>(json['knownSince']),
      kademliaId: serializer.fromJson<Uint8List>(json['kademliaId']),
      publicKey: serializer.fromJson<Uint8List>(json['publicKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ip': serializer.toJson<String>(ip),
      'port': serializer.toJson<int>(port),
      'retries': serializer.toJson<int>(retries),
      'knownSince': serializer.toJson<int>(knownSince),
      'kademliaId': serializer.toJson<Uint8List>(kademliaId),
      'publicKey': serializer.toJson<Uint8List>(publicKey),
    };
  }

  @override
  DBPeersCompanion createCompanion(bool nullToAbsent) {
    return DBPeersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      ip: ip == null && nullToAbsent ? const Value.absent() : Value(ip),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      retries: retries == null && nullToAbsent
          ? const Value.absent()
          : Value(retries),
      knownSince: knownSince == null && nullToAbsent
          ? const Value.absent()
          : Value(knownSince),
      kademliaId: kademliaId == null && nullToAbsent
          ? const Value.absent()
          : Value(kademliaId),
      publicKey: publicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(publicKey),
    );
  }

  DBPeer copyWith(
          {int id,
          String ip,
          int port,
          int retries,
          int knownSince,
          Uint8List kademliaId,
          Uint8List publicKey}) =>
      DBPeer(
        id: id ?? this.id,
        ip: ip ?? this.ip,
        port: port ?? this.port,
        retries: retries ?? this.retries,
        knownSince: knownSince ?? this.knownSince,
        kademliaId: kademliaId ?? this.kademliaId,
        publicKey: publicKey ?? this.publicKey,
      );
  @override
  String toString() {
    return (StringBuffer('DBPeer(')
          ..write('id: $id, ')
          ..write('ip: $ip, ')
          ..write('port: $port, ')
          ..write('retries: $retries, ')
          ..write('knownSince: $knownSince, ')
          ..write('kademliaId: $kademliaId, ')
          ..write('publicKey: $publicKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          ip.hashCode,
          $mrjc(
              port.hashCode,
              $mrjc(
                  retries.hashCode,
                  $mrjc(knownSince.hashCode,
                      $mrjc(kademliaId.hashCode, publicKey.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DBPeer &&
          other.id == this.id &&
          other.ip == this.ip &&
          other.port == this.port &&
          other.retries == this.retries &&
          other.knownSince == this.knownSince &&
          other.kademliaId == this.kademliaId &&
          other.publicKey == this.publicKey);
}

class DBPeersCompanion extends UpdateCompanion<DBPeer> {
  final Value<int> id;
  final Value<String> ip;
  final Value<int> port;
  final Value<int> retries;
  final Value<int> knownSince;
  final Value<Uint8List> kademliaId;
  final Value<Uint8List> publicKey;
  const DBPeersCompanion({
    this.id = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.retries = const Value.absent(),
    this.knownSince = const Value.absent(),
    this.kademliaId = const Value.absent(),
    this.publicKey = const Value.absent(),
  });
  DBPeersCompanion.insert({
    this.id = const Value.absent(),
    @required String ip,
    @required int port,
    this.retries = const Value.absent(),
    @required int knownSince,
    @required Uint8List kademliaId,
    @required Uint8List publicKey,
  })  : ip = Value(ip),
        port = Value(port),
        knownSince = Value(knownSince),
        kademliaId = Value(kademliaId),
        publicKey = Value(publicKey);
  DBPeersCompanion copyWith(
      {Value<int> id,
      Value<String> ip,
      Value<int> port,
      Value<int> retries,
      Value<int> knownSince,
      Value<Uint8List> kademliaId,
      Value<Uint8List> publicKey}) {
    return DBPeersCompanion(
      id: id ?? this.id,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      retries: retries ?? this.retries,
      knownSince: knownSince ?? this.knownSince,
      kademliaId: kademliaId ?? this.kademliaId,
      publicKey: publicKey ?? this.publicKey,
    );
  }
}

class $DBPeersTable extends DBPeers with TableInfo<$DBPeersTable, DBPeer> {
  final GeneratedDatabase _db;
  final String _alias;
  $DBPeersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  GeneratedTextColumn _ip;
  @override
  GeneratedTextColumn get ip => _ip ??= _constructIp();
  GeneratedTextColumn _constructIp() {
    return GeneratedTextColumn('ip', $tableName, false,
        minTextLength: 3, maxTextLength: 32);
  }

  final VerificationMeta _portMeta = const VerificationMeta('port');
  GeneratedIntColumn _port;
  @override
  GeneratedIntColumn get port => _port ??= _constructPort();
  GeneratedIntColumn _constructPort() {
    return GeneratedIntColumn(
      'port',
      $tableName,
      false,
    );
  }

  final VerificationMeta _retriesMeta = const VerificationMeta('retries');
  GeneratedIntColumn _retries;
  @override
  GeneratedIntColumn get retries => _retries ??= _constructRetries();
  GeneratedIntColumn _constructRetries() {
    return GeneratedIntColumn('retries', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _knownSinceMeta = const VerificationMeta('knownSince');
  GeneratedIntColumn _knownSince;
  @override
  GeneratedIntColumn get knownSince => _knownSince ??= _constructKnownSince();
  GeneratedIntColumn _constructKnownSince() {
    return GeneratedIntColumn(
      'known_since',
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

  final VerificationMeta _publicKeyMeta = const VerificationMeta('publicKey');
  GeneratedBlobColumn _publicKey;
  @override
  GeneratedBlobColumn get publicKey => _publicKey ??= _constructPublicKey();
  GeneratedBlobColumn _constructPublicKey() {
    return GeneratedBlobColumn(
      'public_key',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, ip, port, retries, knownSince, kademliaId, publicKey];
  @override
  $DBPeersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'd_b_peers';
  @override
  final String actualTableName = 'd_b_peers';
  @override
  VerificationContext validateIntegrity(DBPeersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.ip.present) {
      context.handle(_ipMeta, ip.isAcceptableValue(d.ip.value, _ipMeta));
    } else if (isInserting) {
      context.missing(_ipMeta);
    }
    if (d.port.present) {
      context.handle(
          _portMeta, port.isAcceptableValue(d.port.value, _portMeta));
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (d.retries.present) {
      context.handle(_retriesMeta,
          retries.isAcceptableValue(d.retries.value, _retriesMeta));
    }
    if (d.knownSince.present) {
      context.handle(_knownSinceMeta,
          knownSince.isAcceptableValue(d.knownSince.value, _knownSinceMeta));
    } else if (isInserting) {
      context.missing(_knownSinceMeta);
    }
    if (d.kademliaId.present) {
      context.handle(_kademliaIdMeta,
          kademliaId.isAcceptableValue(d.kademliaId.value, _kademliaIdMeta));
    } else if (isInserting) {
      context.missing(_kademliaIdMeta);
    }
    if (d.publicKey.present) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableValue(d.publicKey.value, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DBPeer map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DBPeer.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DBPeersCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.ip.present) {
      map['ip'] = Variable<String, StringType>(d.ip.value);
    }
    if (d.port.present) {
      map['port'] = Variable<int, IntType>(d.port.value);
    }
    if (d.retries.present) {
      map['retries'] = Variable<int, IntType>(d.retries.value);
    }
    if (d.knownSince.present) {
      map['known_since'] = Variable<int, IntType>(d.knownSince.value);
    }
    if (d.kademliaId.present) {
      map['kademlia_id'] = Variable<Uint8List, BlobType>(d.kademliaId.value);
    }
    if (d.publicKey.present) {
      map['public_key'] = Variable<Uint8List, BlobType>(d.publicKey.value);
    }
    return map;
  }

  @override
  $DBPeersTable createAlias(String alias) {
    return $DBPeersTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LocalSettingsTable _localSettings;
  $LocalSettingsTable get localSettings =>
      _localSettings ??= $LocalSettingsTable(this);
  $DBChannelsTable _dBChannels;
  $DBChannelsTable get dBChannels => _dBChannels ??= $DBChannelsTable(this);
  $DBPeersTable _dBPeers;
  $DBPeersTable get dBPeers => _dBPeers ??= $DBPeersTable(this);
  DBPeersDao _dBPeersDao;
  DBPeersDao get dBPeersDao => _dBPeersDao ??= DBPeersDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [localSettings, dBChannels, dBPeers];
}
