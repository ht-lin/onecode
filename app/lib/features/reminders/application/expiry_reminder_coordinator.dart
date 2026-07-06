import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart' show basicLocaleListResolution;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../data/repository/card_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/notification_service.dart';
import '../domain/expiry_reminder_rules.dart';
import 'reminder_settings.dart';

part 'expiry_reminder_coordinator.g.dart';

/// 过期提醒协调器（SPEC §3.8）。
///
/// 声明式对账而非命令式挂钩：订阅卡流 + 提醒设置，把"当前应存在的
/// 通知集合"与上一次调度结果做差量——卡保存/编辑/删除、设置变更都
/// 自动触发重排，后续同步引擎（M2-07）改库同样被覆盖，无需在每个
/// 写路径手工插桩。首次对账额外与系统 pending 列表核对，清掉 App
/// 未运行期间残留的过期通知。
class ExpiryReminderCoordinator {
  ExpiryReminderCoordinator({
    required this._scheduler,
    required this._location,
    required this._l10n,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final ReminderScheduler _scheduler;
  final tz.Location Function() _location;
  final AppLocalizations Function() _l10n;
  final DateTime Function() _now;

  List<CardWithState>? _cards;
  ReminderSettings? _settings;

  /// 上次对账后系统里的通知；null = 尚未与系统 pending 对过账。
  Map<int, PlannedNotification>? _scheduled;

  /// 权限只请求一次；null = 还没请求过。拒绝后不再调度，
  /// 降级为列表内过期标识（M1-06 已有）。
  bool? _permissionGranted;

  Future<void> _work = Future.value();

  /// 测试钩子：等待队列中的对账全部完成。
  Future<void> get idle => _work;

  void updateCards(List<CardWithState> cards) {
    _cards = cards;
    _enqueue();
  }

  void updateSettings(ReminderSettings settings) {
    _settings = settings;
    _enqueue();
  }

  /// 卡流与设置都就绪后才开始；对账串行排队，避免交错写系统调度。
  void _enqueue() {
    final cards = _cards;
    final settings = _settings;
    if (cards == null || settings == null) return;
    _work = _work.then((_) => _reconcile(cards, settings));
  }

  Future<void> _reconcile(
      List<CardWithState> cards, ReminderSettings settings) async {
    final desired = <int, PlannedNotification>{};
    if (settings.enabled) {
      final l10n = _l10n();
      final location = _location();
      final now = _now();
      for (final entry in cards) {
        final card = entry.card;
        final reminders = computeExpiryReminders(
          cardId: card.id,
          expiresAt: card.expiresAt,
          leadDays: settings.leadDays,
          location: location,
          now: now,
        );
        for (final reminder in reminders) {
          desired[reminder.id] = PlannedNotification(
            id: reminder.id,
            title: reminder.slot == ReminderSlot.dayOf
                ? l10n.notifExpiresTodayTitle
                : l10n.notifExpiresSoonTitle,
            body: reminder.slot == ReminderSlot.dayOf
                ? l10n.notifExpiresTodayBody(card.name)
                : l10n.notifExpiresSoonBody(card.name, settings.leadDays),
            fireAt: reminder.fireAt,
            payload: AppRoutes.cardDisplay(card.id),
          );
        }
      }
    }

    if (desired.isNotEmpty) {
      _permissionGranted ??= await _scheduler.requestPermission();
      if (!_permissionGranted!) return;
    }

    // 取消不再需要的：首次以系统 pending 为准，之后以上次对账为准。
    final staleIds = _scheduled == null
        ? (await _scheduler.pendingIds()).where((id) => !desired.containsKey(id))
        : _scheduled!.keys.where((id) => !desired.containsKey(id));
    for (final id in staleIds.toList()) {
      await _scheduler.cancel(id);
    }

    final l10n = _l10n();
    for (final notification in desired.values) {
      // 首次对账全量重排（pending 列表看不到触发时刻，无从跳过）；
      // 之后只排有变化的——zonedSchedule 同 ID 覆盖旧通知。
      if (_scheduled != null && _scheduled![notification.id] == notification) {
        continue;
      }
      await _scheduler.schedule(
        notification,
        channelName: l10n.notifChannelName,
        channelDescription: l10n.notifChannelDescription,
      );
    }
    _scheduled = desired;
  }
}

/// 按设备语言解析通知文案（通知在 widget 树外构建，拿不到 context）。
AppLocalizations _resolveL10n() => lookupAppLocalizations(
      basicLocaleListResolution(
        PlatformDispatcher.instance.locales,
        AppLocalizations.supportedLocales,
      ),
    );

@Riverpod(keepAlive: true)
ExpiryReminderCoordinator expiryReminderCoordinator(Ref ref) {
  final service = ref.watch(localNotificationServiceProvider);
  final coordinator = ExpiryReminderCoordinator(
    scheduler: service,
    location: () => service.location,
    l10n: _resolveL10n,
  );
  final subscription = ref
      .watch(cardRepositoryProvider)
      .watchCards()
      .listen(coordinator.updateCards);
  ref.onDispose(subscription.cancel);
  ref.listen(
    reminderSettingsControllerProvider,
    (_, next) => next.whenData(coordinator.updateSettings),
    fireImmediately: true,
  );
  return coordinator;
}
