// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_environment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(displayEnvironment)
final displayEnvironmentProvider = DisplayEnvironmentProvider._();

final class DisplayEnvironmentProvider
    extends
        $FunctionalProvider<
          DisplayEnvironment,
          DisplayEnvironment,
          DisplayEnvironment
        >
    with $Provider<DisplayEnvironment> {
  DisplayEnvironmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayEnvironmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayEnvironmentHash();

  @$internal
  @override
  $ProviderElement<DisplayEnvironment> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DisplayEnvironment create(Ref ref) {
    return displayEnvironment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayEnvironment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayEnvironment>(value),
    );
  }
}

String _$displayEnvironmentHash() =>
    r'735122897b8b7c59010e85a2e2339c2b8a8678f7';
