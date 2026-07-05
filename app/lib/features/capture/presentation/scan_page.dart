import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../card_editor/presentation/code_format_ui.dart';
import '../data/camera_permission_service.dart';
import '../domain/scan_gate.dart';
import '../domain/scan_result.dart';
import 'scanner_view.dart';

/// 摄像头扫码录入页（SPEC §3.1 方式一，M1-03）。
///
/// 权限分支：授予 → 取景识别；未授予 → 请求文案页；
/// 永久拒绝/请求被拒 → 跳系统设置的引导页（从设置返回时自动重查）。
/// 识别成功：震动 + 底部预览（码值/码制）→ 确认后替换为编辑页预填。
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

enum _ScanStatus { loading, scanning, rationale, blocked }

class _ScanPageState extends ConsumerState<ScanPage>
    with WidgetsBindingObserver {
  final _gate = ScanGate();
  _ScanStatus _status = _ScanStatus.loading;
  bool _requesting = false;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 从系统设置返回后重查权限，授予则直接进入取景。
    if (state == AppLifecycleState.resumed &&
        !_requesting &&
        (_status == _ScanStatus.blocked || _status == _ScanStatus.rationale)) {
      _refreshStatus();
    }
  }

  Future<void> _refreshStatus() async {
    final permission =
        await ref.read(cameraPermissionServiceProvider).status();
    if (!mounted) return;
    setState(() {
      _status = switch (permission) {
        CameraPermission.granted => _ScanStatus.scanning,
        CameraPermission.denied => _ScanStatus.rationale,
        CameraPermission.permanentlyDenied => _ScanStatus.blocked,
      };
    });
  }

  Future<void> _requestPermission() async {
    setState(() => _requesting = true);
    final permission =
        await ref.read(cameraPermissionServiceProvider).request();
    if (!mounted) return;
    setState(() {
      _requesting = false;
      // 系统对话框被拒后不再重复弹窗，改走系统设置引导。
      _status = permission == CameraPermission.granted
          ? _ScanStatus.scanning
          : _ScanStatus.blocked;
    });
  }

  Future<void> _onDetect(ScanResult result) async {
    if (_sheetOpen || !_gate.admit(result.value)) return;
    _sheetOpen = true;
    HapticFeedback.mediumImpact();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => _ResultSheet(result: result),
    );
    _sheetOpen = false;
    if (confirmed == true && mounted) {
      context.pushReplacement(
          AppRoutes.cardNewPrefilled(result.value, result.format.wire));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanning = _status == _ScanStatus.scanning;
    return Scaffold(
      backgroundColor: scanning ? Colors.black : null,
      extendBodyBehindAppBar: scanning,
      appBar: AppBar(
        title: Text(l10n.scanTitle),
        backgroundColor: scanning ? Colors.transparent : null,
        foregroundColor: scanning ? Colors.white : null,
      ),
      body: switch (_status) {
        _ScanStatus.loading =>
          const Center(child: CircularProgressIndicator()),
        _ScanStatus.scanning => ref.watch(scannerViewBuilderProvider)(
            _onDetect),
        _ScanStatus.rationale => _PermissionPane(
            icon: Icons.photo_camera_outlined,
            body: l10n.scanPermissionRationale,
            buttonLabel: l10n.scanPermissionAllow,
            onPressed: _requesting ? null : _requestPermission,
          ),
        _ScanStatus.blocked => _PermissionPane(
            icon: Icons.no_photography_outlined,
            body: l10n.scanPermissionDeniedBody,
            buttonLabel: l10n.scanOpenSettings,
            onPressed: () =>
                ref.read(cameraPermissionServiceProvider).openSystemSettings(),
          ),
      },
    );
  }
}

/// 权限请求文案页 / 拒绝后的系统设置引导页。
class _PermissionPane extends StatelessWidget {
  const _PermissionPane({
    required this.icon,
    required this.body,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String body;
  final String buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}

/// 识别成功的底部预览：码值 + 码制，确认或继续扫描。
class _ResultSheet extends StatelessWidget {
  const _ResultSheet({required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.scanResultTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(label: Text(result.format.label)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.value,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.scanUseCode),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.scanRescan),
            ),
          ],
        ),
      ),
    );
  }
}
