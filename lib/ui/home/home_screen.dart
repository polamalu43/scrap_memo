import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/memo_providers.dart';
import '../../utils/date_formatter.dart';
import '../addition/addition_drawer.dart';
import '../common/resize_handle.dart';
import 'memo_input_bar.dart';
import 'memo_search_bar.dart';
import 'pinned_bookmark_area.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _minDrawerWidth = 240.0;

  double _drawerWidth = 360;

  @override
  Widget build(BuildContext context) {
    final selectedMemo = ref.watch(selectedMemoProvider);
    final maxDrawerWidth = MediaQuery.of(context).size.width * 0.95;
    final drawerWidth = _drawerWidth.clamp(_minDrawerWidth, maxDrawerWidth);

    return Scaffold(
      appBar: AppBar(title: const Text('Scrap Memo'), actions: const []),
      endDrawer: selectedMemo == null
          ? null
          : SizedBox(
              width: drawerWidth,
              child: Row(
                children: [
                  HorizontalResizeHandle(
                    onDragDelta: (dx) {
                      setState(() {
                        _drawerWidth = (_drawerWidth - dx).clamp(
                          _minDrawerWidth,
                          maxDrawerWidth,
                        );
                      });
                    },
                  ),
                  Expanded(child: AdditionDrawer(memo: selectedMemo)),
                ],
              ),
            ),
      body: Column(
        children: [
          const MemoSearchBar(),
          const PinnedBookmarkArea(),
          const Divider(height: 1),
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

    final searchQuery = ref.watch(searchQueryProvider);

    return memosAsync.when(
      data: (memos) {
        if (memos.isEmpty) {
          return Center(
            child: Text(
              searchQuery.trim().isEmpty
                  ? 'まだメモがありません'
                  : '見つかりませんでした',
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: memos.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
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
    final isEdited = memo.updatedAt.isAfter(memo.createdAt);
    return ListTile(
      title: Text(memo.content),
      subtitle: Text(
        isEdited
            ? '${formatDateTime(memo.createdAt)} (編集済)'
            : formatDateTime(memo.createdAt),
      ),
      trailing: IconButton(
        icon: Icon(memo.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
        onPressed: () => ref.read(memoControllerProvider.notifier).togglePin(memo),
      ),
      onTap: () {
        ref.read(selectedMemoProvider.notifier).select(memo);
        Scaffold.of(context).openEndDrawer();
      },
      onLongPress: () =>
          ref.read(editingMemoProvider.notifier).startEdit(memo),
    );
  }
}
