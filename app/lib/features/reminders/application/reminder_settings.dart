import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'reminder_settings.g.dart';

/// 过期提醒偏好（SPEC §3.8/§3.9）：开关 + 提前天数。
///
/// 纯本地偏好，存 shared_preferences（不进同步协议）。
class ReminderSettings {
  const ReminderSettings({
    this.enabled = true,
    this.leadDays = defaultLeadDays,
  });

  /// SPEC §3.8 默认：到期前 3 天。
  static const int defaultLeadDays = 3;

  final bool enabled;
  final int leadDays;

  @override
  bool operator ==(Object other) =>
      other is ReminderSettings &&
      other.enabled == enabled &&
      other.leadDays == leadDays;

  @override
  int get hashCode => Object.hash(enabled, leadDays);
}

/// 提醒偏好控制器：设置页写入（M1-09），协调器订阅变化即时重排通知。
@Riverpod(keepAlive: true)
class ReminderSettingsController extends _$ReminderSettingsController {
  static const _enabledKey = 'reminders.enabled';
  static const _leadDaysKey = 'reminders.lead_days';

  @override
  Future<ReminderSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? true,
      leadDays: prefs.getInt(_leadDaysKey) ?? ReminderSettings.defaultLeadDays,
    );
  }

  Future<void> setEnabled(bool value) async {
    final current = await future;
    state = AsyncData(
        ReminderSettings(enabled: value, leadDays: current.leadDays));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
  }

  Future<void> setLeadDays(int value) async {
    final current = await future;
    state =
        AsyncData(ReminderSettings(enabled: current.enabled, leadDays: value));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_leadDaysKey, value);
  }
}
