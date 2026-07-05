import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../l10n/app_localizations.dart';
import '../data/barcode_format_mapping.dart';
import '../domain/scan_result.dart';

part 'scanner_view.g.dart';

typedef ScannerViewBuilder = Widget Function(
    ValueChanged<ScanResult> onDetect);

/// 取景视图构造器。真机走 [ScannerView]（相机平台通道）；
/// widget 测试覆写为 fake 以驱动识别回调。
@riverpod
ScannerViewBuilder scannerViewBuilder(Ref ref) =>
    (onDetect) => ScannerView(onDetect: onDetect);

/// 实时取景识别（SPEC §3.1 方式一）：识别框遮罩 + 手电筒开关。
class ScannerView extends StatefulWidget {
  const ScannerView({super.key, required this.onDetect});

  final ValueChanged<ScanResult> onDetect;

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final _controller =
      MobileScannerController(formats: supportedScannerFormats);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCapture(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final format = codeFormatFromScanner(barcode.format);
      final value = barcode.rawValue;
      if (format == null || value == null || value.isEmpty) continue;
      widget.onDetect(ScanResult(value: value, format: format));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      // 识别框仅为视觉引导，检测覆盖整个取景画面（识别更快，SPEC §4 < 1s）。
      final side = (constraints.maxWidth * 0.7).clamp(0.0, 320.0);
      final window = Rect.fromCenter(
        center: Offset(constraints.maxWidth / 2, constraints.maxHeight * 0.42),
        width: side,
        height: side,
      );
      return Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleCapture,
          ),
          IgnorePointer(
            child: CustomPaint(painter: _ScannerOverlayPainter(window)),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: window.bottom + 24,
            child: Text(
              l10n.scanHint,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(child: _TorchButton(controller: _controller)),
          ),
        ],
      );
    });
  }
}

class _TorchButton extends StatelessWidget {
  const _TorchButton({required this.controller});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, _) {
        if (state.torchState == TorchState.unavailable) {
          return const SizedBox.shrink();
        }
        final on = state.torchState == TorchState.on;
        return IconButton.filledTonal(
          tooltip: AppLocalizations.of(context).scanTorchTooltip,
          isSelected: on,
          icon: const Icon(Icons.flash_off),
          selectedIcon: const Icon(Icons.flash_on),
          iconSize: 32,
          onPressed: controller.toggleTorch,
        );
      },
    );
  }
}

/// 半透明遮罩挖出识别框，四角描亮色角标。
class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter(this.window);

  final Rect window;

  static const _radius = 16.0;
  static const _cornerLength = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect =
        RRect.fromRectAndRadius(window, const Radius.circular(_radius));
    final mask = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(mask, Paint()..color = Colors.black.withValues(alpha: .5));

    final corner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    // 每角一条 L 形短弧线（含圆角段）。
    for (final (dx, dy) in [(1, 1), (-1, 1), (1, -1), (-1, -1)]) {
      final anchorX = dx > 0 ? window.left : window.right;
      final anchorY = dy > 0 ? window.top : window.bottom;
      final path = Path()
        ..moveTo(anchorX + dx * _cornerLength, anchorY)
        ..lineTo(anchorX + dx * _radius, anchorY)
        ..arcToPoint(
          Offset(anchorX, anchorY + dy * _radius),
          radius: const Radius.circular(_radius),
          clockwise: dx * dy < 0,
        )
        ..lineTo(anchorX, anchorY + dy * _cornerLength);
      canvas.drawPath(path, corner);
    }
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter oldDelegate) =>
      oldDelegate.window != window;
}
