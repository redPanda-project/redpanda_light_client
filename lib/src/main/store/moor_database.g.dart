// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final int id;
  final int myUserId;
  final String fcmToken;
  final Uint8List privateKey;
  final Uint8List kademliaId;
  final String defaultName;
  final int versionTimestamp;
  LocalSetting(
      {@required this.id,
      @required this.myUserId,
      this.fcmToken,
      @required this.privateKey,
      @required this.kademliaId,
      this.defaultName,
      this.versionTimestamp});
  factory LocalSetting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return LocalSetting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      myUserId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}my_user_id']),
      fcmToken: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fcm_token']),
      privateKey: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}private_key']),
      kademliaId: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
      defaultName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}default_name']),
      versionTimestamp: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}version_timestamp']),
    );
  }
  factory LocalSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LocalSetting(
      id: serializer.fromJson<int>(json['id']),
      myUserId: serializer.fromJson<int>(json['myUserId']),
      fcmToken: serializer.fromJson<String>(json['fcmToken']),
      privateKey: serializer.fromJson<Uint8List>(json['privateKey']),
      kademliaId: serializer.fromJson<Uint8List>(json['kademliaId']),
      defaultName: serializer.fromJson<String>(json['defaultName']),
      versionTimestamp: serializer.fromJson<int>(json['versionTimestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'myUserId': serializer.toJson<int>(myUserId),
      'fcmToken': serializer.toJson<String>(fcmToken),
      'privateKey': serializer.toJson<Uint8List>(privateKey),
      'kademliaId': serializer.toJson<Uint8List>(kademliaId),
      'defaultName': serializer.toJson<String>(defaultName),
      'versionTimestamp': serializer.toJson<int>(versionTimestamp),
    };
  }

  @override
  LocalSettingsCompanion createCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      myUserId: myUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(myUserId),
      fcmToken: fcmToken == null && nullToAbsent
          ? const Value.absent()
          : Value(fcmToken),
      privateKey: privateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(privateKey),
      kademliaId: kademliaId == null && nullToAbsent
          ? const Value.absent()
          : Value(kademliaId),
      defaultName: defaultName == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultName),
      versionTimestamp: versionTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(versionTimestamp),
    );
  }

  LocalSetting copyWith(
          {int id,
          int myUserId,
          String fcmToken,
          Uint8List privateKey,
          Uint8List kademliaId,
          String defaultName,
          int versionTimestamp}) =>
      LocalSetting(
        id: id ?? this.id,
        myUserId: myUserId ?? this.myUserId,
        fcmToken: fcmToken ?? this.fcmToken,
        privateKey: privateKey ?? this.privateKey,
        kademliaId: kademliaId ?? this.kademliaId,
        defaultName: defaultName ?? this.defaultName,
        versionTimestamp: versionTimestamp ?? this.versionTimestamp,
      );
  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('id: $id, ')
          ..write('myUserId: $myUserId, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('privateKey: $privateKey, ')
          ..write('kademliaId: $kademliaId, ')
          ..write('defaultName: $defaultName, ')
          ..write('versionTimestamp: $versionTimestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          myUserId.hashCode,
          $mrjc(
              fcmToken.hashCode,
              $mrjc(
                  privateKey.hashCode,
                  $mrjc(
                      kademliaId.hashCode,
                      $mrjc(defaultName.hashCode,
                          versionTimestamp.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.id == this.id &&
          other.myUserId == this.myUserId &&
          other.fcmToken == this.fcmToken &&
          other.privateKey == this.privateKey &&
          other.kademliaId == this.kademliaId &&
          other.defaultName == this.defaultName &&
          other.versionTimestamp == this.versionTimestamp);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<int> id;
  final Value<int> myUserId;
  final Value<String> fcmToken;
  final Value<Uint8List> privateKey;
  final Value<Uint8List> kademliaId;
  final Value<String> defaultName;
  final Value<int> versionTimestamp;
  const LocalSettingsCompanion({
    this.id = const Value.absent(),
    this.myUserId = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.kademliaId = const Value.absent(),
    this.defaultName = const Value.absent(),
    this.versionTimestamp = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    this.id = const Value.absent(),
    @required int myUserId,
    this.fcmToken = const Value.absent(),
    @required Uint8List privateKey,
    @required Uint8List kademliaId,
    this.defaultName = const Value.absent(),
    this.versionTimestamp = const Value.absent(),
  })  : myUserId = Value(myUserId),
        privateKey = Value(privateKey),
        kademliaId = Value(kademliaId);
  LocalSettingsCompanion copyWith(
      {Value<int> id,
      Value<int> myUserId,
      Value<String> fcmToken,
      Value<Uint8List> privateKey,
      Value<Uint8List> kademliaId,
      Value<String> defaultName,
      Value<int> versionTimestamp}) {
    return LocalSettingsCompanion(
      id: id ?? this.id,
      myUserId: myUserId ?? this.myUserId,
      fcmToken: fcmToken ?? this.fcmToken,
      privateKey: privateKey ?? this.privateKey,
      kademliaId: kademliaId ?? this.kademliaId,
      defaultName: defaultName ?? this.defaultName,
      versionTimestamp: versionTimestamp ?? this.versionTimestamp,
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
  GeneratedIntColumn _myUserId;
  @override
  GeneratedIntColumn get myUserId => _myUserId ??= _constructMyUserId();
  GeneratedIntColumn _constructMyUserId() {
    return GeneratedIntColumn(
      'my_user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _fcmTokenMeta = const VerificationMeta('fcmToken');
  GeneratedTextColumn _fcmToken;
  @override
  GeneratedTextColumn get fcmToken => _fcmToken ??= _constructFcmToken();
  GeneratedTextColumn _constructFcmToken() {
    return GeneratedTextColumn(
      'fcm_token',
      $tableName,
      true,
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
      true,
    );
  }

  final VerificationMeta _versionTimestampMeta =
      const VerificationMeta('versionTimestamp');
  GeneratedIntColumn _versionTimestamp;
  @override
  GeneratedIntColumn get versionTimestamp =>
      _versionTimestamp ??= _constructVersionTimestamp();
  GeneratedIntColumn _constructVersionTimestamp() {
    return GeneratedIntColumn(
      'version_timestamp',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        myUserId,
        fcmToken,
        privateKey,
        kademliaId,
        defaultName,
        versionTimestamp
      ];
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
    if (d.fcmToken.present) {
      context.handle(_fcmTokenMeta,
          fcmToken.isAcceptableValue(d.fcmToken.value, _fcmTokenMeta));
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
    }
    if (d.versionTimestamp.present) {
      context.handle(
          _versionTimestampMeta,
          versionTimestamp.isAcceptableValue(
              d.versionTimestamp.value, _versionTimestampMeta));
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
      map['my_user_id'] = Variable<int, IntType>(d.myUserId.value);
    }
    if (d.fcmToken.present) {
      map['fcm_token'] = Variable<String, StringType>(d.fcmToken.value);
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
    if (d.versionTimestamp.present) {
      map['version_timestamp'] =
          Variable<int, IntType>(d.versionTimestamp.value);
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
  final int lastMessage_timestamp;
  DBChannel(
      {@required this.id,
      @required this.name,
      @required this.sharedSecret,
      @required this.nodeId,
      this.channelData,
      this.lastMessage_text,
      this.lastMessage_user,
      this.lastMessage_timestamp});
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
      lastMessage_timestamp: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}last_message_timestamp']),
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
      lastMessage_timestamp:
          serializer.fromJson<int>(json['lastMessage_timestamp']),
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
      'lastMessage_timestamp': serializer.toJson<int>(lastMessage_timestamp),
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
      lastMessage_timestamp: lastMessage_timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage_timestamp),
    );
  }

  DBChannel copyWith(
          {int id,
          String name,
          Uint8List sharedSecret,
          Uint8List nodeId,
          String channelData,
          String lastMessage_text,
          String lastMessage_user,
          int lastMessage_timestamp}) =>
      DBChannel(
        id: id ?? this.id,
        name: name ?? this.name,
        sharedSecret: sharedSecret ?? this.sharedSecret,
        nodeId: nodeId ?? this.nodeId,
        channelData: channelData ?? this.channelData,
        lastMessage_text: lastMessage_text ?? this.lastMessage_text,
        lastMessage_user: lastMessage_user ?? this.lastMessage_user,
        lastMessage_timestamp:
            lastMessage_timestamp ?? this.lastMessage_timestamp,
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
          ..write('lastMessage_user: $lastMessage_user, ')
          ..write('lastMessage_timestamp: $lastMessage_timestamp')
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
                      $mrjc(
                          lastMessage_text.hashCode,
                          $mrjc(lastMessage_user.hashCode,
                              lastMessage_timestamp.hashCode))))))));
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
          other.lastMessage_user == this.lastMessage_user &&
          other.lastMessage_timestamp == this.lastMessage_timestamp);
}

class DBChannelsCompanion extends UpdateCompanion<DBChannel> {
  final Value<int> id;
  final Value<String> name;
  final Value<Uint8List> sharedSecret;
  final Value<Uint8List> nodeId;
  final Value<String> channelData;
  final Value<String> lastMessage_text;
  final Value<String> lastMessage_user;
  final Value<int> lastMessage_timestamp;
  const DBChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sharedSecret = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.channelData = const Value.absent(),
    this.lastMessage_text = const Value.absent(),
    this.lastMessage_user = const Value.absent(),
    this.lastMessage_timestamp = const Value.absent(),
  });
  DBChannelsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required Uint8List sharedSecret,
    @required Uint8List nodeId,
    this.channelData = const Value.absent(),
    this.lastMessage_text = const Value.absent(),
    this.lastMessage_user = const Value.absent(),
    this.lastMessage_timestamp = const Value.absent(),
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
      Value<String> lastMessage_user,
      Value<int> lastMessage_timestamp}) {
    return DBChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sharedSecret: sharedSecret ?? this.sharedSecret,
      nodeId: nodeId ?? this.nodeId,
      channelData: channelData ?? this.channelData,
      lastMessage_text: lastMessage_text ?? this.lastMessage_text,
      lastMessage_user: lastMessage_user ?? this.lastMessage_user,
      lastMessage_timestamp:
          lastMessage_timestamp ?? this.lastMessage_timestamp,
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

  final VerificationMeta _lastMessage_timestampMeta =
      const VerificationMeta('lastMessage_timestamp');
  GeneratedIntColumn _lastMessage_timestamp;
  @override
  GeneratedIntColumn get lastMessage_timestamp =>
      _lastMessage_timestamp ??= _constructLastMessageTimestamp();
  GeneratedIntColumn _constructLastMessageTimestamp() {
    return GeneratedIntColumn(
      'last_message_timestamp',
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
        lastMessage_user,
        lastMessage_timestamp
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
    if (d.lastMessage_timestamp.present) {
      context.handle(
          _lastMessage_timestampMeta,
          lastMessage_timestamp.isAcceptableValue(
              d.lastMessage_timestamp.value, _lastMessage_timestampMeta));
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
    if (d.lastMessage_timestamp.present) {
      map['last_message_timestamp'] =
          Variable<int, IntType>(d.lastMessage_timestamp.value);
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
  final int score;
  final int knownSince;
  final Uint8List kademliaId;
  final Uint8List publicKey;
  DBPeer(
      {@required this.id,
      this.ip,
      this.port,
      @required this.score,
      this.knownSince,
      this.kademliaId,
      this.publicKey});
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
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score']),
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
      score: serializer.fromJson<int>(json['score']),
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
      'score': serializer.toJson<int>(score),
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
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
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
          int score,
          int knownSince,
          Uint8List kademliaId,
          Uint8List publicKey}) =>
      DBPeer(
        id: id ?? this.id,
        ip: ip ?? this.ip,
        port: port ?? this.port,
        score: score ?? this.score,
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
          ..write('score: $score, ')
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
                  score.hashCode,
                  $mrjc(knownSince.hashCode,
                      $mrjc(kademliaId.hashCode, publicKey.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DBPeer &&
          other.id == this.id &&
          other.ip == this.ip &&
          other.port == this.port &&
          other.score == this.score &&
          other.knownSince == this.knownSince &&
          other.kademliaId == this.kademliaId &&
          other.publicKey == this.publicKey);
}

class DBPeersCompanion extends UpdateCompanion<DBPeer> {
  final Value<int> id;
  final Value<String> ip;
  final Value<int> port;
  final Value<int> score;
  final Value<int> knownSince;
  final Value<Uint8List> kademliaId;
  final Value<Uint8List> publicKey;
  const DBPeersCompanion({
    this.id = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.score = const Value.absent(),
    this.knownSince = const Value.absent(),
    this.kademliaId = const Value.absent(),
    this.publicKey = const Value.absent(),
  });
  DBPeersCompanion.insert({
    this.id = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.score = const Value.absent(),
    this.knownSince = const Value.absent(),
    this.kademliaId = const Value.absent(),
    this.publicKey = const Value.absent(),
  });
  DBPeersCompanion copyWith(
      {Value<int> id,
      Value<String> ip,
      Value<int> port,
      Value<int> score,
      Value<int> knownSince,
      Value<Uint8List> kademliaId,
      Value<Uint8List> publicKey}) {
    return DBPeersCompanion(
      id: id ?? this.id,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      score: score ?? this.score,
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
    return GeneratedTextColumn('ip', $tableName, true,
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
      true,
    );
  }

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedIntColumn _score;
  @override
  GeneratedIntColumn get score => _score ??= _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn('score', $tableName, false,
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
      true,
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
      true,
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
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, ip, port, score, knownSince, kademliaId, publicKey];
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
    }
    if (d.port.present) {
      context.handle(
          _portMeta, port.isAcceptableValue(d.port.value, _portMeta));
    }
    if (d.score.present) {
      context.handle(
          _scoreMeta, score.isAcceptableValue(d.score.value, _scoreMeta));
    }
    if (d.knownSince.present) {
      context.handle(_knownSinceMeta,
          knownSince.isAcceptableValue(d.knownSince.value, _knownSinceMeta));
    }
    if (d.kademliaId.present) {
      context.handle(_kademliaIdMeta,
          kademliaId.isAcceptableValue(d.kademliaId.value, _kademliaIdMeta));
    }
    if (d.publicKey.present) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableValue(d.publicKey.value, _publicKeyMeta));
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
    if (d.score.present) {
      map['score'] = Variable<int, IntType>(d.score.value);
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

class DBMessage extends DataClass implements Insertable<DBMessage> {
  final int messageId;
  final int channelId;
  final int timestamp;
  final int type;
  final String content;
  final int from;
  final String deliveredTo;
  final bool read;
  DBMessage(
      {@required this.messageId,
      @required this.channelId,
      @required this.timestamp,
      @required this.type,
      this.content,
      @required this.from,
      this.deliveredTo,
      @required this.read});
  factory DBMessage.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return DBMessage(
      messageId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}message_id']),
      channelId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}channel_id']),
      timestamp:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
      type: intType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      from: intType.mapFromDatabaseResponse(data['${effectivePrefix}from']),
      deliveredTo: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}delivered_to']),
      read: boolType.mapFromDatabaseResponse(data['${effectivePrefix}read']),
    );
  }
  factory DBMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DBMessage(
      messageId: serializer.fromJson<int>(json['messageId']),
      channelId: serializer.fromJson<int>(json['channelId']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      type: serializer.fromJson<int>(json['type']),
      content: serializer.fromJson<String>(json['content']),
      from: serializer.fromJson<int>(json['from']),
      deliveredTo: serializer.fromJson<String>(json['deliveredTo']),
      read: serializer.fromJson<bool>(json['read']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<int>(messageId),
      'channelId': serializer.toJson<int>(channelId),
      'timestamp': serializer.toJson<int>(timestamp),
      'type': serializer.toJson<int>(type),
      'content': serializer.toJson<String>(content),
      'from': serializer.toJson<int>(from),
      'deliveredTo': serializer.toJson<String>(deliveredTo),
      'read': serializer.toJson<bool>(read),
    };
  }

  @override
  DBMessagesCompanion createCompanion(bool nullToAbsent) {
    return DBMessagesCompanion(
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      from: from == null && nullToAbsent ? const Value.absent() : Value(from),
      deliveredTo: deliveredTo == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredTo),
      read: read == null && nullToAbsent ? const Value.absent() : Value(read),
    );
  }

  DBMessage copyWith(
          {int messageId,
          int channelId,
          int timestamp,
          int type,
          String content,
          int from,
          String deliveredTo,
          bool read}) =>
      DBMessage(
        messageId: messageId ?? this.messageId,
        channelId: channelId ?? this.channelId,
        timestamp: timestamp ?? this.timestamp,
        type: type ?? this.type,
        content: content ?? this.content,
        from: from ?? this.from,
        deliveredTo: deliveredTo ?? this.deliveredTo,
        read: read ?? this.read,
      );
  @override
  String toString() {
    return (StringBuffer('DBMessage(')
          ..write('messageId: $messageId, ')
          ..write('channelId: $channelId, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('from: $from, ')
          ..write('deliveredTo: $deliveredTo, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      messageId.hashCode,
      $mrjc(
          channelId.hashCode,
          $mrjc(
              timestamp.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      content.hashCode,
                      $mrjc(from.hashCode,
                          $mrjc(deliveredTo.hashCode, read.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DBMessage &&
          other.messageId == this.messageId &&
          other.channelId == this.channelId &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.content == this.content &&
          other.from == this.from &&
          other.deliveredTo == this.deliveredTo &&
          other.read == this.read);
}

class DBMessagesCompanion extends UpdateCompanion<DBMessage> {
  final Value<int> messageId;
  final Value<int> channelId;
  final Value<int> timestamp;
  final Value<int> type;
  final Value<String> content;
  final Value<int> from;
  final Value<String> deliveredTo;
  final Value<bool> read;
  const DBMessagesCompanion({
    this.messageId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.content = const Value.absent(),
    this.from = const Value.absent(),
    this.deliveredTo = const Value.absent(),
    this.read = const Value.absent(),
  });
  DBMessagesCompanion.insert({
    @required int messageId,
    @required int channelId,
    @required int timestamp,
    @required int type,
    this.content = const Value.absent(),
    @required int from,
    this.deliveredTo = const Value.absent(),
    this.read = const Value.absent(),
  })  : messageId = Value(messageId),
        channelId = Value(channelId),
        timestamp = Value(timestamp),
        type = Value(type),
        from = Value(from);
  DBMessagesCompanion copyWith(
      {Value<int> messageId,
      Value<int> channelId,
      Value<int> timestamp,
      Value<int> type,
      Value<String> content,
      Value<int> from,
      Value<String> deliveredTo,
      Value<bool> read}) {
    return DBMessagesCompanion(
      messageId: messageId ?? this.messageId,
      channelId: channelId ?? this.channelId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      content: content ?? this.content,
      from: from ?? this.from,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      read: read ?? this.read,
    );
  }
}

class $DBMessagesTable extends DBMessages
    with TableInfo<$DBMessagesTable, DBMessage> {
  final GeneratedDatabase _db;
  final String _alias;
  $DBMessagesTable(this._db, [this._alias]);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  GeneratedIntColumn _messageId;
  @override
  GeneratedIntColumn get messageId => _messageId ??= _constructMessageId();
  GeneratedIntColumn _constructMessageId() {
    return GeneratedIntColumn(
      'message_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelIdMeta = const VerificationMeta('channelId');
  GeneratedIntColumn _channelId;
  @override
  GeneratedIntColumn get channelId => _channelId ??= _constructChannelId();
  GeneratedIntColumn _constructChannelId() {
    return GeneratedIntColumn(
      'channel_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedIntColumn _timestamp;
  @override
  GeneratedIntColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedIntColumn _constructTimestamp() {
    return GeneratedIntColumn(
      'timestamp',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedIntColumn _type;
  @override
  GeneratedIntColumn get type => _type ??= _constructType();
  GeneratedIntColumn _constructType() {
    return GeneratedIntColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn('content', $tableName, true,
        minTextLength: 1, maxTextLength: 1024);
  }

  final VerificationMeta _fromMeta = const VerificationMeta('from');
  GeneratedIntColumn _from;
  @override
  GeneratedIntColumn get from => _from ??= _constructFrom();
  GeneratedIntColumn _constructFrom() {
    return GeneratedIntColumn(
      'from',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deliveredToMeta =
      const VerificationMeta('deliveredTo');
  GeneratedTextColumn _deliveredTo;
  @override
  GeneratedTextColumn get deliveredTo =>
      _deliveredTo ??= _constructDeliveredTo();
  GeneratedTextColumn _constructDeliveredTo() {
    return GeneratedTextColumn(
      'delivered_to',
      $tableName,
      true,
    );
  }

  final VerificationMeta _readMeta = const VerificationMeta('read');
  GeneratedBoolColumn _read;
  @override
  GeneratedBoolColumn get read => _read ??= _constructRead();
  GeneratedBoolColumn _constructRead() {
    return GeneratedBoolColumn('read', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [messageId, channelId, timestamp, type, content, from, deliveredTo, read];
  @override
  $DBMessagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'd_b_messages';
  @override
  final String actualTableName = 'd_b_messages';
  @override
  VerificationContext validateIntegrity(DBMessagesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.messageId.present) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableValue(d.messageId.value, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (d.channelId.present) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableValue(d.channelId.value, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (d.timestamp.present) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableValue(d.timestamp.value, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (d.content.present) {
      context.handle(_contentMeta,
          content.isAcceptableValue(d.content.value, _contentMeta));
    }
    if (d.from.present) {
      context.handle(
          _fromMeta, from.isAcceptableValue(d.from.value, _fromMeta));
    } else if (isInserting) {
      context.missing(_fromMeta);
    }
    if (d.deliveredTo.present) {
      context.handle(_deliveredToMeta,
          deliveredTo.isAcceptableValue(d.deliveredTo.value, _deliveredToMeta));
    }
    if (d.read.present) {
      context.handle(
          _readMeta, read.isAcceptableValue(d.read.value, _readMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  DBMessage map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DBMessage.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DBMessagesCompanion d) {
    final map = <String, Variable>{};
    if (d.messageId.present) {
      map['message_id'] = Variable<int, IntType>(d.messageId.value);
    }
    if (d.channelId.present) {
      map['channel_id'] = Variable<int, IntType>(d.channelId.value);
    }
    if (d.timestamp.present) {
      map['timestamp'] = Variable<int, IntType>(d.timestamp.value);
    }
    if (d.type.present) {
      map['type'] = Variable<int, IntType>(d.type.value);
    }
    if (d.content.present) {
      map['content'] = Variable<String, StringType>(d.content.value);
    }
    if (d.from.present) {
      map['from'] = Variable<int, IntType>(d.from.value);
    }
    if (d.deliveredTo.present) {
      map['delivered_to'] = Variable<String, StringType>(d.deliveredTo.value);
    }
    if (d.read.present) {
      map['read'] = Variable<bool, BoolType>(d.read.value);
    }
    return map;
  }

  @override
  $DBMessagesTable createAlias(String alias) {
    return $DBMessagesTable(_db, alias);
  }
}

class DBFriend extends DataClass implements Insertable<DBFriend> {
  final int id;
  final String name;
  final Uint8List image;
  final String phoneNumber;
  final String eMail;
  DBFriend(
      {@required this.id, this.name, this.image, this.phoneNumber, this.eMail});
  factory DBFriend.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final uint8ListType = db.typeSystem.forDartType<Uint8List>();
    return DBFriend(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image: uint8ListType
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
      phoneNumber: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}phone_number']),
      eMail:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}e_mail']),
    );
  }
  factory DBFriend.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return DBFriend(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<Uint8List>(json['image']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      eMail: serializer.fromJson<String>(json['eMail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<Uint8List>(image),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'eMail': serializer.toJson<String>(eMail),
    };
  }

  @override
  DBFriendsCompanion createCompanion(bool nullToAbsent) {
    return DBFriendsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      eMail:
          eMail == null && nullToAbsent ? const Value.absent() : Value(eMail),
    );
  }

  DBFriend copyWith(
          {int id,
          String name,
          Uint8List image,
          String phoneNumber,
          String eMail}) =>
      DBFriend(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        eMail: eMail ?? this.eMail,
      );
  @override
  String toString() {
    return (StringBuffer('DBFriend(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('eMail: $eMail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(image.hashCode, $mrjc(phoneNumber.hashCode, eMail.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is DBFriend &&
          other.id == this.id &&
          other.name == this.name &&
          other.image == this.image &&
          other.phoneNumber == this.phoneNumber &&
          other.eMail == this.eMail);
}

class DBFriendsCompanion extends UpdateCompanion<DBFriend> {
  final Value<int> id;
  final Value<String> name;
  final Value<Uint8List> image;
  final Value<String> phoneNumber;
  final Value<String> eMail;
  const DBFriendsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.eMail = const Value.absent(),
  });
  DBFriendsCompanion.insert({
    @required int id,
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.eMail = const Value.absent(),
  }) : id = Value(id);
  DBFriendsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<Uint8List> image,
      Value<String> phoneNumber,
      Value<String> eMail}) {
    return DBFriendsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      eMail: eMail ?? this.eMail,
    );
  }
}

class $DBFriendsTable extends DBFriends
    with TableInfo<$DBFriendsTable, DBFriend> {
  final GeneratedDatabase _db;
  final String _alias;
  $DBFriendsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, true,
        minTextLength: 1, maxTextLength: 32);
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedBlobColumn _image;
  @override
  GeneratedBlobColumn get image => _image ??= _constructImage();
  GeneratedBlobColumn _constructImage() {
    return GeneratedBlobColumn(
      'image',
      $tableName,
      true,
    );
  }

  final VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  GeneratedTextColumn _phoneNumber;
  @override
  GeneratedTextColumn get phoneNumber =>
      _phoneNumber ??= _constructPhoneNumber();
  GeneratedTextColumn _constructPhoneNumber() {
    return GeneratedTextColumn('phone_number', $tableName, true,
        minTextLength: 6, maxTextLength: 16);
  }

  final VerificationMeta _eMailMeta = const VerificationMeta('eMail');
  GeneratedTextColumn _eMail;
  @override
  GeneratedTextColumn get eMail => _eMail ??= _constructEMail();
  GeneratedTextColumn _constructEMail() {
    return GeneratedTextColumn('e_mail', $tableName, true,
        minTextLength: 6, maxTextLength: 16);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, image, phoneNumber, eMail];
  @override
  $DBFriendsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'd_b_friends';
  @override
  final String actualTableName = 'd_b_friends';
  @override
  VerificationContext validateIntegrity(DBFriendsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    }
    if (d.image.present) {
      context.handle(
          _imageMeta, image.isAcceptableValue(d.image.value, _imageMeta));
    }
    if (d.phoneNumber.present) {
      context.handle(_phoneNumberMeta,
          phoneNumber.isAcceptableValue(d.phoneNumber.value, _phoneNumberMeta));
    }
    if (d.eMail.present) {
      context.handle(
          _eMailMeta, eMail.isAcceptableValue(d.eMail.value, _eMailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  DBFriend map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return DBFriend.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DBFriendsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.image.present) {
      map['image'] = Variable<Uint8List, BlobType>(d.image.value);
    }
    if (d.phoneNumber.present) {
      map['phone_number'] = Variable<String, StringType>(d.phoneNumber.value);
    }
    if (d.eMail.present) {
      map['e_mail'] = Variable<String, StringType>(d.eMail.value);
    }
    return map;
  }

  @override
  $DBFriendsTable createAlias(String alias) {
    return $DBFriendsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $LocalSettingsTable _localSettings;
  $LocalSettingsTable get localSettings =>
      _localSettings ??= $LocalSettingsTable(this);
  $DBChannelsTable _dBChannels;
  $DBChannelsTable get dBChannels => _dBChannels ??= $DBChannelsTable(this);
  $DBPeersTable _dBPeers;
  $DBPeersTable get dBPeers => _dBPeers ??= $DBPeersTable(this);
  $DBMessagesTable _dBMessages;
  $DBMessagesTable get dBMessages => _dBMessages ??= $DBMessagesTable(this);
  $DBFriendsTable _dBFriends;
  $DBFriendsTable get dBFriends => _dBFriends ??= $DBFriendsTable(this);
  DBPeersDao _dBPeersDao;
  DBPeersDao get dBPeersDao => _dBPeersDao ??= DBPeersDao(this as AppDatabase);
  DBMessagesDao _dBMessagesDao;
  DBMessagesDao get dBMessagesDao =>
      _dBMessagesDao ??= DBMessagesDao(this as AppDatabase);
  DBFriendsDao _dBFriendsDao;
  DBFriendsDao get dBFriendsDao =>
      _dBFriendsDao ??= DBFriendsDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [localSettings, dBChannels, dBPeers, dBMessages, dBFriends];
}
