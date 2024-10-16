import 'package:flutter/material.dart';

class BasicAlphaColor extends Color {
  const BasicAlphaColor(int primary) : super(primary);

  Color get alpha10 => Color((value & 0x00FFFFFF) | 0x19000000);

  Color get alpha20 => Color((value & 0x00FFFFFF) | 0x33000000);
}

class AlphaColor extends BasicAlphaColor {
  const AlphaColor(int primary) : super(primary);

  Color get alpha0 => Color((value & 0x00FFFFFF) | 0x00000000);

  Color get alpha30 => Color((value & 0x00FFFFFF) | 0x4C000000);

  Color get alpha40 => Color((value & 0x00FFFFFF) | 0x66000000);

  Color get alpha50 => Color((value & 0x00FFFFFF) | 0x7F000000);

  Color get alpha60 => Color((value & 0x00FFFFFF) | 0x99000000);

  Color get alpha70 => Color((value & 0x00FFFFFF) | 0xB2000000);

  Color get alpha80 => Color((value & 0x00FFFFFF) | 0xCC000000);

  Color get alpha90 => Color((value & 0x00FFFFFF) | 0xE5000000);

  Color get alpha100 => Color((value & 0x00FFFFFF) | 0xFF000000);
}

class SDGAColor extends ColorSwatch<int> {
  const SDGAColor(int primary, Map<int, Color> swatch) : super(primary, swatch);

  Color get shade25 => this[25]!;

  Color get shade50 => this[50]!;

  Color get shade100 => this[100]!;

  Color get shade200 => this[200]!;

  Color get shade300 => this[300]!;

  Color get shade400 => this[400]!;

  Color get shade500 => this[500]!;

  Color get shade600 => this[600]!;

  Color get shade700 => this[700]!;

  Color get shade800 => this[800]!;

  Color get shade900 => this[900]!;

  Color get shade950 => this[950]!;
}

/// Represents the base colors of the SDGA design system.
class SDGAColors {
  static const int _black = 0xFF161616;
  static const int _white = 0xFFFFFFFF;
  static const int _primaryPrimary = 0xFF1B8354;
  static const int _secondaryGoldPrimary = 0xFFDBA102;
  static const int _tertiaryLavenderPrimary = 0xFF80519F;
  static const int _neutralPrimary = 0xFF4D5761;
  static const int _redPrimary = 0xFFD92C20;
  static const int _bluePrimary = 0xFF156FEE;
  static const int _greenPrimary = 0xFF069454;
  static const int _yellowPrimary = 0xFFDC6803;

  static const Color black = Color(_black);

  static const Color white = Color(_white);

  static const SDGAColor primary = SDGAColor(_primaryPrimary, {
    25: Color(0xFFF7FDF9),
    50: Color(0xFFF3FCF6),
    100: Color(0xFFDFF6E7),
    200: Color(0xFFB8EACB),
    300: Color(0xFF88D8AD),
    400: Color(0xFF54C08A),
    500: Color(0xFF25935F),
    600: Color(_primaryPrimary),
    700: Color(0xFF166A45),
    800: Color(0xFF14573A),
    900: Color(0xFF104631),
    950: Color(0xFF092A1E),
  });

  static const SDGAColor secondaryGold = SDGAColor(_secondaryGoldPrimary, {
    25: Color(0xFFFFFEF7),
    50: Color(0xFFFFFEF2),
    100: Color(0xFFFFFCE6),
    200: Color(0xFFFCF3BD),
    300: Color(0xFFFAE996),
    400: Color(0xFFF7D54D),
    500: Color(0xFFF5BD02),
    600: Color(_secondaryGoldPrimary),
    700: Color(0xFFB87B02),
    800: Color(0xFF945C01),
    900: Color(0xFF6E3C00),
    950: Color(0xFF472400),
  });

  static const SDGAColor tertiaryLavender =
      SDGAColor(_tertiaryLavenderPrimary, {
    25: Color(0xFFFEFCFF),
    50: Color(0xFFF9F5FA),
    100: Color(0xFFF2E9F5),
    200: Color(0xFFE1CCE8),
    300: Color(0xFFCCADD9),
    400: Color(0xFFA57BBA),
    500: Color(_tertiaryLavenderPrimary),
    600: Color(0xFF6D428F),
    700: Color(0xFF532D75),
    800: Color(0xFF3D1D5E),
    900: Color(0xFF281047),
    950: Color(0xFF16072E),
  });

  static const SDGAColor neutral = SDGAColor(_neutralPrimary, {
    25: Color(0xFFFCFCFD),
    50: Color(0xFFF9FAFB),
    100: Color(0xFFF3F4F6),
    200: Color(0xFFE5E7EB),
    300: Color(0xFFD2D6DB),
    400: Color(0xFF9DA4AE),
    500: Color(0xFF6C727E),
    600: Color(_neutralPrimary),
    700: Color(0xFF384250),
    800: Color(0xFF1F2A37),
    900: Color(0xFF111927),
    950: Color(0xFF0C111B),
  });

  static const SDGAColor red = SDGAColor(_redPrimary, {
    25: Color(0xFFFFFBFA),
    50: Color(0xFFFEF3F2),
    100: Color(0xFFFEE4E2),
    200: Color(0xFFFECDCA),
    300: Color(0xFFFCA19B),
    400: Color(0xFFF97066),
    500: Color(0xFFF04437),
    600: Color(_redPrimary),
    700: Color(0xFFB42318),
    800: Color(0xFF912018),
    900: Color(0xFF7A2619),
    950: Color(0xFF54150C),
  });

  static const SDGAColor blue = SDGAColor(_bluePrimary, {
    25: Color(0xFFF5FAFF),
    50: Color(0xFFEFF8FF),
    100: Color(0xFFD1E9FF),
    200: Color(0xFFB2DDFF),
    300: Color(0xFF84CAFF),
    400: Color(0xFF53B0FD),
    500: Color(0xFF2E90FA),
    600: Color(_bluePrimary),
    700: Color(0xFF175CD3),
    800: Color(0xFF1849A9),
    900: Color(0xFF194084),
    950: Color(0xFF102A56),
  });

  static const SDGAColor green = SDGAColor(_greenPrimary, {
    25: Color(0xFFF6FEF9),
    50: Color(0xFFECFDF3),
    100: Color(0xFFDCFAE6),
    200: Color(0xFFABEFC6),
    300: Color(0xFF75DFA6),
    400: Color(0xFF47CD89),
    500: Color(0xFF17B169),
    600: Color(_greenPrimary),
    700: Color(0xFF067647),
    800: Color(0xFF085D3A),
    900: Color(0xFF074C30),
    950: Color(0xFF053321),
  });

  static const SDGAColor yellow = SDGAColor(_yellowPrimary, {
    25: Color(0xFFFFFCF5),
    50: Color(0xFFFFFAEB),
    100: Color(0xFFFEF0C7),
    200: Color(0xFFFEDF89),
    300: Color(0xFFFEC84B),
    400: Color(0xFFFDB022),
    500: Color(0xFFF79009),
    600: Color(_yellowPrimary),
    700: Color(0xFFB54707),
    800: Color(0xFF93370C),
    900: Color(0xFF7A2E0E),
    950: Color(0xFF4E1D09),
  });

  static const AlphaColor blackAlpha = AlphaColor(_black);

  static const AlphaColor whiteAlpha = AlphaColor(_white);

  static const AlphaColor primaryAlpha = AlphaColor(_primaryPrimary);

  static const BasicAlphaColor redAlpha = BasicAlphaColor(_redPrimary);

  static const BasicAlphaColor blueAlpha = BasicAlphaColor(_bluePrimary);

  static const BasicAlphaColor greenAlpha = BasicAlphaColor(_greenPrimary);

  static const BasicAlphaColor yellowAlpha = BasicAlphaColor(_yellowPrimary);
}
