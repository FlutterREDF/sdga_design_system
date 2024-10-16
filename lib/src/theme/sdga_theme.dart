import 'package:flutter/material.dart';

import 'sdga_color_scheme.dart';

/// An extension for [ThemeData] that provides a set of color schemes
/// specifically designed for the Saudi Digital Government Authority (SDGA).
///
/// This extension allows you to easily apply the SDGA color palette to
/// your application's theme. You can choose between a light or dark color
/// scheme based on your preferred UI style.
class SDGATheme extends ThemeExtension<SDGATheme> {
  final SDGAColorScheme colorScheme;

  const SDGATheme({required this.colorScheme});

  /// The light theme of the [SDGAColorScheme].
  SDGATheme.light() : colorScheme = SDGAColorScheme.light();

  /// The dark theme of the [SDGAColorScheme].
  SDGATheme.dark() : colorScheme = SDGAColorScheme.dark();

  @override
  ThemeExtension<SDGATheme> copyWith() {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<SDGATheme> lerp(SDGATheme? other, double t) {
    if (t == 0 || other == null) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return SDGATheme(colorScheme: colorScheme.lerp(other.colorScheme, t));
    }
  }

  static SDGATheme of(BuildContext context) {
    final SDGATheme? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        throw FlutterError(
          'SDGATheme.of() was called with an invalid context. The provided context '
          'must be a descendant of a Theme widget that has the SDGATheme extension '
          'applied. Please ensure that you\'ve correctly added the SDGATheme '
          'extension to your ThemeData and that the context you\'re using is '
          'within the appropriate widget hierarchy.\n'
          'You can use applySDGATheme() method on your ThemeData to apply it.'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }

  static SDGATheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<SDGATheme>();
}

extension ThemeDataEx on ThemeData {
  /// An extension method that will apply the [SDGATheme] as an extension
  /// to the ThemeData
  ThemeData applySDGATheme() => copyWith(
        extensions: [
          ...extensions.values,
          brightness == Brightness.light ? SDGATheme.light() : SDGATheme.dark(),
        ],
      );
}
