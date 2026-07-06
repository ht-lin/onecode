import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/drift/enums.dart';
import '../domain/scan_result.dart';
import 'barcode_format_mapping.dart';

part 'image_code_analyzer.g.dart';

/// 静态图片条码识别抽象；widget 测试用 fake 覆写 provider。
abstract interface class ImageCodeAnalyzer {
  /// 识别 [path] 图片中的全部条码，返回去重后的候选（可能为空）。
  Future<List<ScanResult>> analyze(String path);
}

/// mobile_scanner `analyzeImage`（Android ML Kit / iOS Vision）。
class MobileScannerImageAnalyzer implements ImageCodeAnalyzer {
  @override
  Future<List<ScanResult>> analyze(String path) async {
    final controller = MobileScannerController();
    try {
      final capture = await controller.analyzeImage(
        path,
        formats: supportedScannerFormats,
      );
      return candidatesFromCapture(capture);
    } on MobileScannerBarcodeException {
      // 平台侧解码失败与"图中无码"同待遇：走失败提示分支。
      return const [];
    } finally {
      await controller.dispose();
    }
  }
}

/// [BarcodeCapture] → 候选列表：过滤空值与不支持的码制，
/// 按 (码制, 码值) 去重（同一码可被检测出多个实例），保持检测顺序。
List<ScanResult> candidatesFromCapture(BarcodeCapture? capture) {
  if (capture == null) return const [];
  final seen = <(CodeFormat, String)>{};
  return [
    for (final barcode in capture.barcodes)
      if (codeFormatFromScanner(barcode.format) case final format?)
        if (barcode.rawValue case final value? when value.isNotEmpty)
          if (seen.add((format, value)))
            ScanResult(value: value, format: format),
  ];
}

@Riverpod(keepAlive: true)
ImageCodeAnalyzer imageCodeAnalyzer(Ref ref) => MobileScannerImageAnalyzer();
