// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expiry_reminder_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expiryReminderCoordinator)
final expiryReminderCoordinatorProvider = ExpiryReminderCoordinatorProvider._();

final class ExpiryReminderCoordinatorProvider
    extends
        $FunctionalProvider<
          ExpiryReminderCoordinator,
          ExpiryReminderCoordinator,
          ExpiryReminderCoordinator
        >
    with $Provider<ExpiryReminderCoordinator> {
  ExpiryReminderCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expiryReminderCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expiryReminderCoordinatorHash();

  @$internal
  @override
  $ProviderElement<ExpiryReminderCoordinator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpiryReminderCoordinator create(Ref ref) {
    return expiryReminderCoordinator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpiryReminderCoordinator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpiryReminderCoordinator>(value),
    );
  }
}

String _$expiryReminderCoordinatorHash() =>
    r'aa8484b4073b95834fec52e1af63404cf3320d20';
