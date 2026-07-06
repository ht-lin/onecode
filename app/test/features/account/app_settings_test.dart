import 'dart:ui';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/features/account/application/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用偏好（M1-09）：默认值 + shared_preferences 持久化往返。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('默认跟随系统：locale null、themeMode system（SPEC §3.9）', () async {
    final settings =
        await container.read(appSettingsControllerProvider.future);
    expect(settings.locale, isNull);
    expect(settings.themeMode, ThemeMode.system);
  });

  test('修改后持久化，新容器读回相同值', () async {
    final controller = container.read(appSettingsControllerProvider.notifier);
    await container.read(appSettingsControllerProvider.future);
    await controller.setLocale(const Locale('de'));
    await controller.setThemeMode(ThemeMode.dark);

    final fresh = ProviderContainer();
    addTearDown(fresh.dispose);
    final settings = await fresh.read(appSettingsControllerProvider.future);
    expect(settings.locale, const Locale('de'));
    expect(settings.themeMode, ThemeMode.dark);
  });

  test('语言切回跟随系统时清除持久化键', () async {
    final controller = container.read(appSettingsControllerProvider.notifier);
    await container.read(appSettingsControllerProvider.future);
    await controller.setLocale(const Locale('en'));
    await controller.setLocale(null);

    final fresh = ProviderContainer();
    addTearDown(fresh.dispose);
    final settings = await fresh.read(appSettingsControllerProvider.future);
    expect(settings.locale, isNull);
  });
}
