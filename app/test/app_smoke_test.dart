import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/app.dart';
import 'package:onecode/features/account/presentation/settings_page.dart';
import 'package:onecode/features/friends/presentation/friends_page.dart';
import 'package:onecode/features/wallet/presentation/wallet_page.dart';

/// tab 标签同时出现在页面正文占位里，限定在 NavigationBar 内查找。
Finder navLabel(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

void main() {
  testWidgets('renders three tabs and switches between them', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OneCodeApp()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
    // 默认 locale 为 en，标签来自 l10n，验证 gen-l10n 链路接通。
    expect(find.byType(WalletPage), findsOneWidget);
    expect(navLabel('Wallet'), findsOneWidget);

    await tester.tap(navLabel('Friends'));
    await tester.pumpAndSettle();
    expect(find.byType(FriendsPage), findsOneWidget);

    await tester.tap(navLabel('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('labels follow system locale (de)', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const ProviderScope(child: OneCodeApp()));
    await tester.pumpAndSettle();

    expect(navLabel('Karten'), findsOneWidget);
    expect(navLabel('Freunde'), findsOneWidget);
    expect(navLabel('Einstellungen'), findsOneWidget);
  });
}
