import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/router/app_router.dart';

part 'notification_service.g.dart';

/// 一条已定稿的本地通知：内容 + 触发时刻 + 点击深链。
///
/// 值语义——协调器靠 `==` 判断"这张卡的通知是否需要重排"。
class PlannedNotification {
  const PlannedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.fireAt,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime fireAt;

  /// 点通知的深链目标，直接是 go_router 路径（`/card/<id>`）。
  final String payload;

  @override
  bool operator ==(Object other) =>
      other is PlannedNotification &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.fireAt.isAtSameMomentAs(fireAt) &&
      other.payload == payload;

  @override
  int get hashCode => Object.hash(id, title, body, fireAt, payload);
}

/// 协调器面向的调度接口；测试注入 fake，真机走
/// [LocalNotificationService]（平台通道）。
abstract interface class ReminderScheduler {
  /// 请求通知权限；拒绝时调用方降级为仅列表内标识（SPEC §3.8）。
  Future<bool> requestPermission();

  Future<void> schedule(
    PlannedNotification notification, {
    required String channelName,
    required String channelDescription,
  });

  Future<void> cancel(int id);

  /// 系统里仍挂着的通知 ID——冷启动对账用（卡在 App 未运行时不会变，
  /// 但设置可能变、时间会流逝，残留通知要清）。
  Future<Set<int>> pendingIds();
}

/// `flutter_local_notifications` 封装（SPEC §3.8：纯本地，不依赖服务端）。
class LocalNotificationService implements ReminderScheduler {
  LocalNotificationService({required this.onSelectPayload});

  static const _channelId = 'expiry_reminders';

  /// 点通知（前台/后台恢复）时回调 payload，由 provider 接到路由 push。
  final void Function(String payload) onSelectPayload;

  final _plugin = FlutterLocalNotificationsPlugin();

  tz.Location _location = tz.UTC;

  /// 设备当前时区；[init] 之前为 UTC。
  tz.Location get location => _location;

  String? _launchPayload;

  /// 冷启动来自点通知时的深链 payload；只可消费一次。
  String? takeLaunchPayload() {
    final payload = _launchPayload;
    _launchPayload = null;
    return payload;
  }

  /// 初始化插件与时区数据库。必须在任何调度调用之前完成。
  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      _location = tz.getLocation(info.identifier);
      tz.setLocalLocation(_location);
    } catch (_) {
      // 拿不到设备时区（罕见）退回 UTC：提醒仍触发，钟点可能偏移。
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // 权限延后到真正有券要提醒时再请求（notification_service 只管
        // 通道，请求时机在协调器）。
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) onSelectPayload(payload);
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchPayload = launch!.notificationResponse?.payload;
    }
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // API < 33 没有运行时通知权限，插件返回 null → 视为已授予。
      return await android.requestNotificationsPermission() ?? true;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    // 其它平台（桌面开发环境）不支持 zonedSchedule，不调度。
    return false;
  }

  @override
  Future<void> schedule(
    PlannedNotification notification, {
    required String channelName,
    required String channelDescription,
  }) {
    return _plugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: notification.fireAt,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          channelDescription: channelDescription,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // 非精确闹钟：09:00 提醒容忍分钟级偏移，免去 Android 14+
      // SCHEDULE_EXACT_ALARM 特殊权限申请。
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: notification.payload,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<Set<int>> pendingIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return {for (final request in pending) request.id};
  }
}

@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(Ref ref) =>
    LocalNotificationService(
      // 点通知直达该卡展示页（SPEC §3.8）：payload 即路由路径。
      onSelectPayload: (payload) => ref.read(appRouterProvider).push(payload),
    );
