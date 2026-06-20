import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/memo_providers.dart';

class MemoSearchBar extends ConsumerStatefulWidget {
  const MemoSearchBar({super.key});

  @override
  ConsumerState<MemoSearchBar> createState() => _MemoSearchBarState();
}

class _MemoSearchBarState extends ConsumerState<MemoSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'メモと追記を検索',
          prefixIcon: const Icon(Icons.search),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchQueryProvider.notifier).updateQuery('');
                    setState(() {});
                  },
                ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
          setState(() {});
        },
      ),
    );
  }
}
