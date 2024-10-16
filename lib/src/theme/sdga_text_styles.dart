import 'package:flutter/widgets.dart';

/// A default text style that will use the default font family of
/// SDGA design system which is `IBMPlexSansArabic`.
class SDGATextStyle extends TextStyle {
  const SDGATextStyle({
    bool inherit = true,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<String>? fontFamilyFallback,
    TextOverflow? overflow,
  }) : super(
          fontFamily: 'IBMPlexSansArabic',
          package: 'sdga_design_system',
          inherit: inherit,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          leadingDistribution: leadingDistribution,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          fontVariations: fontVariations,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
          fontFamilyFallback: fontFamilyFallback,
          overflow: overflow,
        );
}

/// Represents the base text styles of the SDGA design system.
class SDGATextStyles {
  static const TextStyle displayExtraExtraLargeMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 72,
    letterSpacing: -0.02,
    height: 90 / 72,
  );

  static const TextStyle displayExtraExtraLargeSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 72,
    letterSpacing: -0.02,
    height: 90 / 72,
  );

  static const TextStyle displayExtraExtraLargeBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 72,
    letterSpacing: -0.02,
    height: 90 / 72,
  );

  static const TextStyle displayExtraExtraLargeRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 72,
    letterSpacing: -0.02,
    height: 90 / 72,
  );

  static const TextStyle displayExtraLargeRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 60,
    letterSpacing: -0.02,
    height: 72 / 60,
  );

  static const TextStyle displayExtraLargeMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 60,
    letterSpacing: -0.02,
    height: 72 / 60,
  );

  static const TextStyle displayExtraLargeSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 60,
    letterSpacing: -0.02,
    height: 72 / 60,
  );

  static const TextStyle displayExtraLargeBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 60,
    letterSpacing: -0.02,
    height: 72 / 60,
  );

  static const TextStyle displayLargeRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 48,
    letterSpacing: -0.02,
    height: 60 / 48,
  );

  static const TextStyle displayLargeMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 48,
    letterSpacing: -0.02,
    height: 60 / 48,
  );

  static const TextStyle displayLargeSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    letterSpacing: -0.02,
    height: 60 / 48,
  );

  static const TextStyle displayLargeBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 48,
    letterSpacing: -0.02,
    height: 60 / 48,
  );

  static const TextStyle displayMediumRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 36,
    letterSpacing: -0.02,
    height: 44 / 36,
  );

  static const TextStyle displayMediumMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 36,
    letterSpacing: -0.02,
    height: 44 / 36,
  );

  static const TextStyle displayMediumSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 36,
    letterSpacing: -0.02,
    height: 44 / 36,
  );

  static const TextStyle displayMediumBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 36,
    letterSpacing: -0.02,
    height: 44 / 36,
  );

  static const TextStyle displaySmallRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    height: 38 / 30,
  );

  static const TextStyle displaySmallMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 30,
    height: 38 / 30,
  );

  static const TextStyle displaySmallSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30,
    height: 38 / 30,
  );

  static const TextStyle displaySmallBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 38 / 30,
  );

  // static const TextStyle displaySmallMediumItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w500,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 30,
  //   height: 38 / 30,
  // );

  static const TextStyle displayExtraSmallRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    height: 32 / 24,
  );

  static const TextStyle displayExtraSmallMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 32 / 24,
  );

  static const TextStyle displayExtraSmallSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 32 / 24,
  );

  static const TextStyle displayExtraSmallBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32 / 24,
  );

  // static const TextStyle displayExtraSmallMediumItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w500,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 24,
  //   height: 32 / 24,
  // );

  static const TextStyle textExtraLargeRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 30 / 20,
  );

  static const TextStyle textExtraLargeMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 30 / 20,
  );

  static const TextStyle textExtraLargeSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 30 / 20,
  );

  static const TextStyle textExtraLargeBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 30 / 20,
  );

  // static const TextStyle textExtraLargeRegularItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w400,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 20,
  //   height: 30 / 20,
  // );

  // static const TextStyle textExtraLargeMediumItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w500,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 20,
  //   height: 30 / 20,
  // );

  // static const TextStyle textExtraLargeSemiBoldItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w600,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 20,
  //   height: 30 / 20,
  // );

  // static const TextStyle textExtraLargeBoldItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w700,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 20,
  //   height: 30 / 20,
  // );

  static const TextStyle textExtraLargeRegularUnderlined = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 30 / 20,
    decoration: TextDecoration.underline,
  );

  static const TextStyle textLargeRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 28 / 18,
  );

  static const TextStyle textLargeMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 28 / 18,
  );

  static const TextStyle textLargeSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 28 / 18,
  );

  static const TextStyle textLargeBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 28 / 18,
  );

  // static const TextStyle textLargeRegularItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w400,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 18,
  //   height: 28 / 18,
  // );

  // static const TextStyle textLargeMediumItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w500,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 18,
  //   height: 28 / 18,
  // );

  // static const TextStyle textLargeSemiBoldItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w600,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 18,
  //   height: 28 / 18,
  // );

  // static const TextStyle textLargeBoldItalic = SDGATextStyle(
  //   fontFamily: 'IBM Plex Sans',
  //   fontWeight: FontWeight.w700,
  //   fontStyle: FontStyle.italic,
  //   fontSize: 18,
  //   height: 28 / 18,
  // );

  static const TextStyle textMediumRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle textMediumMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle textMediumSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle textMediumBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle textSmallRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle textSmallMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle textSmallSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle textSmallBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle textExtraSmallRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 18 / 12,
  );

  static const TextStyle textExtraSmallMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 18 / 12,
  );

  static const TextStyle textExtraSmallSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 18 / 12,
  );

  static const TextStyle textExtraSmallBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 18 / 12,
  );

  static const TextStyle textExtraExtraSmallRegular = SDGATextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 14 / 10,
  );

  static const TextStyle textExtraExtraSmallMedium = SDGATextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 14 / 10,
  );

  static const TextStyle textExtraExtraSmallSemiBold = SDGATextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 14 / 10,
  );

  static const TextStyle textExtraExtraSmallBold = SDGATextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 10,
    height: 14 / 10,
  );
}
