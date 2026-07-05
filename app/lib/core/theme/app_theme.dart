import 'package:flutter/material.dart';

import 'card_palette.dart';

/// 浅色/深色双主题（SPEC §3.9：外观浅色/深色/跟随系统）。
///
/// 品牌色定案（Q1）前，seed 与数据库默认卡面色同源。
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: CardPalette.steelBlue),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CardPalette.steelBlue,
          brightness: Brightness.dark,
        ),
      );
}
