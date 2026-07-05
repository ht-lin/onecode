import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/enums.dart';
import 'package:onecode/features/card_editor/domain/code_validator.dart';

void main() {
  void expectValid(CodeFormat format, String value) {
    expect(CodeValidator.validate(format, value), isNull,
        reason: '$format 应接受 "$value"');
  }

  void expectIssue(CodeFormat format, String value, CodeIssue issue) {
    expect(CodeValidator.validate(format, value), issue,
        reason: '$format 对 "$value" 应报 $issue');
  }

  test('空值对所有码制都是长度问题', () {
    for (final format in CodeFormat.values) {
      expectIssue(format, '', CodeIssue.length);
    }
  });

  group('2D 码制：任意内容，仅限容量', () {
    test('QR Code', () {
      expectValid(CodeFormat.qrCode, 'https://onecode.example/u/123?t=abc');
      expectValid(CodeFormat.qrCode, '你好 OneCode ✓');
      expectValid(CodeFormat.qrCode, 'a' * 2953);
      expectIssue(CodeFormat.qrCode, 'a' * 2954, CodeIssue.length);
      // 容量按 UTF-8 字节计：985 个三字节汉字 = 2955 字节。
      expectIssue(CodeFormat.qrCode, '码' * 985, CodeIssue.length);
    });

    test('Aztec', () {
      expectValid(CodeFormat.aztec, 'GUTSCHEIN-2026/07');
      expectIssue(CodeFormat.aztec, 'a' * 1915, CodeIssue.length);
    });

    test('Data Matrix', () {
      expectValid(CodeFormat.dataMatrix, 'DM Beispiel 001');
      expectIssue(CodeFormat.dataMatrix, 'a' * 1557, CodeIssue.length);
    });

    test('PDF417', () {
      expectValid(CodeFormat.pdf417, 'PDF417|Feld1|Feld2');
      expectIssue(CodeFormat.pdf417, 'a' * 1109, CodeIssue.length);
    });
  });

  group('EAN/UPC：定长数字 + mod-10 校验位', () {
    test('EAN-13', () {
      expectValid(CodeFormat.ean13, '4006381333931');
      expectValid(CodeFormat.ean13, '5901234123457');
      expectIssue(CodeFormat.ean13, '4006381333930', CodeIssue.checkDigit);
      expectIssue(CodeFormat.ean13, '400638133393', CodeIssue.length);
      expectIssue(CodeFormat.ean13, '40063813339311', CodeIssue.length);
      expectIssue(CodeFormat.ean13, '400638133393a', CodeIssue.charset);
    });

    test('EAN-8', () {
      expectValid(CodeFormat.ean8, '73513537');
      expectIssue(CodeFormat.ean8, '73513536', CodeIssue.checkDigit);
      expectIssue(CodeFormat.ean8, '7351353', CodeIssue.length);
      expectIssue(CodeFormat.ean8, '7351353X', CodeIssue.charset);
    });

    test('UPC-A', () {
      expectValid(CodeFormat.upcA, '036000291452');
      expectIssue(CodeFormat.upcA, '036000291453', CodeIssue.checkDigit);
      expectIssue(CodeFormat.upcA, '03600029145', CodeIssue.length);
      expectIssue(CodeFormat.upcA, '03600029145!', CodeIssue.charset);
    });

    test('UPC-E：8 位验校验位（经 UPC-A 扩展），6 位纯数据直接放行', () {
      // 04252614 ↔ UPC-A 042100005264
      expectValid(CodeFormat.upcE, '04252614');
      expectValid(CodeFormat.upcE, '425261');
      expectIssue(CodeFormat.upcE, '04252615', CodeIssue.checkDigit);
      expectIssue(CodeFormat.upcE, '0425261', CodeIssue.length);
      // 数字系统位仅允许 0/1。
      expectIssue(CodeFormat.upcE, '84252614', CodeIssue.charset);
      expectIssue(CodeFormat.upcE, '0425261x', CodeIssue.charset);
    });
  });

  group('一维字符码制', () {
    test('Code 128：完整 ASCII', () {
      expectValid(CodeFormat.code128, 'OneCode-2026 #15/b');
      expectValid(CodeFormat.code128, 'kleinschreibung ok');
      expectIssue(CodeFormat.code128, 'Größe', CodeIssue.charset);
    });

    test('Code 39：大写字母数字 + -. \$/+%', () {
      expectValid(CodeFormat.code39, 'CODE-39 TEST. 10%');
      expectIssue(CodeFormat.code39, 'code39', CodeIssue.charset);
      expectIssue(CodeFormat.code39, 'AB*CD', CodeIssue.charset);
    });

    test('Code 93：标准字符集同 Code 39', () {
      expectValid(CodeFormat.code93, 'CODE+93/X');
      expectIssue(CodeFormat.code93, 'äöü', CodeIssue.charset);
    });

    test('ITF：纯数字且偶数位', () {
      expectValid(CodeFormat.itf, '1234567890');
      expectValid(CodeFormat.itf, '04');
      expectIssue(CodeFormat.itf, '12345', CodeIssue.length);
      expectIssue(CodeFormat.itf, '12A4', CodeIssue.charset);
    });

    test('Codabar：可选成对起止符 A–D，数据 0-9 -\$:/.+', () {
      expectValid(CodeFormat.codabar, 'A2026-07\$B');
      expectValid(CodeFormat.codabar, '31117013206375');
      expectValid(CodeFormat.codabar, 'c123:456/789d');
      // 起止符必须成对：夹在数据中的字母不合法。
      expectIssue(CodeFormat.codabar, 'A31B17', CodeIssue.charset);
      expectIssue(CodeFormat.codabar, '123E456', CodeIssue.charset);
      expectIssue(CodeFormat.codabar, 'AB', CodeIssue.length);
    });
  });
}
