// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_permission_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cameraPermissionService)
final cameraPermissionServiceProvider = CameraPermissionServiceProvider._();

final class CameraPermissionServiceProvider
    extends
        $FunctionalProvider<
          CameraPermissionService,
          CameraPermissionService,
          CameraPermissionService
        >
    with $Provider<CameraPermissionService> {
  CameraPermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraPermissionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraPermissionServiceHash();

  @$internal
  @override
  $ProviderElement<CameraPermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CameraPermissionService create(Ref ref) {
    return cameraPermissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraPermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraPermissionService>(value),
    );
  }
}

String _$cameraPermissionServiceHash() =>
    r'6e5eca7b50e11c6ea510d5222b88338b8a996c5d';
