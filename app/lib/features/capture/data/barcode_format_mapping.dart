import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/drift/enums.dart';

/// 传给 [MobileScannerController.formats] 的支持列表
/// （SPEC §3.1 全部 13 种码制）。
const supportedScannerFormats = <BarcodeFormat>[
  BarcodeFormat.qrCode,
  BarcodeFormat.aztec,
  BarcodeFormat.dataMatrix,
  BarcodeFormat.pdf417,
  BarcodeFormat.ean13,
  BarcodeFormat.ean8,
  BarcodeFormat.upcA,
  BarcodeFormat.upcE,
  BarcodeFormat.code128,
  BarcodeFormat.code39,
  BarcodeFormat.code93,
  BarcodeFormat.itf14,
  BarcodeFormat.codabar,
];

/// mobile_scanner 码制 → 本地 [CodeFormat]；未知/不支持返回 null。
CodeFormat? codeFormatFromScanner(BarcodeFormat format) => switch (format) {
      BarcodeFormat.qrCode => CodeFormat.qrCode,
      BarcodeFormat.aztec => CodeFormat.aztec,
      BarcodeFormat.dataMatrix => CodeFormat.dataMatrix,
      BarcodeFormat.pdf417 => CodeFormat.pdf417,
      BarcodeFormat.ean13 => CodeFormat.ean13,
      BarcodeFormat.ean8 => CodeFormat.ean8,
      BarcodeFormat.upcA => CodeFormat.upcA,
      BarcodeFormat.upcE => CodeFormat.upcE,
      BarcodeFormat.code128 => CodeFormat.code128,
      BarcodeFormat.code39 => CodeFormat.code39,
      BarcodeFormat.code93 => CodeFormat.code93,
      // ITF 的三个平台变体（ML Kit itf14、Apple Vision itf2of5±校验）
      // 统一落到本地唯一的 ITF 码制。
      BarcodeFormat.itf14 ||
      BarcodeFormat.itf2of5 ||
      BarcodeFormat.itf2of5WithChecksum =>
        CodeFormat.itf,
      BarcodeFormat.codabar => CodeFormat.codabar,
      _ => null,
    };
