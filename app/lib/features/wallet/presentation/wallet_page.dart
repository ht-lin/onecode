import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../data/repository/card_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/wallet_filter.dart';
import 'wallet_providers.dart';
import 'widgets/wallet_card_tile.dart';

/// 主页卡包（SPEC §3.3）：网格卡面 + 搜索 + 筛选 chips。
/// 找卡快是核心指标——收银台 3 秒调出的前半程（M1-06）。
///
/// "+" 菜单：扫码（默认，M1-03）/ 相册识别（M1-04）/ 手动输入（SPEC §3.1）。
class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final _search = TextEditingController();
  WalletFilter _filter = WalletFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardsAsync = ref.watch(walletCardsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: cardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (cards) => cards.isEmpty
            ? _EmptyWallet(onAdd: () => _showAddMenu(context))
            : _buildList(context, cards),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        tooltip: l10n.editorTitleNew,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<CardWithState> cards) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final visible = applyWalletFilter(
      cards,
      filter: _filter,
      query: _search.text,
      now: now,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            controller: _search,
            // 本地即时搜索（SPEC §3.3）：按键直接重过滤内存列表。
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(_search.clear),
                    ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              for (final filter in WalletFilter.values) ...[
                ChoiceChip(
                  label: Text(_filterLabel(l10n, filter)),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? Center(child: Text(l10n.noMatchingCards))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 88),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    // 信用卡比例的卡面，手机竖屏两列。
                    maxCrossAxisExtent: 260,
                    childAspectRatio: 1.586,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final entry = visible[index];
                    return WalletCardTile(
                      entry: entry,
                      expired: isCardExpired(entry.card, now),
                      // 点卡面直达展示页在 M1-07 接入（SPEC §3.4）。
                      onLongPress: () => _showCardActions(context, entry),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _filterLabel(AppLocalizations l10n, WalletFilter filter) =>
      switch (filter) {
        WalletFilter.all => l10n.filterAll,
        WalletFilter.loyalty => l10n.kindLoyalty,
        WalletFilter.coupon => l10n.kindCoupon,
        WalletFilter.expired => l10n.filterExpired,
      };

  /// 长按卡面操作（SPEC §3.3）：收藏 / 编辑 / 删除（软删除，二次确认）。
  Future<void> _showCardActions(BuildContext context, CardWithState entry) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(entry.isFavorite
                  ? Icons.star_outline_rounded
                  : Icons.star_rounded),
              title: Text(entry.isFavorite
                  ? l10n.cardActionUnfavorite
                  : l10n.cardActionFavorite),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ref.read(cardRepositoryProvider).toggleFavorite(entry.card.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.cardActionEdit),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.cardEdit(entry.card.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.cardActionDelete),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _confirmDelete(context, entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CardWithState entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody(entry.card.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.cardActionDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // 软删除：只落墓碑（SPEC §3.3/§6.1），流会自动移除该卡。
      await ref.read(cardRepositoryProvider).softDeleteCard(entry.card.id);
    }
  }

  Future<void> _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: Text(l10n.addMenuScan),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.scan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.addMenuGallery),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.imageCapture);
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: Text(l10n.addMenuManual),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.cardNew);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 首次使用空状态（SPEC §3.3）：引导第一次录入。
class _EmptyWallet extends StatelessWidget {
  const _EmptyWallet({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wallet_outlined,
                size: 72, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(l10n.emptyWalletTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l10n.emptyWalletBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.emptyWalletAction),
            ),
          ],
        ),
      ),
    );
  }
}
