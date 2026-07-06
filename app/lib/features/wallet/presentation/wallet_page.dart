import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';

/// 卡包列表占位页（M1-06 实现列表与卡面）。
///
/// "+" 菜单：扫码（默认，M1-03）/ 相册识别（M1-04）/ 手动输入（SPEC §3.1）。
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(child: Text(l10n.tabWallet)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        tooltip: l10n.editorTitleNew,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: Text(l10n.addMenuScan),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.scan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.addMenuGallery),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.imageCapture);
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: Text(l10n.addMenuManual),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.cardNew);
              },
            ),
          ],
        ),
      ),
    );
  }
}
