import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers.dart';
import '../../../data/repository/card_repository.dart';

part 'wallet_providers.g.dart';

/// 卡包列表响应式流（SPEC §3.3）。
/// 排序（收藏置顶 → 最近使用倒序 → 创建倒序）在 Repository 的 SQL 完成，
/// 搜索/筛选由页面在内存中叠加（wallet_filter.dart）。
@riverpod
Stream<List<CardWithState>> walletCards(Ref ref) =>
    ref.watch(cardRepositoryProvider).watchCards();
