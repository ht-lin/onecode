import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'drift/app_database.dart';
import 'repository/card_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
CardRepository cardRepository(Ref ref) =>
    CardRepository(ref.watch(appDatabaseProvider));
