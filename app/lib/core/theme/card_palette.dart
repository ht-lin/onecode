import 'package:flutter/material.dart';

/// 预置卡面色板（SPEC §3.2：12 色 + 自定义色）。
///
/// 全部为深调，白色前景在浅/深主题下均满足对比度要求——预置卡面前景一律白色。
/// 自定义色的前景明暗判断在 M1-02（卡片编辑表单）实现。
abstract final class CardPalette {
  /// 数据库默认卡面色（SPEC §6 schema: `color TEXT DEFAULT '#4A6FA5'`）。
  static const steelBlue = Color(0xFF4A6FA5);
  static const indigo = Color(0xFF283593);
  static const blue = Color(0xFF1565C0);
  static const teal = Color(0xFF00695C);
  static const green = Color(0xFF2E7D32);
  static const olive = Color(0xFF827717);
  static const orange = Color(0xFFE65100);
  static const red = Color(0xFFC62828);
  static const berry = Color(0xFFAD1457);
  static const purple = Color(0xFF6A1B9A);
  static const brown = Color(0xFF5D4037);
  static const blueGrey = Color(0xFF455A64);

  static const Color defaultColor = steelBlue;

  static const List<Color> presets = [
    steelBlue,
    indigo,
    blue,
    teal,
    green,
    olive,
    orange,
    red,
    berry,
    purple,
    brown,
    blueGrey,
  ];

  /// 卡面前景色：自定义浅色卡面用黑字，其余（含全部预置色）用白字。
  static Color foregroundFor(Color background) =>
      background.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;

  /// 解析数据库存储的 `#RRGGBB`；非法值回退默认色（防御同步来的脏数据）。
  static Color parseHex(String hex) {
    final match = RegExp(r'^#([0-9A-Fa-f]{6})$').firstMatch(hex);
    if (match == null) return defaultColor;
    return Color(0xFF000000 | int.parse(match.group(1)!, radix: 16));
  }

  /// 序列化为数据库/同步协议格式 `#RRGGBB`（SPEC §6.2）。
  static String toHex(Color color) {
    final argb = color.toARGB32() & 0xFFFFFF;
    return '#${argb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
