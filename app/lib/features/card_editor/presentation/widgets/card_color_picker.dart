import 'package:flutter/material.dart';

import '../../../../core/theme/card_palette.dart';
import '../../../../l10n/app_localizations.dart';

/// 卡面颜色选择（SPEC §3.2）：12 预置色 + 自定义色入口。
class CardColorPicker extends StatelessWidget {
  const CardColorPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Color selected;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPreset = CardPalette.presets
        .any((c) => c.toARGB32() == selected.toARGB32());
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final color in CardPalette.presets)
          _Swatch(
            color: color,
            selected: color.toARGB32() == selected.toARGB32(),
            onTap: () => onChanged(color),
          ),
        _CustomSwatch(
          // 自定义色被选中时显示当前色，否则显示色轮渐变。
          current: isPreset ? null : selected,
          tooltip: l10n.customColor,
          onTap: () async {
            final picked = await _CustomColorDialog.show(context, selected);
            if (picked != null) onChanged(picked);
          },
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.selected, this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 3)
              : null,
        ),
        child: selected
            ? Icon(Icons.check, color: CardPalette.foregroundFor(color))
            : null,
      ),
    );
  }
}

/// 自定义色入口：未选中时显示色轮渐变，已选自定义色时显示该颜色。
class _CustomSwatch extends StatelessWidget {
  const _CustomSwatch({this.current, required this.tooltip, this.onTap});

  final Color? current;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: current,
            gradient: current == null
                ? const SweepGradient(colors: [
                    Color(0xFFE53935),
                    Color(0xFFFDD835),
                    Color(0xFF43A047),
                    Color(0xFF1E88E5),
                    Color(0xFF8E24AA),
                    Color(0xFFE53935),
                  ])
                : null,
            border: current != null
                ? Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 3)
                : null,
          ),
          child: Icon(
            current != null ? Icons.check : Icons.colorize,
            color: current != null
                ? CardPalette.foregroundFor(current!)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

/// 极简 HSV 选色对话框（色相/饱和度/明度三滑杆），避免引入第三方选色库。
class _CustomColorDialog extends StatefulWidget {
  const _CustomColorDialog({required this.initial});

  final Color initial;

  static Future<Color?> show(BuildContext context, Color initial) =>
      showDialog<Color>(
        context: context,
        builder: (_) => _CustomColorDialog(initial: initial),
      );

  @override
  State<_CustomColorDialog> createState() => _CustomColorDialogState();
}

class _CustomColorDialogState extends State<_CustomColorDialog> {
  late HSVColor _hsv = HSVColor.fromColor(widget.initial);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _hsv.toColor();
    return AlertDialog(
      title: Text(l10n.customColor),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              CardPalette.toHex(color),
              style: TextStyle(color: CardPalette.foregroundFor(color)),
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.colorHue),
          Slider(
            max: 360,
            value: _hsv.hue,
            onChanged: (v) => setState(() => _hsv = _hsv.withHue(v)),
          ),
          Text(l10n.colorSaturation),
          Slider(
            value: _hsv.saturation,
            onChanged: (v) => setState(() => _hsv = _hsv.withSaturation(v)),
          ),
          Text(l10n.colorBrightness),
          Slider(
            value: _hsv.value,
            onChanged: (v) => setState(() => _hsv = _hsv.withValue(v)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(color),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
