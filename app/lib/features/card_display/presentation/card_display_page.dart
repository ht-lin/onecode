import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/card_palette.dart';
import '../../../data/drift/enums.dart';
import '../../../data/providers.dart';
import '../../../data/repository/card_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../card_editor/presentation/code_format_ui.dart';
import '../application/display_environment.dart';
import 'card_display_providers.dart';

/// 卡片展示页（SPEC §3.4，收银台性能关键路径）：
/// 码图形最大化居中 + 码值明文，进入亮度拉满、屏幕常亮，退出恢复。
/// 数据只读本地库，零网络请求——服务端不可用不影响此路径（§4）。
class CardDisplayPage extends ConsumerStatefulWidget {
  const CardDisplayPage({super.key, required this.cardId});

  final String cardId;

  @override
  ConsumerState<CardDisplayPage> createState() => _CardDisplayPageState();
}

class _CardDisplayPageState extends ConsumerState<CardDisplayPage> {
  /// 整屏旋转状态：0 = 竖屏，1 = 顺时针 90°（一维码用长边）。
  int _quarterTurns = 0;

  /// dispose 阶段不可再用 ref，进入时留存实例。
  late final DisplayEnvironment _env;

  @override
  void initState() {
    super.initState();
    _env = ref.read(displayEnvironmentProvider);
    // 均不 await：亮度/常亮与使用时间戳都不得阻塞码渲染（< 300ms，§4）。
    unawaited(_env.enterDisplayMode());
    // 展示即视为使用，驱动卡包"最近使用倒序"（SPEC §3.3）。
    unawaited(ref.read(cardRepositoryProvider).touchLastUsed(widget.cardId));
  }

  @override
  void dispose() {
    // 所有退出路径（返回键、系统返回手势、pop）都经 dispose 恢复亮度/常亮。
    unawaited(_env.exitDisplayMode());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardAsync = ref.watch(displayCardProvider(widget.cardId));
    final entry = cardAsync.value;

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: cardAsync.isLoading
              ? const CircularProgressIndicator()
              : Text(l10n.editorCardNotFound),
        ),
      );
    }

    final color = CardPalette.parseHex(entry.card.color);
    final foreground = CardPalette.foregroundFor(color);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: foreground,
        title: Text(entry.card.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.screen_rotation),
            tooltip: l10n.displayRotateTooltip,
            onPressed: () =>
                setState(() => _quarterTurns = _quarterTurns == 0 ? 1 : 0),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.displayDetailsTooltip,
            onPressed: () => _showDetails(entry),
          ),
        ],
      ),
      body: SafeArea(
        child: RotatedBox(
          quarterTurns: _quarterTurns,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _CodeView(
                      codeValue: entry.card.codeValue,
                      codeFormat: entry.card.codeFormat,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                // 码值明文：扫码失败时供收银员手工输入兜底（SPEC §3.4）。
                child: SelectableText(
                  entry.card.codeValue,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(letterSpacing: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 次要入口（SPEC §3.4）：卡详情——备注/有效期查看 + 编辑/删除。
  Future<void> _showDetails(CardWithState entry) {
    final l10n = AppLocalizations.of(context);
    final card = entry.card;
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(card.name),
              subtitle: Text(
                '${card.cardKind == CardKind.coupon ? l10n.kindCoupon : l10n.kindLoyalty}'
                ' · ${card.codeFormat.label}',
              ),
            ),
            if (card.expiresAt case final expiresAt?)
              ListTile(
                leading: const Icon(Icons.event_outlined),
                title: Text(l10n.fieldExpiry),
                subtitle: Text(MaterialLocalizations.of(context)
                    .formatCompactDate(expiresAt)),
              ),
            if (card.note case final note? when note.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.notes_outlined),
                title: Text(l10n.fieldNote),
                subtitle: Text(note),
              ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.cardActionEdit),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.cardEdit(card.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.cardActionDelete),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _confirmDelete(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(CardWithState entry) async {
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
    if (confirmed != true) return;
    // 软删除（SPEC §3.3/§6.1），随后退出展示页回卡包。
    await ref.read(cardRepositoryProvider).softDeleteCard(entry.card.id);
    if (mounted) context.pop();
  }
}

/// 码图形最大化渲染：始终黑码白底保证扫码对比度（含 OLED 深色模式）。
///
/// 二维码按固有宽高比撑满可用区域的短边；一维码横向拉满、
/// 高度固定为可扫尺寸（SPEC §3.4，配合整屏旋转用长边）。
class _CodeView extends StatelessWidget {
  const _CodeView({required this.codeValue, required this.codeFormat});

  final String codeValue;
  final CodeFormat codeFormat;

  @override
  Widget build(BuildContext context) {
    final code = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: BarcodeWidget(
        barcode: codeFormat.barcode,
        data: codeValue,
        color: Colors.black,
        drawText: false,
        errorBuilder: (context, error) => Center(
          child: Text(
            AppLocalizations.of(context).previewInvalid,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black54),
          ),
        ),
      ),
    );
    if (!codeFormat.is2d) {
      return SizedBox(width: double.infinity, height: 200, child: code);
    }
    return AspectRatio(
      // PDF417 固有宽扁，其余二维码方形。
      aspectRatio: codeFormat == CodeFormat.pdf417 ? 5 / 2 : 1,
      child: code,
    );
  }
}
