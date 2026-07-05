import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/repository/card_repository.dart';

/// 可拨动的测试时钟：验证 updated_at 维护与"最近使用"排序。
class _Clock {
  DateTime now = DateTime.utc(2026, 7, 5, 12);

  DateTime call() => now;

  void advance([Duration d = const Duration(minutes: 1)]) {
    now = now.add(d);
  }
}

final _uuidV4 = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');

void main() {
  late AppDatabase db;
  late _Clock clock;
  late CardRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = _Clock();
    repo = CardRepository(db, clock: clock.call);
  });

  tearDown(() => db.close());

  Future<String> createSample({String name = 'REWE'}) => repo.createCard(
        name: name,
        codeValue: '4000123456789',
        codeFormat: CodeFormat.ean13,
      );

  group('createCard', () {
    test('生成 UUID v4 主键，且每张卡唯一', () async {
      final a = await createSample();
      final b = await createSample();
      expect(a, matches(_uuidV4));
      expect(b, matches(_uuidV4));
      expect(a, isNot(b));
    });

    test('持久化全部字段并写入时间戳与默认值', () async {
      final id = await repo.createCard(
        name: 'Bäckerei-Gutschein',
        codeValue: 'GUT-2026',
        codeFormat: CodeFormat.qrCode,
        cardKind: CardKind.coupon,
        color: '#C62828',
        note: 'PIN 1234',
        expiresAt: DateTime.utc(2026, 12, 31),
      );

      final loaded = (await repo.getCard(id))!;
      expect(loaded.card.name, 'Bäckerei-Gutschein');
      expect(loaded.card.codeValue, 'GUT-2026');
      expect(loaded.card.codeFormat, CodeFormat.qrCode);
      expect(loaded.card.cardKind, CardKind.coupon);
      expect(loaded.card.color, '#C62828');
      expect(loaded.card.note, 'PIN 1234');
      expect(loaded.card.expiresAt, DateTime.utc(2026, 12, 31));
      expect(loaded.card.createdAt, clock.now);
      expect(loaded.card.updatedAt, clock.now);
      expect(loaded.card.deletedAt, isNull);
      expect(loaded.isFavorite, isFalse);
      expect(loaded.lastUsedAt, isNull);
    });

    test('未登录模式：sync_status 恒为 local，origin 为 own', () async {
      final id = await createSample();
      final loaded = (await repo.getCard(id))!;
      expect(loaded.card.syncStatus, SyncStatus.local);
      expect(loaded.card.origin, CardOrigin.own);
    });

    test('全部 13 种码制持久化往返无损', () async {
      expect(CodeFormat.values, hasLength(13));
      for (final format in CodeFormat.values) {
        final id = await repo.createCard(
            name: format.name, codeValue: '123', codeFormat: format);
        final loaded = (await repo.getCard(id))!;
        expect(loaded.card.codeFormat, format);
      }
    });
  });

  group('updateCard', () {
    test('更新传入字段并推进 updated_at，其余字段不动', () async {
      final id = await createSample();
      final created = clock.now;
      clock.advance();

      await repo.updateCard(id, name: 'REWE Center', color: '#283593');

      final loaded = (await repo.getCard(id))!;
      expect(loaded.card.name, 'REWE Center');
      expect(loaded.card.color, '#283593');
      expect(loaded.card.codeValue, '4000123456789');
      expect(loaded.card.createdAt, created);
      expect(loaded.card.updatedAt, clock.now);
      expect(loaded.card.syncStatus, SyncStatus.local);
    });

    test('Value(null) 显式清空可选字段', () async {
      final id = await repo.createCard(
        name: 'Coupon',
        codeValue: 'X',
        codeFormat: CodeFormat.code128,
        note: 'alt',
        expiresAt: DateTime.utc(2026, 8, 1),
      );

      await repo.updateCard(id,
          note: const Value(null), expiresAt: const Value(null));

      final loaded = (await repo.getCard(id))!;
      expect(loaded.card.note, isNull);
      expect(loaded.card.expiresAt, isNull);
    });

    test('不存在的卡抛错', () {
      expect(() => repo.updateCard('fehlt', name: 'x'), throwsStateError);
    });

    test('共享卡只读：更新抛错', () async {
      final id = await _insertSharedCard(db, clock.now);
      expect(() => repo.updateCard(id, name: 'x'), throwsStateError);
    });
  });

  group('softDeleteCard', () {
    test('落墓碑而非物理删除，且从查询中消失', () async {
      final id = await createSample();
      clock.advance();

      await repo.softDeleteCard(id);

      expect(await repo.getCard(id), isNull);
      expect(await repo.watchCards().first, isEmpty);

      // 墓碑仍在库中（同步协议 SPEC §6.4 依赖）。
      final raw = await (db.select(db.cards)
            ..where((c) => c.id.equals(id)))
          .getSingle();
      expect(raw.deletedAt, clock.now);
      expect(raw.updatedAt, clock.now);
      expect(raw.syncStatus, SyncStatus.local);
    });

    test('已删除的卡再次删除或更新抛错', () async {
      final id = await createSample();
      await repo.softDeleteCard(id);
      expect(() => repo.softDeleteCard(id), throwsStateError);
      expect(() => repo.updateCard(id, name: 'x'), throwsStateError);
    });
  });

  group('收藏与最近使用', () {
    test('toggleFavorite 往返切换', () async {
      final id = await createSample();

      await repo.toggleFavorite(id);
      expect((await repo.getCard(id))!.isFavorite, isTrue);

      await repo.toggleFavorite(id);
      expect((await repo.getCard(id))!.isFavorite, isFalse);
    });

    test('touchLastUsed 写入当前时间', () async {
      final id = await createSample();
      clock.advance();

      await repo.touchLastUsed(id);

      expect((await repo.getCard(id))!.lastUsedAt, clock.now);
    });
  });

  group('watchCards', () {
    test('排序：收藏置顶，其余按最近使用倒序，未使用按创建倒序', () async {
      final oldest = await createSample(name: 'älteste');
      clock.advance();
      final favorite = await createSample(name: 'Favorit');
      clock.advance();
      final recentlyUsed = await createSample(name: 'zuletzt benutzt');
      clock.advance();
      final newest = await createSample(name: 'neueste');

      await repo.toggleFavorite(favorite);
      clock.advance();
      await repo.touchLastUsed(recentlyUsed);

      final list = await repo.watchCards().first;
      expect(list.map((c) => c.card.id).toList(),
          [favorite, recentlyUsed, newest, oldest]);
    });

    test('流对增删改响应式更新', () async {
      final emissions = <List<String>>[];
      final sub = repo
          .watchCards()
          .listen((rows) => emissions.add(rows.map((r) => r.card.name).toList()));
      addTearDown(sub.cancel);

      await _settle();
      final id = await createSample(name: 'A');
      await _settle();
      await repo.updateCard(id, name: 'B');
      await _settle();
      await repo.softDeleteCard(id);
      await _settle();

      expect(emissions.first, isEmpty);
      expect(emissions, containsAllInOrder([
        [],
        ['A'],
        ['B'],
        <String>[],
      ]));
    });
  });
}

/// drift 的流更新经由事件队列分发，等待其稳定。
Future<void> _settle() => Future<void>.delayed(Duration.zero);

/// 绕过 Repository 直插一张共享卡（M2 前 Repository 不提供共享写入）。
Future<String> _insertSharedCard(AppDatabase db, DateTime now) async {
  const id = 'shared-card-1';
  await db.into(db.cards).insert(CardsCompanion.insert(
        id: id,
        name: 'Omas Payback',
        codeValue: '240123',
        codeFormat: CodeFormat.ean13,
        origin: const Value(CardOrigin.shared),
        syncStatus: const Value(SyncStatus.synced),
        createdAt: now,
        updatedAt: now,
      ));
  return id;
}
