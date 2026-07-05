import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';

/// 卡包列表占位页（M1-06 实现列表与卡面）。
///
/// FAB 暂直达手动新建（M1-02 编辑页）；M1-03/05 扩展为
/// 扫码/相册/手动三选一的 "+" 菜单（SPEC §3.1）。
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(child: Text(l10n.tabWallet)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.cardNew),
        tooltip: l10n.editorTitleNew,
        child: const Icon(Icons.add),
      ),
    );
  }
}
