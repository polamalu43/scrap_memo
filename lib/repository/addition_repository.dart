import 'package:drift/drift.dart';

import '../data/database.dart';

class AdditionRepository {
  AdditionRepository(this._db);

  final AppDatabase _db;

  Stream<List<Addition>> watchAdditionsForMemo(int memoId) {
    return (_db.select(_db.additions)
          ..where((a) => a.memoId.equals(memoId))
          ..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .watch();
  }

  Future<void> addAddition(int memoId, String content) {
    final now = DateTime.now();
    return _db.into(_db.additions).insert(
      AdditionsCompanion.insert(
        memoId: memoId,
        content: content,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
