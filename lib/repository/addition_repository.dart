import 'package:drift/drift.dart';

import '../data/database.dart';

/// ブックマークされた追記と、その親メモの文脈をまとめたデータ。
class BookmarkedAddition {
  BookmarkedAddition({required this.addition, required this.parentMemo});

  final Addition addition;
  final Memo parentMemo;
}

class AdditionRepository {
  AdditionRepository(this._db);

  final AppDatabase _db;

  Stream<List<Addition>> watchAdditionsForMemo(int memoId) {
    return (_db.select(_db.additions)
          ..where((a) => a.memoId.equals(memoId))
          ..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .watch();
  }

  Stream<List<BookmarkedAddition>> watchBookmarkedAdditions() {
    final query = _db.select(_db.additions).join([
      innerJoin(_db.memos, _db.memos.id.equalsExp(_db.additions.memoId)),
    ])
      ..where(_db.additions.isBookmarked.equals(true))
      ..orderBy([OrderingTerm.desc(_db.additions.createdAt)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => BookmarkedAddition(
              addition: row.readTable(_db.additions),
              parentMemo: row.readTable(_db.memos),
            ),
          )
          .toList(),
    );
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

  Future<void> setBookmarked(int id, bool isBookmarked) {
    return (_db.update(_db.additions)..where((a) => a.id.equals(id))).write(
      AdditionsCompanion(isBookmarked: Value(isBookmarked)),
    );
  }

  Future<void> updateContent(int id, String content) {
    return (_db.update(_db.additions)..where((a) => a.id.equals(id))).write(
      AdditionsCompanion(
        content: Value(content),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
