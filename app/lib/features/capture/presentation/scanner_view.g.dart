// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanner_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 取景视图构造器。真机走 [ScannerView]（相机平台通道）；
/// widget 测试覆写为 fake 以驱动识别回调。

@ProviderFor(scannerViewBuilder)
final scannerViewBuilderProvider = ScannerViewBuilderProvider._();

/// 取景视图构造器。真机走 [ScannerView]（相机平台通道）；
/// widget 测试覆写为 fake 以驱动识别回调。

final class ScannerViewBuilderProvider
    extends
        $FunctionalProvider<
          ScannerViewBuilder,
          ScannerViewBuilder,
          ScannerViewBuilder
        >
    with $Provider<ScannerViewBuilder> {
  /// 取景视图构造器。真机走 [ScannerView]（相机平台通道）；
  /// widget 测试覆写为 fake 以驱动识别回调。
  ScannerViewBuilderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scannerViewBuilderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scannerViewBuilderHash();

  @$internal
  @override
  $ProviderElement<ScannerViewBuilder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScannerViewBuilder create(Ref ref) {
    return scannerViewBuilder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScannerViewBuilder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScannerViewBuilder>(value),
    );
  }
}

String _$scannerViewBuilderHash() =>
    r'441c87492df2ff764cb1aac3b0e204a68890935d';
