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
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          // ベース
          surface: Colors.white,
          onSurface: Color(0xFF1A1A1A),
          surfaceContainerHighest: Color(0xFFF5F5F5),
          onSurfaceVariant: Color(0xFF616161),
          // プライマリ（AppBar・ボタン等）
          primary: Color(0xFF1A1A1A),
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFEEEEEE),
          onPrimaryContainer: Color(0xFF1A1A1A),
          // セカンダリ
          secondary: Color(0xFF616161),
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFF0F0F0),
          onSecondaryContainer: Color(0xFF1A1A1A),
          // テキスト装飾・ボーダー・タイムスタンプ
          outline: Color(0xFF9E9E9E),
          outlineVariant: Color(0xFFE0E0E0),
          // その他
          tertiary: Color(0xFF757575),
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFFF5F5F5),
          onTertiaryContainer: Color(0xFF424242),
          error: Color(0xFFB00020),
          onError: Colors.white,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF1A1A1A),
          onInverseSurface: Colors.white,
          inversePrimary: Color(0xFFE0E0E0),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
