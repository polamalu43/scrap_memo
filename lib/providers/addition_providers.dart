import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../repository/addition_repository.dart';
import 'database_provider.dart';

export '../repository/addition_repository.dart' show BookmarkedAddition;

final additionRepositoryProvider = Provider<AdditionRepository>((ref) {
  return AdditionRepository(ref.watch(appDatabaseProvider));
});

final additionListProvider = StreamProvider.family<List<Addition>, int>((
  ref,
  memoId,
) {
  return ref.watch(additionRepositoryProvider).watchAdditionsForMemo(memoId);
});

final bookmarkedAdditionListProvider =
    StreamProvider<List<BookmarkedAddition>>((ref) {
      return ref.watch(additionRepositoryProvider).watchBookmarkedAdditions();
    });

class AdditionController extends Notifier<void> {
  @override
  void build() {}

  Future<void> addAddition(int memoId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(additionRepositoryProvider).addAddition(memoId, trimmed);
  }

  Future<void> toggleBookmark(Addition addition) async {
    await ref
        .read(additionRepositoryProvider)
        .setBookmarked(addition.id, !addition.isBookmarked);
  }

  Future<void> updateAddition(int id, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(additionRepositoryProvider).updateContent(id, trimmed);
  }
}

final additionControllerProvider = NotifierProvider<AdditionController, void>(
  AdditionController.new,
);

/// 編集中の追記。null は編集モードでないことを示す。
class EditingAdditionController extends Notifier<Addition?> {
  @override
  Addition? build() => null;

  void startEdit(Addition addition) {
    state = addition;
  }

  void cancelEdit() {
    state = null;
  }
}

final editingAdditionProvider =
    NotifierProvider<EditingAdditionController, Addition?>(
      EditingAdditionController.new,
    );
