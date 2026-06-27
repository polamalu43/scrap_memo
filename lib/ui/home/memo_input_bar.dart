import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/memo_providers.dart';
import '../common/resize_handle.dart';

class MemoInputBar extends ConsumerStatefulWidget {
  const MemoInputBar({super.key});

  @override
  ConsumerState<MemoInputBar> createState() => _MemoInputBarState();
}

class _MemoInputBarState extends ConsumerState<MemoInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  double _height = 56;
  double _minHeight = 48.0;
  double _maxHeight = 400.0;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    final editingMemo = ref.read(editingMemoProvider);
    if (editingMemo != null) {
      ref
          .read(memoControllerProvider.notifier)
          .updateMemo(editingMemo.id, text);
      ref.read(editingMemoProvider.notifier).cancelEdit();
    } else {
      ref.read(memoControllerProvider.notifier).addMemo(text);
    }
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    _minHeight = screenHeight * 0.06;
    _maxHeight = screenHeight * 0.40;

    ref.listen<Memo?>(editingMemoProvider, (previous, next) {
      if (next != null) {
        _controller.text = next.content;
        _focusNode.requestFocus();
      }
    });
    final isEditing = ref.watch(editingMemoProvider) != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalResizeHandle(
              onDragDelta: (dy) {
                setState(() {
                  _height = (_height - dy).clamp(_minHeight, _maxHeight);
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: _height,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: isEditing ? '編集する' : '思いついたことを書く',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: '編集をキャンセル',
                    onPressed: () {
                      ref.read(editingMemoProvider.notifier).cancelEdit();
                      _controller.clear();
                    },
                  ),
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.add),
                  tooltip: isEditing ? '更新' : '追加',
                  onPressed: _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
