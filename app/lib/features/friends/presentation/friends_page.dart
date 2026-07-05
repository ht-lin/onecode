import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// 好友列表占位页（M3 实现好友与共享）。
class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabFriends)),
      body: Center(child: Text(l10n.tabFriends)),
    );
  }
}
