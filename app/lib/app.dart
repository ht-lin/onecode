import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/account/application/app_settings.dart';
import 'l10n/app_localizations.dart';

class OneCodeApp extends ConsumerWidget {
  const OneCodeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 偏好加载是毫秒级；就绪前先按系统默认渲染首帧，避免阻塞冷启动。
    final settings = ref.watch(appSettingsControllerProvider).value ??
        const AppSettings();
    return MaterialApp.router(
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    );
  }
}
