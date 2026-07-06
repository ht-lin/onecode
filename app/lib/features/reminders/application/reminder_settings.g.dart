// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提醒偏好控制器：设置页写入（M1-09），协调器订阅变化即时重排通知。

@ProviderFor(ReminderSettingsController)
final reminderSettingsControllerProvider =
    ReminderSettingsControllerProvider._();

/// 提醒偏好控制器：设置页写入（M1-09），协调器订阅变化即时重排通知。
final class ReminderSettingsControllerProvider
    extends
        $AsyncNotifierProvider<ReminderSettingsController, ReminderSettings> {
  /// 提醒偏好控制器：设置页写入（M1-09），协调器订阅变化即时重排通知。
  ReminderSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSettingsControllerHash();

  @$internal
  @override
  ReminderSettingsController create() => ReminderSettingsController();
}

String _$reminderSettingsControllerHash() =>
    r'bbc66720a90e15db30f17863c44c709b14a0d798';

/// 提醒偏好控制器：设置页写入（M1-09），协调器订阅变化即时重排通知。

abstract class _$ReminderSettingsController
    extends $AsyncNotifier<ReminderSettings> {
  FutureOr<ReminderSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReminderSettings>, ReminderSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReminderSettings>, ReminderSettings>,
              AsyncValue<ReminderSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
