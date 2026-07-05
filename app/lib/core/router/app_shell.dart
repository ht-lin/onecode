import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// 底部导航骨架：卡包 / 好友 / 设置（SPEC §5.3）。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.credit_card),
            label: l10n.tabWallet,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            label: l10n.tabFriends,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
