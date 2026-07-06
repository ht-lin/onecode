import 'dart:ui';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_settings.g.dart';

/// 应用级偏好（SPEC §3.9）：语言（跟随系统/de/en）+ 外观。
///
/// 纯本地偏好，存 shared_preferences（不进同步协议）。
class AppSettings {
  const AppSettings({this.locale, this.themeMode = ThemeMode.system});

  /// null = 跟随系统。仅 de/en 两种显式选择（SPEC §3.9）。
  final Locale? locale;
  final ThemeMode themeMode;

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.locale == locale &&
      other.themeMode == themeMode;

  @override
  int get hashCode => Object.hash(locale, themeMode);
}

/// 应用偏好控制器：设置页写入，[OneCodeApp] 订阅即时生效。
@Riverpod(keepAlive: true)
class AppSettingsController extends _$AppSettingsController {
  static const _localeKey = 'app.locale';
  static const _themeModeKey = 'app.theme_mode';

  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final localeTag = prefs.getString(_localeKey);
    final themeModeName = prefs.getString(_themeModeKey);
    return AppSettings(
      locale: localeTag == null ? null : Locale(localeTag),
      themeMode: ThemeMode.values
              .where((mode) => mode.name == themeModeName)
              .firstOrNull ??
          ThemeMode.system,
    );
  }

  /// [locale] 为 null 时回到跟随系统。
  Future<void> setLocale(Locale? locale) async {
    final current = await future;
    state = AsyncData(
        AppSettings(locale: locale, themeMode: current.themeMode));
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = await future;
    state = AsyncData(AppSettings(locale: current.locale, themeMode: mode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }
}
