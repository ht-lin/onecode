import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../drift/app_database.dart';

/// 卡 + 个人状态的组合读取模型，供列表页/详情页消费。
class CardWithState {
  const CardWithState({
    required this.card,
    required this.isFavorite,
    this.lastUsedAt,
  });

  final CardRow card;
  final bool isFavorite;
  final DateTime? lastUsedAt;
}

/// 卡数据的唯一出入口（SPEC §5.3：UI 只与 Repository 交互）。
///
/// 未登录模式：所有写入保持 `sync_status = local`，本类不做任何网络调用；
/// 登录后的 dirty 标记与上行由 SyncEngine 引入（M2-07）。
class CardRepository {
  CardRepository(this._db, {Uuid? uuid, DateTime Function()? clock})
      : _uuid = uuid ?? const Uuid(),
        _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final Uuid _uuid;
  final DateTime Function() _now;

  /// 新建卡，返回客户端生成的 UUID v4（SPEC §6.1）。
  Future<String> createCard({
    required String name,
    required String codeValue,
    required CodeFormat codeFormat,
    CardKind cardKind = CardKind.loyalty,
    String color = '#4A6FA5',
    String? note,
    DateTime? expiresAt,
  }) async {
    final id = _uuid.v4();
    final now = _now().toUtc();
    await _db.transaction(() async {
      await _db.into(_db.cards).insert(CardsCompanion.insert(
            id: id,
            name: name,
            codeValue: codeValue,
            codeFormat: codeFormat,
            cardKind: Value(cardKind),
            color: Value(color),
            note: Value(note),
            expiresAt: Value(expiresAt),
            createdAt: now,
            updatedAt: now,
          ));
      await _db.into(_db.userCardStates).insert(
          UserCardStatesCompanion.insert(cardId: id, updatedAt: now));
    });
    return id;
  }

  /// 更新可编辑字段（SPEC §3.2）。未传入的字段保持不变；
  /// `note`/`expiresAt` 需要显式置空时传 `Value(null)`。
  Future<void> updateCard(
    String id, {
    String? name,
    String? codeValue,
    CodeFormat? codeFormat,
    CardKind? cardKind,
    String? color,
    Value<String?> note = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
  }) async {
    await _requireOwnCard(id);
    final updated = await (_db.update(_db.cards)..where((c) => c.id.equals(id)))
        .write(CardsCompanion(
      name: Value.absentIfNull(name),
      codeValue: Value.absentIfNull(codeValue),
      codeFormat: Value.absentIfNull(codeFormat),
      cardKind: Value.absentIfNull(cardKind),
      color: Value.absentIfNull(color),
      note: note,
      expiresAt: expiresAt,
      updatedAt: Value(_now().toUtc()),
    ));
    if (updated == 0) {
      throw StateError('Karte $id existiert nicht');
    }
  }

  /// 软删除：只落墓碑（SPEC §3.3/§6.1），不物理删除。
  Future<void> softDeleteCard(String id) async {
    await _requireOwnCard(id);
    final now = _now().toUtc();
    await (_db.update(_db.cards)..where((c) => c.id.equals(id))).write(
        CardsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  /// 批量软删除（SPEC §3.8：过期 30 天批量清理），单事务落墓碑。
  Future<void> softDeleteCards(Iterable<String> ids) async {
    final now = _now().toUtc();
    await _db.transaction(() async {
      for (final id in ids) {
        await _requireOwnCard(id);
        await (_db.update(_db.cards)..where((c) => c.id.equals(id))).write(
            CardsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
      }
    });
  }

  /// 收藏切换（置顶显示，SPEC §3.2/§3.3）。
  Future<void> toggleFavorite(String id) async {
    final state = await _stateOf(id);
    await (_db.update(_db.userCardStates)..where((s) => s.cardId.equals(id)))
        .write(UserCardStatesCompanion(
      isFavorite: Value(!state.isFavorite),
      updatedAt: Value(_now().toUtc()),
    ));
  }

  /// 展示码后触碰使用时间，驱动"最近使用倒序"排序（SPEC §3.3）。
  Future<void> touchLastUsed(String id) async {
    final now = _now().toUtc();
    await (_db.update(_db.userCardStates)..where((s) => s.cardId.equals(id)))
        .write(UserCardStatesCompanion(
      lastUsedAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  /// 卡包列表响应式流：排除已删除，收藏置顶，其余按最近使用倒序
  /// （SPEC §3.3），从未使用的按创建时间倒序垫底。
  Stream<List<CardWithState>> watchCards() {
    return _cardsQuery()
        .watch()
        .map((rows) => rows.map(_toCardWithState).toList());
  }

  /// 单卡响应式流（详情页）；卡不存在或已删除时发出 null。
  Stream<CardWithState?> watchCard(String id) {
    final query = _cardsQuery()..where(_db.cards.id.equals(id));
    return query
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toCardWithState(row));
  }

  Future<CardWithState?> getCard(String id) async {
    final row = await (_cardsQuery()..where(_db.cards.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toCardWithState(row);
  }

  JoinedSelectStatement _cardsQuery() {
    final query = _db.select(_db.cards).join([
      leftOuterJoin(_db.userCardStates,
          _db.userCardStates.cardId.equalsExp(_db.cards.id)),
    ])
      ..where(_db.cards.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(_db.userCardStates.isFavorite),
        OrderingTerm.desc(_db.userCardStates.lastUsedAt),
        OrderingTerm.desc(_db.cards.createdAt),
      ]);
    return query;
  }

  CardWithState _toCardWithState(TypedResult row) {
    final state = row.readTableOrNull(_db.userCardStates);
    return CardWithState(
      card: row.readTable(_db.cards),
      isFavorite: state?.isFavorite ?? false,
      lastUsedAt: state?.lastUsedAt,
    );
  }

  Future<UserCardStateRow> _stateOf(String id) async {
    final state = await (_db.select(_db.userCardStates)
          ..where((s) => s.cardId.equals(id)))
        .getSingleOrNull();
    if (state == null) {
      throw StateError('Karte $id existiert nicht');
    }
    return state;
  }

  /// 共享卡只读（SPEC §6.3）：写操作仅允许自有且未删除的卡。
  Future<CardRow> _requireOwnCard(String id) async {
    final card = await (_db.select(_db.cards)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
    if (card == null) {
      throw StateError('Karte $id existiert nicht');
    }
    if (card.origin == CardOrigin.shared) {
      throw StateError('Geteilte Karten sind schreibgeschützt');
    }
    return card;
  }
}
