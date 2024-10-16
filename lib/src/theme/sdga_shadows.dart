import 'package:flutter/material.dart';

/// Represents the base shadows of the SDGA design system.
class SDGAShadows {
  static const int _shadowColor = 0x101828;

  static const List<BoxShadow> shadowXS = [
    BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 1),
      color: Color(_shadowColor | 0x0D000000),
    ),
  ];

  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      blurRadius: 3,
      offset: Offset(0, 1),
      color: Color(_shadowColor | 0x1A000000),
    ),
    BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 1),
      color: Color(_shadowColor | 0x0F000000),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 4),
      color: Color(_shadowColor | 0x1A000000),
    ),
    BoxShadow(
      blurRadius: 4,
      spreadRadius: -2,
      offset: Offset(0, 2),
      color: Color(_shadowColor | 0x0F000000),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      blurRadius: 16,
      spreadRadius: -6,
      offset: Offset(0, 12),
      color: Color(_shadowColor | 0x14000000),
    ),
    BoxShadow(
      blurRadius: 6,
      spreadRadius: -2,
      offset: Offset(0, 4),
      color: Color(_shadowColor | 0x08000000),
    ),
  ];

  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 20),
      color: Color(_shadowColor | 0x14000000),
    ),
    BoxShadow(
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 8),
      color: Color(_shadowColor | 0x08000000),
    ),
  ];

  static const List<BoxShadow> shadow2XL = [
    BoxShadow(
      blurRadius: 48,
      spreadRadius: -12,
      offset: Offset(0, 24),
      color: Color(_shadowColor | 0x2E000000),
    )
  ];

  static const List<BoxShadow> shadow3XL = [
    BoxShadow(
      blurRadius: 64,
      spreadRadius: -12,
      offset: Offset(0, 32),
      color: Color(_shadowColor | 0x24000000),
    ),
  ];

  static const List<BoxShadow> shadowDrawer = [
    BoxShadow(
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(4, 18),
      color: Color(_shadowColor | 0x1A000000),
    ),
  ];
}

 // 3% > 08
 // 5% > 0D
 // 6% > 0F
 // 8% > 14
 // 10% > 1A
 // 14% > 24
 // 18% > 2E