import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/data/drift/app_database.dart';

import 'generated/schema.dart';

// Drift schema 迁移测试（M1-01）：以 drift_schemas/ 下的版本快照为基准。
// 新增 schema 版本时：dart run drift_dev schema dump → schema generate，
// 然后在此补充各版本间的迁移用例。
void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('v1 数据库与 schema 快照一致', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 1);
  });
}
