import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/addition_providers.dart';
import '../common/resize_handle.dart';

class AdditionInputBar extends ConsumerStatefulWidget {
  const AdditionInputBar({super.key, required this.memoId});

  final int memoId;

  @override
  ConsumerState<AdditionInputBar> createState() => _AdditionInputBarState();
}

class _AdditionInputBarState extends ConsumerState<AdditionInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  double _height = 48;
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
    final editingAddition = ref.read(editingAdditionProvider);
    if (editingAddition != null) {
      ref
          .read(additionControllerProvider.notifier)
          .updateAddition(editingAddition.id, text);
      ref.read(editingAdditionProvider.notifier).cancelEdit();
    } else {
      ref
          .read(additionControllerProvider.notifier)
          .addAddition(widget.memoId, text);
    }
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    _minHeight = screenHeight * 0.06;
    _maxHeight = screenHeight * 0.40;

    ref.listen<Addition?>(editingAdditionProvider, (previous, next) {
      if (next != null) {
        _controller.text = next.content;
        _focusNode.requestFocus();
      }
    });
    final isEditing = ref.watch(editingAdditionProvider) != null;

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
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: isEditing ? '編集する' : '追記する',
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
                      ref.read(editingAdditionProvider.notifier).cancelEdit();
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
