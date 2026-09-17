import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF0B6E4F);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
