import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/features/capture/domain/scan_gate.dart';

void main() {
  test('同一码 2s 内不重复触发，超窗后放行', () {
    var now = DateTime(2026, 7, 6);
    final gate = ScanGate(now: () => now);

    expect(gate.admit('4006381333931'), isTrue);

    now = now.add(const Duration(milliseconds: 500));
    expect(gate.admit('4006381333931'), isFalse);

    now = now.add(const Duration(milliseconds: 1499)); // 距放行 1999ms
    expect(gate.admit('4006381333931'), isFalse);

    now = now.add(const Duration(milliseconds: 1));
    expect(gate.admit('4006381333931'), isTrue);
  });

  test('不同码值立即放行', () {
    var now = DateTime(2026, 7, 6);
    final gate = ScanGate(now: () => now);

    expect(gate.admit('AAA'), isTrue);
    expect(gate.admit('BBB'), isTrue);
    // 换码后再回到旧码：以最近一次放行为基准，旧码不再被抑制。
    expect(gate.admit('AAA'), isTrue);
  });
}
