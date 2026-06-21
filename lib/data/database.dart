import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@TableIndex(
  name: 'idx_memos_created_at',
  columns: {IndexedColumn(#createdAt, orderBy: OrderingMode.desc)},
)
@TableIndex(
  name: 'idx_memos_pinned_created_at',
  columns: {
    #isPinned,
    IndexedColumn(#createdAt, orderBy: OrderingMode.desc),
  },
)
class Memos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@TableIndex(name: 'idx_additions_memo_id', columns: {#memoId})
@TableIndex(
  name: 'idx_additions_memo_id_created_at',
  columns: {
    #memoId,
    IndexedColumn(#createdAt, orderBy: OrderingMode.asc),
  },
)
class Additions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get memoId => integer()();
  TextColumn get content => text()();
  BoolColumn get isBookmarked =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [Memos, Additions])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'scrap_memo',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.dart.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(additions, additions.isBookmarked);
      }
    },
  );
}
