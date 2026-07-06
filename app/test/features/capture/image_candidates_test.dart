import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:onecode/data/drift/enums.dart';
import 'package:onecode/features/capture/data/image_code_analyzer.dart';

/// 一图多码候选提取（M1-04）：过滤、去重、保序。
void main() {
  group('candidatesFromCapture', () {
    test('null capture（平台未识别到码）→ 空候选', () {
      expect(candidatesFromCapture(null), isEmpty);
    });

    test('过滤空码值与不支持的码制', () {
      const capture = BarcodeCapture(barcodes: [
        Barcode(rawValue: null, format: BarcodeFormat.qrCode),
        Barcode(rawValue: '', format: BarcodeFormat.qrCode),
        Barcode(rawValue: 'x', format: BarcodeFormat.unknown),
        Barcode(rawValue: '4006381333931', format: BarcodeFormat.ean13),
      ]);

      final candidates = candidatesFromCapture(capture);

      expect(candidates, hasLength(1));
      expect(candidates.single.value, '4006381333931');
      expect(candidates.single.format, CodeFormat.ean13);
    });

    test('同码值同码制去重（同一码被检测出多个实例）', () {
      const capture = BarcodeCapture(barcodes: [
        Barcode(rawValue: 'ABC', format: BarcodeFormat.code128),
        Barcode(rawValue: 'ABC', format: BarcodeFormat.code128),
        Barcode(rawValue: 'ABC', format: BarcodeFormat.code128),
      ]);

      expect(candidatesFromCapture(capture), hasLength(1));
    });

    test('同码值不同码制保留为独立候选', () {
      const capture = BarcodeCapture(barcodes: [
        Barcode(rawValue: 'ABC', format: BarcodeFormat.code128),
        Barcode(rawValue: 'ABC', format: BarcodeFormat.code39),
      ]);

      final candidates = candidatesFromCapture(capture);

      expect(candidates, hasLength(2));
      expect(candidates[0].format, CodeFormat.code128);
      expect(candidates[1].format, CodeFormat.code39);
    });

    test('多码保持检测顺序', () {
      const capture = BarcodeCapture(barcodes: [
        Barcode(rawValue: 'coupon-1', format: BarcodeFormat.qrCode),
        Barcode(rawValue: '4006381333931', format: BarcodeFormat.ean13),
        Barcode(rawValue: 'coupon-2', format: BarcodeFormat.qrCode),
      ]);

      expect(
        candidatesFromCapture(capture).map((c) => c.value),
        ['coupon-1', '4006381333931', 'coupon-2'],
      );
    });

    test('ITF 平台变体统一映射到本地 ITF 并互相去重', () {
      const capture = BarcodeCapture(barcodes: [
        Barcode(rawValue: '12345678901231', format: BarcodeFormat.itf14),
        Barcode(rawValue: '12345678901231', format: BarcodeFormat.itf2of5),
      ]);

      final candidates = candidatesFromCapture(capture);

      expect(candidates, hasLength(1));
      expect(candidates.single.format, CodeFormat.itf);
    });
  });
}
