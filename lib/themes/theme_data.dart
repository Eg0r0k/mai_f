import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'Raleway',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Color(0xFFFDFDFD),
        primary: Color(0xFF5331EA),
        secondary: Color(0xFFF2F2F2)));

class TextStyles {
  static const TextStyle displayLarge =
      TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
  static const TextStyle displayMedium = TextStyle(fontSize: 24);
  static const TextStyle displaySmall = TextStyle(fontSize: 18);
  static const TextStyle headlineLarge =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle headlineMedium =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const TextStyle headlineSmall =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle titleLarge = TextStyle(fontSize: 20);
  static const TextStyle subtitle = TextStyle(fontSize: 14);
  static const TextStyle body = TextStyle(fontSize: 14);
  static const TextStyle caption = TextStyle(fontSize: 12);
}
