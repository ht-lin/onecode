# data/

数据层（SPEC §5.3），UI 只与 Repository 交互，不直接接触 Drift/SQL。

- `drift/` — Drift schema v1（`cards`、`user_card_states`、`sync_meta`）、枚举与 wire 映射（M1-01）
- `repository/` — `CardRepository`：CRUD、软删除、收藏、最近使用、响应式 watch 流（M1-01）
- `providers.dart` — Riverpod 入口（`appDatabaseProvider`、`cardRepositoryProvider`）
- `api/` — dio API client（→ M2-06）
- `sync/` — SyncEngine 增量同步（→ M2-07）

## Schema 迁移

从 v1 起版本化。每次升 schema 版本：

```bash
dart run drift_dev schema dump lib/data/drift/app_database.dart drift_schemas/
dart run drift_dev schema generate drift_schemas/ test/drift/generated/
```

然后在 `AppDatabase.migration.onUpgrade` 写迁移步骤，并在
`test/drift/migration_test.dart` 补充版本间迁移用例。
