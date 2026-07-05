/// 连续识别防抖：同一码值在 [window] 内不重复触发（M1-03）。
///
/// 取景帧率下同一条码每秒可被识别多次；只放行与上次放行
/// 不同的码值，或距上次放行超过 [window] 的重复码值。
class ScanGate {
  ScanGate({
    this.window = const Duration(seconds: 2),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration window;
  final DateTime Function() _now;

  String? _lastValue;
  DateTime? _lastAt;

  /// 是否放行本次识别。放行时更新内部状态。
  bool admit(String value) {
    final now = _now();
    final lastAt = _lastAt;
    if (value == _lastValue &&
        lastAt != null &&
        now.difference(lastAt) < window) {
      return false;
    }
    _lastValue = value;
    _lastAt = now;
    return true;
  }
}
