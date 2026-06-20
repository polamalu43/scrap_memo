import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/memo_providers.dart';

class PinnedMemoList extends ConsumerWidget {
  const PinnedMemoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(pinnedMemoListProvider);

    return pinnedAsync.when(
      data: (memos) {
        if (memos.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: memos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final memo = memos[index];
              return _PinnedMemoCard(memo: memo);
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _PinnedMemoCard extends ConsumerWidget {
  const _PinnedMemoCard({required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            ref.read(selectedMemoProvider.notifier).select(memo);
            Scaffold.of(context).openEndDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              memo.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
