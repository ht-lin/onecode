import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/providers.dart';
import '../../../data/repository/card_repository.dart';

part 'card_display_providers.g.dart';

/// 展示页单卡响应式流（SPEC §3.4）：编辑实时反映，删除/不存在时发出 null。
@riverpod
Stream<CardWithState?> displayCard(Ref ref, String cardId) =>
    ref.watch(cardRepositoryProvider).watchCard(cardId);
