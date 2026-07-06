// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 卡包列表响应式流（SPEC §3.3）。
/// 排序（收藏置顶 → 最近使用倒序 → 创建倒序）在 Repository 的 SQL 完成，
/// 搜索/筛选由页面在内存中叠加（wallet_filter.dart）。

@ProviderFor(walletCards)
final walletCardsProvider = WalletCardsProvider._();

/// 卡包列表响应式流（SPEC §3.3）。
/// 排序（收藏置顶 → 最近使用倒序 → 创建倒序）在 Repository 的 SQL 完成，
/// 搜索/筛选由页面在内存中叠加（wallet_filter.dart）。

final class WalletCardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CardWithState>>,
          List<CardWithState>,
          Stream<List<CardWithState>>
        >
    with
        $FutureModifier<List<CardWithState>>,
        $StreamProvider<List<CardWithState>> {
  /// 卡包列表响应式流（SPEC §3.3）。
  /// 排序（收藏置顶 → 最近使用倒序 → 创建倒序）在 Repository 的 SQL 完成，
  /// 搜索/筛选由页面在内存中叠加（wallet_filter.dart）。
  WalletCardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletCardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletCardsHash();

  @$internal
  @override
  $StreamProviderElement<List<CardWithState>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CardWithState>> create(Ref ref) {
    return walletCards(ref);
  }
}

String _$walletCardsHash() => r'a70959778dd5e69c0966316c1104a6c662dc7d44';
