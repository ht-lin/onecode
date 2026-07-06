import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../card_editor/presentation/code_format_ui.dart';
import '../data/gallery_image_picker.dart';
import '../data/image_code_analyzer.dart';
import '../domain/scan_result.dart';

/// 相册图片识别录入页（SPEC §3.1 方式二，M1-04）。
///
/// 打开即调系统选图器：取消 → 返回；无码/解码失败 → 失败提示
/// （可能原因 + 换图/手动输入兜底）；单码 → 与扫码同路径替换为
/// 编辑页预填；多码 → 候选列表（码值 + 码制）供选择。
class ImageCapturePage extends ConsumerStatefulWidget {
  const ImageCapturePage({super.key});

  @override
  ConsumerState<ImageCapturePage> createState() => _ImageCapturePageState();
}

sealed class _Stage {
  const _Stage();
}

/// 选图器打开中 / 识别中。
class _Working extends _Stage {
  const _Working();
}

/// 未识别出任何码。
class _NoCode extends _Stage {
  const _NoCode();
}

/// 一图多码：等用户从候选中选择。
class _Candidates extends _Stage {
  const _Candidates(this.results);

  final List<ScanResult> results;
}

class _ImageCapturePageState extends ConsumerState<ImageCapturePage> {
  _Stage _stage = const _Working();

  @override
  void initState() {
    super.initState();
    _pickAndAnalyze();
  }

  Future<void> _pickAndAnalyze() async {
    setState(() => _stage = const _Working());
    final path = await ref.read(galleryImagePickerProvider).pickImagePath();
    if (!mounted) return;
    if (path == null) {
      // 用户取消选图 = 放弃本次录入。
      context.pop();
      return;
    }
    final results = await ref.read(imageCodeAnalyzerProvider).analyze(path);
    if (!mounted) return;
    switch (results) {
      case []:
        setState(() => _stage = const _NoCode());
      case [final single]:
        _useResult(single);
      default:
        setState(() => _stage = _Candidates(results));
    }
  }

  /// 与扫码确认后同路径：替换为编辑页，码值与码制预填。
  void _useResult(ScanResult result) => context.pushReplacement(
      AppRoutes.cardNewPrefilled(result.value, result.format.wire));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.imageCaptureTitle)),
      body: switch (_stage) {
        _Working() => const Center(child: CircularProgressIndicator()),
        _NoCode() => _NoCodePane(onPickAnother: _pickAndAnalyze),
        _Candidates(:final results) =>
          _CandidateList(results: results, onSelect: _useResult),
      },
    );
  }
}

/// 识别失败提示：可能原因 + 换一张图 / 手动输入兜底。
class _NoCodePane extends StatelessWidget {
  const _NoCodePane({required this.onPickAnother});

  final VoidCallback onPickAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.image_search_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(l10n.imageNoCodeTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(l10n.imageNoCodeBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onPickAnother,
              child: Text(l10n.imagePickAnother),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.pushReplacement(AppRoutes.cardNew),
              child: Text(l10n.imageEnterManually),
            ),
          ],
        ),
      ),
    );
  }
}

/// 一图多码候选列表：码值 + 码制（SPEC §3.1）。
class _CandidateList extends StatelessWidget {
  const _CandidateList({required this.results, required this.onSelect});

  final List<ScanResult> results;
  final ValueChanged<ScanResult> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(l10n.imageMultiHint, style: theme.textTheme.bodyLarge),
        ),
        for (final result in results)
          ListTile(
            leading: const Icon(Icons.qr_code_2_outlined),
            title: Text(
              result.value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontFamily: 'monospace'),
            ),
            subtitle: Text(result.format.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onSelect(result),
          ),
      ],
    );
  }
}
