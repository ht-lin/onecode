import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/card_palette.dart';
import '../../../../data/drift/enums.dart';
import '../../../../l10n/app_localizations.dart';
import '../code_format_ui.dart';

/// 编辑页顶部实时预览：卡面色 + 名称 + 当前码值/码制的图形码（SPEC §3.1）。
///
/// 渲染交给 `barcode_widget`，其校验比 [CodeValidator] 更严格
/// （如 Codabar 起止符、ITF 位数），失败时经 `errorBuilder` 显示占位提示——
/// 与"允许强制保存"策略一致，预览失败不阻塞任何操作。
class CardPreview extends StatelessWidget {
  const CardPreview({
    super.key,
    required this.name,
    required this.codeValue,
    required this.codeFormat,
    required this.color,
  });

  final String name;
  final String codeValue;
  final CodeFormat codeFormat;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foreground = CardPalette.foregroundFor(color);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isEmpty ? l10n.editorTitleNew : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          // 码图形始终画在白底上，保证扫码对比度（与展示页一致）。
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            height: codeFormat.is2d ? 160 : 96,
            child: codeValue.isEmpty
                ? _placeholder(context, l10n)
                : BarcodeWidget(
                    barcode: codeFormat.barcode,
                    data: codeValue,
                    color: Colors.black,
                    drawText: false,
                    errorBuilder: (context, error) =>
                        _placeholder(context, l10n),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context, AppLocalizations l10n) => Center(
        child: Text(
          l10n.previewInvalid,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
      );
}
