// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_code_analyzer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageCodeAnalyzer)
final imageCodeAnalyzerProvider = ImageCodeAnalyzerProvider._();

final class ImageCodeAnalyzerProvider
    extends
        $FunctionalProvider<
          ImageCodeAnalyzer,
          ImageCodeAnalyzer,
          ImageCodeAnalyzer
        >
    with $Provider<ImageCodeAnalyzer> {
  ImageCodeAnalyzerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCodeAnalyzerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCodeAnalyzerHash();

  @$internal
  @override
  $ProviderElement<ImageCodeAnalyzer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageCodeAnalyzer create(Ref ref) {
    return imageCodeAnalyzer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageCodeAnalyzer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageCodeAnalyzer>(value),
    );
  }
}

String _$imageCodeAnalyzerHash() => r'f12834882babd4ada276243cc3376a5073791b18';
