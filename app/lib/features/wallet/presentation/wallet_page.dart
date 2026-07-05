import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// 卡包列表占位页（M1-02 实现列表与卡面）。
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(child: Text(l10n.tabWallet)),
    );
  }
}
