import 'package:drift/drift.dart';

import '../data/database.dart';

class ThreadRepository {
  ThreadRepository(this._db);

  final AppDatabase _db;

  Stream<List<Thread>> watchThreadsForMemo(int memoId) {
    return (_db.select(_db.threads)
          ..where((t) => t.memoId.equals(memoId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<void> addThread(int memoId, String content) {
    final now = DateTime.now();
    return _db.into(_db.threads).insert(
      ThreadsCompanion.insert(
        memoId: memoId,
        content: content,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
