import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_permission_service.g.dart';

/// 相机权限的三态归并：授予 / 可再请求的拒绝 / 永久拒绝（只能去系统设置）。
enum CameraPermission { granted, denied, permanentlyDenied }

/// 相机权限操作抽象；widget 测试用 fake 覆写 provider。
abstract interface class CameraPermissionService {
  Future<CameraPermission> status();

  /// 触发系统权限对话框。
  Future<CameraPermission> request();

  /// 跳转本 App 的系统设置页（永久拒绝后的兜底路径）。
  Future<void> openSystemSettings();
}

class PermissionHandlerCameraService implements CameraPermissionService {
  @override
  Future<CameraPermission> status() async =>
      _map(await ph.Permission.camera.status);

  @override
  Future<CameraPermission> request() async =>
      _map(await ph.Permission.camera.request());

  @override
  Future<void> openSystemSettings() => ph.openAppSettings();

  CameraPermission _map(ph.PermissionStatus status) => switch (status) {
        ph.PermissionStatus.granted ||
        ph.PermissionStatus.limited ||
        ph.PermissionStatus.provisional =>
          CameraPermission.granted,
        ph.PermissionStatus.permanentlyDenied =>
          CameraPermission.permanentlyDenied,
        ph.PermissionStatus.denied || ph.PermissionStatus.restricted =>
          CameraPermission.denied,
      };
}

@Riverpod(keepAlive: true)
CameraPermissionService cameraPermissionService(Ref ref) =>
    PermissionHandlerCameraService();
