import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/memo_providers.dart';
import '../thread/thread_drawer.dart';
import 'memo_input_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMemo = ref.watch(selectedMemoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scrap Memo')),
      endDrawer: selectedMemo == null
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: ThreadDrawer(memo: selectedMemo),
            ),
      body: Column(
        children: [
          Expanded(child: _MemoTimeline()),
          const Divider(height: 1),
          const MemoInputBar(),
        ],
      ),
    );
  }
}

class _MemoTimeline extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(memoListProvider);

    return memosAsync.when(
      data: (memos) {
        if (memos.isEmpty) {
          return const Center(child: Text('まだメモがありません'));
        }
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: memos.length,
          itemBuilder: (context, index) {
            final memo = memos[index];
            return _MemoTile(memo: memo);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('エラー: $error')),
    );
  }
}

class _MemoTile extends ConsumerWidget {
  const _MemoTile({required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(memo.content),
      subtitle: Text(memo.createdAt.toString()),
      onTap: () {
        ref.read(selectedMemoProvider.notifier).select(memo);
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}
