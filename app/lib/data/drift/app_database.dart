import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'enums.dart';
import 'tables.dart';

export 'enums.dart';
export 'tables.dart';

part 'app_database.g.dart';

/// 本地数据库（SPEC §6.3）。
///
/// UI 层不直接接触本类，一律经由 Repository（SPEC §5.3 架构原则）。
@DriftDatabase(tables: [Cards, UserCardStates, SyncMeta])
class AppDatabase extends _$AppDatabase {
  /// 测试用：注入任意 executor（如 NativeDatabase.memory()）。
  AppDatabase(super.e);

  /// 生产用：平台默认位置的 SQLite 文件。
  AppDatabase.open() : super(driftDatabase(name: 'onecode'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // 从 v1 起版本化。v2 引入后改用 stepByStep 迁移
          // （drift_dev schema 快照见 drift_schemas/）。
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
