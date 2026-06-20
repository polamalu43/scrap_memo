import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/addition_providers.dart';
import '../../utils/date_formatter.dart';
import 'addition_input_bar.dart';

class AdditionDrawer extends ConsumerWidget {
  const AdditionDrawer({super.key, required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('追記'),
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
          Expanded(child: _AdditionList(memoId: memo.id)),
          const Divider(height: 1),
          AdditionInputBar(memoId: memo.id),
        ],
      ),
    );
  }
}

class _AdditionList extends ConsumerWidget {
  const _AdditionList({required this.memoId});

  final int memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final additionsAsync = ref.watch(additionListProvider(memoId));

    return additionsAsync.when(
      data: (additions) {
        if (additions.isEmpty) {
          return const Center(child: Text('追記はまだありません'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: additions.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final addition = additions[index];
            return ListTile(
              title: Text(addition.content),
              subtitle: Text(formatDateTime(addition.createdAt)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('エラー: $error')),
    );
  }
}
