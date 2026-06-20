import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../repository/addition_repository.dart';
import 'database_provider.dart';

final additionRepositoryProvider = Provider<AdditionRepository>((ref) {
  return AdditionRepository(ref.watch(appDatabaseProvider));
});

final additionListProvider = StreamProvider.family<List<Addition>, int>((
  ref,
  memoId,
) {
  return ref.watch(additionRepositoryProvider).watchAdditionsForMemo(memoId);
});

class AdditionController extends Notifier<void> {
  @override
  void build() {}

  Future<void> addAddition(int memoId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    await ref.read(additionRepositoryProvider).addAddition(memoId, trimmed);
  }
}

final additionControllerProvider = NotifierProvider<AdditionController, void>(
  AdditionController.new,
);
