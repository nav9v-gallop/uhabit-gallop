import 'package:flutter/material.dart';

/// The 20-color palette matching the source Android app exactly.
///
/// Index 8 (teal #00897B) is the default color for new habits.
class PaletteColor {
  PaletteColor._();

  static const List<Color> colors = [
    Color(0xFFD32F2F), //  0 - Red
    Color(0xFFE64A19), //  1 - Deep Orange
    Color(0xFFF57C00), //  2 - Orange
    Color(0xFFFF8F00), //  3 - Amber
    Color(0xFFF9A825), //  4 - Yellow
    Color(0xFFAFB42B), //  5 - Lime
    Color(0xFF7CB342), //  6 - Light Green
    Color(0xFF388E3C), //  7 - Green
    Color(0xFF00897B), //  8 - Teal (default)
    Color(0xFF00ACC1), //  9 - Cyan
    Color(0xFF039BE5), // 10 - Light Blue
    Color(0xFF1976D2), // 11 - Blue
    Color(0xFF303F9F), // 12 - Indigo
    Color(0xFF5E35B1), // 13 - Deep Purple
    Color(0xFF8E24AA), // 14 - Purple
    Color(0xFFD81B60), // 15 - Pink
    Color(0xFF5D4037), // 16 - Brown
    Color(0xFF303030), // 17 - Dark Grey
    Color(0xFF757575), // 18 - Grey
    Color(0xFFAAAAAA), // 19 - Light Grey
  ];

  /// Human-readable names for accessibility labels.
  static const List<String> names = [
    'Red',
    'Deep Orange',
    'Orange',
    'Amber',
    'Yellow',
    'Lime',
    'Light Green',
    'Green',
    'Teal',
    'Cyan',
    'Light Blue',
    'Blue',
    'Indigo',
    'Deep Purple',
    'Purple',
    'Pink',
    'Brown',
    'Dark Grey',
    'Grey',
    'Light Grey',
  ];

  /// Default color index for new habits.
  static const int defaultIndex = 8;

  /// Returns the [Color] for a given palette index, clamped to valid range.
  static Color getColor(int index) {
    final clamped = index.clamp(0, colors.length - 1);
    return colors[clamped];
  }

  /// Returns the human-readable name for a given palette index.
  static String getName(int index) {
    final clamped = index.clamp(0, names.length - 1);
    return names[clamped];
  }
}
