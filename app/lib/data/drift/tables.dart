import 'package:drift/drift.dart';

import 'enums.dart';

/// 卡（SPEC §3.2 字段 + §6.3 本地列）。
///
/// 主键 UUID v4 由客户端生成（SPEC §6.1），在 Repository 层完成。
@DataClassName('CardRow')
class Cards extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();
  TextColumn get codeValue => text()();
  TextColumn get codeFormat =>
      text().map(const WireEnumConverter(CodeFormat.values))();
  TextColumn get cardKind => text()
      .map(const WireEnumConverter(CardKind.values))
      .withDefault(const Constant('loyalty'))();

  /// 卡面颜色，hex（SPEC §6.2 默认 #4A6FA5 = CardPalette.steelBlue）。
  TextColumn get color => text().withDefault(const Constant('#4A6FA5'))();
  TextColumn get note => text().nullable()();

  /// 有效期，仅 coupon（SPEC §3.2）；只取日期部分。
  DateTimeColumn get expiresAt => dateTime().nullable()();

  TextColumn get syncStatus => text()
      .map(const WireEnumConverter(SyncStatus.values))
      .withDefault(const Constant('local'))();
  TextColumn get origin => text()
      .map(const WireEnumConverter(CardOrigin.values))
      .withDefault(const Constant('own'))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// 软删除墓碑（SPEC §6.1）。
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 每卡个人状态（SPEC §6.2 user_card_state 的单用户本地投影，
/// 服务端复合主键 (user_id, card_id) 在本地退化为 card_id）。
@DataClassName('UserCardStateRow')
class UserCardStates extends Table {
  TextColumn get cardId => text().references(Cards, #id)();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {cardId};
}

/// 同步元数据单行表（SPEC §6.3），id 恒为 1。
@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  IntColumn get id => integer()();

  /// 服务端返回的同步游标（SPEC §6.4），未同步过为 NULL。
  TextColumn get lastCursor => text().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
