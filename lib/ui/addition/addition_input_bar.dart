import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/addition_providers.dart';
import '../common/resize_handle.dart';

class AdditionInputBar extends ConsumerStatefulWidget {
  const AdditionInputBar({super.key, required this.memoId});

  final int memoId;

  @override
  ConsumerState<AdditionInputBar> createState() => _AdditionInputBarState();
}

class _AdditionInputBarState extends ConsumerState<AdditionInputBar> {
  static const _minHeight = 48.0;
  static const _maxHeight = 400.0;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  double _height = 48;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    ref
        .read(additionControllerProvider.notifier)
        .addAddition(widget.memoId, text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(
                        hintText: '追記する',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
