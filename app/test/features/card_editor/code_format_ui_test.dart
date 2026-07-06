import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/enums.dart';
import 'package:onecode/features/card_editor/presentation/code_format_ui.dart';

void main() {
  group('isNumericOnly（键盘类型依据，SPEC §3.1）', () {
    const numeric = {
      CodeFormat.ean13,
      CodeFormat.ean8,
      CodeFormat.upcA,
      CodeFormat.upcE,
      CodeFormat.itf,
    };

    for (final format in CodeFormat.values) {
      test(
          '${format.label} → ${numeric.contains(format) ? '数字' : '文本'}键盘',
          () {
        expect(format.isNumericOnly, numeric.contains(format));
      });
    }
  });
}
