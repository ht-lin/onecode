import 'package:timezone/timezone.dart' as tz;

import '../../../data/drift/app_database.dart';

/// 提醒触发的本地钟点（SPEC §3.8：09:00）。
const int reminderHour = 9;

/// 过期超过该天数后提示批量清理（SPEC §3.8，不自动删除）。
const int cleanupAfterDays = 30;

/// 一张卡的两个提醒时刻（SPEC §3.8）。
enum ReminderSlot {
  /// 到期前 N 天（默认 3，可在设置调整）。
  upcoming,

  /// 到期日当天。
  dayOf,
}

/// 待调度的提醒时刻（纯计算结果，通知文案由协调器补齐）。
class ScheduledReminder {
  const ScheduledReminder({
    required this.id,
    required this.cardId,
    required this.slot,
    required this.fireAt,
  });

  final int id;
  final String cardId;
  final ReminderSlot slot;
  final tz.TZDateTime fireAt;
}

/// 卡 → 稳定通知 ID 基（FNV-1a 32 位截 30 位）。
///
/// 通知 ID 必须跨进程重启稳定，同一张卡重排时 `zonedSchedule` 才能
/// 覆盖旧通知而不是堆积新的；Dart 的 `hashCode` 跨运行不稳定，不可用。
int reminderIdBase(String cardId) {
  var hash = 0x811c9dc5;
  for (final unit in cardId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash & 0x3FFFFFFF;
}

/// 槽位编码进最低位，两个槽位 ID 相邻且互不冲突（31 位，安卓 int32 安全）。
int reminderId(String cardId, ReminderSlot slot) =>
    (reminderIdBase(cardId) << 1) | slot.index;

/// 计算一张卡当前应存在的提醒时刻（SPEC §3.8）：
/// 到期前 [leadDays] 天 + 到期日各一次，均为 [location] 本地时间 09:00。
///
/// [expiresAt] 为 UTC 零点存储的纯日期（M1-02），只取年月日；用
/// `TZDateTime(location, y, m, d, 9)` 落到本地时刻——跨 DST 切换时
/// timezone 库按该日期实际生效的 UTC 偏移换算，欧洲夏令时切换正确
/// （用例见单测）。已过去的时刻不返回；[leadDays] ≤ 0 时只保留到期日。
List<ScheduledReminder> computeExpiryReminders({
  required String cardId,
  required DateTime? expiresAt,
  required int leadDays,
  required tz.Location location,
  required DateTime now,
}) {
  if (expiresAt == null) return const [];
  final expiry = expiresAt.toUtc();
  // 日构造参数允许越界（day - leadDays 可为 0/负数），语义同 DateTime：
  // 自动向前归一化到上一个月。
  final upcoming = tz.TZDateTime(location, expiry.year, expiry.month,
      expiry.day - leadDays, reminderHour);
  final dayOf = tz.TZDateTime(
      location, expiry.year, expiry.month, expiry.day, reminderHour);
  return [
    if (leadDays > 0 && upcoming.isAfter(now))
      ScheduledReminder(
        id: reminderId(cardId, ReminderSlot.upcoming),
        cardId: cardId,
        slot: ReminderSlot.upcoming,
        fireAt: upcoming,
      ),
    if (dayOf.isAfter(now))
      ScheduledReminder(
        id: reminderId(cardId, ReminderSlot.dayOf),
        cardId: cardId,
        slot: ReminderSlot.dayOf,
        fireAt: dayOf,
      ),
  ];
}

/// 批量清理候选（SPEC §3.8）：自有卡过期超过 30 天。
///
/// 与 [cleanupAfterDays] 的比较按整日差：到期日后第 31 天起提示。
/// 共享卡只读（SPEC §6.3），不进清理列表。
bool isCleanupCandidate(CardRow card, DateTime now) {
  final expiresAt = card.expiresAt;
  if (expiresAt == null || card.origin == CardOrigin.shared) return false;
  final today = DateTime.utc(now.year, now.month, now.day);
  return today.difference(expiresAt.toUtc()).inDays > cleanupAfterDays;
}
