// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_image_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(galleryImagePicker)
final galleryImagePickerProvider = GalleryImagePickerProvider._();

final class GalleryImagePickerProvider
    extends
        $FunctionalProvider<
          GalleryImagePicker,
          GalleryImagePicker,
          GalleryImagePicker
        >
    with $Provider<GalleryImagePicker> {
  GalleryImagePickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryImagePickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryImagePickerHash();

  @$internal
  @override
  $ProviderElement<GalleryImagePicker> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GalleryImagePicker create(Ref ref) {
    return galleryImagePicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GalleryImagePicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GalleryImagePicker>(value),
    );
  }
}

String _$galleryImagePickerHash() =>
    r'48ec93a5c9a1a2361629c43c657893a1d6b16ba4';
