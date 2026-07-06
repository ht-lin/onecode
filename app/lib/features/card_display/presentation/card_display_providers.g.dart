// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_display_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。

@ProviderFor(displayCard)
final displayCardProvider = DisplayCardFamily._();

/// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。

final class DisplayCardProvider
    extends
        $FunctionalProvider<
          AsyncValue<CardWithState?>,
          CardWithState?,
          Stream<CardWithState?>
        >
    with $FutureModifier<CardWithState?>, $StreamProvider<CardWithState?> {
  /// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。
  DisplayCardProvider._({
    required DisplayCardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'displayCardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$displayCardHash();

  @override
  String toString() {
    return r'displayCardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<CardWithState?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CardWithState?> create(Ref ref) {
    final argument = this.argument as String;
    return displayCard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DisplayCardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$displayCardHash() => r'573faff7ddc02d0745d51d6b439b6af6ed19bc33';

/// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。

final class DisplayCardFamily extends $Family
    with $FunctionalFamilyOverride<Stream<CardWithState?>, String> {
  DisplayCardFamily._()
    : super(
        retry: null,
        name: r'displayCardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。

  DisplayCardProvider call(String cardId) =>
      DisplayCardProvider._(argument: cardId, from: this);

  @override
  String toString() => r'displayCardProvider';
}
