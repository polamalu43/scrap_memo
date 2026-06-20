import 'package:drift/drift.dart';

import '../data/database.dart';

class MemoRepository {
  MemoRepository(this._db);

  final AppDatabase _db;

  Stream<List<Memo>> watchAllMemos() {
    return (_db.select(_db.memos)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> addMemo(String content) {
    final now = DateTime.now();
    return _db.into(_db.memos).insert(
      MemosCompanion.insert(
        content: content,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
