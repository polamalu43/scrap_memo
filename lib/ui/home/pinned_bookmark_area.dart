import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/addition_providers.dart';
import '../../providers/home_tab_providers.dart';
import '../../providers/memo_providers.dart';

void _openAdditionDrawer(BuildContext context, WidgetRef ref, Memo memo) {
  ref.read(selectedMemoProvider.notifier).select(memo);
  Scaffold.of(context).openEndDrawer();
}

/// 検索窓下エリア：ピン留め/ブックマークの切り替えタブと一覧。
class PinnedBookmarkArea extends ConsumerWidget {
  const PinnedBookmarkArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(homeTabProvider);
    final isVisible = ref.watch(homeTabAreaVisibleProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              Expanded(child: _HomeTabSegments(selected: selectedTab)),
              IconButton(
                icon: Icon(isVisible ? Icons.expand_less : Icons.expand_more),
                tooltip: isVisible ? '隠す' : '表示する',
                onPressed: () =>
                    ref.read(homeTabAreaVisibleProvider.notifier).toggle(),
              ),
            ],
          ),
        ),
        if (isVisible)
          switch (selectedTab) {
            HomeTab.pinned => const _PinnedHorizontalList(),
            HomeTab.bookmarked => const _BookmarkedHorizontalList(),
          },
      ],
    );
  }
}

class _HomeTabSegments extends ConsumerWidget {
  const _HomeTabSegments({required this.selected});

  final HomeTab selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentTab(
            label: 'ピン留め',
            isSelected: selected == HomeTab.pinned,
            onTap: () => ref.read(homeTabProvider.notifier).select(HomeTab.pinned),
          ),
          _SegmentTab(
            label: 'ブックマーク',
            isSelected: selected == HomeTab.bookmarked,
            onTap: () =>
                ref.read(homeTabProvider.notifier).select(HomeTab.bookmarked),
          ),
        ],
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimaryContainer : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}

class _PinnedHorizontalList extends ConsumerWidget {
  const _PinnedHorizontalList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(pinnedMemoListProvider);

    return pinnedAsync.when(
      data: (memos) {
        if (memos.isEmpty) {
          return const _EmptyHint(text: 'ピン留めはまだありません');
        }
        return SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: memos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _PinnedCard(memo: memos[index]),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _PinnedCard extends ConsumerWidget {
  const _PinnedCard({required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _openAdditionDrawer(context, ref, memo),
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

class _BookmarkedHorizontalList extends ConsumerWidget {
  const _BookmarkedHorizontalList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedAsync = ref.watch(bookmarkedAdditionListProvider);

    return bookmarkedAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyHint(text: 'ブックマークはまだありません');
        }
        return SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) =>
                _BookmarkedCard(item: items[index]),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _BookmarkedCard extends ConsumerWidget {
  const _BookmarkedCard({required this.item});

  final BookmarkedAddition item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _openAdditionDrawer(context, ref, item.parentMemo),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.parentMemo.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    item.addition.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
