import 'package:drift/drift.dart';

import '../data/database.dart';

class MemoRepository {
  MemoRepository(this._db);

  final AppDatabase _db;

  Stream<List<Memo>> watchAllMemos({String searchQuery = ''}) {
    final query = _db.select(_db.memos);

    final trimmed = searchQuery.trim();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      final additionMemoIds = _db.selectOnly(_db.additions)
        ..addColumns([_db.additions.memoId])
        ..where(_db.additions.content.like(pattern));
      query.where(
        (m) => m.content.like(pattern) | m.id.isInQuery(additionMemoIds),
      );
    }

    query.orderBy([(m) => OrderingTerm.asc(m.createdAt)]);
    return query.watch();
  }

  Stream<List<Memo>> watchPinnedMemos() {
    return (_db.select(_db.memos)
          ..where((m) => m.isPinned.equals(true))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
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

  Future<void> setPinned(int id, bool isPinned) {
    return (_db.update(_db.memos)..where((m) => m.id.equals(id))).write(
      MemosCompanion(isPinned: Value(isPinned)),
    );
  }

  Future<void> updateContent(int id, String content) {
    return (_db.update(_db.memos)..where((m) => m.id.equals(id))).write(
      MemosCompanion(
        content: Value(content),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
