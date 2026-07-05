import 'package:drift/drift.dart';

/// 带稳定持久化标识的枚举。
///
/// `wire` 同时用作本地库存储值与同步协议值（SPEC §6.2/§6.3），
/// 与 Dart 枚举名解耦——重命名枚举成员不影响已存数据。
abstract interface class WireEnum {
  String get wire;
}

/// 码制（SPEC §3.1，全部 13 种）。
enum CodeFormat implements WireEnum {
  qrCode('qr_code'),
  aztec('aztec'),
  dataMatrix('data_matrix'),
  pdf417('pdf417'),
  ean13('ean13'),
  ean8('ean8'),
  upcA('upc_a'),
  upcE('upc_e'),
  code128('code128'),
  code39('code39'),
  code93('code93'),
  itf('itf'),
  codabar('codabar');

  const CodeFormat(this.wire);

  @override
  final String wire;
}

/// 卡类型（SPEC §3.2）：会员卡 / 优惠券。
enum CardKind implements WireEnum {
  loyalty('loyalty'),
  coupon('coupon');

  const CardKind(this.wire);

  @override
  final String wire;
}

/// 本地同步状态（SPEC §6.3）。未登录模式恒为 [local]。
enum SyncStatus implements WireEnum {
  local('local'),
  synced('synced'),
  dirty('dirty'),
  pendingDelete('pending_delete');

  const SyncStatus(this.wire);

  @override
  final String wire;
}

/// 卡来源（SPEC §6.3）：自有 / 好友共享（共享卡只读）。
enum CardOrigin implements WireEnum {
  own('own'),
  shared('shared');

  const CardOrigin(this.wire);

  @override
  final String wire;
}

/// 按 [WireEnum.wire] 值存取的 Drift 转换器。
class WireEnumConverter<T extends WireEnum> extends TypeConverter<T, String> {
  const WireEnumConverter(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => values.firstWhere(
        (e) => e.wire == fromDb,
        orElse: () => throw ArgumentError.value(
          fromDb, 'fromDb', 'Unbekannter Wert für $T'),
      );

  @override
  String toSql(T value) => value.wire;
}
