import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/memo_providers.dart';

class MemoInputBar extends ConsumerStatefulWidget {
  const MemoInputBar({super.key});

  @override
  ConsumerState<MemoInputBar> createState() => _MemoInputBarState();
}

class _MemoInputBarState extends ConsumerState<MemoInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    ref.read(memoControllerProvider.notifier).addMemo(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '思いついたことを書く',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
