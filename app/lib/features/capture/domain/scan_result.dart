import '../../../data/drift/enums.dart';

/// 取景/相册识别出的单个码（SPEC §3.1）。
class ScanResult {
  const ScanResult({required this.value, required this.format});

  /// 原始码值字符串。
  final String value;

  final CodeFormat format;
}
