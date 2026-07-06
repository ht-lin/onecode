import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'features/reminders/application/expiry_reminder_coordinator.dart';
import 'features/reminders/data/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  runApp(UncontrolledProviderScope(container: container, child: const OneCodeApp()));
  // 提醒子系统在首帧之后异步起步：时区库加载 + 插件初始化不占
  // 冷启动关键路径（SPEC §4：卡包可交互 < 2s）。
  unawaited(_startExpiryReminders(container));
}

Future<void> _startExpiryReminders(ProviderContainer container) async {
  final notifications = container.read(localNotificationServiceProvider);
  await notifications.init();
  // 激活协调器：订阅卡流 + 设置，对账本地通知（SPEC §3.8）。
  container.read(expiryReminderCoordinatorProvider);
  // 冷启动来自点通知：直达该卡展示页。
  final payload = notifications.takeLaunchPayload();
  if (payload != null) {
    container.read(appRouterProvider).push(payload);
  }
}
