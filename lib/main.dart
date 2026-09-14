import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const RolnikApp());
}

class RolnikApp extends StatelessWidget {
  const RolnikApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3F7A2B),
      secondary: const Color(0xFFD4A017),
      tertiary: const Color(0xFF9B5DE5),
    );
    return MaterialApp(
      title: 'Rolnik: Dług Kruka',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3E7),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.surfaceContainerHighest,
          side: BorderSide.none,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
