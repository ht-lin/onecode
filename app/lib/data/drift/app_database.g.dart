// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeValueMeta = const VerificationMeta(
    'codeValue',
  );
  @override
  late final GeneratedColumn<String> codeValue = GeneratedColumn<String>(
    'code_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CodeFormat, String> codeFormat =
      GeneratedColumn<String>(
        'code_format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CodeFormat>($CardsTable.$convertercodeFormat);
  @override
  late final GeneratedColumnWithTypeConverter<CardKind, String> cardKind =
      GeneratedColumn<String>(
        'card_kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('loyalty'),
      ).withConverter<CardKind>($CardsTable.$convertercardKind);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#4A6FA5'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('local'),
      ).withConverter<SyncStatus>($CardsTable.$convertersyncStatus);
  @override
  late final GeneratedColumnWithTypeConverter<CardOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('own'),
      ).withConverter<CardOrigin>($CardsTable.$converterorigin);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    codeValue,
    codeFormat,
    cardKind,
    color,
    note,
    expiresAt,
    syncStatus,
    origin,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code_value')) {
      context.handle(
        _codeValueMeta,
        codeValue.isAcceptableOrUnknown(data['code_value']!, _codeValueMeta),
      );
    } else if (isInserting) {
      context.missing(_codeValueMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      codeValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_value'],
      )!,
      codeFormat: $CardsTable.$convertercodeFormat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}code_format'],
        )!,
      ),
      cardKind: $CardsTable.$convertercardKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}card_kind'],
        )!,
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      syncStatus: $CardsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      origin: $CardsTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }

  static TypeConverter<CodeFormat, String> $convertercodeFormat =
      const WireEnumConverter(CodeFormat.values);
  static TypeConverter<CardKind, String> $convertercardKind =
      const WireEnumConverter(CardKind.values);
  static TypeConverter<SyncStatus, String> $convertersyncStatus =
      const WireEnumConverter(SyncStatus.values);
  static TypeConverter<CardOrigin, String> $converterorigin =
      const WireEnumConverter(CardOrigin.values);
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final String id;
  final String name;
  final String codeValue;
  final CodeFormat codeFormat;
  final CardKind cardKind;

  /// 卡面颜色，hex（SPEC §6.2 默认 #4A6FA5 = CardPalette.steelBlue）。
  final String color;
  final String? note;

  /// 有效期，仅 coupon（SPEC §3.2）；只取日期部分。
  final DateTime? expiresAt;
  final SyncStatus syncStatus;
  final CardOrigin origin;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// 软删除墓碑（SPEC §6.1）。
  final DateTime? deletedAt;
  const CardRow({
    required this.id,
    required this.name,
    required this.codeValue,
    required this.codeFormat,
    required this.cardKind,
    required this.color,
    this.note,
    this.expiresAt,
    required this.syncStatus,
    required this.origin,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code_value'] = Variable<String>(codeValue);
    {
      map['code_format'] = Variable<String>(
        $CardsTable.$convertercodeFormat.toSql(codeFormat),
      );
    }
    {
      map['card_kind'] = Variable<String>(
        $CardsTable.$convertercardKind.toSql(cardKind),
      );
    }
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    {
      map['sync_status'] = Variable<String>(
        $CardsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    {
      map['origin'] = Variable<String>(
        $CardsTable.$converterorigin.toSql(origin),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      name: Value(name),
      codeValue: Value(codeValue),
      codeFormat: Value(codeFormat),
      cardKind: Value(cardKind),
      color: Value(color),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      syncStatus: Value(syncStatus),
      origin: Value(origin),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      codeValue: serializer.fromJson<String>(json['codeValue']),
      codeFormat: serializer.fromJson<CodeFormat>(json['codeFormat']),
      cardKind: serializer.fromJson<CardKind>(json['cardKind']),
      color: serializer.fromJson<String>(json['color']),
      note: serializer.fromJson<String?>(json['note']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      syncStatus: serializer.fromJson<SyncStatus>(json['syncStatus']),
      origin: serializer.fromJson<CardOrigin>(json['origin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'codeValue': serializer.toJson<String>(codeValue),
      'codeFormat': serializer.toJson<CodeFormat>(codeFormat),
      'cardKind': serializer.toJson<CardKind>(cardKind),
      'color': serializer.toJson<String>(color),
      'note': serializer.toJson<String?>(note),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'syncStatus': serializer.toJson<SyncStatus>(syncStatus),
      'origin': serializer.toJson<CardOrigin>(origin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CardRow copyWith({
    String? id,
    String? name,
    String? codeValue,
    CodeFormat? codeFormat,
    CardKind? cardKind,
    String? color,
    Value<String?> note = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    SyncStatus? syncStatus,
    CardOrigin? origin,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => CardRow(
    id: id ?? this.id,
    name: name ?? this.name,
    codeValue: codeValue ?? this.codeValue,
    codeFormat: codeFormat ?? this.codeFormat,
    cardKind: cardKind ?? this.cardKind,
    color: color ?? this.color,
    note: note.present ? note.value : this.note,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    syncStatus: syncStatus ?? this.syncStatus,
    origin: origin ?? this.origin,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  CardRow copyWithCompanion(CardsCompanion data) {
    return CardRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      codeValue: data.codeValue.present ? data.codeValue.value : this.codeValue,
      codeFormat: data.codeFormat.present
          ? data.codeFormat.value
          : this.codeFormat,
      cardKind: data.cardKind.present ? data.cardKind.value : this.cardKind,
      color: data.color.present ? data.color.value : this.color,
      note: data.note.present ? data.note.value : this.note,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      origin: data.origin.present ? data.origin.value : this.origin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('codeValue: $codeValue, ')
          ..write('codeFormat: $codeFormat, ')
          ..write('cardKind: $cardKind, ')
          ..write('color: $color, ')
          ..write('note: $note, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    codeValue,
    codeFormat,
    cardKind,
    color,
    note,
    expiresAt,
    syncStatus,
    origin,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.codeValue == this.codeValue &&
          other.codeFormat == this.codeFormat &&
          other.cardKind == this.cardKind &&
          other.color == this.color &&
          other.note == this.note &&
          other.expiresAt == this.expiresAt &&
          other.syncStatus == this.syncStatus &&
          other.origin == this.origin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CardsCompanion extends UpdateCompanion<CardRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> codeValue;
  final Value<CodeFormat> codeFormat;
  final Value<CardKind> cardKind;
  final Value<String> color;
  final Value<String?> note;
  final Value<DateTime?> expiresAt;
  final Value<SyncStatus> syncStatus;
  final Value<CardOrigin> origin;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.codeValue = const Value.absent(),
    this.codeFormat = const Value.absent(),
    this.cardKind = const Value.absent(),
    this.color = const Value.absent(),
    this.note = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.origin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String name,
    required String codeValue,
    required CodeFormat codeFormat,
    this.cardKind = const Value.absent(),
    this.color = const Value.absent(),
    this.note = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.origin = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       codeValue = Value(codeValue),
       codeFormat = Value(codeFormat),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CardRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? codeValue,
    Expression<String>? codeFormat,
    Expression<String>? cardKind,
    Expression<String>? color,
    Expression<String>? note,
    Expression<DateTime>? expiresAt,
    Expression<String>? syncStatus,
    Expression<String>? origin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (codeValue != null) 'code_value': codeValue,
      if (codeFormat != null) 'code_format': codeFormat,
      if (cardKind != null) 'card_kind': cardKind,
      if (color != null) 'color': color,
      if (note != null) 'note': note,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (origin != null) 'origin': origin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? codeValue,
    Value<CodeFormat>? codeFormat,
    Value<CardKind>? cardKind,
    Value<String>? color,
    Value<String?>? note,
    Value<DateTime?>? expiresAt,
    Value<SyncStatus>? syncStatus,
    Value<CardOrigin>? origin,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      codeValue: codeValue ?? this.codeValue,
      codeFormat: codeFormat ?? this.codeFormat,
      cardKind: cardKind ?? this.cardKind,
      color: color ?? this.color,
      note: note ?? this.note,
      expiresAt: expiresAt ?? this.expiresAt,
      syncStatus: syncStatus ?? this.syncStatus,
      origin: origin ?? this.origin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (codeValue.present) {
      map['code_value'] = Variable<String>(codeValue.value);
    }
    if (codeFormat.present) {
      map['code_format'] = Variable<String>(
        $CardsTable.$convertercodeFormat.toSql(codeFormat.value),
      );
    }
    if (cardKind.present) {
      map['card_kind'] = Variable<String>(
        $CardsTable.$convertercardKind.toSql(cardKind.value),
      );
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $CardsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $CardsTable.$converterorigin.toSql(origin.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('codeValue: $codeValue, ')
          ..write('codeFormat: $codeFormat, ')
          ..write('cardKind: $cardKind, ')
          ..write('color: $color, ')
          ..write('note: $note, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserCardStatesTable extends UserCardStates
    with TableInfo<$UserCardStatesTable, UserCardStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCardStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    isFavorite,
    lastUsedAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_card_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCardStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  UserCardStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCardStateRow(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $UserCardStatesTable createAlias(String alias) {
    return $UserCardStatesTable(attachedDatabase, alias);
  }
}

class UserCardStateRow extends DataClass
    implements Insertable<UserCardStateRow> {
  final String cardId;
  final bool isFavorite;
  final DateTime? lastUsedAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const UserCardStateRow({
    required this.cardId,
    required this.isFavorite,
    this.lastUsedAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  UserCardStatesCompanion toCompanion(bool nullToAbsent) {
    return UserCardStatesCompanion(
      cardId: Value(cardId),
      isFavorite: Value(isFavorite),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory UserCardStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCardStateRow(
      cardId: serializer.fromJson<String>(json['cardId']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  UserCardStateRow copyWith({
    String? cardId,
    bool? isFavorite,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => UserCardStateRow(
    cardId: cardId ?? this.cardId,
    isFavorite: isFavorite ?? this.isFavorite,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  UserCardStateRow copyWithCompanion(UserCardStatesCompanion data) {
    return UserCardStateRow(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCardStateRow(')
          ..write('cardId: $cardId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(cardId, isFavorite, lastUsedAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCardStateRow &&
          other.cardId == this.cardId &&
          other.isFavorite == this.isFavorite &&
          other.lastUsedAt == this.lastUsedAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class UserCardStatesCompanion extends UpdateCompanion<UserCardStateRow> {
  final Value<String> cardId;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const UserCardStatesCompanion({
    this.cardId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserCardStatesCompanion.insert({
    required String cardId,
    this.isFavorite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       updatedAt = Value(updatedAt);
  static Insertable<UserCardStateRow> custom({
    Expression<String>? cardId,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserCardStatesCompanion copyWith({
    Value<String>? cardId,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return UserCardStatesCompanion(
      cardId: cardId ?? this.cardId,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCardStatesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastCursorMeta = const VerificationMeta(
    'lastCursor',
  );
  @override
  late final GeneratedColumn<String> lastCursor = GeneratedColumn<String>(
    'last_cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lastCursor, deviceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_cursor')) {
      context.handle(
        _lastCursorMeta,
        lastCursor.isAcceptableOrUnknown(data['last_cursor']!, _lastCursorMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_cursor'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final int id;

  /// 服务端返回的同步游标（SPEC §6.4），未同步过为 NULL。
  final String? lastCursor;
  final String? deviceId;
  const SyncMetaRow({required this.id, this.lastCursor, this.deviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastCursor != null) {
      map['last_cursor'] = Variable<String>(lastCursor);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      id: Value(id),
      lastCursor: lastCursor == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCursor),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory SyncMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      id: serializer.fromJson<int>(json['id']),
      lastCursor: serializer.fromJson<String?>(json['lastCursor']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastCursor': serializer.toJson<String?>(lastCursor),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  SyncMetaRow copyWith({
    int? id,
    Value<String?> lastCursor = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => SyncMetaRow(
    id: id ?? this.id,
    lastCursor: lastCursor.present ? lastCursor.value : this.lastCursor,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      id: data.id.present ? data.id.value : this.id,
      lastCursor: data.lastCursor.present
          ? data.lastCursor.value
          : this.lastCursor,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('id: $id, ')
          ..write('lastCursor: $lastCursor, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastCursor, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaRow &&
          other.id == this.id &&
          other.lastCursor == this.lastCursor &&
          other.deviceId == this.deviceId);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<int> id;
  final Value<String?> lastCursor;
  final Value<String?> deviceId;
  const SyncMetaCompanion({
    this.id = const Value.absent(),
    this.lastCursor = const Value.absent(),
    this.deviceId = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    this.id = const Value.absent(),
    this.lastCursor = const Value.absent(),
    this.deviceId = const Value.absent(),
  });
  static Insertable<SyncMetaRow> custom({
    Expression<int>? id,
    Expression<String>? lastCursor,
    Expression<String>? deviceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastCursor != null) 'last_cursor': lastCursor,
      if (deviceId != null) 'device_id': deviceId,
    });
  }

  SyncMetaCompanion copyWith({
    Value<int>? id,
    Value<String?>? lastCursor,
    Value<String?>? deviceId,
  }) {
    return SyncMetaCompanion(
      id: id ?? this.id,
      lastCursor: lastCursor ?? this.lastCursor,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastCursor.present) {
      map['last_cursor'] = Variable<String>(lastCursor.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('id: $id, ')
          ..write('lastCursor: $lastCursor, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $UserCardStatesTable userCardStates = $UserCardStatesTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cards,
    userCardStates,
    syncMeta,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      required String id,
      required String name,
      required String codeValue,
      required CodeFormat codeFormat,
      Value<CardKind> cardKind,
      Value<String> color,
      Value<String?> note,
      Value<DateTime?> expiresAt,
      Value<SyncStatus> syncStatus,
      Value<CardOrigin> origin,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> codeValue,
      Value<CodeFormat> codeFormat,
      Value<CardKind> cardKind,
      Value<String> color,
      Value<String?> note,
      Value<DateTime?> expiresAt,
      Value<SyncStatus> syncStatus,
      Value<CardOrigin> origin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, CardRow> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserCardStatesTable, List<UserCardStateRow>>
  _userCardStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userCardStates,
    aliasName: 'cards__id__user_card_states__card_id',
  );

  $$UserCardStatesTableProcessedTableManager get userCardStatesRefs {
    final manager = $$UserCardStatesTableTableManager(
      $_db,
      $_db.userCardStates,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userCardStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeValue => $composableBuilder(
    column: $table.codeValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CodeFormat, CodeFormat, String>
  get codeFormat => $composableBuilder(
    column: $table.codeFormat,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<CardKind, CardKind, String> get cardKind =>
      $composableBuilder(
        column: $table.cardKind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<CardOrigin, CardOrigin, String> get origin =>
      $composableBuilder(
        column: $table.origin,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userCardStatesRefs(
    Expression<bool> Function($$UserCardStatesTableFilterComposer f) f,
  ) {
    final $$UserCardStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userCardStates,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCardStatesTableFilterComposer(
            $db: $db,
            $table: $db.userCardStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeValue => $composableBuilder(
    column: $table.codeValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeFormat => $composableBuilder(
    column: $table.codeFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardKind => $composableBuilder(
    column: $table.cardKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get codeValue =>
      $composableBuilder(column: $table.codeValue, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CodeFormat, String> get codeFormat =>
      $composableBuilder(
        column: $table.codeFormat,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<CardKind, String> get cardKind =>
      $composableBuilder(column: $table.cardKind, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<CardOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> userCardStatesRefs<T extends Object>(
    Expression<T> Function($$UserCardStatesTableAnnotationComposer a) f,
  ) {
    final $$UserCardStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userCardStates,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCardStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCardStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          CardRow,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (CardRow, $$CardsTableReferences),
          CardRow,
          PrefetchHooks Function({bool userCardStatesRefs})
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> codeValue = const Value.absent(),
                Value<CodeFormat> codeFormat = const Value.absent(),
                Value<CardKind> cardKind = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<CardOrigin> origin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                name: name,
                codeValue: codeValue,
                codeFormat: codeFormat,
                cardKind: cardKind,
                color: color,
                note: note,
                expiresAt: expiresAt,
                syncStatus: syncStatus,
                origin: origin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String codeValue,
                required CodeFormat codeFormat,
                Value<CardKind> cardKind = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<CardOrigin> origin = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                name: name,
                codeValue: codeValue,
                codeFormat: codeFormat,
                cardKind: cardKind,
                color: color,
                note: note,
                expiresAt: expiresAt,
                syncStatus: syncStatus,
                origin: origin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CardsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({userCardStatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userCardStatesRefs) db.userCardStates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userCardStatesRefs)
                    await $_getPrefetchedData<
                      CardRow,
                      $CardsTable,
                      UserCardStateRow
                    >(
                      currentTable: table,
                      referencedTable: $$CardsTableReferences
                          ._userCardStatesRefsTable(db),
                      managerFromTypedResult: (p0) => $$CardsTableReferences(
                        db,
                        table,
                        p0,
                      ).userCardStatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      CardRow,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (CardRow, $$CardsTableReferences),
      CardRow,
      PrefetchHooks Function({bool userCardStatesRefs})
    >;
typedef $$UserCardStatesTableCreateCompanionBuilder =
    UserCardStatesCompanion Function({
      required String cardId,
      Value<bool> isFavorite,
      Value<DateTime?> lastUsedAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$UserCardStatesTableUpdateCompanionBuilder =
    UserCardStatesCompanion Function({
      Value<String> cardId,
      Value<bool> isFavorite,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$UserCardStatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserCardStatesTable, UserCardStateRow> {
  $$UserCardStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('user_card_states__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserCardStatesTableFilterComposer
    extends Composer<_$AppDatabase, $UserCardStatesTable> {
  $$UserCardStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCardStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCardStatesTable> {
  $$UserCardStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCardStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCardStatesTable> {
  $$UserCardStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCardStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCardStatesTable,
          UserCardStateRow,
          $$UserCardStatesTableFilterComposer,
          $$UserCardStatesTableOrderingComposer,
          $$UserCardStatesTableAnnotationComposer,
          $$UserCardStatesTableCreateCompanionBuilder,
          $$UserCardStatesTableUpdateCompanionBuilder,
          (UserCardStateRow, $$UserCardStatesTableReferences),
          UserCardStateRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$UserCardStatesTableTableManager(
    _$AppDatabase db,
    $UserCardStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCardStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCardStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCardStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserCardStatesCompanion(
                cardId: cardId,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserCardStatesCompanion.insert(
                cardId: cardId,
                isFavorite: isFavorite,
                lastUsedAt: lastUsedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserCardStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable: $$UserCardStatesTableReferences
                                    ._cardIdTable(db),
                                referencedColumn:
                                    $$UserCardStatesTableReferences
                                        ._cardIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserCardStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCardStatesTable,
      UserCardStateRow,
      $$UserCardStatesTableFilterComposer,
      $$UserCardStatesTableOrderingComposer,
      $$UserCardStatesTableAnnotationComposer,
      $$UserCardStatesTableCreateCompanionBuilder,
      $$UserCardStatesTableUpdateCompanionBuilder,
      (UserCardStateRow, $$UserCardStatesTableReferences),
      UserCardStateRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<int> id,
      Value<String?> lastCursor,
      Value<String?> deviceId,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<int> id,
      Value<String?> lastCursor,
      Value<String?> deviceId,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaRow,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaRow,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>,
          ),
          SyncMetaRow,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastCursor = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
              }) => SyncMetaCompanion(
                id: id,
                lastCursor: lastCursor,
                deviceId: deviceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastCursor = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                id: id,
                lastCursor: lastCursor,
                deviceId: deviceId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaRow,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
      SyncMetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$UserCardStatesTableTableManager get userCardStates =>
      $$UserCardStatesTableTableManager(_db, _db.userCardStates);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
