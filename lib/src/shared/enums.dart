import 'dart:ui';

import 'package:sdga_design_system/sdga_design_system.dart';

/// Defines the types of alerts in the SDGA design system.
enum SDGAAlertType {
  /// Neutral alert type, uses neutral color scheme.
  neutral(SDGAWidgetColor.neutral),

  /// Success alert type, uses success color scheme.
  success(SDGAWidgetColor.success),

  /// Information alert type, uses info color scheme.
  info(SDGAWidgetColor.info),

  /// Warning alert type, uses warning color scheme.
  warning(SDGAWidgetColor.warning),

  /// Error alert type, uses error color scheme.
  error(SDGAWidgetColor.error);

  /// The corresponding widget color for this alert type.
  final SDGAWidgetColor color;

  const SDGAAlertType(this.color);
}

/// Defines the size variants for SDGA widgets.
enum SDGAWidgetSize {
  /// Small-sized widget.
  small,

  /// Medium-sized widget.
  medium,

  /// Large-sized widget.
  large
}

/// Defines the style variants for SDGA widgets.
enum SDGAWidgetStyle {
  /// Neutral style, typically used for default or less emphasized widgets.
  neutral,

  /// Brand style, typically used for widgets that should reflect the brand identity.
  brand,

  /// On-color style, typically used for widgets placed on colored backgrounds.
  onColor
}

/// Defines the color variants for SDGA widgets.
enum SDGAWidgetColor {
  /// Neutral color variant.
  neutral,

  /// Information color variant.
  info,

  /// Success color variant.
  success,

  /// Warning color variant.
  warning,

  /// Error color variant.
  error;

  /// Gets the icon color based on the current color variant.
  ///
  /// [colors] The SDGA color scheme to use.
  Color getIconColor(SDGAColorScheme colors) {
    switch (this) {
      case SDGAWidgetColor.neutral:
        return colors.icons.neutral;
      case SDGAWidgetColor.info:
        return colors.icons.info;
      case SDGAWidgetColor.success:
        return colors.icons.success;
      case SDGAWidgetColor.warning:
        return colors.icons.warning;
      case SDGAWidgetColor.error:
        return colors.icons.error;
    }
  }

  /// Gets the main color based on the current color variant.
  ///
  /// [colors] The SDGA color scheme to use.
  Color getColor(SDGAColorScheme colors) {
    switch (this) {
      case SDGAWidgetColor.neutral:
        return colors.backgrounds.neutral400;
      case SDGAWidgetColor.info:
        return colors.backgrounds.info;
      case SDGAWidgetColor.success:
        return colors.backgrounds.success;
      case SDGAWidgetColor.warning:
        return colors.backgrounds.warning;
      case SDGAWidgetColor.error:
        return colors.backgrounds.error;
    }
  }

  /// Gets the text color based on the current color variant.
  ///
  /// [colors] The SDGA color scheme to use.
  Color getTextColor(SDGAColorScheme colors) {
    switch (this) {
      case SDGAWidgetColor.neutral:
        return colors.texts.primaryParagraph;
      case SDGAWidgetColor.info:
        return colors.texts.info;
      case SDGAWidgetColor.success:
        return colors.texts.success;
      case SDGAWidgetColor.warning:
        return colors.texts.warning;
      case SDGAWidgetColor.error:
        return colors.texts.error;
    }
  }

  /// Gets the light color variant based on the current color variant.
  ///
  /// [colors] The SDGA color scheme to use.
  Color getLightColor(SDGAColorScheme colors) {
    switch (this) {
      case SDGAWidgetColor.neutral:
        return colors.backgrounds.neutral50;
      case SDGAWidgetColor.info:
        return colors.backgrounds.info50;
      case SDGAWidgetColor.success:
        return colors.backgrounds.success50;
      case SDGAWidgetColor.warning:
        return colors.backgrounds.warning50;
      case SDGAWidgetColor.error:
        return colors.backgrounds.error50;
    }
  }

  /// Gets the border color based on the current color variant.
  ///
  /// [colors] The SDGA color scheme to use.
  Color getBorderColor(SDGAColorScheme colors) {
    switch (this) {
      case SDGAWidgetColor.neutral:
        return colors.borders.neutralPrimary;
      case SDGAWidgetColor.info:
        return colors.borders.info;
      case SDGAWidgetColor.success:
        return colors.borders.success;
      case SDGAWidgetColor.warning:
        return colors.borders.warning;
      case SDGAWidgetColor.error:
        return colors.borders.error;
    }
  }
}
