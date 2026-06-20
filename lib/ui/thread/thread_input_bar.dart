import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/thread_providers.dart';

class ThreadInputBar extends ConsumerStatefulWidget {
  const ThreadInputBar({super.key, required this.memoId});

  final int memoId;

  @override
  ConsumerState<ThreadInputBar> createState() => _ThreadInputBarState();
}

class _ThreadInputBarState extends ConsumerState<ThreadInputBar> {
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
    ref.read(threadControllerProvider.notifier).addThread(widget.memoId, text);
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
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'スレッドに返信',
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
