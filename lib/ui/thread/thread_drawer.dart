import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/thread_providers.dart';
import 'thread_input_bar.dart';

class ThreadDrawer extends ConsumerWidget {
  const ThreadDrawer({super.key, required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('スレッド'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(memo.content),
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _ThreadList(memoId: memo.id)),
          const Divider(height: 1),
          ThreadInputBar(memoId: memo.id),
        ],
      ),
    );
  }
}

class _ThreadList extends ConsumerWidget {
  const _ThreadList({required this.memoId});

  final int memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(threadListProvider(memoId));

    return threadsAsync.when(
      data: (threads) {
        if (threads.isEmpty) {
          return const Center(child: Text('スレッドはまだありません'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: threads.length,
          itemBuilder: (context, index) {
            final thread = threads[index];
            return ListTile(
              title: Text(thread.content),
              subtitle: Text(thread.createdAt.toString()),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('エラー: $error')),
    );
  }
}
