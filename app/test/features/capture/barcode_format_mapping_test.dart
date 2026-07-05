import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:onecode/data/drift/enums.dart';
import 'package:onecode/features/capture/data/barcode_format_mapping.dart';

void main() {
  test('支持列表覆盖 SPEC §3.1 全部 13 种码制', () {
    expect(supportedScannerFormats, hasLength(13));
    final mapped = supportedScannerFormats.map(codeFormatFromScanner).toSet();
    expect(mapped, CodeFormat.values.toSet());
  });

  test('逐一映射', () {
    expect(codeFormatFromScanner(BarcodeFormat.qrCode), CodeFormat.qrCode);
    expect(codeFormatFromScanner(BarcodeFormat.aztec), CodeFormat.aztec);
    expect(
        codeFormatFromScanner(BarcodeFormat.dataMatrix), CodeFormat.dataMatrix);
    expect(codeFormatFromScanner(BarcodeFormat.pdf417), CodeFormat.pdf417);
    expect(codeFormatFromScanner(BarcodeFormat.ean13), CodeFormat.ean13);
    expect(codeFormatFromScanner(BarcodeFormat.ean8), CodeFormat.ean8);
    expect(codeFormatFromScanner(BarcodeFormat.upcA), CodeFormat.upcA);
    expect(codeFormatFromScanner(BarcodeFormat.upcE), CodeFormat.upcE);
    expect(codeFormatFromScanner(BarcodeFormat.code128), CodeFormat.code128);
    expect(codeFormatFromScanner(BarcodeFormat.code39), CodeFormat.code39);
    expect(codeFormatFromScanner(BarcodeFormat.code93), CodeFormat.code93);
    expect(codeFormatFromScanner(BarcodeFormat.codabar), CodeFormat.codabar);
  });

  test('ITF 平台变体统一映射到本地 ITF', () {
    expect(codeFormatFromScanner(BarcodeFormat.itf14), CodeFormat.itf);
    expect(codeFormatFromScanner(BarcodeFormat.itf2of5), CodeFormat.itf);
    expect(codeFormatFromScanner(BarcodeFormat.itf2of5WithChecksum),
        CodeFormat.itf);
  });

  test('未知/聚合值不映射', () {
    expect(codeFormatFromScanner(BarcodeFormat.unknown), isNull);
    expect(codeFormatFromScanner(BarcodeFormat.all), isNull);
  });
}
