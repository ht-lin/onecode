import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/card_palette.dart';
import '../../../data/drift/app_database.dart';
import '../../../data/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/code_validator.dart';
import 'code_format_ui.dart';
import 'widgets/card_color_picker.dart';
import 'widgets/card_preview.dart';

/// 卡片编辑页（SPEC §3.1/§3.2）：三种录入方式与既有卡编辑共用。
///
/// - 新建：[cardId] 为 null；扫码/相册/手动入口可经 [initialCodeValue]、
///   [initialCodeFormat] 预填（M1-03/04/05）。
/// - 编辑：[cardId] 非 null，异步加载后预填全部字段。
class CardEditorPage extends ConsumerWidget {
  const CardEditorPage({
    super.key,
    this.cardId,
    this.initialCodeValue,
    this.initialCodeFormat,
  });

  final String? cardId;
  final String? initialCodeValue;
  final CodeFormat? initialCodeFormat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = cardId;
    if (id == null) {
      return _EditorForm(
        initialCodeValue: initialCodeValue,
        initialCodeFormat: initialCodeFormat,
      );
    }
    return FutureBuilder(
      future: ref.watch(cardRepositoryProvider).getCard(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final card = snapshot.data?.card;
        if (card == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Text(AppLocalizations.of(context).editorCardNotFound)),
          );
        }
        return _EditorForm(existing: card);
      },
    );
  }
}

class _EditorForm extends ConsumerStatefulWidget {
  const _EditorForm({
    this.existing,
    this.initialCodeValue,
    this.initialCodeFormat,
  });

  final CardRow? existing;
  final String? initialCodeValue;
  final CodeFormat? initialCodeFormat;

  @override
  ConsumerState<_EditorForm> createState() => _EditorFormState();
}

class _EditorFormState extends ConsumerState<_EditorForm> {
  final _formKey = GlobalKey<FormState>();

  late final _name = TextEditingController(text: widget.existing?.name);
  late final _codeValue = TextEditingController(
      text: widget.existing?.codeValue ?? widget.initialCodeValue);
  late final _note = TextEditingController(text: widget.existing?.note);

  // 手动输入默认 Code 128：兼容任意 ASCII（SPEC §3.1）。
  late CodeFormat _format = widget.existing?.codeFormat ??
      widget.initialCodeFormat ??
      CodeFormat.code128;
  late CardKind _kind = widget.existing?.cardKind ?? CardKind.loyalty;
  late DateTime? _expiresAt = widget.existing?.expiresAt;
  late Color _color = widget.existing == null
      ? CardPalette.defaultColor
      : CardPalette.parseHex(widget.existing!.color);

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _codeValue.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final issue = _codeValue.text.isEmpty
        ? null
        : CodeValidator.validate(_format, _codeValue.text);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null
            ? l10n.editorTitleNew
            : l10n.editorTitleEdit),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CardPreview(
              name: _name.text,
              codeValue: _codeValue.text,
              codeFormat: _format,
              color: _color,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.fieldName),
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.errorNameRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeValue,
              decoration: InputDecoration(
                labelText: l10n.fieldCodeValue,
                // 非法不设 errorText（不阻止保存），用 helper 样式警示。
                helperText: issue?.message(l10n, _format),
                helperStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error),
                helperMaxLines: 2,
              ),
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  (v == null || v.isEmpty) ? l10n.errorCodeValueRequired : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CodeFormat>(
              initialValue: _format,
              decoration: InputDecoration(labelText: l10n.fieldCodeFormat),
              items: [
                for (final f in CodeFormat.values)
                  DropdownMenuItem(value: f, child: Text(f.label)),
              ],
              onChanged: (f) => setState(() => _format = f!),
            ),
            const SizedBox(height: 24),
            Text(l10n.fieldCardKind,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<CardKind>(
              segments: [
                ButtonSegment(
                    value: CardKind.loyalty,
                    label: Text(l10n.kindLoyalty),
                    icon: const Icon(Icons.card_membership)),
                ButtonSegment(
                    value: CardKind.coupon,
                    label: Text(l10n.kindCoupon),
                    icon: const Icon(Icons.local_activity_outlined)),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            // 有效期仅优惠券可设（SPEC §3.2）。
            if (_kind == CardKind.coupon) ...[
              const SizedBox(height: 16),
              _ExpiryField(
                value: _expiresAt,
                onChanged: (d) => setState(() => _expiresAt = d),
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.fieldColor,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            CardColorPicker(
              selected: _color,
              onChanged: (c) => setState(() => _color = c),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _note,
              decoration: InputDecoration(labelText: l10n.fieldNote),
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final codeValue = _codeValue.text;

    // 非法码值警示但允许强制保存（SPEC §3.1：真实世界存在非标码）。
    if (CodeValidator.validate(_format, codeValue) != null) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.forceSaveTitle),
          content: Text(l10n.forceSaveBody(_format.label)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.forceSaveConfirm),
            ),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }

    setState(() => _saving = true);
    final repo = ref.read(cardRepositoryProvider);
    final note = _note.text.trim();
    // 会员卡无有效期（SPEC §3.2），切回 loyalty 时丢弃已选日期。
    final expiresAt = _kind == CardKind.coupon ? _expiresAt : null;

    try {
      final existing = widget.existing;
      if (existing == null) {
        await repo.createCard(
          name: _name.text.trim(),
          codeValue: codeValue,
          codeFormat: _format,
          cardKind: _kind,
          color: CardPalette.toHex(_color),
          note: note.isEmpty ? null : note,
          expiresAt: expiresAt,
        );
      } else {
        await repo.updateCard(
          existing.id,
          name: _name.text.trim(),
          codeValue: codeValue,
          codeFormat: _format,
          cardKind: _kind,
          color: CardPalette.toHex(_color),
          note: Value(note.isEmpty ? null : note),
          expiresAt: Value(expiresAt),
        );
      }
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

/// 有效期选择：只读文本框拉起日期选择器，仅存日期部分（UTC 零点）。
class _ExpiryField extends StatelessWidget {
  const _ExpiryField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 20),
        );
        if (picked != null) {
          onChanged(DateTime.utc(picked.year, picked.month, picked.day));
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldExpiry,
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today_outlined)
              : IconButton(
                  tooltip: l10n.removeExpiry,
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(value == null
            ? l10n.expiryNotSet
            : MaterialLocalizations.of(context).formatCompactDate(value!)),
      ),
    );
  }
}
