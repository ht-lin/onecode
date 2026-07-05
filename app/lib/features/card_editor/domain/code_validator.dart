import 'dart:convert';

import '../../../data/drift/enums.dart';

/// 码值不符合所选码制时的原因分类（SPEC §3.1）。
///
/// 校验失败**不阻止保存**——真实世界存在非标码，UI 据此警示并提供强制保存。
enum CodeIssue {
  /// 含有该码制字符集之外的字符。
  charset,

  /// 长度不符（定长码制位数不对、ITF 奇数位、2D 码超容量、空值）。
  length,

  /// 校验位不匹配（EAN-13/8、UPC-A/E）。
  checkDigit,
}

/// 按码制校验码值合法性。返回 `null` 表示合法。
///
/// 规则来源：GS1 通用规范（EAN/UPC 校验位）、各码制符号学标准字符集。
/// 2D 码只做容量上限检查（字节数按 UTF-8 计）。
abstract final class CodeValidator {
  static final _digits = RegExp(r'^\d+$');
  static final _code39 = RegExp(r'^[0-9A-Z\-. $/+%]+$');
  static final _codabarBody = RegExp(r'^[0-9\-$:/.+]+$');

  /// 2D 码制的最大 UTF-8 字节容量（二进制模式、最低纠错等级）。
  static const _maxBytes = <CodeFormat, int>{
    CodeFormat.qrCode: 2953,
    CodeFormat.aztec: 1914,
    CodeFormat.dataMatrix: 1556,
    CodeFormat.pdf417: 1108,
  };

  static CodeIssue? validate(CodeFormat format, String value) {
    if (value.isEmpty) return CodeIssue.length;

    switch (format) {
      case CodeFormat.qrCode:
      case CodeFormat.aztec:
      case CodeFormat.dataMatrix:
      case CodeFormat.pdf417:
        return utf8.encode(value).length > _maxBytes[format]!
            ? CodeIssue.length
            : null;

      case CodeFormat.ean13:
        return _gtin(value, 13);
      case CodeFormat.ean8:
        return _gtin(value, 8);
      case CodeFormat.upcA:
        return _gtin(value, 12);
      case CodeFormat.upcE:
        return _upcE(value);

      case CodeFormat.code128:
        // Code Set A/B/C 合计覆盖完整 ASCII（0–127）。
        return value.codeUnits.every((u) => u <= 127)
            ? null
            : CodeIssue.charset;

      case CodeFormat.code39:
      case CodeFormat.code93:
        // Code 93 标准字符集与 Code 39 相同（43 字符 + 空格）。
        return _code39.hasMatch(value) ? null : CodeIssue.charset;

      case CodeFormat.itf:
        if (!_digits.hasMatch(value)) return CodeIssue.charset;
        return value.length.isEven ? null : CodeIssue.length;

      case CodeFormat.codabar:
        return _codabar(value);
    }
  }

  /// 定长数字码 + GS1 mod-10 校验位（末位）。
  static CodeIssue? _gtin(String value, int length) {
    if (!_digits.hasMatch(value)) return CodeIssue.charset;
    if (value.length != length) return CodeIssue.length;
    return _checkDigit(value.substring(0, length - 1)) ==
            int.parse(value[length - 1])
        ? null
        : CodeIssue.checkDigit;
  }

  /// GS1 mod-10：自右向左交替加权 3/1（紧邻校验位的权重为 3）。
  static int _checkDigit(String payload) {
    var sum = 0;
    for (var i = 0; i < payload.length; i++) {
      final digit = payload.codeUnitAt(payload.length - 1 - i) - 0x30;
      sum += digit * (i.isEven ? 3 : 1);
    }
    return (10 - sum % 10) % 10;
  }

  /// UPC-E：6 位（纯数据，无校验位可验）或 8 位
  /// （数字系统位 0/1 + 6 位数据 + 校验位，校验位按扩展后的 UPC-A 计算）。
  static CodeIssue? _upcE(String value) {
    if (!_digits.hasMatch(value)) return CodeIssue.charset;
    if (value.length == 6) return null;
    if (value.length != 8) return CodeIssue.length;
    if (value[0] != '0' && value[0] != '1') return CodeIssue.charset;
    final upcA = _upcEToUpcA(value[0], value.substring(1, 7));
    return _checkDigit(upcA) == int.parse(value[7])
        ? null
        : CodeIssue.checkDigit;
  }

  /// UPC-E → UPC-A 前 11 位扩展（GS1 压缩规则，按末位数据位分派）。
  static String _upcEToUpcA(String system, String d) {
    final body = switch (d[5]) {
      '0' || '1' || '2' =>
        '${d.substring(0, 2)}${d[5]}0000${d.substring(2, 5)}',
      '3' => '${d.substring(0, 3)}00000${d.substring(3, 5)}',
      '4' => '${d.substring(0, 4)}00000${d[4]}',
      _ => '${d.substring(0, 5)}0000${d[5]}',
    };
    return '$system$body';
  }

  /// Codabar：起止符 A–D 可选（须成对出现），数据字符集 `0-9 - $ : / . +`。
  static CodeIssue? _codabar(String value) {
    var body = value;
    final startStop = RegExp(r'^[A-Da-d].*[A-Da-d]$');
    if (value.length >= 2 && startStop.hasMatch(value)) {
      body = value.substring(1, value.length - 1);
      if (body.isEmpty) return CodeIssue.length;
    }
    return _codabarBody.hasMatch(body) ? null : CodeIssue.charset;
  }
}
