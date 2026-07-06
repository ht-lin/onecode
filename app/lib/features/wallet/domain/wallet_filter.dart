import '../../../data/drift/app_database.dart';
import '../../../data/repository/card_repository.dart';

/// 卡包筛选 chips（SPEC §3.3）。"好友共享给我的"在 M3-06 加入。
enum WalletFilter { all, loyalty, coupon, expired }

/// 已过期判定（SPEC §3.8）。有效期含当天（"Gültig bis"），次日起算过期；
/// [now] 取设备本地时间，只比较日期部分（有效期存为 UTC 零点，M1-02）。
bool isCardExpired(CardRow card, DateTime now) {
  final expiresAt = card.expiresAt;
  if (expiresAt == null) return false;
  return DateTime.utc(now.year, now.month, now.day).isAfter(expiresAt);
}

/// 内存内筛选 + 搜索，保持 Repository 流的排序不变（SPEC §3.3）。
///
/// 数据量目标上限数百张（§4：500 张），单流订阅 + 内存过滤即可保证
/// 每次按键即时响应，无需把 LIKE 下推 SQL 反复重建查询。
List<CardWithState> applyWalletFilter(
  List<CardWithState> cards, {
  required WalletFilter filter,
  required String query,
  required DateTime now,
}) {
  final q = query.trim().toLowerCase();
  return cards.where((entry) {
    final card = entry.card;
    final matchesFilter = switch (filter) {
      WalletFilter.all => true,
      WalletFilter.loyalty => card.cardKind == CardKind.loyalty,
      WalletFilter.coupon => card.cardKind == CardKind.coupon,
      WalletFilter.expired => isCardExpired(card, now),
    };
    if (!matchesFilter) return false;
    if (q.isEmpty) return true;
    // 名称/备注模糊匹配（SPEC §3.3）：大小写不敏感的子串包含。
    return card.name.toLowerCase().contains(q) ||
        (card.note?.toLowerCase().contains(q) ?? false);
  }).toList();
}
