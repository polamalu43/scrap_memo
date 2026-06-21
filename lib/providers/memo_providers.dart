import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../repository/memo_repository.dart';
import 'database_provider.dart';

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository(ref.watch(appDatabaseProvider));
});

/// 検索バーに入力中の検索クエリ。
class SearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String value) {
    state = value;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryController, String>(
  SearchQueryController.new,
);

final memoListProvider = StreamProvider<List<Memo>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  return ref
      .watch(memoRepositoryProvider)
      .watchAllMemos(searchQuery: searchQuery);
});

final pinnedMemoListProvider = StreamProvider<List<Memo>>((ref) {
  return ref.watch(memoRepositoryProvider).watchPinnedMemos();
});

class MemoController extends Notifier<void> {
  @override
  void build() {}

  Future<void> addMemo(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(memoRepositoryProvider).addMemo(trimmed);
  }

  Future<void> togglePin(Memo memo) async {
    await ref.read(memoRepositoryProvider).setPinned(memo.id, !memo.isPinned);
  }

  Future<void> updateMemo(int id, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(memoRepositoryProvider).updateContent(id, trimmed);
  }
}

final memoControllerProvider = NotifierProvider<MemoController, void>(
  MemoController.new,
);

/// メモ詳細（追記）を表示中のメモ。未選択時は null。
class SelectedMemoController extends Notifier<Memo?> {
  @override
  Memo? build() => null;

  void select(Memo? memo) {
    state = memo;
  }
}

final selectedMemoProvider = NotifierProvider<SelectedMemoController, Memo?>(
  SelectedMemoController.new,
);

/// 編集中のメモ。null は編集モードでないことを示す。
class EditingMemoController extends Notifier<Memo?> {
  @override
  Memo? build() => null;

  void startEdit(Memo memo) {
    state = memo;
  }

  void cancelEdit() {
    state = null;
  }
}

final editingMemoProvider = NotifierProvider<EditingMemoController, Memo?>(
  EditingMemoController.new,
);
