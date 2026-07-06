import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/repository/card_repository.dart';
import 'package:onecode/features/reminders/application/expiry_reminder_coordinator.dart';
import 'package:onecode/features/reminders/application/reminder_settings.dart';
import 'package:onecode/features/reminders/data/notification_service.dart';
import 'package:onecode/features/reminders/domain/expiry_reminder_rules.dart';
import 'package:onecode/l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 记录调度调用的假实现；系统 pending 集合由测试预置。
class FakeScheduler implements ReminderScheduler {
  bool permissionGranted = true;
  int permissionRequests = 0;
  Set<int> systemPending = {};

  /// 当前"系统里"的通知（schedule 覆盖、cancel 移除）。
  final scheduled = <int, PlannedNotification>{};
  final scheduleLog = <PlannedNotification>[];
  final cancelLog = <int>[];

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> schedule(
    PlannedNotification notification, {
    required String channelName,
    required String channelDescription,
  }) async {
    scheduled[notification.id] = notification;
    scheduleLog.add(notification);
  }

  @override
  Future<void> cancel(int id) async {
    scheduled.remove(id);
    systemPending.remove(id);
    cancelLog.add(id);
  }

  @override
  Future<Set<int>> pendingIds() async => systemPending;
}

void main() {
  late tz.Location berlin;

  setUpAll(() {
    tz_data.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  final now = DateTime.utc(2026, 7, 1, 12);

  CardWithState coupon(String id,
          {String name = 'REWE', DateTime? expiresAt}) =>
      CardWithState(
        card: CardRow(
          id: id,
          name: name,
          codeValue: '4006381333931',
          codeFormat: CodeFormat.ean13,
          cardKind: CardKind.coupon,
          color: '#4A6FA5',
          syncStatus: SyncStatus.local,
          origin: CardOrigin.own,
          expiresAt: expiresAt,
          createdAt: now,
          updatedAt: now,
        ),
        isFavorite: false,
      );

  (ExpiryReminderCoordinator, FakeScheduler) build() {
    final scheduler = FakeScheduler();
    final coordinator = ExpiryReminderCoordinator(
      scheduler: scheduler,
      location: () => berlin,
      l10n: () => lookupAppLocalizations(const Locale('en')),
      clock: () => now,
    );
    return (coordinator, scheduler);
  }

  test('卡流+设置就绪后调度两条提醒，文案含卡名', () async {
    final (coordinator, scheduler) = build();

    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    expect(scheduler.scheduled, hasLength(2));
    final upcoming = scheduler.scheduled[reminderId('c1', ReminderSlot.upcoming)]!;
    final dayOf = scheduler.scheduled[reminderId('c1', ReminderSlot.dayOf)]!;
    expect(upcoming.fireAt, tz.TZDateTime(berlin, 2026, 7, 17, reminderHour));
    expect(upcoming.body, contains('REWE'));
    expect(upcoming.body, contains('3 days'));
    expect(dayOf.fireAt, tz.TZDateTime(berlin, 2026, 7, 20, reminderHour));
    // 点通知直达展示页：payload 即路由路径。
    expect(dayOf.payload, '/card/c1');
  });

  test('改有效期：同 ID 重排到新时刻（旧通知被覆盖，DoD）', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;
    scheduler.scheduleLog.clear();

    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 8, 5))]);
    await coordinator.idle;

    // ID 稳定 → zonedSchedule 覆盖旧通知，无需先取消。
    expect(scheduler.cancelLog, isEmpty);
    expect(scheduler.scheduleLog, hasLength(2));
    expect(scheduler.scheduled[reminderId('c1', ReminderSlot.dayOf)]!.fireAt,
        tz.TZDateTime(berlin, 2026, 8, 5, reminderHour));
  });

  test('内容不变不重复调度', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    final cards = [coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))];
    coordinator.updateCards(cards);
    await coordinator.idle;
    scheduler.scheduleLog.clear();

    coordinator.updateCards(cards);
    await coordinator.idle;

    expect(scheduler.scheduleLog, isEmpty);
    expect(scheduler.cancelLog, isEmpty);
  });

  test('删除卡（流中消失）取消其两条提醒', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    coordinator.updateCards([]);
    await coordinator.idle;

    expect(scheduler.scheduled, isEmpty);
    expect(
      scheduler.cancelLog,
      containsAll([
        reminderId('c1', ReminderSlot.upcoming),
        reminderId('c1', ReminderSlot.dayOf),
      ]),
    );
  });

  test('首次对账清掉系统残留通知（App 未运行期间过时的）', () async {
    final (coordinator, scheduler) = build();
    scheduler.systemPending = {12345};

    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    expect(scheduler.cancelLog, [12345]);
    expect(scheduler.scheduled, hasLength(2));
  });

  test('提醒关闭：取消全部且不再请求权限', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    coordinator.updateSettings(const ReminderSettings(enabled: false));
    await coordinator.idle;

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.permissionRequests, 1);
  });

  test('调整提前天数触发重排', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    coordinator.updateSettings(const ReminderSettings(leadDays: 7));
    await coordinator.idle;

    expect(
        scheduler.scheduled[reminderId('c1', ReminderSlot.upcoming)]!.fireAt,
        tz.TZDateTime(berlin, 2026, 7, 13, reminderHour));
  });

  test('权限被拒绝：不调度任何通知（降级为列表标识）', () async {
    final (coordinator, scheduler) = build();
    scheduler.permissionGranted = false;

    coordinator.updateSettings(const ReminderSettings());
    coordinator
        .updateCards([coupon('c1', expiresAt: DateTime.utc(2026, 7, 20))]);
    await coordinator.idle;

    expect(scheduler.scheduled, isEmpty);
    // 拒绝结果被缓存，后续对账不反复弹权限框。
    coordinator
        .updateCards([coupon('c2', expiresAt: DateTime.utc(2026, 7, 25))]);
    await coordinator.idle;
    expect(scheduler.permissionRequests, 1);
  });

  test('会员卡（无有效期）不产生通知', () async {
    final (coordinator, scheduler) = build();
    coordinator.updateSettings(const ReminderSettings());
    coordinator.updateCards([coupon('c1')]);
    await coordinator.idle;

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.permissionRequests, 0);
  });
}
