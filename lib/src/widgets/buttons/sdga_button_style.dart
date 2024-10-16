part of 'sdga_button.dart';

BoxConstraints _min(double width, double height) => BoxConstraints(
      minWidth: width,
      minHeight: height,
    );
BoxConstraints _minSquare(double dimension) => BoxConstraints(
      minWidth: dimension,
      minHeight: dimension,
    );
BoxConstraints _allSquare(double dimension) => BoxConstraints(
      minWidth: dimension,
      minHeight: dimension,
      maxWidth: dimension,
      maxHeight: dimension,
    );

BoxConstraints _getButtonConstraints({
  required SDGAWidgetSize size,
  required SDGACloseButtonSize closeSize,
  required _SDGAButtonType type,
}) {
  switch (type) {
    case _SDGAButtonType.fab:
    case _SDGAButtonType.button:
    case _SDGAButtonType.destructiveButton:
      switch (size) {
        case SDGAWidgetSize.small:
          return _minSquare(32);
        case SDGAWidgetSize.medium:
          return _minSquare(40);
        case SDGAWidgetSize.large:
          return _minSquare(44);
      }
    case _SDGAButtonType.icon:
    case _SDGAButtonType.destructiveIcon:
      switch (size) {
        case SDGAWidgetSize.small:
          return _allSquare(24);
        case SDGAWidgetSize.medium:
          return _allSquare(32);
        case SDGAWidgetSize.large:
          return _allSquare(44);
      }
    case _SDGAButtonType.menu:
      switch (size) {
        case SDGAWidgetSize.small:
          return _min(28, 24);
        case SDGAWidgetSize.medium:
          return _min(40, 32);
        case SDGAWidgetSize.large:
          return _min(52, 40);
      }
    case _SDGAButtonType.close:
      switch (closeSize) {
        case SDGACloseButtonSize.xSmall:
          return _allSquare(20);
        case SDGACloseButtonSize.small:
          return _allSquare(24);
        case SDGACloseButtonSize.medium:
          return _allSquare(32);
        case SDGACloseButtonSize.large:
          return _allSquare(40);
      }
  }
}

/// Represents the different styles for SDGA buttons.
enum SDGAButtonStyle {
  primaryNeutral,
  primaryBrand,
  secondary,
  secondaryOutline,
  subtle,
  transparent,
}

/// Represents the different styles for SDGA floating action buttons (FABs).
enum SDGAFabButtonStyle {
  primaryNeutral(SDGAButtonStyle.primaryNeutral),
  primaryBrand(SDGAButtonStyle.primaryBrand),
  secondary(SDGAButtonStyle.secondary);

  final SDGAButtonStyle normalStyle;

  const SDGAFabButtonStyle(this.normalStyle);
}

/// Represents the different styles for SDGA destructive buttons.
enum SDGADestructiveButtonStyle {
  primary,
  secondary,
  secondaryOutline,
  subtle,
  transparent,
}

enum _SDGAButtonType {
  button,
  icon,
  destructiveButton,
  destructiveIcon,
  menu,
  close,
  fab,
}

class _SDGAButtonStyle {
  final Color background;
  final Color backgroundDisabled;
  final Color backgroundPressed;
  final Color backgroundSelected;
  final Color backgroundFocused;
  final Color backgroundHovered;
  final Color text;
  final Color? textPressed;
  final Color? textHovered;
  final Color? textSelected;
  final Color textDisabled;
  final BoxBorder? border;
  final BoxBorder? borderFocused;
  final BoxBorder? borderDisabled;

  _SDGAButtonStyle({
    this.background = Colors.transparent,
    this.backgroundDisabled = Colors.transparent,
    this.backgroundPressed = Colors.transparent,
    this.backgroundSelected = Colors.transparent,
    this.backgroundFocused = Colors.transparent,
    this.backgroundHovered = Colors.transparent,
    required this.text,
    required this.textDisabled,
    this.textPressed,
    this.textHovered,
    this.textSelected,
    this.border,
    this.borderFocused,
    this.borderDisabled,
  });

  factory _SDGAButtonStyle.fromStyle(
    _SDGAButtonType type,
    SDGAButtonStyle style,
    SDGADestructiveButtonStyle destructiveStyle,
    bool onColor,
    SDGAColorScheme colors,
  ) {
    final Color transparent = colors.backgrounds.white.withOpacity(0);
    switch (type) {
      case _SDGAButtonType.button:
      case _SDGAButtonType.icon:
      case _SDGAButtonType.menu:
      case _SDGAButtonType.fab:
        switch (style) {
          case SDGAButtonStyle.primaryNeutral:
            return _SDGAButtonStyle(
              background: onColor
                  ? colors.buttons.backgroundOnColorDefault
                  : colors.buttons.backgroundBlackDefault,
              backgroundDisabled: onColor
                  ? colors.buttons.backgroundDisabledOnColor
                  : colors.globals.backgroundDisabled,
              backgroundPressed: onColor
                  ? colors.buttons.backgroundOnColorPressed
                  : colors.buttons.backgroundBlackPressed,
              backgroundSelected: onColor
                  ? colors.buttons.backgroundOnColorSelected
                  : colors.buttons.backgroundBlackSelected,
              backgroundHovered: onColor
                  ? colors.buttons.backgroundOnColorHovered
                  : colors.buttons.backgroundBlackHovered,
              backgroundFocused: onColor
                  ? colors.buttons.backgroundOnColorFocused
                  : colors.buttons.backgroundBlackFocused,
              text: onColor
                  ? colors.texts.defaultColor
                  : colors.texts.onColorPrimary,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              borderFocused: SDGADoubleBorder(
                firstBorder: Border.all(
                  color: onColor
                      ? colors.borders.black
                      : colors.texts.onColorPrimary,
                  width: 3,
                ),
                secondBorder: Border.all(
                  color: onColor ? colors.borders.white : colors.borders.black,
                  width: 2,
                ),
              ),
            );
          case SDGAButtonStyle.primaryBrand:
            return _SDGAButtonStyle(
              background: onColor
                  ? colors.buttons.backgroundOnColorDefault
                  : colors.buttons.backgroundPrimaryDefault,
              backgroundDisabled: onColor
                  ? colors.buttons.backgroundDisabledOnColor
                  : colors.globals.backgroundDisabled,
              backgroundPressed: onColor
                  ? colors.buttons.backgroundOnColorPressed
                  : colors.buttons.backgroundPrimaryPressed,
              backgroundSelected: onColor
                  ? colors.buttons.backgroundOnColorSelected
                  : colors.buttons.backgroundPrimarySelected,
              backgroundHovered: onColor
                  ? colors.buttons.backgroundOnColorHovered
                  : colors.buttons.backgroundPrimaryHovered,
              backgroundFocused: onColor
                  ? colors.buttons.backgroundOnColorFocused
                  : colors.buttons.backgroundPrimaryFocused,
              text: onColor
                  ? colors.texts.defaultColor
                  : colors.texts.onColorPrimary,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              borderFocused: SDGADoubleBorder(
                firstBorder: Border.all(
                  color: onColor
                      ? colors.borders.black
                      : colors.texts.onColorPrimary,
                  width: 3,
                ),
                secondBorder: Border.all(
                  color: onColor ? colors.borders.white : colors.borders.black,
                  width: 2,
                ),
              ),
            );
          case SDGAButtonStyle.secondary:
            return _SDGAButtonStyle(
              background: onColor
                  ? colors.buttons.backgroundTransparentDefault
                  : colors.buttons.backgroundNeutralDefault,
              backgroundDisabled: onColor
                  ? colors.buttons.backgroundDisabledOnColor
                  : colors.globals.backgroundDisabled,
              backgroundPressed: onColor
                  ? colors.buttons.backgroundTransparentPressed
                  : colors.buttons.backgroundNeutralPressed,
              backgroundSelected: onColor
                  ? colors.buttons.backgroundTransparentSelected
                  : colors.buttons.backgroundNeutralSelected,
              backgroundHovered: onColor
                  ? colors.buttons.backgroundTransparentHovered
                  : colors.buttons.backgroundNeutralHovered,
              backgroundFocused: onColor
                  ? colors.buttons.backgroundTransparentSelected
                  : colors.buttons.backgroundNeutralFocused,
              text: onColor
                  ? colors.texts.onColorPrimary
                  : colors.texts.defaultColor,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              borderFocused: Border.all(
                color: onColor ? colors.borders.white : colors.borders.black,
                width: 2,
              ),
            );
          case SDGAButtonStyle.secondaryOutline:
            return _SDGAButtonStyle(
              background: transparent,
              backgroundFocused: transparent,
              backgroundDisabled: transparent,
              backgroundPressed: onColor
                  ? colors.buttons.backgroundTransparentPressed
                  : colors.buttons.backgroundNeutralPressed,
              backgroundSelected: onColor
                  ? colors.buttons.backgroundTransparentSelected
                  : colors.buttons.backgroundNeutralSelected,
              backgroundHovered: onColor
                  ? colors.buttons.backgroundTransparentHovered
                  : colors.buttons.backgroundNeutralHovered,
              text: onColor
                  ? colors.texts.onColorPrimary
                  : colors.texts.defaultColor,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              border: Border.all(
                color: onColor
                    ? colors.borders.white
                    : colors.borders.neutralPrimary,
                width: 1,
              ),
              borderDisabled: Border.all(
                color: onColor
                    ? colors.globals.iconDefaultOnColorDisabled
                    : colors.borders.neutralSecondary,
                width: 1,
              ),
              borderFocused: Border.all(
                color: onColor ? colors.borders.white40 : colors.borders.black,
                width: 2,
              ),
            );
          case SDGAButtonStyle.subtle:
            return _SDGAButtonStyle(
              background: transparent,
              backgroundFocused: transparent,
              backgroundDisabled: transparent,
              backgroundPressed: onColor
                  ? colors.buttons.backgroundTransparentPressed
                  : colors.buttons.backgroundNeutralPressed,
              backgroundSelected: onColor
                  ? colors.buttons.backgroundTransparentSelected
                  : colors.buttons.backgroundNeutralSelected,
              backgroundHovered: onColor
                  ? colors.buttons.backgroundTransparentHovered
                  : colors.buttons.backgroundNeutralHovered,
              text: onColor
                  ? colors.texts.onColorPrimary
                  : colors.texts.defaultColor,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              borderFocused: Border.all(
                color: onColor ? colors.borders.white40 : colors.borders.black,
                width: 2,
              ),
            );
          case SDGAButtonStyle.transparent:
            return _SDGAButtonStyle(
              text: onColor
                  ? colors.texts.onColorPrimary
                  : colors.texts.defaultColor,
              textDisabled: onColor
                  ? colors.globals.textDefaultOnColorDisabled
                  : colors.globals.textDefaultDisabled,
              textHovered: onColor
                  ? colors.links.primaryHovered
                  : colors.buttons.backgroundPrimaryHovered,
              textPressed: onColor
                  ? colors.links.primaryPressed
                  : colors.buttons.backgroundPrimaryPressed,
              borderFocused: Border.all(
                color: onColor ? colors.borders.white40 : colors.borders.black,
                width: 2,
              ),
            );
        }
      case _SDGAButtonType.destructiveButton:
      case _SDGAButtonType.destructiveIcon:
        switch (destructiveStyle) {
          case SDGADestructiveButtonStyle.primary:
            return _SDGAButtonStyle(
              background: colors.buttons.backgroundDangerPrimaryDefault,
              backgroundDisabled: colors.globals.backgroundDisabled,
              backgroundPressed: colors.buttons.backgroundDangerPrimaryPressed,
              backgroundSelected:
                  colors.buttons.backgroundDangerPrimarySelected,
              backgroundHovered: colors.buttons.backgroundDangerPrimaryHovered,
              backgroundFocused: colors.buttons.backgroundDangerPrimaryFocused,
              text: colors.texts.onColorPrimary,
              textDisabled: colors.globals.textDefaultDisabled,
              borderFocused: SDGADoubleBorder(
                firstBorder: Border.all(
                  color: colors.texts.onColorPrimary,
                  width: 3,
                ),
                secondBorder: Border.all(
                  color: colors.borders.black,
                  width: 2,
                ),
              ),
            );
          case SDGADestructiveButtonStyle.secondary:
            return _SDGAButtonStyle(
              background: colors.buttons.backgroundDangerSecondaryDefault,
              backgroundDisabled: colors.globals.backgroundDisabled,
              backgroundPressed:
                  colors.buttons.backgroundDangerSecondaryPressed,
              backgroundSelected:
                  colors.buttons.backgroundDangerSecondarySelected,
              backgroundHovered:
                  colors.buttons.backgroundDangerSecondaryHovered,
              backgroundFocused:
                  colors.buttons.backgroundDangerSecondaryFocused,
              text: colors.texts.error,
              textDisabled: colors.globals.textDefaultDisabled,
              borderFocused: Border.all(
                color: colors.borders.black,
                width: 2,
              ),
            );
          case SDGADestructiveButtonStyle.secondaryOutline:
            return _SDGAButtonStyle(
              background: transparent,
              backgroundFocused: transparent,
              backgroundDisabled: transparent,
              backgroundPressed:
                  colors.buttons.backgroundDangerSecondaryPressed,
              backgroundSelected:
                  colors.buttons.backgroundDangerSecondarySelected,
              backgroundHovered:
                  colors.buttons.backgroundDangerSecondaryHovered,
              text: colors.texts.error,
              textDisabled: colors.globals.textDefaultDisabled,
              border: Border.all(
                color: colors.borders.error,
                width: 1,
              ),
              borderDisabled: Border.all(
                color: colors.borders.neutralSecondary,
                width: 1,
              ),
              borderFocused: Border.all(
                color: colors.borders.black,
                width: 2,
              ),
            );
          case SDGADestructiveButtonStyle.subtle:
            return _SDGAButtonStyle(
              background: transparent,
              backgroundFocused: transparent,
              backgroundDisabled: transparent,
              backgroundPressed:
                  colors.buttons.backgroundDangerSecondaryPressed,
              backgroundSelected:
                  colors.buttons.backgroundDangerSecondarySelected,
              backgroundHovered:
                  colors.buttons.backgroundDangerSecondaryHovered,
              text: colors.texts.error,
              textDisabled: colors.globals.textDefaultDisabled,
              borderFocused: Border.all(
                color: colors.borders.black,
                width: 2,
              ),
            );
          case SDGADestructiveButtonStyle.transparent:
            return _SDGAButtonStyle(
              text: colors.texts.error,
              textDisabled: colors.globals.textDefaultDisabled,
              textHovered: colors.buttons.backgroundDangerPrimaryHovered,
              textPressed: colors.buttons.backgroundDangerPrimaryPressed,
              textSelected: colors.buttons.backgroundDangerPrimarySelected,
              borderFocused: Border.all(
                color: colors.borders.black,
                width: 2,
              ),
            );
        }
      case _SDGAButtonType.close:
        return _SDGAButtonStyle(
          background: onColor
              ? colors.buttons.backgroundTransparentDefault
              : colors.buttons.backgroundNeutralDefault,
          backgroundDisabled: onColor
              ? colors.buttons.backgroundDisabledOnColor
              : colors.globals.backgroundDisabled,
          backgroundPressed: onColor
              ? colors.buttons.backgroundTransparentPressed
              : colors.buttons.backgroundNeutralPressed,
          backgroundSelected: onColor
              ? colors.buttons.backgroundTransparentSelected
              : colors.buttons.backgroundNeutralSelected,
          backgroundHovered: onColor
              ? colors.buttons.backgroundTransparentHovered
              : colors.buttons.backgroundNeutralHovered,
          backgroundFocused: onColor
              ? colors.buttons.backgroundTransparentSelected
              : colors.buttons.backgroundNeutralFocused,
          text:
              onColor ? colors.texts.onColorPrimary : colors.texts.defaultColor,
          textDisabled: onColor
              ? colors.globals.textDefaultOnColorDisabled
              : colors.globals.textDefaultDisabled,
          borderFocused: Border.all(
            color: onColor ? colors.borders.white : colors.borders.black,
            width: 2,
          ),
        );
    }
  }
}
