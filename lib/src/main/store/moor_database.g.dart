// @dart=2.9
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
    return LocalSetting(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      myUserId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}my_user_id']),
      fcmToken: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fcm_token']),
      privateKey: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}private_key']),
      kademliaId: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
      defaultName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}default_name']),
      versionTimestamp: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}version_timestamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || myUserId != null) {
      map['my_user_id'] = Variable<int>(myUserId);
    }
    if (!nullToAbsent || fcmToken != null) {
      map['fcm_token'] = Variable<String>(fcmToken);
    }
    if (!nullToAbsent || privateKey != null) {
      map['private_key'] = Variable<Uint8List>(privateKey);
    }
    if (!nullToAbsent || kademliaId != null) {
      map['kademlia_id'] = Variable<Uint8List>(kademliaId);
    }
    if (!nullToAbsent || defaultName != null) {
      map['default_name'] = Variable<String>(defaultName);
    }
    if (!nullToAbsent || versionTimestamp != null) {
      map['version_timestamp'] = Variable<int>(versionTimestamp);
    }
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
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
  int get hashCode => Object.hash(id, myUserId, fcmToken, privateKey,
      kademliaId, defaultName, versionTimestamp);
  @override
  bool operator ==(Object other) =>
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
  static Insertable<LocalSetting> custom({
    Expression<int> id,
    Expression<int> myUserId,
    Expression<String> fcmToken,
    Expression<Uint8List> privateKey,
    Expression<Uint8List> kademliaId,
    Expression<String> defaultName,
    Expression<int> versionTimestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (myUserId != null) 'my_user_id': myUserId,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (privateKey != null) 'private_key': privateKey,
      if (kademliaId != null) 'kademlia_id': kademliaId,
      if (defaultName != null) 'default_name': defaultName,
      if (versionTimestamp != null) 'version_timestamp': versionTimestamp,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (myUserId.present) {
      map['my_user_id'] = Variable<int>(myUserId.value);
    }
    if (fcmToken.present) {
      map['fcm_token'] = Variable<String>(fcmToken.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<Uint8List>(privateKey.value);
    }
    if (kademliaId.present) {
      map['kademlia_id'] = Variable<Uint8List>(kademliaId.value);
    }
    if (defaultName.present) {
      map['default_name'] = Variable<String>(defaultName.value);
    }
    if (versionTimestamp.present) {
      map['version_timestamp'] = Variable<int>(versionTimestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
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
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _myUserIdMeta = const VerificationMeta('myUserId');
  GeneratedColumn<int> _myUserId;
  @override
  GeneratedColumn<int> get myUserId =>
      _myUserId ??= GeneratedColumn<int>('my_user_id', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _fcmTokenMeta = const VerificationMeta('fcmToken');
  GeneratedColumn<String> _fcmToken;
  @override
  GeneratedColumn<String> get fcmToken =>
      _fcmToken ??= GeneratedColumn<String>('fcm_token', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _privateKeyMeta = const VerificationMeta('privateKey');
  GeneratedColumn<Uint8List> _privateKey;
  @override
  GeneratedColumn<Uint8List> get privateKey => _privateKey ??=
      GeneratedColumn<Uint8List>('private_key', aliasedName, false,
          type: const BlobType(), requiredDuringInsert: true);
  final VerificationMeta _kademliaIdMeta = const VerificationMeta('kademliaId');
  GeneratedColumn<Uint8List> _kademliaId;
  @override
  GeneratedColumn<Uint8List> get kademliaId => _kademliaId ??=
      GeneratedColumn<Uint8List>('kademlia_id', aliasedName, false,
          type: const BlobType(), requiredDuringInsert: true);
  final VerificationMeta _defaultNameMeta =
      const VerificationMeta('defaultName');
  GeneratedColumn<String> _defaultName;
  @override
  GeneratedColumn<String> get defaultName => _defaultName ??=
      GeneratedColumn<String>('default_name', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _versionTimestampMeta =
      const VerificationMeta('versionTimestamp');
  GeneratedColumn<int> _versionTimestamp;
  @override
  GeneratedColumn<int> get versionTimestamp => _versionTimestamp ??=
      GeneratedColumn<int>('version_timestamp', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
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
  String get aliasedName => _alias ?? 'local_settings';
  @override
  String get actualTableName => 'local_settings';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('my_user_id')) {
      context.handle(_myUserIdMeta,
          myUserId.isAcceptableOrUnknown(data['my_user_id'], _myUserIdMeta));
    } else if (isInserting) {
      context.missing(_myUserIdMeta);
    }
    if (data.containsKey('fcm_token')) {
      context.handle(_fcmTokenMeta,
          fcmToken.isAcceptableOrUnknown(data['fcm_token'], _fcmTokenMeta));
    }
    if (data.containsKey('private_key')) {
      context.handle(
          _privateKeyMeta,
          privateKey.isAcceptableOrUnknown(
              data['private_key'], _privateKeyMeta));
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (data.containsKey('kademlia_id')) {
      context.handle(
          _kademliaIdMeta,
          kademliaId.isAcceptableOrUnknown(
              data['kademlia_id'], _kademliaIdMeta));
    } else if (isInserting) {
      context.missing(_kademliaIdMeta);
    }
    if (data.containsKey('default_name')) {
      context.handle(
          _defaultNameMeta,
          defaultName.isAcceptableOrUnknown(
              data['default_name'], _defaultNameMeta));
    }
    if (data.containsKey('version_timestamp')) {
      context.handle(
          _versionTimestampMeta,
          versionTimestamp.isAcceptableOrUnknown(
              data['version_timestamp'], _versionTimestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSetting map(Map<String, dynamic> data, {String tablePrefix}) {
    return LocalSetting.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
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
    return DBChannel(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      sharedSecret: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shared_secret']),
      nodeId: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      channelData: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_data']),
      lastMessage_text: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_text']),
      lastMessage_user: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_user']),
      lastMessage_timestamp: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}last_message_timestamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || sharedSecret != null) {
      map['shared_secret'] = Variable<Uint8List>(sharedSecret);
    }
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<Uint8List>(nodeId);
    }
    if (!nullToAbsent || channelData != null) {
      map['channel_data'] = Variable<String>(channelData);
    }
    if (!nullToAbsent || lastMessage_text != null) {
      map['last_message_text'] = Variable<String>(lastMessage_text);
    }
    if (!nullToAbsent || lastMessage_user != null) {
      map['last_message_user'] = Variable<String>(lastMessage_user);
    }
    if (!nullToAbsent || lastMessage_timestamp != null) {
      map['last_message_timestamp'] = Variable<int>(lastMessage_timestamp);
    }
    return map;
  }

  DBChannelsCompanion toCompanion(bool nullToAbsent) {
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
  int get hashCode => Object.hash(id, name, sharedSecret, nodeId, channelData,
      lastMessage_text, lastMessage_user, lastMessage_timestamp);
  @override
  bool operator ==(Object other) =>
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
  static Insertable<DBChannel> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<Uint8List> sharedSecret,
    Expression<Uint8List> nodeId,
    Expression<String> channelData,
    Expression<String> lastMessage_text,
    Expression<String> lastMessage_user,
    Expression<int> lastMessage_timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sharedSecret != null) 'shared_secret': sharedSecret,
      if (nodeId != null) 'node_id': nodeId,
      if (channelData != null) 'channel_data': channelData,
      if (lastMessage_text != null) 'last_message_text': lastMessage_text,
      if (lastMessage_user != null) 'last_message_user': lastMessage_user,
      if (lastMessage_timestamp != null)
        'last_message_timestamp': lastMessage_timestamp,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sharedSecret.present) {
      map['shared_secret'] = Variable<Uint8List>(sharedSecret.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<Uint8List>(nodeId.value);
    }
    if (channelData.present) {
      map['channel_data'] = Variable<String>(channelData.value);
    }
    if (lastMessage_text.present) {
      map['last_message_text'] = Variable<String>(lastMessage_text.value);
    }
    if (lastMessage_user.present) {
      map['last_message_user'] = Variable<String>(lastMessage_user.value);
    }
    if (lastMessage_timestamp.present) {
      map['last_message_timestamp'] =
          Variable<int>(lastMessage_timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DBChannelsCompanion(')
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
}

class $DBChannelsTable extends DBChannels
    with TableInfo<$DBChannelsTable, DBChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $DBChannelsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name => _name ??= GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _sharedSecretMeta =
      const VerificationMeta('sharedSecret');
  GeneratedColumn<Uint8List> _sharedSecret;
  @override
  GeneratedColumn<Uint8List> get sharedSecret => _sharedSecret ??=
      GeneratedColumn<Uint8List>('shared_secret', aliasedName, false,
          type: const BlobType(), requiredDuringInsert: true);
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  GeneratedColumn<Uint8List> _nodeId;
  @override
  GeneratedColumn<Uint8List> get nodeId =>
      _nodeId ??= GeneratedColumn<Uint8List>('node_id', aliasedName, false,
          type: const BlobType(), requiredDuringInsert: true);
  final VerificationMeta _channelDataMeta =
      const VerificationMeta('channelData');
  GeneratedColumn<String> _channelData;
  @override
  GeneratedColumn<String> get channelData => _channelData ??=
      GeneratedColumn<String>('channel_data', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _lastMessage_textMeta =
      const VerificationMeta('lastMessage_text');
  GeneratedColumn<String> _lastMessage_text;
  @override
  GeneratedColumn<String> get lastMessage_text => _lastMessage_text ??=
      GeneratedColumn<String>('last_message_text', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(),
          type: const StringType(),
          requiredDuringInsert: false);
  final VerificationMeta _lastMessage_userMeta =
      const VerificationMeta('lastMessage_user');
  GeneratedColumn<String> _lastMessage_user;
  @override
  GeneratedColumn<String> get lastMessage_user => _lastMessage_user ??=
      GeneratedColumn<String>('last_message_user', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(),
          type: const StringType(),
          requiredDuringInsert: false);
  final VerificationMeta _lastMessage_timestampMeta =
      const VerificationMeta('lastMessage_timestamp');
  GeneratedColumn<int> _lastMessage_timestamp;
  @override
  GeneratedColumn<int> get lastMessage_timestamp => _lastMessage_timestamp ??=
      GeneratedColumn<int>('last_message_timestamp', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
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
  String get aliasedName => _alias ?? 'd_b_channels';
  @override
  String get actualTableName => 'd_b_channels';
  @override
  VerificationContext validateIntegrity(Insertable<DBChannel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('shared_secret')) {
      context.handle(
          _sharedSecretMeta,
          sharedSecret.isAcceptableOrUnknown(
              data['shared_secret'], _sharedSecretMeta));
    } else if (isInserting) {
      context.missing(_sharedSecretMeta);
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id'], _nodeIdMeta));
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('channel_data')) {
      context.handle(
          _channelDataMeta,
          channelData.isAcceptableOrUnknown(
              data['channel_data'], _channelDataMeta));
    }
    if (data.containsKey('last_message_text')) {
      context.handle(
          _lastMessage_textMeta,
          lastMessage_text.isAcceptableOrUnknown(
              data['last_message_text'], _lastMessage_textMeta));
    }
    if (data.containsKey('last_message_user')) {
      context.handle(
          _lastMessage_userMeta,
          lastMessage_user.isAcceptableOrUnknown(
              data['last_message_user'], _lastMessage_userMeta));
    }
    if (data.containsKey('last_message_timestamp')) {
      context.handle(
          _lastMessage_timestampMeta,
          lastMessage_timestamp.isAcceptableOrUnknown(
              data['last_message_timestamp'], _lastMessage_timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DBChannel map(Map<String, dynamic> data, {String tablePrefix}) {
    return DBChannel.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DBChannelsTable createAlias(String alias) {
    return $DBChannelsTable(attachedDatabase, alias);
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
    return DBPeer(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      ip: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      port: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}port']),
      score: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}score']),
      knownSince: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}known_since']),
      kademliaId: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}kademlia_id']),
      publicKey: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}public_key']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || ip != null) {
      map['ip'] = Variable<String>(ip);
    }
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<int>(port);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || knownSince != null) {
      map['known_since'] = Variable<int>(knownSince);
    }
    if (!nullToAbsent || kademliaId != null) {
      map['kademlia_id'] = Variable<Uint8List>(kademliaId);
    }
    if (!nullToAbsent || publicKey != null) {
      map['public_key'] = Variable<Uint8List>(publicKey);
    }
    return map;
  }

  DBPeersCompanion toCompanion(bool nullToAbsent) {
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
  int get hashCode =>
      Object.hash(id, ip, port, score, knownSince, kademliaId, publicKey);
  @override
  bool operator ==(Object other) =>
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
  static Insertable<DBPeer> custom({
    Expression<int> id,
    Expression<String> ip,
    Expression<int> port,
    Expression<int> score,
    Expression<int> knownSince,
    Expression<Uint8List> kademliaId,
    Expression<Uint8List> publicKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ip != null) 'ip': ip,
      if (port != null) 'port': port,
      if (score != null) 'score': score,
      if (knownSince != null) 'known_since': knownSince,
      if (kademliaId != null) 'kademlia_id': kademliaId,
      if (publicKey != null) 'public_key': publicKey,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (knownSince.present) {
      map['known_since'] = Variable<int>(knownSince.value);
    }
    if (kademliaId.present) {
      map['kademlia_id'] = Variable<Uint8List>(kademliaId.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<Uint8List>(publicKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DBPeersCompanion(')
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
}

class $DBPeersTable extends DBPeers with TableInfo<$DBPeersTable, DBPeer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $DBPeersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  GeneratedColumn<String> _ip;
  @override
  GeneratedColumn<String> get ip => _ip ??= GeneratedColumn<String>(
      'ip', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _portMeta = const VerificationMeta('port');
  GeneratedColumn<int> _port;
  @override
  GeneratedColumn<int> get port =>
      _port ??= GeneratedColumn<int>('port', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedColumn<int> _score;
  @override
  GeneratedColumn<int> get score =>
      _score ??= GeneratedColumn<int>('score', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  final VerificationMeta _knownSinceMeta = const VerificationMeta('knownSince');
  GeneratedColumn<int> _knownSince;
  @override
  GeneratedColumn<int> get knownSince =>
      _knownSince ??= GeneratedColumn<int>('known_since', aliasedName, true,
          type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _kademliaIdMeta = const VerificationMeta('kademliaId');
  GeneratedColumn<Uint8List> _kademliaId;
  @override
  GeneratedColumn<Uint8List> get kademliaId => _kademliaId ??=
      GeneratedColumn<Uint8List>('kademlia_id', aliasedName, true,
          type: const BlobType(), requiredDuringInsert: false);
  final VerificationMeta _publicKeyMeta = const VerificationMeta('publicKey');
  GeneratedColumn<Uint8List> _publicKey;
  @override
  GeneratedColumn<Uint8List> get publicKey =>
      _publicKey ??= GeneratedColumn<Uint8List>('public_key', aliasedName, true,
          type: const BlobType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ip, port, score, knownSince, kademliaId, publicKey];
  @override
  String get aliasedName => _alias ?? 'd_b_peers';
  @override
  String get actualTableName => 'd_b_peers';
  @override
  VerificationContext validateIntegrity(Insertable<DBPeer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip'], _ipMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port'], _portMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score'], _scoreMeta));
    }
    if (data.containsKey('known_since')) {
      context.handle(
          _knownSinceMeta,
          knownSince.isAcceptableOrUnknown(
              data['known_since'], _knownSinceMeta));
    }
    if (data.containsKey('kademlia_id')) {
      context.handle(
          _kademliaIdMeta,
          kademliaId.isAcceptableOrUnknown(
              data['kademlia_id'], _kademliaIdMeta));
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key'], _publicKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DBPeer map(Map<String, dynamic> data, {String tablePrefix}) {
    return DBPeer.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DBPeersTable createAlias(String alias) {
    return $DBPeersTable(attachedDatabase, alias);
  }
}

class DBMessage extends DataClass implements Insertable<DBMessage> {
/**
   * Message id has to be unique for all memebers of the Channel. Thus, we have to generate a random interger for the
   * message id.
   */
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
    return DBMessage(
      messageId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id']),
      channelId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_id']),
      timestamp: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type']),
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content']),
      from: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}from']),
      deliveredTo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}delivered_to']),
      read: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || messageId != null) {
      map['message_id'] = Variable<int>(messageId);
    }
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<int>(channelId);
    }
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<int>(timestamp);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || from != null) {
      map['from'] = Variable<int>(from);
    }
    if (!nullToAbsent || deliveredTo != null) {
      map['delivered_to'] = Variable<String>(deliveredTo);
    }
    if (!nullToAbsent || read != null) {
      map['read'] = Variable<bool>(read);
    }
    return map;
  }

  DBMessagesCompanion toCompanion(bool nullToAbsent) {
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
  int get hashCode => Object.hash(
      messageId, channelId, timestamp, type, content, from, deliveredTo, read);
  @override
  bool operator ==(Object other) =>
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
  static Insertable<DBMessage> custom({
    Expression<int> messageId,
    Expression<int> channelId,
    Expression<int> timestamp,
    Expression<int> type,
    Expression<String> content,
    Expression<int> from,
    Expression<String> deliveredTo,
    Expression<bool> read,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (channelId != null) 'channel_id': channelId,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (from != null) 'from': from,
      if (deliveredTo != null) 'delivered_to': deliveredTo,
      if (read != null) 'read': read,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<int>(channelId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (from.present) {
      map['from'] = Variable<int>(from.value);
    }
    if (deliveredTo.present) {
      map['delivered_to'] = Variable<String>(deliveredTo.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DBMessagesCompanion(')
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
}

class $DBMessagesTable extends DBMessages
    with TableInfo<$DBMessagesTable, DBMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $DBMessagesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  GeneratedColumn<int> _messageId;
  @override
  GeneratedColumn<int> get messageId =>
      _messageId ??= GeneratedColumn<int>('message_id', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _channelIdMeta = const VerificationMeta('channelId');
  GeneratedColumn<int> _channelId;
  @override
  GeneratedColumn<int> get channelId =>
      _channelId ??= GeneratedColumn<int>('channel_id', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedColumn<int> _timestamp;
  @override
  GeneratedColumn<int> get timestamp =>
      _timestamp ??= GeneratedColumn<int>('timestamp', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedColumn<int> _type;
  @override
  GeneratedColumn<int> get type =>
      _type ??= GeneratedColumn<int>('type', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedColumn<String> _content;
  @override
  GeneratedColumn<String> get content =>
      _content ??= GeneratedColumn<String>('content', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 1024),
          type: const StringType(),
          requiredDuringInsert: false);
  final VerificationMeta _fromMeta = const VerificationMeta('from');
  GeneratedColumn<int> _from;
  @override
  GeneratedColumn<int> get from =>
      _from ??= GeneratedColumn<int>('from', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _deliveredToMeta =
      const VerificationMeta('deliveredTo');
  GeneratedColumn<String> _deliveredTo;
  @override
  GeneratedColumn<String> get deliveredTo => _deliveredTo ??=
      GeneratedColumn<String>('delivered_to', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _readMeta = const VerificationMeta('read');
  GeneratedColumn<bool> _read;
  @override
  GeneratedColumn<bool> get read =>
      _read ??= GeneratedColumn<bool>('read', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: false,
          defaultConstraints: 'CHECK (read IN (0, 1))',
          defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [messageId, channelId, timestamp, type, content, from, deliveredTo, read];
  @override
  String get aliasedName => _alias ?? 'd_b_messages';
  @override
  String get actualTableName => 'd_b_messages';
  @override
  VerificationContext validateIntegrity(Insertable<DBMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id'], _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id'], _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp'], _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    }
    if (data.containsKey('from')) {
      context.handle(
          _fromMeta, from.isAcceptableOrUnknown(data['from'], _fromMeta));
    } else if (isInserting) {
      context.missing(_fromMeta);
    }
    if (data.containsKey('delivered_to')) {
      context.handle(
          _deliveredToMeta,
          deliveredTo.isAcceptableOrUnknown(
              data['delivered_to'], _deliveredToMeta));
    }
    if (data.containsKey('read')) {
      context.handle(
          _readMeta, read.isAcceptableOrUnknown(data['read'], _readMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  DBMessage map(Map<String, dynamic> data, {String tablePrefix}) {
    return DBMessage.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DBMessagesTable createAlias(String alias) {
    return $DBMessagesTable(attachedDatabase, alias);
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
    return DBFriend(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
      phoneNumber: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone_number']),
      eMail: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}e_mail']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<Uint8List>(image);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || eMail != null) {
      map['e_mail'] = Variable<String>(eMail);
    }
    return map;
  }

  DBFriendsCompanion toCompanion(bool nullToAbsent) {
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
  int get hashCode => Object.hash(id, name, image, phoneNumber, eMail);
  @override
  bool operator ==(Object other) =>
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
  static Insertable<DBFriend> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<Uint8List> image,
    Expression<String> phoneNumber,
    Expression<String> eMail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (eMail != null) 'e_mail': eMail,
    });
  }

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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List>(image.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (eMail.present) {
      map['e_mail'] = Variable<String>(eMail.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DBFriendsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('eMail: $eMail')
          ..write(')'))
        .toString();
  }
}

class $DBFriendsTable extends DBFriends
    with TableInfo<$DBFriendsTable, DBFriend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String _alias;
  $DBFriendsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name => _name ??= GeneratedColumn<String>(
      'name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedColumn<Uint8List> _image;
  @override
  GeneratedColumn<Uint8List> get image =>
      _image ??= GeneratedColumn<Uint8List>('image', aliasedName, true,
          type: const BlobType(), requiredDuringInsert: false);
  final VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  GeneratedColumn<String> _phoneNumber;
  @override
  GeneratedColumn<String> get phoneNumber => _phoneNumber ??=
      GeneratedColumn<String>('phone_number', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 6, maxTextLength: 16),
          type: const StringType(),
          requiredDuringInsert: false);
  final VerificationMeta _eMailMeta = const VerificationMeta('eMail');
  GeneratedColumn<String> _eMail;
  @override
  GeneratedColumn<String> get eMail => _eMail ??= GeneratedColumn<String>(
      'e_mail', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 16),
      type: const StringType(),
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, image, phoneNumber, eMail];
  @override
  String get aliasedName => _alias ?? 'd_b_friends';
  @override
  String get actualTableName => 'd_b_friends';
  @override
  VerificationContext validateIntegrity(Insertable<DBFriend> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number'], _phoneNumberMeta));
    }
    if (data.containsKey('e_mail')) {
      context.handle(
          _eMailMeta, eMail.isAcceptableOrUnknown(data['e_mail'], _eMailMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  DBFriend map(Map<String, dynamic> data, {String tablePrefix}) {
    return DBFriend.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DBFriendsTable createAlias(String alias) {
    return $DBFriendsTable(attachedDatabase, alias);
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
