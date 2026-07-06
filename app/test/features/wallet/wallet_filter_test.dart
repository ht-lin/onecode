import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/repository/card_repository.dart';
import 'package:onecode/features/wallet/domain/wallet_filter.dart';

CardWithState card({
  String id = 'id',
  String name = 'Karte',
  String? note,
  CardKind kind = CardKind.loyalty,
  DateTime? expiresAt,
}) =>
    CardWithState(
      isFavorite: false,
      card: CardRow(
        id: id,
        name: name,
        codeValue: '123',
        codeFormat: CodeFormat.code128,
        cardKind: kind,
        color: '#4A6FA5',
        note: note,
        expiresAt: expiresAt,
        syncStatus: SyncStatus.local,
        origin: CardOrigin.own,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

void main() {
  final now = DateTime(2026, 7, 6, 14, 30); // 本地时间

  group('isCardExpired（§3.8：有效期含当天）', () {
    test('无有效期永不过期', () {
      expect(isCardExpired(card().card, now), isFalse);
    });

    test('有效期 = 今天 → 仍有效', () {
      final c = card(expiresAt: DateTime.utc(2026, 7, 6));
      expect(isCardExpired(c.card, now), isFalse);
    });

    test('有效期 = 昨天 → 已过期', () {
      final c = card(expiresAt: DateTime.utc(2026, 7, 5));
      expect(isCardExpired(c.card, now), isTrue);
    });
  });

  group('applyWalletFilter', () {
    final loyalty = card(id: 'a', name: 'REWE');
    final coupon = card(
        id: 'b',
        name: 'Edeka Coupon',
        note: 'PIN 1234',
        kind: CardKind.coupon,
        expiresAt: DateTime.utc(2026, 12, 31));
    final expired = card(
        id: 'c',
        name: 'Alter Gutschein',
        kind: CardKind.coupon,
        expiresAt: DateTime.utc(2026, 1, 31));
    final all = [loyalty, coupon, expired];

    List<String> ids(List<CardWithState> cards) =>
        [for (final c in cards) c.card.id];

    test('筛选 chips：全部 / 会员卡 / 优惠券 / 已过期', () {
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.all, query: '', now: now)),
        ['a', 'b', 'c'],
      );
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.loyalty, query: '', now: now)),
        ['a'],
      );
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.coupon, query: '', now: now)),
        ['b', 'c'],
      );
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.expired, query: '', now: now)),
        ['c'],
      );
    });

    test('搜索：名称模糊匹配，大小写不敏感，首尾空白忽略', () {
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.all, query: ' rewe ', now: now)),
        ['a'],
      );
    });

    test('搜索：备注也参与匹配', () {
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.all, query: '1234', now: now)),
        ['b'],
      );
    });

    test('搜索与筛选叠加', () {
      expect(
        ids(applyWalletFilter(all,
            filter: WalletFilter.coupon, query: 'edeka', now: now)),
        ['b'],
      );
      expect(
        applyWalletFilter(all,
            filter: WalletFilter.loyalty, query: 'edeka', now: now),
        isEmpty,
      );
    });
  });
}
