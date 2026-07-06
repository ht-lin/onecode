import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../reminders/application/reminder_settings.dart';

/// 提前天数可选档位（SPEC §3.8 默认 3 天，可调整）。
const _leadDayChoices = [1, 2, 3, 5, 7, 14];

/// 设置页：M1-08 先落过期提醒偏好；语言/外观/账号/法务在 M1-09/M2。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(reminderSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabSettings)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (settings) => ListView(
          children: [
            ListTile(
              title: Text(
                l10n.settingsRemindersSection,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dense: true,
            ),
            SwitchListTile(
              title: Text(l10n.settingsRemindersEnabled),
              value: settings.enabled,
              onChanged: (value) => ref
                  .read(reminderSettingsControllerProvider.notifier)
                  .setEnabled(value),
            ),
            ListTile(
              title: Text(l10n.settingsRemindersLeadDays),
              enabled: settings.enabled,
              trailing: DropdownButton<int>(
                value: _leadDayChoices.contains(settings.leadDays)
                    ? settings.leadDays
                    : ReminderSettings.defaultLeadDays,
                items: [
                  for (final days in _leadDayChoices)
                    DropdownMenuItem(
                      value: days,
                      child: Text(l10n.settingsLeadDaysValue(days)),
                    ),
                ],
                onChanged: settings.enabled
                    ? (value) {
                        if (value != null) {
                          ref
                              .read(reminderSettingsControllerProvider.notifier)
                              .setLeadDays(value);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
