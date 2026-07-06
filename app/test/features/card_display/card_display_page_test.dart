import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/data/repository/card_repository.dart';
import 'package:onecode/features/card_display/application/display_environment.dart';
import 'package:onecode/features/card_display/presentation/card_display_page.dart';
import 'package:onecode/l10n/app_localizations.dart';

/// 记录进入/退出展示模式的调用序列，替代真实平台通道
/// （亮度 mock 与常亮生命周期验证，M1-07）。
class _RecordingDisplayEnvironment implements DisplayEnvironment {
  final calls = <String>[];

  @override
  Future<void> enterDisplayMode() async => calls.add('enter');

  @override
  Future<void> exitDisplayMode() async => calls.add('exit');
}

/// 卡片展示页（M1-07，SPEC §3.4）：走真实 [appRouterProvider]，
/// 数据库换内存实例，显示能力换 [_RecordingDisplayEnvironment]。
void main() {
  late AppDatabase db;
  late CardRepository repo;
  late ProviderContainer container;
  late _RecordingDisplayEnvironment env;

  var now = DateTime.utc(2026, 7, 1, 12);

  setUp(() {
    now = DateTime.utc(2026, 7, 1, 12);
    db = AppDatabase(NativeDatabase.memory());
    repo = CardRepository(db, clock: () => now);
    env = _RecordingDisplayEnvironment();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        cardRepositoryProvider.overrideWithValue(repo),
        displayEnvironmentProvider.overrideWithValue(env),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<String> addCard(
    String name, {
    String codeValue = '4006381333931',
    CodeFormat codeFormat = CodeFormat.ean13,
    String? note,
  }) =>
      repo.createCard(
        name: name,
        codeValue: codeValue,
        codeFormat: codeFormat,
        note: note,
      );

  // appRouterProvider 是 autoDispose：只 read 一次并留存实例，
  // 保证测试内 push 的 router 与挂在树上的是同一个。
  late GoRouter router;

  Future<void> pumpApp(WidgetTester tester) async {
    router = container.read(appRouterProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// 卡包 → 点卡面 → 展示页（点卡直达路径）。
  Future<void> openDisplay(WidgetTester tester, String name) async {
    await pumpApp(tester);
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  /// 展示页 pop 后 displayCard provider 释放，drift 在 FakeAsync 里排一个
  /// 零时长的流关闭定时器；pumpAndSettle 不再推帧时它会悬着——多推一帧
  /// 点火，否则测试报 pending timer 且 tearDown 的 db.close() 挂起。
  Future<void> flushStreamClose(WidgetTester tester) =>
      tester.pump(const Duration(milliseconds: 100));

  group('点卡直达展示（SPEC §3.4）', () {
    testWidgets('码图形 + 码值明文 + 卡名', (tester) async {
      await addCard('REWE');
      await openDisplay(tester, 'REWE');

      expect(find.byType(CardDisplayPage), findsOneWidget);
      expect(find.byType(BarcodeWidget), findsOneWidget);
      // 码值明文兜底（人工输入）。
      expect(find.text('4006381333931'), findsOneWidget);
      // AppBar 显示卡名。
      expect(find.widgetWithText(AppBar, 'REWE'), findsOneWidget);
    });

    testWidgets('一维码横向拉伸至可扫尺寸（宽 ≫ 高）', (tester) async {
      await addCard('REWE'); // EAN-13，一维
      await openDisplay(tester, 'REWE');

      final size = tester.getSize(find.byType(BarcodeWidget));
      expect(size.width, greaterThan(size.height * 2));
    });

    testWidgets('不存在的卡显示 not found，不崩溃', (tester) async {
      await pumpApp(tester);
      unawaited(router.push('/card/unknown-id'));
      await tester.pumpAndSettle();

      expect(find.text('Card not found'), findsOneWidget);
    });
  });

  group('亮度与常亮生命周期', () {
    testWidgets('进入 enter 一次；停留期间不 exit；返回键退出后 exit 一次',
        (tester) async {
      await addCard('REWE');
      await openDisplay(tester, 'REWE');

      expect(env.calls, ['enter']);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await flushStreamClose(tester);

      expect(env.calls, ['enter', 'exit']);
      expect(find.byType(CardDisplayPage), findsNothing);
    });

    testWidgets('系统返回手势（异常退出路径）同样恢复', (tester) async {
      await addCard('REWE');
      await openDisplay(tester, 'REWE');
      expect(env.calls, ['enter']);

      // 模拟 Android 系统返回手势/返回键。
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await flushStreamClose(tester);

      expect(env.calls, ['enter', 'exit']);
      expect(find.byType(CardDisplayPage), findsNothing);
    });
  });

  group('使用时间戳（SPEC §3.3 排序驱动）', () {
    testWidgets('展示触碰 last_used_at，返回后卡包重排', (tester) async {
      final alpha = await addCard('Alpha');
      now = now.add(const Duration(minutes: 1));
      await addCard('Bravo'); // 创建更晚，初始排前
      await pumpApp(tester);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      final state = await (db.select(db.userCardStates)
            ..where((s) => s.cardId.equals(alpha)))
          .getSingle();
      expect(state.lastUsedAt, now);

      // 返回卡包：Alpha 因最近使用升至首位。
      await tester.pageBack();
      await tester.pumpAndSettle();
      await flushStreamClose(tester);
      final tiles = tester.getTopLeft(find.text('Alpha')).dx <
              tester.getTopLeft(find.text('Bravo')).dx ||
          tester.getTopLeft(find.text('Alpha')).dy <
              tester.getTopLeft(find.text('Bravo')).dy;
      expect(tiles, isTrue);
    });
  });

  group('整屏旋转', () {
    testWidgets('旋转按钮在 0° 与 90° 间切换', (tester) async {
      await addCard('REWE');
      await openDisplay(tester, 'REWE');

      RotatedBox rotated() => tester.widget<RotatedBox>(find
          .ancestor(
              of: find.byType(BarcodeWidget),
              matching: find.byType(RotatedBox))
          .first);

      expect(rotated().quarterTurns, 0);
      final before = tester.getSize(find.byType(BarcodeWidget));

      await tester.tap(find.byIcon(Icons.screen_rotation));
      await tester.pumpAndSettle();
      expect(rotated().quarterTurns, 1);
      // 旋转后一维码以屏幕长边为宽。
      final after = tester.getSize(find.byType(BarcodeWidget));
      expect(after.width, isNot(before.width));

      await tester.tap(find.byIcon(Icons.screen_rotation));
      await tester.pumpAndSettle();
      expect(rotated().quarterTurns, 0);
    });
  });

  group('次要入口：卡详情', () {
    testWidgets('详情 sheet 显示备注，编辑跳转编辑页', (tester) async {
      await addCard('REWE', note: 'PIN 1234');
      await openDisplay(tester, 'REWE');

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      expect(find.text('PIN 1234'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Edit card'), findsOneWidget);
    });

    testWidgets('删除需二次确认，确认后软删除并退回卡包', (tester) async {
      final id = await addCard('REWE');
      await openDisplay(tester, 'REWE');

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      await flushStreamClose(tester);

      // 退回卡包（空状态），墓碑保留。
      expect(find.byType(CardDisplayPage), findsNothing);
      expect(find.text('No cards yet'), findsOneWidget);
      final row =
          await (db.select(db.cards)..where((c) => c.id.equals(id))).getSingle();
      expect(row.deletedAt, isNotNull);
      // 展示模式已恢复。
      expect(env.calls, ['enter', 'exit']);
    });
  });

  group('渲染耗时基准（§4：点卡到码渲染 < 300ms）', () {
    testWidgets('展示页冷构建到码图形出现 < 300ms（debug 宿主机上界）',
        (tester) async {
      final id = await addCard('REWE');

      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: CardDisplayPage(cardId: id),
          ),
        ),
      );
      await tester.pumpAndSettle();
      stopwatch.stop();

      expect(find.byType(BarcodeWidget), findsOneWidget);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(300),
        reason: '点卡到码渲染超出 §4 预算（真机 DoD 另行实测）',
      );
    });
  });
}
