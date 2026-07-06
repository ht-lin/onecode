import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'display_environment.g.dart';

/// 展示页对系统显示能力的抽象（SPEC §3.4）：亮度拉满 + 屏幕常亮。
///
/// 真实实现走平台通道，widget 测试环境不可用——经此接口注入以便 mock。
abstract interface class DisplayEnvironment {
  /// 进入展示页：应用内亮度拉满 + 保持屏幕常亮。
  Future<void> enterDisplayMode();

  /// 退出展示页：恢复原亮度 + 释放常亮。
  Future<void> exitDisplayMode();
}

/// 基于 `screen_brightness` + `wakelock_plus` 的真实实现。
///
/// 亮度用应用级 API：只覆盖本应用窗口，系统亮度从未改变，
/// 因此崩溃/被杀等异常退出路径也自动"恢复原值"。
/// 两项能力互相独立容错——平台通道失败绝不阻塞码渲染（§4 核心路径）。
class SystemDisplayEnvironment implements DisplayEnvironment {
  @override
  Future<void> enterDisplayMode() async {
    await Future.wait([
      ScreenBrightness.instance
          .setApplicationScreenBrightness(1.0)
          .catchError((_) {}),
      WakelockPlus.enable().catchError((_) {}),
    ]);
  }

  @override
  Future<void> exitDisplayMode() async {
    await Future.wait([
      ScreenBrightness.instance
          .resetApplicationScreenBrightness()
          .catchError((_) {}),
      WakelockPlus.disable().catchError((_) {}),
    ]);
  }
}

@Riverpod(keepAlive: true)
DisplayEnvironment displayEnvironment(Ref ref) => SystemDisplayEnvironment();
