import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../reminders/application/reminder_settings.dart';
import '../application/app_settings.dart';
import '../application/app_version.dart';

/// 提前天数可选档位（SPEC §3.8 默认 3 天，可调整）。
const _leadDayChoices = [1, 2, 3, 5, 7, 14];

/// 设置页（SPEC §3.9）：账号占位、语言/外观、过期提醒、法务页、版本。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final appSettings = ref.watch(appSettingsControllerProvider).value;
    final reminderSettings =
        ref.watch(reminderSettingsControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabSettings)),
      body: appSettings == null || reminderSettings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // 账号区占位：M2-06 接管为真实登录/账号管理入口。
                _SectionHeader(l10n.settingsAccountSection),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(l10n.settingsSignInTitle),
                  subtitle: Text(l10n.settingsSignInSubtitle),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsSignInComingSoon)),
                  ),
                ),
                _SectionHeader(l10n.settingsGeneralSection),
                ListTile(
                  title: Text(l10n.settingsLanguage),
                  trailing: DropdownButton<String>(
                    value: appSettings.locale?.languageCode ?? _followSystem,
                    items: [
                      DropdownMenuItem(
                        value: _followSystem,
                        child: Text(l10n.settingsLanguageSystem),
                      ),
                      // 语言名按其自身语言显示，不随界面语言翻译。
                      const DropdownMenuItem(
                          value: 'de', child: Text('Deutsch')),
                      const DropdownMenuItem(
                          value: 'en', child: Text('English')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(appSettingsControllerProvider.notifier)
                            .setLocale(
                                value == _followSystem ? null : Locale(value));
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Text(l10n.settingsAppearance),
                  trailing: DropdownButton<ThemeMode>(
                    value: appSettings.themeMode,
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(l10n.settingsAppearanceSystem),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(l10n.settingsAppearanceLight),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(l10n.settingsAppearanceDark),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(appSettingsControllerProvider.notifier)
                            .setThemeMode(value);
                      }
                    },
                  ),
                ),
                _SectionHeader(l10n.settingsRemindersSection),
                SwitchListTile(
                  title: Text(l10n.settingsRemindersEnabled),
                  value: reminderSettings.enabled,
                  onChanged: (value) => ref
                      .read(reminderSettingsControllerProvider.notifier)
                      .setEnabled(value),
                ),
                ListTile(
                  title: Text(l10n.settingsRemindersLeadDays),
                  enabled: reminderSettings.enabled,
                  trailing: DropdownButton<int>(
                    value: _leadDayChoices.contains(reminderSettings.leadDays)
                        ? reminderSettings.leadDays
                        : ReminderSettings.defaultLeadDays,
                    items: [
                      for (final days in _leadDayChoices)
                        DropdownMenuItem(
                          value: days,
                          child: Text(l10n.settingsLeadDaysValue(days)),
                        ),
                    ],
                    onChanged: reminderSettings.enabled
                        ? (value) {
                            if (value != null) {
                              ref
                                  .read(
                                      reminderSettingsControllerProvider.notifier)
                                  .setLeadDays(value);
                            }
                          }
                        : null,
                  ),
                ),
                _SectionHeader(l10n.settingsLegalSection),
                ListTile(
                  title: Text(l10n.legalImpressum),
                  onTap: () => context.push(AppRoutes.impressum),
                ),
                ListTile(
                  title: Text(l10n.legalPrivacy),
                  onTap: () => context.push(AppRoutes.privacy),
                ),
                ListTile(
                  title: Text(l10n.legalLicenses),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion:
                        ref.read(appVersionProvider).value,
                  ),
                ),
                ListTile(
                  title: Text(l10n.settingsVersion),
                  trailing: Text(
                    ref.watch(appVersionProvider).value ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
    );
  }
}

/// 语言下拉里"跟随系统"的哨兵值（Locale 值只可能是 de/en）。
const _followSystem = 'system';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dense: true,
    );
  }
}
