import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: ScrapMemoApp()));
}

class ScrapMemoApp extends StatelessWidget {
  const ScrapMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrap Memo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const HomeScreen(),
    );
  }
}
