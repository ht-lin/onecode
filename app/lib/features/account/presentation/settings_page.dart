import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// 设置占位页（M2 登录 OTP 流、外观/语言设置、法务页）。
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabSettings)),
      body: Center(child: Text(l10n.tabSettings)),
    );
  }
}
