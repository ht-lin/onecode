import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/features/reminders/domain/expiry_reminder_rules.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 调度计算（M1-08，SPEC §3.8）：到期前 N 天 + 到期日 09:00 本地时间，
/// 重点验证欧洲夏令时切换（DoD：时区/DST 正确性）。
void main() {
  late tz.Location berlin;

  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  List<ScheduledReminder> compute({
    String cardId = 'card-1',
    DateTime? expiresAt,
    int leadDays = 3,
    tz.Location? location,
    DateTime? now,
  }) =>
      computeExpiryReminders(
        cardId: cardId,
        expiresAt: expiresAt,
        leadDays: leadDays,
        location: location ?? berlin,
        now: now ?? DateTime.utc(2026, 7, 1, 12),
      );

  group('computeExpiryReminders', () {
    test('无有效期不产生提醒', () {
      expect(compute(expiresAt: null), isEmpty);
    });

    test('到期前 3 天 + 到期日各一次，均为本地 09:00', () {
      final reminders = compute(expiresAt: DateTime.utc(2026, 7, 20));

      expect(reminders, hasLength(2));
      final upcoming = reminders[0];
      final dayOf = reminders[1];
      expect(upcoming.slot, ReminderSlot.upcoming);
      expect(
          upcoming.fireAt, tz.TZDateTime(berlin, 2026, 7, 17, reminderHour));
      expect(dayOf.slot, ReminderSlot.dayOf);
      expect(dayOf.fireAt, tz.TZDateTime(berlin, 2026, 7, 20, reminderHour));
      for (final r in reminders) {
        expect(r.fireAt.hour, reminderHour);
        expect(r.fireAt.location, berlin);
      }
    });

    test('提前天数跨月边界正确归一化', () {
      final reminders = compute(expiresAt: DateTime.utc(2026, 8, 2));

      expect(reminders.first.fireAt,
          tz.TZDateTime(berlin, 2026, 7, 30, reminderHour));
    });

    test('欧洲 DST 春季切换：两个时刻各取当日实际 UTC 偏移', () {
      // 2027-03-28（最后一个周日）02:00 CET → 03:00 CEST。
      final reminders = compute(
        expiresAt: DateTime.utc(2027, 3, 29),
        now: DateTime.utc(2027, 3, 1),
      );

      final upcoming = reminders[0].fireAt; // 03-26，仍是冬令时 +01:00
      final dayOf = reminders[1].fireAt; // 03-29，已是夏令时 +02:00
      expect(upcoming.hour, reminderHour);
      expect(dayOf.hour, reminderHour);
      expect(upcoming.timeZoneOffset, const Duration(hours: 1));
      expect(dayOf.timeZoneOffset, const Duration(hours: 2));
      // UTC 时刻相应错开：08:00Z（冬令时）vs 07:00Z（夏令时）。
      expect(upcoming.toUtc().hour, 8);
      expect(dayOf.toUtc().hour, 7);
    });

    test('欧洲 DST 秋季切换：夏令时 → 冬令时', () {
      // 2026-10-25（最后一个周日）03:00 CEST → 02:00 CET。
      final reminders = compute(
        expiresAt: DateTime.utc(2026, 10, 27),
        now: DateTime.utc(2026, 10, 1),
      );

      expect(reminders[0].fireAt.timeZoneOffset, const Duration(hours: 2));
      expect(reminders[1].fireAt.timeZoneOffset, const Duration(hours: 1));
      expect(reminders[0].fireAt.hour, reminderHour);
      expect(reminders[1].fireAt.hour, reminderHour);
    });

    test('已过去的时刻不调度：提前档已过只剩到期日', () {
      final reminders = compute(
        expiresAt: DateTime.utc(2026, 7, 2),
        // 明天过期（DoD 用例）：提前 3 天档在过去，只排到期日 09:00。
        now: DateTime.utc(2026, 7, 1, 12),
      );

      expect(reminders, hasLength(1));
      expect(reminders.single.slot, ReminderSlot.dayOf);
      expect(reminders.single.fireAt,
          tz.TZDateTime(berlin, 2026, 7, 2, reminderHour));
    });

    test('到期日 09:00 也已过去则完全不调度', () {
      expect(
        compute(
          expiresAt: DateTime.utc(2026, 7, 1),
          now: DateTime.utc(2026, 7, 1, 12),
        ),
        isEmpty,
      );
    });

    test('提前天数为 0 时只保留到期日一条', () {
      final reminders = compute(
        expiresAt: DateTime.utc(2026, 7, 20),
        leadDays: 0,
      );

      expect(reminders, hasLength(1));
      expect(reminders.single.slot, ReminderSlot.dayOf);
    });
  });

  group('reminderId', () {
    test('跨调用稳定且槽位互不冲突', () {
      const cardId = '4f4df3f4-8a5a-4f7e-9d5c-2f6c8f1a2b3c';
      expect(reminderId(cardId, ReminderSlot.upcoming),
          reminderId(cardId, ReminderSlot.upcoming));
      expect(reminderId(cardId, ReminderSlot.upcoming),
          isNot(reminderId(cardId, ReminderSlot.dayOf)));
      // 31 位以内，Android int32 通知 ID 安全。
      expect(reminderId(cardId, ReminderSlot.dayOf), lessThan(1 << 31));
      expect(reminderId(cardId, ReminderSlot.dayOf), isNonNegative);
    });

    test('不同卡得到不同 ID', () {
      expect(reminderId('card-a', ReminderSlot.upcoming),
          isNot(reminderId('card-b', ReminderSlot.upcoming)));
    });
  });

  group('isCleanupCandidate', () {
    CardRow card({DateTime? expiresAt, CardOrigin origin = CardOrigin.own}) =>
        CardRow(
          id: 'card-1',
          name: 'REWE',
          codeValue: '4006381333931',
          codeFormat: CodeFormat.ean13,
          cardKind: CardKind.coupon,
          color: '#4A6FA5',
          syncStatus: SyncStatus.local,
          origin: origin,
          expiresAt: expiresAt,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        );

    test('过期 30 天内不提示，第 31 天起提示', () {
      final expiry = DateTime.utc(2026, 6, 1);
      expect(
        isCleanupCandidate(card(expiresAt: expiry), DateTime.utc(2026, 7, 1)),
        isFalse,
      );
      expect(
        isCleanupCandidate(card(expiresAt: expiry), DateTime.utc(2026, 7, 2)),
        isTrue,
      );
    });

    test('无有效期或共享卡不进清理列表', () {
      final now = DateTime.utc(2026, 7, 6);
      expect(isCleanupCandidate(card(), now), isFalse);
      expect(
        isCleanupCandidate(
          card(expiresAt: DateTime.utc(2026, 1, 1), origin: CardOrigin.shared),
          now,
        ),
        isFalse,
      );
    });
  });
}
