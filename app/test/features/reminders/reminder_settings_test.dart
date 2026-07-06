import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/features/reminders/application/reminder_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 提醒偏好（M1-08）：默认值 + shared_preferences 持久化往返。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('默认开启、提前 3 天（SPEC §3.8）', () async {
    final settings =
        await container.read(reminderSettingsControllerProvider.future);
    expect(settings.enabled, isTrue);
    expect(settings.leadDays, 3);
  });

  test('修改后持久化，新容器读回相同值', () async {
    final controller =
        container.read(reminderSettingsControllerProvider.notifier);
    await container.read(reminderSettingsControllerProvider.future);
    await controller.setEnabled(false);
    await controller.setLeadDays(7);

    final fresh = ProviderContainer();
    addTearDown(fresh.dispose);
    final settings =
        await fresh.read(reminderSettingsControllerProvider.future);
    expect(settings.enabled, isFalse);
    expect(settings.leadDays, 7);
  });
}
