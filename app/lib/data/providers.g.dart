// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'365ef3f215d780c29a21b6328f0b547a8363c6a6';

@ProviderFor(cardRepository)
final cardRepositoryProvider = CardRepositoryProvider._();

final class CardRepositoryProvider
    extends $FunctionalProvider<CardRepository, CardRepository, CardRepository>
    with $Provider<CardRepository> {
  CardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cardRepositoryHash();

  @$internal
  @override
  $ProviderElement<CardRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CardRepository create(Ref ref) {
    return cardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CardRepository>(value),
    );
  }
}

String _$cardRepositoryHash() => r'b39bc1ec11cbad9da4e9c12f39a8d9afc767c129';
