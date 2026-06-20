import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrap_memo/data/database.dart';
import 'package:scrap_memo/main.dart';
import 'package:scrap_memo/providers/memo_providers.dart';

void main() {
  testWidgets('Home screen shows app bar and memo input field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoListProvider.overrideWith(
            (ref) => Stream.value(const <Memo>[]),
          ),
          pinnedMemoListProvider.overrideWith(
            (ref) => Stream.value(const <Memo>[]),
          ),
        ],
        child: const ScrapMemoApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Scrap Memo'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('思いついたことを書く'), findsOneWidget);
    expect(find.text('メモと追記を検索'), findsOneWidget);
  });
}
