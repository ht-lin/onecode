import 'package:barcode_widget/barcode_widget.dart';

import '../../../data/drift/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/code_validator.dart';

/// [CodeFormat] 的 UI 侧扩展：显示名与 `barcode_widget` 渲染器映射。
extension CodeFormatUi on CodeFormat {
  /// 码制专有名，不参与 i18n。
  String get label => switch (this) {
        CodeFormat.qrCode => 'QR Code',
        CodeFormat.aztec => 'Aztec',
        CodeFormat.dataMatrix => 'Data Matrix',
        CodeFormat.pdf417 => 'PDF417',
        CodeFormat.ean13 => 'EAN-13',
        CodeFormat.ean8 => 'EAN-8',
        CodeFormat.upcA => 'UPC-A',
        CodeFormat.upcE => 'UPC-E',
        CodeFormat.code128 => 'Code 128',
        CodeFormat.code39 => 'Code 39',
        CodeFormat.code93 => 'Code 93',
        CodeFormat.itf => 'ITF',
        CodeFormat.codabar => 'Codabar',
      };

  /// 字符集是否为纯数字（决定手动录入键盘类型，SPEC §3.1）。
  ///
  /// Codabar 数据字符含 `- $ : / . +` 与起止符 A–D，不算纯数字。
  bool get isNumericOnly => switch (this) {
        CodeFormat.ean13 ||
        CodeFormat.ean8 ||
        CodeFormat.upcA ||
        CodeFormat.upcE ||
        CodeFormat.itf =>
          true,
        _ => false,
      };

  /// 是否为二维码制（决定预览宽高比与展示页拉伸策略）。
  bool get is2d => switch (this) {
        CodeFormat.qrCode ||
        CodeFormat.aztec ||
        CodeFormat.dataMatrix ||
        CodeFormat.pdf417 =>
          true,
        _ => false,
      };

  Barcode get barcode => switch (this) {
        CodeFormat.qrCode => Barcode.qrCode(),
        CodeFormat.aztec => Barcode.aztec(),
        CodeFormat.dataMatrix => Barcode.dataMatrix(),
        CodeFormat.pdf417 => Barcode.pdf417(),
        CodeFormat.ean13 => Barcode.ean13(),
        CodeFormat.ean8 => Barcode.ean8(),
        CodeFormat.upcA => Barcode.upcA(),
        CodeFormat.upcE => Barcode.upcE(),
        CodeFormat.code128 => Barcode.code128(),
        CodeFormat.code39 => Barcode.code39(),
        CodeFormat.code93 => Barcode.code93(),
        CodeFormat.itf => Barcode.itf(),
        CodeFormat.codabar => Barcode.codabar(),
      };
}

/// [CodeIssue] 对应的本地化警示文案。
extension CodeIssueUi on CodeIssue {
  String message(AppLocalizations l10n, CodeFormat format) => switch (this) {
        CodeIssue.charset => l10n.codeIssueCharset(format.label),
        CodeIssue.length => l10n.codeIssueLength(format.label),
        CodeIssue.checkDigit => l10n.codeIssueCheckDigit(format.label),
      };
}
