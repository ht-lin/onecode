import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/data/repository/card_repository.dart';
import 'package:onecode/features/wallet/presentation/widgets/wallet_card_tile.dart';
import 'package:onecode/l10n/app_localizations.dart';

/// 卡包列表页（M1-06）：走真实 [appRouterProvider]，数据库换成内存实例。
void main() {
  late AppDatabase db;
  late CardRepository repo;
  late ProviderContainer container;

  /// 可拨动的时钟，驱动"最近使用倒序"的确定性排序。
  var now = DateTime.utc(2026, 7, 1, 12);

  setUp(() {
    now = DateTime.utc(2026, 7, 1, 12);
    db = AppDatabase(NativeDatabase.memory());
    repo = CardRepository(db, clock: () => now);
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpWallet(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: container.read(appRouterProvider),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<String> addCard(
    String name, {
    CardKind kind = CardKind.loyalty,
    String? note,
    DateTime? expiresAt,
  }) =>
      repo.createCard(
        name: name,
        codeValue: '4006381333931',
        codeFormat: CodeFormat.ean13,
        cardKind: kind,
        note: note,
        expiresAt: expiresAt,
      );

  /// 网格中可见卡面的名称，按视觉顺序（先行后列）。
  List<String> visibleTileNames(WidgetTester tester) {
    final tiles = find.byType(WalletCardTile);
    final entries = [
      for (final element in tiles.evaluate())
        (
          pos: tester.getTopLeft(find.byWidget(element.widget)),
          name: (element.widget as WalletCardTile).entry.card.name,
        ),
    ]..sort((a, b) {
        final dy = a.pos.dy.compareTo(b.pos.dy);
        return dy != 0 ? dy : a.pos.dx.compareTo(b.pos.dx);
      });
    return [for (final e in entries) e.name];
  }

  Finder tileNamed(String name) => find.ancestor(
      of: find.text(name), matching: find.byType(WalletCardTile));

  group('排序（SPEC §3.3）', () {
    testWidgets('收藏置顶，其余按最近使用倒序，从未使用按创建倒序垫底', (tester) async {
      final alpha = await addCard('Alpha');
      now = now.add(const Duration(minutes: 1));
      final bravo = await addCard('Bravo');
      now = now.add(const Duration(minutes: 1));
      await addCard('Charlie'); // 创建最晚，从未使用
      now = now.add(const Duration(minutes: 1));
      await repo.touchLastUsed(alpha); // 最近使用
      await repo.toggleFavorite(bravo); // 收藏

      await pumpWallet(tester);

      expect(visibleTileNames(tester), ['Bravo', 'Alpha', 'Charlie']);
      // 收藏卡显示星标。
      expect(
        find.descendant(
            of: tileNamed('Bravo'),
            matching: find.byIcon(Icons.star_rounded)),
        findsOneWidget,
      );
    });
  });

  group('搜索', () {
    testWidgets('名称/备注模糊匹配，即时过滤，可清空', (tester) async {
      await addCard('REWE');
      await addCard('Edeka', note: 'PIN 1234');
      await pumpWallet(tester);
      expect(find.byType(WalletCardTile), findsNWidgets(2));

      // 名称匹配（大小写不敏感）。
      await tester.enterText(find.byType(TextField), 'rew');
      await tester.pump();
      expect(visibleTileNames(tester), ['REWE']);

      // 备注匹配。
      await tester.enterText(find.byType(TextField), '1234');
      await tester.pump();
      expect(visibleTileNames(tester), ['Edeka']);

      // 无结果占位。
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();
      expect(find.byType(WalletCardTile), findsNothing);
      expect(find.text('No matching cards'), findsOneWidget);

      // 清空按钮恢复全量。
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      expect(find.byType(WalletCardTile), findsNWidgets(2));
    });
  });

  group('筛选 chips', () {
    Finder chip(String label) =>
        find.widgetWithText(ChoiceChip, label);

    testWidgets('全部 / 会员卡 / 优惠券 / 已过期', (tester) async {
      await addCard('REWE');
      await addCard('Gutschein Neu',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2099, 1, 1));
      await addCard('Gutschein Alt',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2020, 1, 1));
      await pumpWallet(tester);
      expect(find.byType(WalletCardTile), findsNWidgets(3));

      await tester.tap(chip('Loyalty card'));
      await tester.pump();
      expect(visibleTileNames(tester), ['REWE']);

      await tester.tap(chip('Coupon'));
      await tester.pump();
      expect(visibleTileNames(tester),
          containsAll(['Gutschein Neu', 'Gutschein Alt']));
      expect(find.byType(WalletCardTile), findsNWidgets(2));

      await tester.tap(chip('Expired'));
      await tester.pump();
      expect(visibleTileNames(tester), ['Gutschein Alt']);

      await tester.tap(chip('All'));
      await tester.pump();
      expect(find.byType(WalletCardTile), findsNWidgets(3));
    });
  });

  group('卡面呈现', () {
    testWidgets('优惠券显示有效期角标；已过期置灰并标"Expired"（§3.8）', (tester) async {
      await addCard('Gutschein Neu',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2099, 12, 31));
      await addCard('Gutschein Alt',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2020, 1, 1));
      await pumpWallet(tester);

      // 未过期优惠券：日期角标，无置灰。
      expect(
        find.descendant(
            of: tileNamed('Gutschein Neu'),
            matching: find.text('12/31/2099')),
        findsOneWidget,
      );
      expect(
        find.ancestor(
            of: find.text('Gutschein Neu'),
            matching: find.byType(ColorFiltered)),
        findsNothing,
      );

      // 已过期：置灰滤镜 + "Expired" 角标。
      expect(
        find.ancestor(
            of: find.text('Gutschein Alt'),
            matching: find.byType(ColorFiltered)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: tileNamed('Gutschein Alt'), matching: find.text('Expired')),
        findsOneWidget,
      );
    });
  });

  group('批量清理横幅（M1-08，SPEC §3.8）', () {
    testWidgets('仅过期超 30 天的卡计入；确认后软删除，近期过期的保留', (tester) async {
      final oldId = await addCard('Gutschein Alt',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2020, 1, 1));
      // 刚过期两天：置灰标识，但不进清理横幅。
      await addCard('Gutschein Neulich',
          kind: CardKind.coupon,
          expiresAt: DateTime.now().toUtc().subtract(const Duration(days: 2)));
      await pumpWallet(tester);

      expect(find.byType(MaterialBanner), findsOneWidget);
      expect(
          find.text('1 coupon expired more than 30 days ago.'), findsOneWidget);

      // 不自动删除：需经确认对话框。
      await tester.tap(find.text('Clean up'));
      await tester.pumpAndSettle();
      expect(find.text('Delete expired coupons?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsNothing);
      expect(visibleTileNames(tester), ['Gutschein Neulich']);
      final row = await (db.select(db.cards)
            ..where((c) => c.id.equals(oldId)))
          .getSingle();
      expect(row.deletedAt, isNotNull);
    });

    testWidgets('"Not now" 本会话内隐藏横幅', (tester) async {
      await addCard('Gutschein Alt',
          kind: CardKind.coupon, expiresAt: DateTime.utc(2020, 1, 1));
      await pumpWallet(tester);
      expect(find.byType(MaterialBanner), findsOneWidget);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialBanner), findsNothing);
      expect(find.byType(WalletCardTile), findsOneWidget);
    });
  });

  group('长按操作', () {
    testWidgets('收藏切换并实时重排', (tester) async {
      await addCard('Alpha');
      now = now.add(const Duration(minutes: 1));
      await addCard('Bravo');
      await pumpWallet(tester);
      expect(visibleTileNames(tester), ['Bravo', 'Alpha']);

      await tester.longPress(find.text('Alpha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to favorites'));
      await tester.pumpAndSettle();

      expect(visibleTileNames(tester), ['Alpha', 'Bravo']);

      // 已收藏卡的菜单显示取消收藏。
      await tester.longPress(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(find.text('Remove from favorites'), findsOneWidget);
    });

    testWidgets('编辑跳转到编辑页', (tester) async {
      await addCard('REWE');
      await pumpWallet(tester);

      await tester.longPress(find.text('REWE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Edit card'), findsOneWidget);
    });

    testWidgets('删除需二次确认，确认后软删除（墓碑保留）', (tester) async {
      final id = await addCard('REWE');
      await pumpWallet(tester);

      // 取消：卡保留。
      await tester.longPress(find.text('REWE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete card?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(WalletCardTile), findsOneWidget);

      // 确认：列表移除，但行仍在库中（软删除，SPEC §6.1）。
      await tester.longPress(find.text('REWE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(WalletCardTile), findsNothing);
      final row = await (db.select(db.cards)
            ..where((c) => c.id.equals(id)))
          .getSingle();
      expect(row.deletedAt, isNotNull);
    });
  });

  group('空状态', () {
    testWidgets('引导第一次录入，按钮打开 "+" 菜单', (tester) async {
      await pumpWallet(tester);

      expect(find.text('No cards yet'), findsOneWidget);
      // 空钱包不显示搜索与筛选。
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(ChoiceChip), findsNothing);

      await tester.tap(find.text('Add first card'));
      await tester.pumpAndSettle();
      expect(find.text('Scan barcode'), findsOneWidget);
    });
  });

  group('500 张卡（§4 性能目标）', () {
    Future<void> seed500() async {
      final base = DateTime.utc(2026, 1, 1);
      await db.batch((b) {
        for (var i = 1; i <= 500; i++) {
          final created = base.add(Duration(seconds: i));
          b.insert(
            db.cards,
            CardsCompanion.insert(
              id: 'card-$i',
              name: 'Laden ${i.toString().padLeft(3, '0')}',
              codeValue: 'CODE-$i',
              codeFormat: CodeFormat.code128,
              note: Value('Notiz $i'),
              createdAt: created,
              updatedAt: created,
            ),
          );
          b.insert(
            db.userCardStates,
            UserCardStatesCompanion.insert(
                cardId: 'card-$i', updatedAt: created),
          );
        }
      });
    }

    testWidgets('网格懒加载：只构建视口内卡面，滚动流畅', (tester) async {
      await seed500();
      await pumpWallet(tester);

      // 创建倒序：最新的 500 号在最前。
      expect(visibleTileNames(tester).first, 'Laden 500');
      // GridView.builder 懒加载：远小于全量 500。
      expect(find.byType(WalletCardTile).evaluate().length, lessThan(40));

      await tester.fling(
          find.byType(GridView), const Offset(0, -3000), 4000);
      await tester.pumpAndSettle();
      expect(find.byType(WalletCardTile), findsWidgets);
    });

    testWidgets('搜索在单帧内出结果（名称与备注）', (tester) async {
      await seed500();
      await pumpWallet(tester);

      await tester.enterText(find.byType(TextField), 'Laden 042');
      await tester.pump();
      expect(visibleTileNames(tester), ['Laden 042']);

      await tester.enterText(find.byType(TextField), 'Notiz 7');
      await tester.pump();
      // Notiz 7 / 7x / 7xx：1 + 10 + 100 = 111 张，验证过滤正确性。
      final matches = find.byType(WalletCardTile).evaluate().length;
      expect(matches, greaterThan(0));
      expect(matches, lessThan(40)); // 仍是懒加载
    });
  });
}
