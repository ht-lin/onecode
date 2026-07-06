import 'package:barcode_widget/barcode_widget.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/core/router/routes.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/data/repository/card_repository.dart';
import 'package:onecode/l10n/app_localizations.dart';

/// 走真实 [appRouterProvider]（覆盖路由接线与查询参数预填），
/// 数据库换成内存实例。
void main() {
  late AppDatabase db;
  late CardRepository repo;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CardRepository(db);
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpApp(WidgetTester tester, String location) async {
    final router = container.read(appRouterProvider);
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
    if (location != AppRoutes.wallet) router.push(location);
    await tester.pumpAndSettle();
  }

  Future<void> enterByLabel(
      WidgetTester tester, String label, String text) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, label),
      text,
    );
    await tester.pump();
  }

  Future<void> selectFormat(WidgetTester tester, String label) async {
    await tester.tap(find.byType(DropdownButtonFormField<CodeFormat>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  /// 码值输入框当前的键盘类型。
  TextInputType? codeKeyboard(WidgetTester tester) => tester
      .widget<TextField>(find.descendant(
        of: find.widgetWithText(TextFormField, 'Code value'),
        matching: find.byType(TextField),
      ))
      .keyboardType;

  Future<List<CardRow>> allCards() =>
      (db.select(db.cards)).get();

  group('手动输入（M1-05）', () {
    testWidgets('"+" 菜单第三项进入空白编辑页，码制默认 Code 128', (tester) async {
      await pumpApp(tester, AppRoutes.wallet);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enter manually'));
      await tester.pumpAndSettle();

      // "Add card" 同时是 AppBar 标题与预览占位名，限定在 AppBar 内断言。
      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Add card')),
        findsOneWidget,
      );
      expect(find.text('Code 128'), findsOneWidget);
      // 空白态：码值未预填。
      final codeField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Code value'));
      expect(codeField.controller!.text, isEmpty);
    });

    testWidgets('键盘类型随码制切换：纯数字码制用数字键盘', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      // 默认 Code 128（任意 ASCII）→ 文本键盘。
      expect(codeKeyboard(tester), TextInputType.text);

      // 全部 13 种码制的映射由 code_format_ui_test 单元覆盖，
      // 此处验证 UI 切换往返生效。
      await selectFormat(tester, 'EAN-13');
      expect(codeKeyboard(tester), TextInputType.number);

      await selectFormat(tester, 'QR Code');
      expect(codeKeyboard(tester), TextInputType.text);
    });

    testWidgets('输入即渲染实时预览', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      // 空白态预览无码图形。
      expect(find.byType(BarcodeWidget), findsNothing);

      await enterByLabel(tester, 'Code value', '4006381333931');
      expect(find.byType(BarcodeWidget), findsOneWidget);
    });
  });

  group('新建', () {
    testWidgets('必填校验：名称与码值为空时不入库', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter a code value'), findsOneWidget);
      expect(await allCards(), isEmpty);
    });

    testWidgets('有效期字段仅优惠券显示', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      expect(find.text('Valid until'), findsNothing);

      await tester.tap(find.text('Coupon'));
      await tester.pumpAndSettle();
      expect(find.text('Valid until'), findsOneWidget);
      expect(find.text('No expiry date'), findsOneWidget);

      await tester.tap(find.text('Loyalty card'));
      await tester.pumpAndSettle();
      expect(find.text('Valid until'), findsNothing);
    });

    testWidgets('合法 EAN-13 直接保存并返回', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      await enterByLabel(tester, 'Name', 'REWE');
      await enterByLabel(tester, 'Code value', '4006381333931');
      await selectFormat(tester, 'EAN-13');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 无强制保存对话框，直接落库并退出编辑页。
      expect(find.text('Save non-standard code?'), findsNothing);
      expect(find.text('Add card'), findsNothing);

      final cards = await allCards();
      expect(cards, hasLength(1));
      expect(cards.single.name, 'REWE');
      expect(cards.single.codeValue, '4006381333931');
      expect(cards.single.codeFormat, CodeFormat.ean13);
      expect(cards.single.cardKind, CardKind.loyalty);
    });

    testWidgets('非法码值：实时警示 + 取消不入库 + 确认强制保存', (tester) async {
      await pumpApp(tester, AppRoutes.cardNew);

      await enterByLabel(tester, 'Name', 'Kaputte Karte');
      await enterByLabel(tester, 'Code value', '123');
      await selectFormat(tester, 'EAN-13');

      // 实时警示（helper 样式，不阻塞保存）。
      expect(find.text('Length does not match EAN-13'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Save non-standard code?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await allCards(), isEmpty);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save anyway'));
      await tester.pumpAndSettle();

      final cards = await allCards();
      expect(cards, hasLength(1));
      expect(cards.single.codeValue, '123');
      expect(cards.single.codeFormat, CodeFormat.ean13);
    });

    testWidgets('扫码入口经查询参数预填码值与码制', (tester) async {
      await pumpApp(
          tester, AppRoutes.cardNewPrefilled('73513537', 'ean8'));

      expect(find.text('73513537'), findsOneWidget);
      expect(find.text('EAN-8'), findsOneWidget);
      // 无预填时的默认 Code 128 不应出现在码制选择器上。
      expect(find.text('Code 128'), findsNothing);
    });
  });

  group('编辑', () {
    testWidgets('既有卡预填全部字段，保存走 updateCard', (tester) async {
      final id = await repo.createCard(
        name: 'Bäckerei',
        codeValue: 'GUT-2026',
        codeFormat: CodeFormat.qrCode,
        cardKind: CardKind.coupon,
        color: '#C62828',
        note: 'PIN 1234',
        expiresAt: DateTime.utc(2026, 12, 31),
      );
      await pumpApp(tester, AppRoutes.cardEdit(id));

      // 预填检查。
      expect(find.text('Edit card'), findsOneWidget);
      expect(find.text('GUT-2026'), findsNWidgets(1));
      expect(find.text('QR Code'), findsOneWidget);

      // 下方字段在视口外，逐段滚动断言，再滚回顶部改名。
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(find.text('Valid until'), 200,
          scrollable: scrollable);
      expect(find.text('12/31/2026'), findsOneWidget);
      expect(find.text('No expiry date'), findsNothing);
      await tester.scrollUntilVisible(find.text('PIN 1234'), 200,
          scrollable: scrollable);
      await tester.drag(find.byType(ListView), const Offset(0, 1200));
      await tester.pumpAndSettle();

      await enterByLabel(tester, 'Name', 'Bäckerei Müller');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final card = (await repo.getCard(id))!.card;
      expect(card.name, 'Bäckerei Müller');
      expect(card.codeValue, 'GUT-2026');
      expect(card.cardKind, CardKind.coupon);
      expect(card.note, 'PIN 1234');
      expect(card.expiresAt, DateTime.utc(2026, 12, 31));
      expect(await allCards(), hasLength(1));
    });

    testWidgets('不存在的卡 id 显示占位', (tester) async {
      await pumpApp(tester, AppRoutes.cardEdit('nicht-da'));
      expect(find.text('Card not found'), findsOneWidget);
    });
  });
}
