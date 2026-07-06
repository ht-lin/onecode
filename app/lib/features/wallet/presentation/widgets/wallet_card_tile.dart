import 'package:flutter/material.dart';

import '../../../../core/theme/card_palette.dart';
import '../../../../data/drift/app_database.dart';
import '../../../../data/repository/card_repository.dart';
import '../../../../l10n/app_localizations.dart';

/// 已过期卡面的置灰滤镜（SPEC §3.8）：去饱和为亮度灰阶。
const ColorFilter _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// 网格卡面（SPEC §3.3）：色块 + 名称，收藏星标，优惠券有效期角标；
/// 已过期整卡置灰并把角标替换为"已过期"（§3.8）。
class WalletCardTile extends StatelessWidget {
  const WalletCardTile({
    super.key,
    required this.entry,
    required this.expired,
    this.onTap,
    this.onLongPress,
  });

  final CardWithState entry;
  final bool expired;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final card = entry.card;
    final color = CardPalette.parseHex(card.color);
    final foreground = CardPalette.foregroundFor(color);

    final tile = Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      card.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: foreground, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (entry.isFavorite)
                    Icon(Icons.star_rounded, size: 20, color: foreground),
                ],
              ),
              const Spacer(),
              if (_badgeText(context) case final badge?)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (!expired) return tile;
    return Opacity(
      opacity: 0.65,
      child: ColorFiltered(colorFilter: _greyscale, child: tile),
    );
  }

  /// 角标文案：优惠券显示有效期（SPEC §3.3），已过期卡显示"已过期"。
  String? _badgeText(BuildContext context) {
    if (expired) return AppLocalizations.of(context).filterExpired;
    final expiresAt = entry.card.expiresAt;
    if (entry.card.cardKind != CardKind.coupon || expiresAt == null) {
      return null;
    }
    return MaterialLocalizations.of(context).formatCompactDate(expiresAt);
  }
}
