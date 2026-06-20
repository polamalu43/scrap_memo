import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../repository/thread_repository.dart';
import 'database_provider.dart';

final threadRepositoryProvider = Provider<ThreadRepository>((ref) {
  return ThreadRepository(ref.watch(appDatabaseProvider));
});

final threadListProvider = StreamProvider.family<List<Thread>, int>((
  ref,
  memoId,
) {
  return ref.watch(threadRepositoryProvider).watchThreadsForMemo(memoId);
});

class ThreadController extends Notifier<void> {
  @override
  void build() {}

  Future<void> addThread(int memoId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(threadRepositoryProvider).addThread(memoId, trimmed);
  }
}

final threadControllerProvider = NotifierProvider<ThreadController, void>(
  ThreadController.new,
);
