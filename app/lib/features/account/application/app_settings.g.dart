// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用偏好控制器：设置页写入，[OneCodeApp] 订阅即时生效。

@ProviderFor(AppSettingsController)
final appSettingsControllerProvider = AppSettingsControllerProvider._();

/// 应用偏好控制器：设置页写入，[OneCodeApp] 订阅即时生效。
final class AppSettingsControllerProvider
    extends $AsyncNotifierProvider<AppSettingsController, AppSettings> {
  /// 应用偏好控制器：设置页写入，[OneCodeApp] 订阅即时生效。
  AppSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsControllerHash();

  @$internal
  @override
  AppSettingsController create() => AppSettingsController();
}

String _$appSettingsControllerHash() =>
    r'3c86e30c91f7c67db74a292917ca89b7871dfad5';

/// 应用偏好控制器：设置页写入，[OneCodeApp] 订阅即时生效。

abstract class _$AppSettingsController extends $AsyncNotifier<AppSettings> {
  FutureOr<AppSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppSettings>, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppSettings>, AppSettings>,
              AsyncValue<AppSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
