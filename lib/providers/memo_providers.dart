import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../repository/memo_repository.dart';
import 'database_provider.dart';

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository(ref.watch(appDatabaseProvider));
});

final memoListProvider = StreamProvider<List<Memo>>((ref) {
  return ref.watch(memoRepositoryProvider).watchAllMemos();
});

class MemoController extends Notifier<void> {
  @override
  void build() {}

  Future<void> addMemo(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(memoRepositoryProvider).addMemo(trimmed);
  }
}

final memoControllerProvider = NotifierProvider<MemoController, void>(
  MemoController.new,
);

/// メモ詳細（スレッド）を表示中のメモ。未選択時は null。
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
