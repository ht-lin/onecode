import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/app.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/core/router/routes.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/features/legal/presentation/legal_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 设置页（M1-09）：走真实 [OneCodeApp]，验证语言/外观即时生效、
/// 持久化与法务页入口（DoD）。
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'OneCode',
      packageName: 'org.example.onecode',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const OneCodeApp(),
      ),
    );
    container.read(appRouterProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
  }

  /// 列表较长，目标可能在测试视口折叠线以下：先滚到可见。
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(finder, 100,
          scrollable: find.byType(Scrollable).first);

  testWidgets('渲染全部分区：账号占位、通用、提醒、法务、版本', (tester) async {
    await pumpSettings(tester);

    // 测试环境系统语言为英文，默认跟随系统。
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Expiry reminders'), findsOneWidget);
    await scrollTo(tester, find.text('Legal'));
    expect(find.text('Legal'), findsOneWidget);
    await scrollTo(tester, find.text('1.2.3 (7)'));
    expect(find.text('1.2.3 (7)'), findsOneWidget);
  });

  testWidgets('切语言到德语：界面即时生效并写入偏好', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('System').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch').last);
    await tester.pumpAndSettle();

    expect(find.text('Einstellungen'), findsWidgets);
    expect(find.text('Sprache'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app.locale'), 'de');
  });

  testWidgets('切外观到深色：MaterialApp 即时生效并写入偏好', (tester) async {
    await pumpSettings(tester);

    // 第二个 "System" 是外观下拉的当前值（第一个属于语言下拉）。
    await tester.tap(find.text('System').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app.theme_mode'), 'dark');
  });

  testWidgets('重启（新容器）后读回持久化的语言', (tester) async {
    SharedPreferences.setMockInitialValues({'app.locale': 'de'});
    await pumpSettings(tester);

    expect(find.text('Einstellungen'), findsWidgets);
  });

  testWidgets('法务入口：Impressum 与 Datenschutzerklärung 可进入', (tester) async {
    await pumpSettings(tester);

    await scrollTo(tester, find.text('Legal notice (Impressum)'));
    await tester.tap(find.text('Legal notice (Impressum)'));
    await tester.pumpAndSettle();
    expect(find.byType(LegalPage), findsOneWidget);
    expect(find.text('Anbieter'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('Privacy policy'));
    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();
    expect(find.byType(LegalPage), findsOneWidget);
    expect(find.text('Verantwortlicher'), findsOneWidget);
  });

  testWidgets('开源许可证列表可进入（自动生成）', (tester) async {
    await pumpSettings(tester);

    await scrollTo(tester, find.text('Open source licenses'));
    await tester.tap(find.text('Open source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
