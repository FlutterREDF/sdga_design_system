import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

/// Represents the comprehensive color scheme for the SDGA design system.
///
/// This class encapsulates various color sub-schemes for different UI components
/// and elements, providing a centralized color management system for the entire
/// application.
class SDGAColorScheme {
  /// Color scheme for alpha (transparency) values.
  final AlphaColorScheme alphas;

  /// Color scheme for background elements.
  final BackgroundColorScheme backgrounds;

  /// Color scheme for borders and dividers.
  final BorderColorScheme borders;

  /// Color scheme for buttons.
  final ButtonColorScheme buttons;

  /// Color scheme for various control elements (e.g., switches, checkboxes).
  final ControlsColorScheme controls;

  /// Color scheme for form elements (e.g., input fields, labels).
  final FormColorScheme forms;

  /// Global color scheme for common elements across the app.
  final GlobalColorScheme globals;

  /// Color scheme for icons.
  final IconColorScheme icons;

  /// Color scheme for hyperlinks.
  final LinkColorScheme links;

  /// Color scheme for stepper components.
  final StepperColorScheme steppers;

  /// Color scheme for tables and data grids.
  final TableColorScheme tables;

  /// Color scheme for tags or chips.
  final TagColorScheme tags;

  /// Color scheme for text elements.
  final TextColorScheme texts;

  /// Color scheme for tooltips and popovers.
  final TooltipColorScheme tooltips;

  const SDGAColorScheme({
    required this.alphas,
    required this.backgrounds,
    required this.borders,
    required this.buttons,
    required this.controls,
    required this.forms,
    required this.globals,
    required this.icons,
    required this.links,
    required this.steppers,
    required this.tables,
    required this.tags,
    required this.texts,
    required this.tooltips,
  });

  SDGAColorScheme.light()
      : alphas = AlphaColorScheme.light(),
        backgrounds = BackgroundColorScheme.light(),
        borders = BorderColorScheme.light(),
        buttons = ButtonColorScheme.light(),
        controls = ControlsColorScheme.light(),
        forms = FormColorScheme.light(),
        globals = GlobalColorScheme.light(),
        icons = IconColorScheme.light(),
        links = LinkColorScheme.light(),
        steppers = StepperColorScheme.light(),
        tables = TableColorScheme.light(),
        tags = TagColorScheme.light(),
        texts = TextColorScheme.light(),
        tooltips = TooltipColorScheme.light();

  SDGAColorScheme.dark()
      : alphas = AlphaColorScheme.dark(),
        backgrounds = BackgroundColorScheme.dark(),
        borders = BorderColorScheme.dark(),
        buttons = ButtonColorScheme.dark(),
        controls = ControlsColorScheme.dark(),
        forms = FormColorScheme.dark(),
        globals = GlobalColorScheme.dark(),
        icons = IconColorScheme.dark(),
        links = LinkColorScheme.dark(),
        steppers = StepperColorScheme.dark(),
        tables = TableColorScheme.dark(),
        tags = TagColorScheme.dark(),
        texts = TextColorScheme.dark(),
        tooltips = TooltipColorScheme.dark();

  SDGAColorScheme lerp(SDGAColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return SDGAColorScheme(
        alphas: alphas.lerp(other.alphas, t),
        backgrounds: backgrounds.lerp(other.backgrounds, t),
        borders: borders.lerp(other.borders, t),
        buttons: buttons.lerp(other.buttons, t),
        controls: controls.lerp(other.controls, t),
        forms: forms.lerp(other.forms, t),
        globals: globals.lerp(other.globals, t),
        icons: icons.lerp(other.icons, t),
        links: links.lerp(other.links, t),
        steppers: steppers.lerp(other.steppers, t),
        tables: tables.lerp(other.tables, t),
        tags: tags.lerp(other.tags, t),
        texts: texts.lerp(other.texts, t),
        tooltips: tooltips.lerp(other.tooltips, t),
      );
    }
  }

  static SDGAColorScheme of(BuildContext context) => maybeOf(context)!;

  static SDGAColorScheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<SDGATheme>()?.colorScheme;
}

@protected
class AlphaColorScheme {
  final Color black0;
  final Color black10;
  final Color black20;
  final Color black30;
  final Color black40;
  final Color black50;
  final Color black60;
  final Color black70;
  final Color black80;
  final Color black90;
  final Color black100;
  final Color white0;
  final Color white10;
  final Color white20;
  final Color white30;
  final Color white40;
  final Color white50;
  final Color white60;
  final Color white70;
  final Color white80;
  final Color white90;
  final Color white100;
  final Color alphaError10;
  final Color alphaError20;
  final Color alphaInfo10;
  final Color alphaInfo20;
  final Color alphaPrimary10;
  final Color alphaPrimary20;
  final Color alphaSuccess10;
  final Color alphaSuccess20;
  final Color alphaWarning10;
  final Color alphaWarning20;

  const AlphaColorScheme({
    required this.black0,
    required this.black10,
    required this.black20,
    required this.black30,
    required this.black40,
    required this.black50,
    required this.black60,
    required this.black70,
    required this.black80,
    required this.black90,
    required this.black100,
    required this.white0,
    required this.white10,
    required this.white20,
    required this.white30,
    required this.white40,
    required this.white50,
    required this.white60,
    required this.white70,
    required this.white80,
    required this.white90,
    required this.white100,
    required this.alphaError10,
    required this.alphaError20,
    required this.alphaInfo10,
    required this.alphaInfo20,
    required this.alphaPrimary10,
    required this.alphaPrimary20,
    required this.alphaSuccess10,
    required this.alphaSuccess20,
    required this.alphaWarning10,
    required this.alphaWarning20,
  });

  AlphaColorScheme.light()
      : black0 = SDGAColors.blackAlpha.alpha0,
        black10 = SDGAColors.blackAlpha.alpha10,
        black20 = SDGAColors.blackAlpha.alpha20,
        black30 = SDGAColors.blackAlpha.alpha30,
        black40 = SDGAColors.blackAlpha.alpha40,
        black50 = SDGAColors.blackAlpha.alpha50,
        black60 = SDGAColors.blackAlpha.alpha60,
        black70 = SDGAColors.blackAlpha.alpha70,
        black80 = SDGAColors.blackAlpha.alpha80,
        black90 = SDGAColors.blackAlpha.alpha90,
        black100 = SDGAColors.blackAlpha.alpha100,
        white0 = SDGAColors.whiteAlpha.alpha0,
        white10 = SDGAColors.whiteAlpha.alpha10,
        white20 = SDGAColors.whiteAlpha.alpha20,
        white30 = SDGAColors.whiteAlpha.alpha30,
        white40 = SDGAColors.whiteAlpha.alpha40,
        white50 = SDGAColors.whiteAlpha.alpha50,
        white60 = SDGAColors.whiteAlpha.alpha60,
        white70 = SDGAColors.whiteAlpha.alpha70,
        white80 = SDGAColors.whiteAlpha.alpha80,
        white90 = SDGAColors.whiteAlpha.alpha90,
        white100 = SDGAColors.whiteAlpha.alpha100,
        alphaError10 = SDGAColors.redAlpha.alpha10,
        alphaError20 = SDGAColors.redAlpha.alpha20,
        alphaInfo10 = SDGAColors.blueAlpha.alpha10,
        alphaInfo20 = SDGAColors.blueAlpha.alpha20,
        alphaPrimary10 = SDGAColors.primaryAlpha.alpha10,
        alphaPrimary20 = SDGAColors.primaryAlpha.alpha20,
        alphaSuccess10 = SDGAColors.greenAlpha.alpha10,
        alphaSuccess20 = SDGAColors.greenAlpha.alpha20,
        alphaWarning10 = SDGAColors.yellowAlpha.alpha10,
        alphaWarning20 = SDGAColors.yellowAlpha.alpha20;

  AlphaColorScheme.dark()
      : black0 = SDGAColors.whiteAlpha.alpha10,
        black10 = SDGAColors.whiteAlpha.alpha10,
        black20 = SDGAColors.whiteAlpha.alpha20,
        black30 = SDGAColors.whiteAlpha.alpha30,
        black40 = SDGAColors.whiteAlpha.alpha40,
        black50 = SDGAColors.whiteAlpha.alpha50,
        black60 = SDGAColors.whiteAlpha.alpha60,
        black70 = SDGAColors.whiteAlpha.alpha70,
        black80 = SDGAColors.whiteAlpha.alpha80,
        black90 = SDGAColors.whiteAlpha.alpha90,
        black100 = SDGAColors.whiteAlpha.alpha100,
        white0 = SDGAColors.blackAlpha.alpha10,
        white10 = SDGAColors.blackAlpha.alpha10,
        white20 = SDGAColors.blackAlpha.alpha20,
        white30 = SDGAColors.blackAlpha.alpha30,
        white40 = SDGAColors.blackAlpha.alpha40,
        white50 = SDGAColors.blackAlpha.alpha50,
        white60 = SDGAColors.blackAlpha.alpha60,
        white70 = SDGAColors.blackAlpha.alpha70,
        white80 = SDGAColors.blackAlpha.alpha80,
        white90 = SDGAColors.blackAlpha.alpha90,
        white100 = SDGAColors.blackAlpha.alpha100,
        alphaError10 = const Color(0x19B42318),
        alphaError20 = const Color(0x33B42318),
        alphaInfo10 = const Color(0x19175CD3),
        alphaInfo20 = const Color(0x33175CD3),
        alphaPrimary10 = const Color(0x19166A45),
        alphaPrimary20 = const Color(0x33166A45),
        alphaSuccess10 = const Color(0x19067647),
        alphaSuccess20 = const Color(0x33067647),
        alphaWarning10 = const Color(0x19B54708),
        alphaWarning20 = const Color(0x33B54708);

  AlphaColorScheme lerp(AlphaColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return AlphaColorScheme(
        black0: Color.lerp(black0, other.black0, t)!,
        black10: Color.lerp(black10, other.black10, t)!,
        black20: Color.lerp(black20, other.black20, t)!,
        black30: Color.lerp(black30, other.black30, t)!,
        black40: Color.lerp(black40, other.black40, t)!,
        black50: Color.lerp(black50, other.black50, t)!,
        black60: Color.lerp(black60, other.black60, t)!,
        black70: Color.lerp(black70, other.black70, t)!,
        black80: Color.lerp(black80, other.black80, t)!,
        black90: Color.lerp(black90, other.black90, t)!,
        black100: Color.lerp(black100, other.black100, t)!,
        white0: Color.lerp(white0, other.white0, t)!,
        white10: Color.lerp(white10, other.white10, t)!,
        white20: Color.lerp(white20, other.white20, t)!,
        white30: Color.lerp(white30, other.white30, t)!,
        white40: Color.lerp(white40, other.white40, t)!,
        white50: Color.lerp(white50, other.white50, t)!,
        white60: Color.lerp(white60, other.white60, t)!,
        white70: Color.lerp(white70, other.white70, t)!,
        white80: Color.lerp(white80, other.white80, t)!,
        white90: Color.lerp(white90, other.white90, t)!,
        white100: Color.lerp(white100, other.white100, t)!,
        alphaError10: Color.lerp(alphaError10, other.alphaError10, t)!,
        alphaError20: Color.lerp(alphaError20, other.alphaError20, t)!,
        alphaInfo10: Color.lerp(alphaInfo10, other.alphaInfo10, t)!,
        alphaInfo20: Color.lerp(alphaInfo20, other.alphaInfo20, t)!,
        alphaPrimary10: Color.lerp(alphaPrimary10, other.alphaPrimary10, t)!,
        alphaPrimary20: Color.lerp(alphaPrimary20, other.alphaPrimary20, t)!,
        alphaSuccess10: Color.lerp(alphaSuccess10, other.alphaSuccess10, t)!,
        alphaSuccess20: Color.lerp(alphaSuccess20, other.alphaSuccess20, t)!,
        alphaWarning10: Color.lerp(alphaWarning10, other.alphaWarning10, t)!,
        alphaWarning20: Color.lerp(alphaWarning20, other.alphaWarning20, t)!,
      );
    }
  }
}

@protected
class BackgroundColorScheme {
  final Color black;
  final Color body;
  final Color card;
  final Color error;
  final Color error25;
  final Color error50;
  final Color info;
  final Color info25;
  final Color info50;
  final Color menu;
  final Color navHeader;
  final Color neutral100;
  final Color neutral200;
  final Color neutral25;
  final Color neutral300;
  final Color neutral400;
  final Color neutral50;
  final Color neutral800;
  final Color notificationWhite;
  final Color primary;
  final Color primary200;
  final Color primary25;
  final Color primary400;
  final Color primary50;
  final Color saFlag;
  final Color saFlag25;
  final Color saFlag50;
  final Color secondary;
  final Color secondary25;
  final Color secondary50;
  final Color success;
  final Color success25;
  final Color success50;
  final Color tertiary;
  final Color tertiary25;
  final Color tertiary50;
  final Color warning;
  final Color warning25;
  final Color warning50;
  final Color white;
  final Color surfaceOnColor;

  const BackgroundColorScheme({
    required this.black,
    required this.body,
    required this.card,
    required this.error,
    required this.error25,
    required this.error50,
    required this.info,
    required this.info25,
    required this.info50,
    required this.menu,
    required this.navHeader,
    required this.neutral100,
    required this.neutral200,
    required this.neutral25,
    required this.neutral300,
    required this.neutral400,
    required this.neutral50,
    required this.neutral800,
    required this.notificationWhite,
    required this.primary,
    required this.primary200,
    required this.primary25,
    required this.primary400,
    required this.primary50,
    required this.saFlag,
    required this.saFlag25,
    required this.saFlag50,
    required this.secondary,
    required this.secondary25,
    required this.secondary50,
    required this.success,
    required this.success25,
    required this.success50,
    required this.tertiary,
    required this.tertiary25,
    required this.tertiary50,
    required this.warning,
    required this.warning25,
    required this.warning50,
    required this.white,
    required this.surfaceOnColor,
  });

  BackgroundColorScheme.light()
      : black = SDGAColors.black,
        body = SDGAColors.neutral.shade50,
        card = SDGAColors.white,
        error = SDGAColors.red,
        error25 = SDGAColors.red.shade25,
        error50 = SDGAColors.red.shade50,
        info = SDGAColors.blue,
        info25 = SDGAColors.blue.shade25,
        info50 = SDGAColors.blue.shade50,
        menu = SDGAColors.white,
        navHeader = SDGAColors.primary.shade800,
        neutral100 = SDGAColors.neutral.shade100,
        neutral200 = SDGAColors.neutral.shade200,
        neutral25 = SDGAColors.neutral.shade25,
        neutral300 = SDGAColors.neutral.shade300,
        neutral400 = SDGAColors.neutral.shade400,
        neutral50 = SDGAColors.neutral.shade50,
        neutral800 = SDGAColors.neutral.shade800,
        notificationWhite = SDGAColors.white,
        primary = SDGAColors.primary,
        primary200 = SDGAColors.primary.shade200,
        primary25 = SDGAColors.primary.shade25,
        primary400 = SDGAColors.primary.shade400,
        primary50 = SDGAColors.primary.shade50,
        saFlag = SDGAColors.green.shade900,
        saFlag25 = SDGAColors.green.shade25,
        saFlag50 = SDGAColors.green.shade50,
        secondary = SDGAColors.secondaryGold,
        secondary25 = SDGAColors.secondaryGold.shade25,
        secondary50 = SDGAColors.secondaryGold.shade50,
        success = SDGAColors.green,
        success25 = SDGAColors.green.shade25,
        success50 = SDGAColors.green.shade50,
        tertiary = SDGAColors.tertiaryLavender,
        tertiary25 = SDGAColors.tertiaryLavender.shade25,
        tertiary50 = SDGAColors.tertiaryLavender.shade50,
        warning = SDGAColors.yellow,
        warning25 = SDGAColors.yellow.shade25,
        warning50 = SDGAColors.yellow.shade50,
        white = SDGAColors.white,
        surfaceOnColor = SDGAColors.white;

  BackgroundColorScheme.dark()
      : black = SDGAColors.white,
        body = SDGAColors.neutral.shade900,
        card = SDGAColors.neutral.shade800,
        error = SDGAColors.red,
        error25 = const Color(0x19B42318),
        error50 = const Color(0x33B42318),
        info = SDGAColors.blue,
        info25 = const Color(0x19175CD3),
        info50 = const Color(0x33175CD3),
        menu = SDGAColors.neutral.shade800,
        navHeader = SDGAColors.primary.shade800,
        neutral100 = SDGAColors.neutral.shade800,
        neutral200 = SDGAColors.neutral,
        neutral25 = SDGAColors.neutral.shade950,
        neutral300 = SDGAColors.neutral.shade500,
        neutral400 = SDGAColors.neutral.shade400,
        neutral50 = SDGAColors.neutral.shade900,
        neutral800 = SDGAColors.neutral.shade100,
        notificationWhite = SDGAColors.neutral.shade900,
        primary = SDGAColors.primary,
        primary200 = SDGAColors.neutral.shade700,
        primary25 = SDGAColors.primary.shade950,
        primary400 = SDGAColors.primary.shade400,
        primary50 = SDGAColors.primaryAlpha.alpha10,
        saFlag = SDGAColors.primary,
        saFlag25 = SDGAColors.neutral.shade900,
        saFlag50 = SDGAColors.neutral.shade800,
        secondary = SDGAColors.secondaryGold,
        secondary25 = SDGAColors.neutral.shade900,
        secondary50 = SDGAColors.neutral.shade800,
        success = SDGAColors.green,
        success25 = const Color(0x19067647),
        success50 = const Color(0x33067647),
        tertiary = SDGAColors.tertiaryLavender,
        tertiary25 = SDGAColors.neutral.shade900,
        tertiary50 = SDGAColors.neutral.shade800,
        warning = SDGAColors.yellow,
        warning25 = const Color(0x19B54708),
        warning50 = const Color(0x33B54708),
        white = SDGAColors.neutral.shade950,
        surfaceOnColor = SDGAColors.white;

  BackgroundColorScheme lerp(BackgroundColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return BackgroundColorScheme(
        black: Color.lerp(black, other.black, t)!,
        body: Color.lerp(body, other.body, t)!,
        card: Color.lerp(card, other.card, t)!,
        error: Color.lerp(error, other.error, t)!,
        error25: Color.lerp(error25, other.error25, t)!,
        error50: Color.lerp(error50, other.error50, t)!,
        info: Color.lerp(info, other.info, t)!,
        info25: Color.lerp(info25, other.info25, t)!,
        info50: Color.lerp(info50, other.info50, t)!,
        menu: Color.lerp(menu, other.menu, t)!,
        navHeader: Color.lerp(navHeader, other.navHeader, t)!,
        neutral100: Color.lerp(neutral100, other.neutral100, t)!,
        neutral200: Color.lerp(neutral200, other.neutral200, t)!,
        neutral25: Color.lerp(neutral25, other.neutral25, t)!,
        neutral300: Color.lerp(neutral300, other.neutral300, t)!,
        neutral400: Color.lerp(neutral400, other.neutral400, t)!,
        neutral50: Color.lerp(neutral50, other.neutral50, t)!,
        neutral800: Color.lerp(neutral800, other.neutral800, t)!,
        notificationWhite:
            Color.lerp(notificationWhite, other.notificationWhite, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primary200: Color.lerp(primary200, other.primary200, t)!,
        primary25: Color.lerp(primary25, other.primary25, t)!,
        primary400: Color.lerp(primary400, other.primary400, t)!,
        primary50: Color.lerp(primary50, other.primary50, t)!,
        saFlag: Color.lerp(saFlag, other.saFlag, t)!,
        saFlag25: Color.lerp(saFlag25, other.saFlag25, t)!,
        saFlag50: Color.lerp(saFlag50, other.saFlag50, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        secondary25: Color.lerp(secondary25, other.secondary25, t)!,
        secondary50: Color.lerp(secondary50, other.secondary50, t)!,
        success: Color.lerp(success, other.success, t)!,
        success25: Color.lerp(success25, other.success25, t)!,
        success50: Color.lerp(success50, other.success50, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        tertiary25: Color.lerp(tertiary25, other.tertiary25, t)!,
        tertiary50: Color.lerp(tertiary50, other.tertiary50, t)!,
        warning: Color.lerp(warning, other.warning, t)!,
        warning25: Color.lerp(warning25, other.warning25, t)!,
        warning50: Color.lerp(warning50, other.warning50, t)!,
        white: Color.lerp(white, other.white, t)!,
        surfaceOnColor: Color.lerp(surfaceOnColor, other.surfaceOnColor, t)!,
      );
    }
  }
}

@protected
class BorderColorScheme {
  final Color backgroundNeutral;
  final Color backgroundWhite;
  final Color black;
  final Color disabled;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;
  final Color neutralPrimary;
  final Color neutralSecondary;
  final Color neutralTertiary;
  final Color onColorTransparent30;
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryLight;
  final Color success;
  final Color successLight;
  final Color tertiary;
  final Color tertiaryLight;
  final Color transparent10;
  final Color warning;
  final Color warningLight;
  final Color white;
  final Color white40;

  const BorderColorScheme({
    required this.backgroundNeutral,
    required this.backgroundWhite,
    required this.black,
    required this.disabled,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.neutralPrimary,
    required this.neutralSecondary,
    required this.neutralTertiary,
    required this.onColorTransparent30,
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryLight,
    required this.success,
    required this.successLight,
    required this.tertiary,
    required this.tertiaryLight,
    required this.transparent10,
    required this.warning,
    required this.warningLight,
    required this.white,
    required this.white40,
  });

  BorderColorScheme.light()
      : backgroundNeutral = SDGAColors.neutral.shade300,
        backgroundWhite = SDGAColors.neutral.shade100,
        black = SDGAColors.black,
        disabled = SDGAColors.neutral.shade300,
        error = SDGAColors.red.shade700,
        errorLight = SDGAColors.red.shade200,
        info = SDGAColors.blue.shade700,
        infoLight = SDGAColors.blue.shade200,
        neutralPrimary = SDGAColors.neutral.shade300,
        neutralSecondary = SDGAColors.neutral.shade200,
        neutralTertiary = SDGAColors.neutral.shade100,
        onColorTransparent30 = SDGAColors.whiteAlpha.alpha30,
        primary = SDGAColors.primary,
        primaryLight = SDGAColors.primary.shade200,
        secondary = SDGAColors.secondaryGold,
        secondaryLight = SDGAColors.secondaryGold.shade200,
        success = SDGAColors.green.shade700,
        successLight = SDGAColors.green.shade200,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryLight = SDGAColors.tertiaryLavender.shade200,
        transparent10 = SDGAColors.whiteAlpha.alpha10,
        warning = SDGAColors.yellow.shade700,
        warningLight = SDGAColors.yellow.shade200,
        white = SDGAColors.white,
        white40 = SDGAColors.whiteAlpha.alpha40;

  BorderColorScheme.dark()
      : backgroundNeutral = SDGAColors.neutral,
        backgroundWhite = SDGAColors.neutral,
        black = SDGAColors.white,
        disabled = SDGAColors.neutral.shade500,
        error = SDGAColors.red.shade700,
        errorLight = SDGAColors.red.shade200,
        info = SDGAColors.blue.shade700,
        infoLight = SDGAColors.blue.shade200,
        neutralPrimary = SDGAColors.neutral.shade500,
        neutralSecondary = SDGAColors.neutral.shade700,
        neutralTertiary = SDGAColors.neutral.shade800,
        onColorTransparent30 = SDGAColors.whiteAlpha.alpha30,
        primary = SDGAColors.primary,
        primaryLight = SDGAColors.green.shade200,
        secondary = SDGAColors.secondaryGold,
        secondaryLight = SDGAColors.secondaryGold.shade200,
        success = SDGAColors.green.shade500,
        successLight = SDGAColors.green.shade200,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryLight = SDGAColors.tertiaryLavender.shade200,
        transparent10 = SDGAColors.blackAlpha.alpha10,
        warning = SDGAColors.yellow.shade700,
        warningLight = SDGAColors.yellow.shade200,
        white = SDGAColors.black,
        white40 = SDGAColors.blackAlpha.alpha40;

  BorderColorScheme lerp(BorderColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return BorderColorScheme(
        backgroundNeutral:
            Color.lerp(backgroundNeutral, other.backgroundNeutral, t)!,
        backgroundWhite: Color.lerp(backgroundWhite, other.backgroundWhite, t)!,
        black: Color.lerp(black, other.black, t)!,
        disabled: Color.lerp(disabled, other.disabled, t)!,
        error: Color.lerp(error, other.error, t)!,
        errorLight: Color.lerp(errorLight, other.errorLight, t)!,
        info: Color.lerp(info, other.info, t)!,
        infoLight: Color.lerp(infoLight, other.infoLight, t)!,
        neutralPrimary: Color.lerp(neutralPrimary, other.neutralPrimary, t)!,
        neutralSecondary:
            Color.lerp(neutralSecondary, other.neutralSecondary, t)!,
        neutralTertiary: Color.lerp(neutralTertiary, other.neutralTertiary, t)!,
        onColorTransparent30:
            Color.lerp(onColorTransparent30, other.onColorTransparent30, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
        success: Color.lerp(success, other.success, t)!,
        successLight: Color.lerp(successLight, other.successLight, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        tertiaryLight: Color.lerp(tertiaryLight, other.tertiaryLight, t)!,
        transparent10: Color.lerp(transparent10, other.transparent10, t)!,
        warning: Color.lerp(warning, other.warning, t)!,
        warningLight: Color.lerp(warningLight, other.warningLight, t)!,
        white: Color.lerp(white, other.white, t)!,
        white40: Color.lerp(white40, other.white40, t)!,
      );
    }
  }
}

@protected
class ButtonColorScheme {
  final Color backgroundBlackDefault;
  final Color backgroundBlackFocused;
  final Color backgroundBlackHovered;
  final Color backgroundBlackPressed;
  final Color backgroundBlackSelected;
  final Color backgroundDangerPrimaryDefault;
  final Color backgroundDangerPrimaryFocused;
  final Color backgroundDangerPrimaryHovered;
  final Color backgroundDangerPrimaryPressed;
  final Color backgroundDangerPrimarySelected;
  final Color backgroundDangerSecondaryDefault;
  final Color backgroundDangerSecondaryFocused;
  final Color backgroundDangerSecondaryHovered;
  final Color backgroundDangerSecondaryPressed;
  final Color backgroundDangerSecondarySelected;
  final Color backgroundDisabledOnColor;
  final Color backgroundNeutralDefault;
  final Color backgroundNeutralFocused;
  final Color backgroundNeutralHovered;
  final Color backgroundNeutralPressed;
  final Color backgroundNeutralSelected;
  final Color backgroundOnColorDefault;
  final Color backgroundOnColorFocused;
  final Color backgroundOnColorHovered;
  final Color backgroundOnColorPressed;
  final Color backgroundOnColorSelected;
  final Color backgroundPrimaryDefault;
  final Color backgroundPrimaryFocused;
  final Color backgroundPrimaryHovered;
  final Color backgroundPrimaryPressed;
  final Color backgroundPrimarySelected;
  final Color backgroundTransparentDefault;
  final Color backgroundTransparentFocused;
  final Color backgroundTransparentHovered;
  final Color backgroundTransparentPressed;
  final Color backgroundTransparentSelected;
  final Color buttonIconTransparentHoveredOnColor;
  final Color iconTransparentPressedOnColor;
  final Color iconTransparentSelectedOnColor;
  final Color labelDangerPrimaryDefaultOnColor;
  final Color labelDangerPrimaryHoveredOnColor;
  final Color labelDangerPrimaryPressedOnColor;
  final Color labelTransparentHoveredOnColor;
  final Color labelTransparentPressedOnColor;
  final Color labelTransparentSelectedOnColor;

  const ButtonColorScheme({
    required this.backgroundBlackDefault,
    required this.backgroundBlackFocused,
    required this.backgroundBlackHovered,
    required this.backgroundBlackPressed,
    required this.backgroundBlackSelected,
    required this.backgroundDangerPrimaryDefault,
    required this.backgroundDangerPrimaryFocused,
    required this.backgroundDangerPrimaryHovered,
    required this.backgroundDangerPrimaryPressed,
    required this.backgroundDangerPrimarySelected,
    required this.backgroundDangerSecondaryDefault,
    required this.backgroundDangerSecondaryFocused,
    required this.backgroundDangerSecondaryHovered,
    required this.backgroundDangerSecondaryPressed,
    required this.backgroundDangerSecondarySelected,
    required this.backgroundDisabledOnColor,
    required this.backgroundNeutralDefault,
    required this.backgroundNeutralFocused,
    required this.backgroundNeutralHovered,
    required this.backgroundNeutralPressed,
    required this.backgroundNeutralSelected,
    required this.backgroundOnColorDefault,
    required this.backgroundOnColorFocused,
    required this.backgroundOnColorHovered,
    required this.backgroundOnColorPressed,
    required this.backgroundOnColorSelected,
    required this.backgroundPrimaryDefault,
    required this.backgroundPrimaryFocused,
    required this.backgroundPrimaryHovered,
    required this.backgroundPrimaryPressed,
    required this.backgroundPrimarySelected,
    required this.backgroundTransparentDefault,
    required this.backgroundTransparentFocused,
    required this.backgroundTransparentHovered,
    required this.backgroundTransparentPressed,
    required this.backgroundTransparentSelected,
    required this.buttonIconTransparentHoveredOnColor,
    required this.iconTransparentPressedOnColor,
    required this.iconTransparentSelectedOnColor,
    required this.labelDangerPrimaryDefaultOnColor,
    required this.labelDangerPrimaryHoveredOnColor,
    required this.labelDangerPrimaryPressedOnColor,
    required this.labelTransparentHoveredOnColor,
    required this.labelTransparentPressedOnColor,
    required this.labelTransparentSelectedOnColor,
  });

  ButtonColorScheme.light()
      : backgroundBlackDefault = SDGAColors.neutral.shade950,
        backgroundBlackFocused = SDGAColors.neutral.shade950,
        backgroundBlackHovered = SDGAColors.neutral.shade800,
        backgroundBlackPressed = SDGAColors.neutral,
        backgroundBlackSelected = SDGAColors.neutral.shade700,
        backgroundDangerPrimaryDefault = SDGAColors.red,
        backgroundDangerPrimaryFocused = SDGAColors.red,
        backgroundDangerPrimaryHovered = SDGAColors.red.shade700,
        backgroundDangerPrimaryPressed = SDGAColors.red.shade900,
        backgroundDangerPrimarySelected = SDGAColors.red.shade800,
        backgroundDangerSecondaryDefault = SDGAColors.red.shade50,
        backgroundDangerSecondaryFocused = SDGAColors.red.shade50,
        backgroundDangerSecondaryHovered = SDGAColors.red.shade100,
        backgroundDangerSecondaryPressed = SDGAColors.red.shade200,
        backgroundDangerSecondarySelected = SDGAColors.red.shade50,
        backgroundDisabledOnColor = SDGAColors.whiteAlpha.alpha20,
        backgroundNeutralDefault = SDGAColors.neutral.shade100,
        backgroundNeutralFocused = SDGAColors.neutral.shade100,
        // Note: I have changed hovered from 100 to 200
        // pressed from 200 to 300, for better visibility
        backgroundNeutralHovered = SDGAColors.neutral.shade200,
        backgroundNeutralPressed = SDGAColors.neutral.shade300,
        backgroundNeutralSelected = SDGAColors.neutral.shade200,
        backgroundOnColorDefault = SDGAColors.white,
        backgroundOnColorFocused = SDGAColors.whiteAlpha.alpha100,
        backgroundOnColorHovered = SDGAColors.whiteAlpha.alpha80,
        backgroundOnColorPressed = SDGAColors.whiteAlpha.alpha60,
        backgroundOnColorSelected = SDGAColors.whiteAlpha.alpha70,
        backgroundPrimaryDefault = SDGAColors.primary,
        backgroundPrimaryFocused = SDGAColors.primary,
        backgroundPrimaryHovered = SDGAColors.primary.shade700,
        backgroundPrimaryPressed = SDGAColors.primary.shade900,
        backgroundPrimarySelected = SDGAColors.primary.shade800,
        backgroundTransparentDefault = SDGAColors.whiteAlpha.alpha0,
        backgroundTransparentFocused = SDGAColors.whiteAlpha.alpha0,
        backgroundTransparentHovered = SDGAColors.whiteAlpha.alpha20,
        backgroundTransparentPressed = SDGAColors.whiteAlpha.alpha40,
        backgroundTransparentSelected = SDGAColors.whiteAlpha.alpha30,
        buttonIconTransparentHoveredOnColor = SDGAColors.primary.shade400,
        iconTransparentPressedOnColor = SDGAColors.primary.shade300,
        iconTransparentSelectedOnColor = SDGAColors.primary.shade400,
        labelDangerPrimaryDefaultOnColor = SDGAColors.red.shade200,
        labelDangerPrimaryHoveredOnColor = SDGAColors.red.shade300,
        labelDangerPrimaryPressedOnColor = SDGAColors.red.shade400,
        labelTransparentHoveredOnColor = SDGAColors.primary.shade400,
        labelTransparentPressedOnColor = SDGAColors.primary.shade300,
        labelTransparentSelectedOnColor = SDGAColors.primary.shade400;

  ButtonColorScheme.dark()
      : backgroundBlackDefault = SDGAColors.neutral.shade950,
        backgroundBlackFocused = SDGAColors.neutral.shade950,
        backgroundBlackHovered = SDGAColors.neutral.shade800,
        backgroundBlackPressed = SDGAColors.neutral,
        backgroundBlackSelected = SDGAColors.neutral.shade700,
        backgroundDangerPrimaryDefault = SDGAColors.red,
        backgroundDangerPrimaryFocused = SDGAColors.red,
        backgroundDangerPrimaryHovered = SDGAColors.red.shade700,
        backgroundDangerPrimaryPressed = SDGAColors.red.shade900,
        backgroundDangerPrimarySelected = SDGAColors.red.shade800,
        backgroundDangerSecondaryDefault = SDGAColors.red.shade50,
        backgroundDangerSecondaryFocused = SDGAColors.red.shade50,
        backgroundDangerSecondaryHovered = SDGAColors.red.shade100,
        backgroundDangerSecondaryPressed = SDGAColors.red.shade200,
        backgroundDangerSecondarySelected = SDGAColors.red.shade50,
        backgroundDisabledOnColor = SDGAColors.blackAlpha.alpha20,
        backgroundNeutralDefault = SDGAColors.neutral.shade800,
        backgroundNeutralFocused = SDGAColors.neutral.shade800,
        backgroundNeutralHovered = SDGAColors.neutral.shade700,
        backgroundNeutralPressed = SDGAColors.neutral,
        backgroundNeutralSelected = SDGAColors.neutral.shade700,
        backgroundOnColorDefault = SDGAColors.black,
        backgroundOnColorFocused = SDGAColors.blackAlpha.alpha100,
        backgroundOnColorHovered = SDGAColors.blackAlpha.alpha80,
        backgroundOnColorPressed = SDGAColors.blackAlpha.alpha60,
        backgroundOnColorSelected = SDGAColors.blackAlpha.alpha70,
        backgroundPrimaryDefault = SDGAColors.primary,
        backgroundPrimaryFocused = SDGAColors.primary,
        backgroundPrimaryHovered = SDGAColors.primary.shade700,
        backgroundPrimaryPressed = SDGAColors.primary.shade900,
        backgroundPrimarySelected = SDGAColors.primary.shade800,
        backgroundTransparentDefault = SDGAColors.blackAlpha.alpha10,
        backgroundTransparentFocused = SDGAColors.blackAlpha.alpha10,
        backgroundTransparentHovered = SDGAColors.blackAlpha.alpha20,
        backgroundTransparentPressed = SDGAColors.blackAlpha.alpha40,
        backgroundTransparentSelected = SDGAColors.blackAlpha.alpha30,
        buttonIconTransparentHoveredOnColor = SDGAColors.primary.shade400,
        iconTransparentPressedOnColor = SDGAColors.primary.shade300,
        iconTransparentSelectedOnColor = SDGAColors.primary.shade400,
        labelDangerPrimaryDefaultOnColor = SDGAColors.red.shade200,
        labelDangerPrimaryHoveredOnColor = SDGAColors.red.shade300,
        labelDangerPrimaryPressedOnColor = SDGAColors.red.shade400,
        labelTransparentHoveredOnColor = SDGAColors.primary.shade400,
        labelTransparentPressedOnColor = SDGAColors.primary.shade300,
        labelTransparentSelectedOnColor = SDGAColors.primary.shade400;

  ButtonColorScheme lerp(ButtonColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return ButtonColorScheme(
        backgroundBlackDefault: Color.lerp(
            backgroundBlackDefault, other.backgroundBlackDefault, t)!,
        backgroundBlackFocused: Color.lerp(
            backgroundBlackFocused, other.backgroundBlackFocused, t)!,
        backgroundBlackHovered: Color.lerp(
            backgroundBlackHovered, other.backgroundBlackHovered, t)!,
        backgroundBlackPressed: Color.lerp(
            backgroundBlackPressed, other.backgroundBlackPressed, t)!,
        backgroundBlackSelected: Color.lerp(
            backgroundBlackSelected, other.backgroundBlackSelected, t)!,
        backgroundDangerPrimaryDefault: Color.lerp(
            backgroundDangerPrimaryDefault,
            other.backgroundDangerPrimaryDefault,
            t)!,
        backgroundDangerPrimaryFocused: Color.lerp(
            backgroundDangerPrimaryFocused,
            other.backgroundDangerPrimaryFocused,
            t)!,
        backgroundDangerPrimaryHovered: Color.lerp(
            backgroundDangerPrimaryHovered,
            other.backgroundDangerPrimaryHovered,
            t)!,
        backgroundDangerPrimaryPressed: Color.lerp(
            backgroundDangerPrimaryPressed,
            other.backgroundDangerPrimaryPressed,
            t)!,
        backgroundDangerPrimarySelected: Color.lerp(
            backgroundDangerPrimarySelected,
            other.backgroundDangerPrimarySelected,
            t)!,
        backgroundDangerSecondaryDefault: Color.lerp(
            backgroundDangerSecondaryDefault,
            other.backgroundDangerSecondaryDefault,
            t)!,
        backgroundDangerSecondaryFocused: Color.lerp(
            backgroundDangerSecondaryFocused,
            other.backgroundDangerSecondaryFocused,
            t)!,
        backgroundDangerSecondaryHovered: Color.lerp(
            backgroundDangerSecondaryHovered,
            other.backgroundDangerSecondaryHovered,
            t)!,
        backgroundDangerSecondaryPressed: Color.lerp(
            backgroundDangerSecondaryPressed,
            other.backgroundDangerSecondaryPressed,
            t)!,
        backgroundDangerSecondarySelected: Color.lerp(
            backgroundDangerSecondarySelected,
            other.backgroundDangerSecondarySelected,
            t)!,
        backgroundDisabledOnColor: Color.lerp(
            backgroundDisabledOnColor, other.backgroundDisabledOnColor, t)!,
        backgroundNeutralDefault: Color.lerp(
            backgroundNeutralDefault, other.backgroundNeutralDefault, t)!,
        backgroundNeutralFocused: Color.lerp(
            backgroundNeutralFocused, other.backgroundNeutralFocused, t)!,
        backgroundNeutralHovered: Color.lerp(
            backgroundNeutralHovered, other.backgroundNeutralHovered, t)!,
        backgroundNeutralPressed: Color.lerp(
            backgroundNeutralPressed, other.backgroundNeutralPressed, t)!,
        backgroundNeutralSelected: Color.lerp(
            backgroundNeutralSelected, other.backgroundNeutralSelected, t)!,
        backgroundOnColorDefault: Color.lerp(
            backgroundOnColorDefault, other.backgroundOnColorDefault, t)!,
        backgroundOnColorFocused: Color.lerp(
            backgroundOnColorFocused, other.backgroundOnColorFocused, t)!,
        backgroundOnColorHovered: Color.lerp(
            backgroundOnColorHovered, other.backgroundOnColorHovered, t)!,
        backgroundOnColorPressed: Color.lerp(
            backgroundOnColorPressed, other.backgroundOnColorPressed, t)!,
        backgroundOnColorSelected: Color.lerp(
            backgroundOnColorSelected, other.backgroundOnColorSelected, t)!,
        backgroundPrimaryDefault: Color.lerp(
            backgroundPrimaryDefault, other.backgroundPrimaryDefault, t)!,
        backgroundPrimaryFocused: Color.lerp(
            backgroundPrimaryFocused, other.backgroundPrimaryFocused, t)!,
        backgroundPrimaryHovered: Color.lerp(
            backgroundPrimaryHovered, other.backgroundPrimaryHovered, t)!,
        backgroundPrimaryPressed: Color.lerp(
            backgroundPrimaryPressed, other.backgroundPrimaryPressed, t)!,
        backgroundPrimarySelected: Color.lerp(
            backgroundPrimarySelected, other.backgroundPrimarySelected, t)!,
        backgroundTransparentDefault: Color.lerp(backgroundTransparentDefault,
            other.backgroundTransparentDefault, t)!,
        backgroundTransparentFocused: Color.lerp(backgroundTransparentFocused,
            other.backgroundTransparentFocused, t)!,
        backgroundTransparentHovered: Color.lerp(backgroundTransparentHovered,
            other.backgroundTransparentHovered, t)!,
        backgroundTransparentPressed: Color.lerp(backgroundTransparentPressed,
            other.backgroundTransparentPressed, t)!,
        backgroundTransparentSelected: Color.lerp(backgroundTransparentSelected,
            other.backgroundTransparentSelected, t)!,
        buttonIconTransparentHoveredOnColor: Color.lerp(
            buttonIconTransparentHoveredOnColor,
            other.buttonIconTransparentHoveredOnColor,
            t)!,
        iconTransparentPressedOnColor: Color.lerp(iconTransparentPressedOnColor,
            other.iconTransparentPressedOnColor, t)!,
        iconTransparentSelectedOnColor: Color.lerp(
            iconTransparentSelectedOnColor,
            other.iconTransparentSelectedOnColor,
            t)!,
        labelDangerPrimaryDefaultOnColor: Color.lerp(
            labelDangerPrimaryDefaultOnColor,
            other.labelDangerPrimaryDefaultOnColor,
            t)!,
        labelDangerPrimaryHoveredOnColor: Color.lerp(
            labelDangerPrimaryHoveredOnColor,
            other.labelDangerPrimaryHoveredOnColor,
            t)!,
        labelDangerPrimaryPressedOnColor: Color.lerp(
            labelDangerPrimaryPressedOnColor,
            other.labelDangerPrimaryPressedOnColor,
            t)!,
        labelTransparentHoveredOnColor: Color.lerp(
            labelTransparentHoveredOnColor,
            other.labelTransparentHoveredOnColor,
            t)!,
        labelTransparentPressedOnColor: Color.lerp(
            labelTransparentPressedOnColor,
            other.labelTransparentPressedOnColor,
            t)!,
        labelTransparentSelectedOnColor: Color.lerp(
            labelTransparentSelectedOnColor,
            other.labelTransparentSelectedOnColor,
            t)!,
      );
    }
  }
}

@protected
class ControlsColorScheme {
  final Color boarderDisabled;
  final Color border;
  final Color disabled;
  final Color iconDisabled;
  final Color iconHovered;
  final Color iconPressed;
  final Color neutralChecked;
  final Color neutralFocused;
  final Color neutralHovered;
  final Color neutralPressed;
  final Color pressed;
  final Color primary;
  final Color primaryChecked;
  final Color primaryFocused;
  final Color primaryHovered;
  final Color primaryPressed;
  final Color primaryReadonly;
  final Color rippleEffect;

  const ControlsColorScheme({
    required this.boarderDisabled,
    required this.border,
    required this.disabled,
    required this.iconDisabled,
    required this.iconHovered,
    required this.iconPressed,
    required this.neutralChecked,
    required this.neutralFocused,
    required this.neutralHovered,
    required this.neutralPressed,
    required this.pressed,
    required this.primary,
    required this.primaryChecked,
    required this.primaryFocused,
    required this.primaryHovered,
    required this.primaryPressed,
    required this.primaryReadonly,
    required this.rippleEffect,
  });

  ControlsColorScheme.light()
      : boarderDisabled = SDGAColors.neutral.shade400,
        border = SDGAColors.neutral.shade500,
        disabled = SDGAColors.neutral.shade300,
        iconDisabled = SDGAColors.white,
        iconHovered = SDGAColors.white,
        iconPressed = SDGAColors.white,
        neutralChecked = SDGAColors.neutral.shade950,
        neutralFocused = SDGAColors.neutral.shade950,
        neutralHovered = SDGAColors.neutral,
        neutralPressed = SDGAColors.neutral.shade500,
        pressed = SDGAColors.neutral.shade300,
        primary = SDGAColors.whiteAlpha.alpha0,
        primaryChecked = SDGAColors.primary,
        primaryFocused = SDGAColors.primary,
        primaryHovered = SDGAColors.primary.shade800,
        primaryPressed = SDGAColors.primary.shade900,
        primaryReadonly = SDGAColors.whiteAlpha.alpha0,
        rippleEffect = SDGAColors.neutral.shade100;

  ControlsColorScheme.dark()
      : boarderDisabled = SDGAColors.whiteAlpha.alpha30,
        border = SDGAColors.neutral.shade400,
        disabled = SDGAColors.neutral.shade300,
        iconDisabled = SDGAColors.neutral.shade400,
        iconHovered = SDGAColors.primary.shade800,
        iconPressed = SDGAColors.primary.shade800,
        neutralChecked = SDGAColors.neutral,
        neutralFocused = SDGAColors.neutral,
        neutralHovered = SDGAColors.neutral.shade400,
        neutralPressed = SDGAColors.neutral.shade400,
        pressed = SDGAColors.neutral,
        primary = SDGAColors.blackAlpha.alpha10,
        primaryChecked = SDGAColors.primary,
        primaryFocused = SDGAColors.primary,
        primaryHovered = SDGAColors.primary.shade300,
        primaryPressed = SDGAColors.primary.shade400,
        primaryReadonly = SDGAColors.blackAlpha.alpha10,
        rippleEffect = SDGAColors.neutral.shade900;

  ControlsColorScheme lerp(ControlsColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return ControlsColorScheme(
        boarderDisabled: Color.lerp(boarderDisabled, other.boarderDisabled, t)!,
        border: Color.lerp(border, other.border, t)!,
        disabled: Color.lerp(disabled, other.disabled, t)!,
        iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
        iconHovered: Color.lerp(iconHovered, other.iconHovered, t)!,
        iconPressed: Color.lerp(iconPressed, other.iconPressed, t)!,
        neutralChecked: Color.lerp(neutralChecked, other.neutralChecked, t)!,
        neutralFocused: Color.lerp(neutralFocused, other.neutralFocused, t)!,
        neutralHovered: Color.lerp(neutralHovered, other.neutralHovered, t)!,
        neutralPressed: Color.lerp(neutralPressed, other.neutralPressed, t)!,
        pressed: Color.lerp(pressed, other.pressed, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primaryChecked: Color.lerp(primaryChecked, other.primaryChecked, t)!,
        primaryFocused: Color.lerp(primaryFocused, other.primaryFocused, t)!,
        primaryHovered: Color.lerp(primaryHovered, other.primaryHovered, t)!,
        primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
        primaryReadonly: Color.lerp(primaryReadonly, other.primaryReadonly, t)!,
        rippleEffect: Color.lerp(rippleEffect, other.rippleEffect, t)!,
      );
    }
  }
}

@protected
class FormColorScheme {
  final Color datecellBackground100;
  final Color datecellBackground200;
  final Color datecellBackground300;
  final Color datecellBackground600;
  final Color datecellBackgroundDefault;
  final Color datecellBackgroundDisabled;
  final Color datecellBackgroundFocused;
  final Color datecellBackgroundHovered;
  final Color datecellBackgroundPressed;
  final Color datecellTodayBackgroundDefault;
  final Color datecellTodayBackgroundFocused;
  final Color datecellTodayBackgroundHovered;
  final Color datecellTodayBackgroundPressed;
  final Color fieldBackgroundDarker;
  final Color fieldBackgroundDefault;
  final Color fieldBackgroundLighter;
  final Color fieldBackgroundPressed;
  final Color fieldBorderDefault;
  final Color fieldBorderError;
  final Color fieldBorderHovered;
  final Color fieldBorderPressed;
  final Color fieldTextFilled;
  final Color fieldTextFocused;
  final Color fieldTextHelper;
  final Color fieldTextHovered;
  final Color fieldTextLabel;
  final Color fieldTextPlaceholder;
  final Color fieldTextPressed;
  final Color fieldTextReadonly;
  final Color optionBackgroundHover;
  final Color optionBackgroundPressed;
  final Color textareaScrollbarBar;
  final Color textFormParagraph;
  final Color textFormTitle;

  const FormColorScheme({
    required this.datecellBackground100,
    required this.datecellBackground200,
    required this.datecellBackground300,
    required this.datecellBackground600,
    required this.datecellBackgroundDefault,
    required this.datecellBackgroundDisabled,
    required this.datecellBackgroundFocused,
    required this.datecellBackgroundHovered,
    required this.datecellBackgroundPressed,
    required this.datecellTodayBackgroundDefault,
    required this.datecellTodayBackgroundFocused,
    required this.datecellTodayBackgroundHovered,
    required this.datecellTodayBackgroundPressed,
    required this.fieldBackgroundDarker,
    required this.fieldBackgroundDefault,
    required this.fieldBackgroundLighter,
    required this.fieldBackgroundPressed,
    required this.fieldBorderDefault,
    required this.fieldBorderError,
    required this.fieldBorderHovered,
    required this.fieldBorderPressed,
    required this.fieldTextFilled,
    required this.fieldTextFocused,
    required this.fieldTextHelper,
    required this.fieldTextHovered,
    required this.fieldTextLabel,
    required this.fieldTextPlaceholder,
    required this.fieldTextPressed,
    required this.fieldTextReadonly,
    required this.optionBackgroundHover,
    required this.optionBackgroundPressed,
    required this.textareaScrollbarBar,
    required this.textFormParagraph,
    required this.textFormTitle,
  });

  FormColorScheme.light()
      : datecellBackground100 = SDGAColors.primary.shade100,
        datecellBackground200 = SDGAColors.primary.shade200,
        datecellBackground300 = SDGAColors.primary.shade300,
        datecellBackground600 = SDGAColors.primary,
        datecellBackgroundDefault = SDGAColors.primary,
        datecellBackgroundDisabled = const Color(0xFFFFFFFF),
        datecellBackgroundFocused = SDGAColors.primary,
        datecellBackgroundHovered = SDGAColors.primary.shade700,
        datecellBackgroundPressed = SDGAColors.primary.shade900,
        datecellTodayBackgroundDefault = SDGAColors.whiteAlpha.alpha0,
        datecellTodayBackgroundFocused = SDGAColors.whiteAlpha.alpha0,
        datecellTodayBackgroundHovered = SDGAColors.neutral.shade200,
        datecellTodayBackgroundPressed = SDGAColors.neutral.shade300,
        fieldBackgroundDarker = SDGAColors.neutral.shade100,
        fieldBackgroundDefault = SDGAColors.white,
        fieldBackgroundLighter = SDGAColors.neutral.shade25,
        fieldBackgroundPressed = SDGAColors.neutral.shade100,
        fieldBorderDefault = SDGAColors.neutral.shade400,
        fieldBorderError = SDGAColors.red.shade700,
        fieldBorderHovered = SDGAColors.neutral.shade700,
        fieldBorderPressed = SDGAColors.neutral.shade950,
        fieldTextFilled = SDGAColors.black,
        fieldTextFocused = SDGAColors.neutral.shade700,
        fieldTextHelper = SDGAColors.neutral.shade500,
        fieldTextHovered = SDGAColors.black,
        fieldTextLabel = SDGAColors.black,
        fieldTextPlaceholder = SDGAColors.neutral.shade500,
        fieldTextPressed = SDGAColors.neutral.shade700,
        fieldTextReadonly = SDGAColors.black,
        optionBackgroundHover = SDGAColors.neutral.shade100,
        optionBackgroundPressed = SDGAColors.neutral.shade200,
        textareaScrollbarBar = SDGAColors.neutral.shade300,
        textFormParagraph = SDGAColors.neutral.shade500,
        textFormTitle = SDGAColors.black;

  FormColorScheme.dark()
      : datecellBackground100 = SDGAColors.primary.shade300,
        datecellBackground200 = SDGAColors.primary.shade400,
        datecellBackground300 = SDGAColors.primary.shade300,
        datecellBackground600 = SDGAColors.primary,
        datecellBackgroundDefault = SDGAColors.primary,
        datecellBackgroundDisabled = const Color(0xFFFFFFFF),
        datecellBackgroundFocused = SDGAColors.primary,
        datecellBackgroundHovered = SDGAColors.primary.shade700,
        datecellBackgroundPressed = SDGAColors.primary.shade900,
        datecellTodayBackgroundDefault = SDGAColors.blackAlpha.alpha10,
        datecellTodayBackgroundFocused = SDGAColors.blackAlpha.alpha10,
        datecellTodayBackgroundHovered = SDGAColors.neutral.shade700,
        datecellTodayBackgroundPressed = SDGAColors.neutral,
        fieldBackgroundDarker = SDGAColors.neutral.shade800,
        fieldBackgroundDefault = SDGAColors.neutral.shade800,
        fieldBackgroundLighter = SDGAColors.neutral,
        fieldBackgroundPressed = SDGAColors.neutral,
        fieldBorderDefault = SDGAColors.neutral.shade500,
        fieldBorderError = SDGAColors.red.shade700,
        fieldBorderHovered = SDGAColors.neutral.shade200,
        fieldBorderPressed = SDGAColors.neutral.shade25,
        fieldTextFilled = SDGAColors.white,
        fieldTextFocused = SDGAColors.neutral.shade100,
        fieldTextHelper = SDGAColors.neutral.shade200,
        fieldTextHovered = SDGAColors.white,
        fieldTextLabel = SDGAColors.white,
        fieldTextPlaceholder = SDGAColors.neutral.shade200,
        fieldTextPressed = SDGAColors.neutral.shade100,
        fieldTextReadonly = SDGAColors.white,
        optionBackgroundHover = SDGAColors.neutral.shade500,
        optionBackgroundPressed = SDGAColors.neutral.shade700,
        textareaScrollbarBar = SDGAColors.neutral,
        textFormParagraph = SDGAColors.neutral.shade200,
        textFormTitle = SDGAColors.white;

  FormColorScheme lerp(FormColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return FormColorScheme(
        datecellBackground100:
            Color.lerp(datecellBackground100, other.datecellBackground100, t)!,
        datecellBackground200:
            Color.lerp(datecellBackground200, other.datecellBackground200, t)!,
        datecellBackground300:
            Color.lerp(datecellBackground300, other.datecellBackground300, t)!,
        datecellBackground600:
            Color.lerp(datecellBackground600, other.datecellBackground600, t)!,
        datecellBackgroundDefault: Color.lerp(
            datecellBackgroundDefault, other.datecellBackgroundDefault, t)!,
        datecellBackgroundDisabled: Color.lerp(
            datecellBackgroundDisabled, other.datecellBackgroundDisabled, t)!,
        datecellBackgroundFocused: Color.lerp(
            datecellBackgroundFocused, other.datecellBackgroundFocused, t)!,
        datecellBackgroundHovered: Color.lerp(
            datecellBackgroundHovered, other.datecellBackgroundHovered, t)!,
        datecellBackgroundPressed: Color.lerp(
            datecellBackgroundPressed, other.datecellBackgroundPressed, t)!,
        datecellTodayBackgroundDefault: Color.lerp(
            datecellTodayBackgroundDefault,
            other.datecellTodayBackgroundDefault,
            t)!,
        datecellTodayBackgroundFocused: Color.lerp(
            datecellTodayBackgroundFocused,
            other.datecellTodayBackgroundFocused,
            t)!,
        datecellTodayBackgroundHovered: Color.lerp(
            datecellTodayBackgroundHovered,
            other.datecellTodayBackgroundHovered,
            t)!,
        datecellTodayBackgroundPressed: Color.lerp(
            datecellTodayBackgroundPressed,
            other.datecellTodayBackgroundPressed,
            t)!,
        fieldBackgroundDarker:
            Color.lerp(fieldBackgroundDarker, other.fieldBackgroundDarker, t)!,
        fieldBackgroundDefault: Color.lerp(
            fieldBackgroundDefault, other.fieldBackgroundDefault, t)!,
        fieldBackgroundLighter: Color.lerp(
            fieldBackgroundLighter, other.fieldBackgroundLighter, t)!,
        fieldBackgroundPressed: Color.lerp(
            fieldBackgroundPressed, other.fieldBackgroundPressed, t)!,
        fieldBorderDefault:
            Color.lerp(fieldBorderDefault, other.fieldBorderDefault, t)!,
        fieldBorderError:
            Color.lerp(fieldBorderError, other.fieldBorderError, t)!,
        fieldBorderHovered:
            Color.lerp(fieldBorderHovered, other.fieldBorderHovered, t)!,
        fieldBorderPressed:
            Color.lerp(fieldBorderPressed, other.fieldBorderPressed, t)!,
        fieldTextFilled: Color.lerp(fieldTextFilled, other.fieldTextFilled, t)!,
        fieldTextFocused:
            Color.lerp(fieldTextFocused, other.fieldTextFocused, t)!,
        fieldTextHelper: Color.lerp(fieldTextHelper, other.fieldTextHelper, t)!,
        fieldTextHovered:
            Color.lerp(fieldTextHovered, other.fieldTextHovered, t)!,
        fieldTextLabel: Color.lerp(fieldTextLabel, other.fieldTextLabel, t)!,
        fieldTextPlaceholder:
            Color.lerp(fieldTextPlaceholder, other.fieldTextPlaceholder, t)!,
        fieldTextPressed:
            Color.lerp(fieldTextPressed, other.fieldTextPressed, t)!,
        fieldTextReadonly:
            Color.lerp(fieldTextReadonly, other.fieldTextReadonly, t)!,
        optionBackgroundHover:
            Color.lerp(optionBackgroundHover, other.optionBackgroundHover, t)!,
        optionBackgroundPressed: Color.lerp(
            optionBackgroundPressed, other.optionBackgroundPressed, t)!,
        textareaScrollbarBar:
            Color.lerp(textareaScrollbarBar, other.textareaScrollbarBar, t)!,
        textFormParagraph:
            Color.lerp(textFormParagraph, other.textFormParagraph, t)!,
        textFormTitle: Color.lerp(textFormTitle, other.textFormTitle, t)!,
      );
    }
  }
}

@protected
class GlobalColorScheme {
  final Color backgroundDisabled;
  final Color backgroundDisabledPrimary;
  final Color backgroundInverseDisabled;
  final Color borderDisabled;
  final Color controlDisabled;
  final Color iconDefaultDisabled;
  final Color iconDefaultOnColorDisabled;
  final Color textDefaultDisabled;
  final Color textDefaultOnColorDisabled;

  const GlobalColorScheme({
    required this.backgroundDisabled,
    required this.backgroundDisabledPrimary,
    required this.backgroundInverseDisabled,
    required this.borderDisabled,
    required this.controlDisabled,
    required this.iconDefaultDisabled,
    required this.iconDefaultOnColorDisabled,
    required this.textDefaultDisabled,
    required this.textDefaultOnColorDisabled,
  });

  GlobalColorScheme.light()
      : backgroundDisabled = SDGAColors.neutral.shade200,
        backgroundDisabledPrimary = SDGAColors.primary.shade200,
        backgroundInverseDisabled = SDGAColors.neutral.shade100,
        borderDisabled = SDGAColors.neutral.shade400,
        controlDisabled = SDGAColors.neutral.shade400,
        iconDefaultDisabled = SDGAColors.neutral.shade400,
        iconDefaultOnColorDisabled = SDGAColors.whiteAlpha.alpha40,
        textDefaultDisabled = SDGAColors.neutral.shade400,
        textDefaultOnColorDisabled = SDGAColors.whiteAlpha.alpha40;

  GlobalColorScheme.dark()
      : backgroundDisabled = SDGAColors.neutral.shade700,
        backgroundDisabledPrimary = SDGAColors.primary.shade700,
        backgroundInverseDisabled = SDGAColors.neutral.shade700,
        borderDisabled = SDGAColors.neutral.shade400,
        controlDisabled = SDGAColors.whiteAlpha.alpha30,
        iconDefaultDisabled = SDGAColors.neutral.shade400,
        iconDefaultOnColorDisabled = SDGAColors.white,
        textDefaultDisabled = SDGAColors.neutral.shade400,
        textDefaultOnColorDisabled = SDGAColors.whiteAlpha.alpha40;

  GlobalColorScheme lerp(GlobalColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return GlobalColorScheme(
        backgroundDisabled:
            Color.lerp(backgroundDisabled, other.backgroundDisabled, t)!,
        backgroundDisabledPrimary: Color.lerp(
            backgroundDisabledPrimary, other.backgroundDisabledPrimary, t)!,
        backgroundInverseDisabled: Color.lerp(
            backgroundInverseDisabled, other.backgroundInverseDisabled, t)!,
        borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
        controlDisabled: Color.lerp(controlDisabled, other.controlDisabled, t)!,
        iconDefaultDisabled:
            Color.lerp(iconDefaultDisabled, other.iconDefaultDisabled, t)!,
        iconDefaultOnColorDisabled: Color.lerp(
            iconDefaultOnColorDisabled, other.iconDefaultOnColorDisabled, t)!,
        textDefaultDisabled:
            Color.lerp(textDefaultDisabled, other.textDefaultDisabled, t)!,
        textDefaultOnColorDisabled: Color.lerp(
            textDefaultOnColorDisabled, other.textDefaultOnColorDisabled, t)!,
      );
    }
  }
}

@protected
class IconColorScheme {
  final Color backgroundBrandLight;
  final Color backgroundErrorLight;
  final Color backgroundInfoLight;
  final Color backgroundSuccessLight;
  final Color backgroundWarningLight;
  final Color defaultColor;
  final Color default400;
  final Color default500;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;
  final Color neutral;
  final Color neutralLight;
  final Color onColor;
  final Color primary;
  final Color primary400;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryLight;
  final Color success;
  final Color successLight;
  final Color tertiary;
  final Color tertiaryLight;
  final Color warning;
  final Color warningLight;
  final Color unselectedTabIcon;

  const IconColorScheme({
    required this.backgroundBrandLight,
    required this.backgroundErrorLight,
    required this.backgroundInfoLight,
    required this.backgroundSuccessLight,
    required this.backgroundWarningLight,
    required this.defaultColor,
    required this.default400,
    required this.default500,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.neutral,
    required this.neutralLight,
    required this.onColor,
    required this.primary,
    required this.primary400,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryLight,
    required this.success,
    required this.successLight,
    required this.tertiary,
    required this.tertiaryLight,
    required this.warning,
    required this.warningLight,
    required this.unselectedTabIcon,
  });

  IconColorScheme.light()
      : backgroundBrandLight = SDGAColors.primary.shade50,
        backgroundErrorLight = SDGAColors.red.shade50,
        backgroundInfoLight = SDGAColors.blue.shade50,
        backgroundSuccessLight = SDGAColors.green.shade50,
        backgroundWarningLight = SDGAColors.yellow.shade50,
        defaultColor = SDGAColors.black,
        default400 = SDGAColors.neutral.shade400,
        default500 = SDGAColors.neutral.shade500,
        error = SDGAColors.red.shade700,
        errorLight = SDGAColors.red.shade50,
        info = SDGAColors.blue.shade700,
        infoLight = SDGAColors.blue.shade50,
        neutral = SDGAColors.neutral.shade700,
        neutralLight = SDGAColors.neutral.shade50,
        onColor = SDGAColors.white,
        primary = SDGAColors.primary,
        primary400 = SDGAColors.primary.shade400,
        primaryLight = SDGAColors.primary.shade50,
        secondary = SDGAColors.secondaryGold,
        secondaryLight = SDGAColors.secondaryGold.shade50,
        success = SDGAColors.green.shade700,
        successLight = SDGAColors.green.shade50,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryLight = SDGAColors.tertiaryLavender.shade50,
        warning = SDGAColors.yellow.shade700,
        warningLight = SDGAColors.yellow.shade50,
        unselectedTabIcon = SDGAColors.neutral.shade700;

  IconColorScheme.dark()
      : backgroundBrandLight = const Color(0x19166A45),
        backgroundErrorLight = const Color(0x19B42318),
        backgroundInfoLight = const Color(0x19175CD3),
        backgroundSuccessLight = const Color(0x19067647),
        backgroundWarningLight = const Color(0x19B54708),
        defaultColor = SDGAColors.white,
        default400 = SDGAColors.neutral.shade500,
        default500 = SDGAColors.neutral.shade200,
        error = SDGAColors.red.shade400,
        errorLight = SDGAColors.red.shade50,
        info = SDGAColors.blue.shade400,
        infoLight = SDGAColors.blue.shade50,
        neutral = SDGAColors.neutral.shade400,
        neutralLight = SDGAColors.neutral.shade950,
        onColor = SDGAColors.white,
        primary = SDGAColors.primary.shade400,
        primary400 = SDGAColors.primary.shade200,
        primaryLight = SDGAColors.primary.shade50,
        secondary = SDGAColors.secondaryGold.shade400,
        secondaryLight = SDGAColors.secondaryGold.shade50,
        success = SDGAColors.green.shade400,
        successLight = SDGAColors.green.shade50,
        tertiary = SDGAColors.tertiaryLavender.shade400,
        tertiaryLight = SDGAColors.tertiaryLavender.shade50,
        warning = SDGAColors.yellow.shade400,
        warningLight = SDGAColors.yellow.shade50,
        unselectedTabIcon = SDGAColors.neutral.shade100;

  IconColorScheme lerp(IconColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return IconColorScheme(
        backgroundBrandLight:
            Color.lerp(backgroundBrandLight, other.backgroundBrandLight, t)!,
        backgroundErrorLight:
            Color.lerp(backgroundErrorLight, other.backgroundErrorLight, t)!,
        backgroundInfoLight:
            Color.lerp(backgroundInfoLight, other.backgroundInfoLight, t)!,
        backgroundSuccessLight: Color.lerp(
            backgroundSuccessLight, other.backgroundSuccessLight, t)!,
        backgroundWarningLight: Color.lerp(
            backgroundWarningLight, other.backgroundWarningLight, t)!,
        defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
        default400: Color.lerp(default400, other.default400, t)!,
        default500: Color.lerp(default500, other.default500, t)!,
        error: Color.lerp(error, other.error, t)!,
        errorLight: Color.lerp(errorLight, other.errorLight, t)!,
        info: Color.lerp(info, other.info, t)!,
        infoLight: Color.lerp(infoLight, other.infoLight, t)!,
        neutral: Color.lerp(neutral, other.neutral, t)!,
        neutralLight: Color.lerp(neutralLight, other.neutralLight, t)!,
        onColor: Color.lerp(onColor, other.onColor, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primary400: Color.lerp(primary400, other.primary400, t)!,
        primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
        success: Color.lerp(success, other.success, t)!,
        successLight: Color.lerp(successLight, other.successLight, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        tertiaryLight: Color.lerp(tertiaryLight, other.tertiaryLight, t)!,
        warning: Color.lerp(warning, other.warning, t)!,
        warningLight: Color.lerp(warningLight, other.warningLight, t)!,
        unselectedTabIcon:
            Color.lerp(unselectedTabIcon, other.unselectedTabIcon, t)!,
      );
    }
  }
}

@protected
class LinkColorScheme {
  final Color danger;
  final Color dangerFocused;
  final Color dangerHovered;
  final Color dangerPressed;
  final Color dangerVisited;
  final Color disabled;
  final Color iconDangerFocused;
  final Color iconDangerHovered;
  final Color iconDangerPressed;
  final Color iconDangerVisited;
  final Color iconNeutralFocused;
  final Color iconNeutralHovered;
  final Color iconNeutralPressed;
  final Color iconNeutralVisited;
  final Color iconOnColorDisabled;
  final Color iconOnColorHovered;
  final Color iconOnColorPressed;
  final Color iconOnColorVisited;
  final Color iconPrimaryFocused;
  final Color iconPrimaryHovered;
  final Color iconPrimaryPressed;
  final Color iconPrimaryVisited;
  final Color linkOnColorFocused;
  final Color neutral;
  final Color neutralFocused;
  final Color neutralHovered;
  final Color neutralPressed;
  final Color neutralVisited;
  final Color onColor;
  final Color onColorDisabled;
  final Color onColorFocused;
  final Color onColorHovered;
  final Color onColorPressed;
  final Color onColorVisited;
  final Color primary;
  final Color primaryFocused;
  final Color primaryHovered;
  final Color primaryPressed;
  final Color primaryVisited;
  final Color secondary;
  final Color secondaryFocused;
  final Color secondaryHovered;
  final Color secondaryPressed;
  final Color secondaryVisited;
  final Color tertiary;
  final Color tertiaryFocused;
  final Color tertiaryHovered;
  final Color tertiaryPressed;
  final Color tertiaryVisited;

  const LinkColorScheme({
    required this.danger,
    required this.dangerFocused,
    required this.dangerHovered,
    required this.dangerPressed,
    required this.dangerVisited,
    required this.disabled,
    required this.iconDangerFocused,
    required this.iconDangerHovered,
    required this.iconDangerPressed,
    required this.iconDangerVisited,
    required this.iconNeutralFocused,
    required this.iconNeutralHovered,
    required this.iconNeutralPressed,
    required this.iconNeutralVisited,
    required this.iconOnColorDisabled,
    required this.iconOnColorHovered,
    required this.iconOnColorPressed,
    required this.iconOnColorVisited,
    required this.iconPrimaryFocused,
    required this.iconPrimaryHovered,
    required this.iconPrimaryPressed,
    required this.iconPrimaryVisited,
    required this.linkOnColorFocused,
    required this.neutral,
    required this.neutralFocused,
    required this.neutralHovered,
    required this.neutralPressed,
    required this.neutralVisited,
    required this.onColor,
    required this.onColorDisabled,
    required this.onColorFocused,
    required this.onColorHovered,
    required this.onColorPressed,
    required this.onColorVisited,
    required this.primary,
    required this.primaryFocused,
    required this.primaryHovered,
    required this.primaryPressed,
    required this.primaryVisited,
    required this.secondary,
    required this.secondaryFocused,
    required this.secondaryHovered,
    required this.secondaryPressed,
    required this.secondaryVisited,
    required this.tertiary,
    required this.tertiaryFocused,
    required this.tertiaryHovered,
    required this.tertiaryPressed,
    required this.tertiaryVisited,
  });

  LinkColorScheme.light()
      : danger = SDGAColors.red,
        dangerFocused = SDGAColors.red,
        dangerHovered = SDGAColors.red.shade700,
        dangerPressed = SDGAColors.red.shade900,
        dangerVisited = SDGAColors.red.shade800,
        disabled = SDGAColors.neutral.shade400,
        iconDangerFocused = SDGAColors.red,
        iconDangerHovered = SDGAColors.red.shade700,
        iconDangerPressed = SDGAColors.red.shade900,
        iconDangerVisited = SDGAColors.red.shade800,
        iconNeutralFocused = SDGAColors.neutral.shade700,
        iconNeutralHovered = SDGAColors.neutral.shade500,
        iconNeutralPressed = SDGAColors.neutral.shade400,
        iconNeutralVisited = SDGAColors.neutral,
        iconOnColorDisabled = SDGAColors.whiteAlpha.alpha30,
        iconOnColorHovered = SDGAColors.whiteAlpha.alpha80,
        iconOnColorPressed = SDGAColors.whiteAlpha.alpha60,
        iconOnColorVisited = SDGAColors.whiteAlpha.alpha90,
        iconPrimaryFocused = SDGAColors.primary,
        iconPrimaryHovered = SDGAColors.primary.shade400,
        iconPrimaryPressed = SDGAColors.primary.shade300,
        iconPrimaryVisited = SDGAColors.primary.shade800,
        linkOnColorFocused = SDGAColors.white,
        neutral = SDGAColors.neutral.shade700,
        neutralFocused = SDGAColors.neutral.shade700,
        neutralHovered = SDGAColors.neutral.shade500,
        neutralPressed = SDGAColors.neutral.shade400,
        neutralVisited = SDGAColors.neutral,
        onColor = SDGAColors.white,
        onColorDisabled = SDGAColors.whiteAlpha.alpha30,
        onColorFocused = SDGAColors.white,
        onColorHovered = SDGAColors.whiteAlpha.alpha80,
        onColorPressed = SDGAColors.whiteAlpha.alpha60,
        onColorVisited = SDGAColors.whiteAlpha.alpha90,
        primary = SDGAColors.primary,
        primaryFocused = SDGAColors.primary,
        primaryHovered = SDGAColors.primary.shade400,
        primaryPressed = SDGAColors.primary.shade300,
        primaryVisited = SDGAColors.primary.shade800,
        secondary = SDGAColors.secondaryGold,
        secondaryFocused = SDGAColors.secondaryGold,
        secondaryHovered = SDGAColors.secondaryGold.shade400,
        secondaryPressed = SDGAColors.secondaryGold.shade300,
        secondaryVisited = SDGAColors.secondaryGold.shade900,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryFocused = SDGAColors.tertiaryLavender,
        tertiaryHovered = SDGAColors.tertiaryLavender.shade400,
        tertiaryPressed = SDGAColors.tertiaryLavender.shade300,
        tertiaryVisited = SDGAColors.tertiaryLavender.shade800;

  LinkColorScheme.dark()
      : danger = SDGAColors.red,
        dangerFocused = SDGAColors.red,
        dangerHovered = SDGAColors.red.shade700,
        dangerPressed = SDGAColors.red.shade900,
        dangerVisited = SDGAColors.red.shade800,
        disabled = SDGAColors.white,
        iconDangerFocused = SDGAColors.red,
        iconDangerHovered = SDGAColors.red.shade700,
        iconDangerPressed = SDGAColors.red.shade900,
        iconDangerVisited = SDGAColors.red.shade800,
        iconNeutralFocused = SDGAColors.neutral.shade200,
        iconNeutralHovered = SDGAColors.neutral.shade400,
        iconNeutralPressed = SDGAColors.neutral.shade500,
        iconNeutralVisited = SDGAColors.neutral.shade300,
        iconOnColorDisabled = SDGAColors.blackAlpha.alpha30,
        iconOnColorHovered = SDGAColors.blackAlpha.alpha80,
        iconOnColorPressed = SDGAColors.blackAlpha.alpha60,
        iconOnColorVisited = SDGAColors.blackAlpha.alpha90,
        iconPrimaryFocused = SDGAColors.primary,
        iconPrimaryHovered = SDGAColors.primary.shade400,
        iconPrimaryPressed = SDGAColors.primary.shade300,
        iconPrimaryVisited = SDGAColors.primary.shade800,
        linkOnColorFocused = SDGAColors.white,
        neutral = SDGAColors.neutral.shade200,
        neutralFocused = SDGAColors.neutral.shade200,
        neutralHovered = SDGAColors.neutral.shade400,
        neutralPressed = SDGAColors.neutral.shade500,
        neutralVisited = SDGAColors.neutral.shade300,
        onColor = SDGAColors.white,
        onColorDisabled = SDGAColors.whiteAlpha.alpha30,
        onColorFocused = SDGAColors.white,
        onColorHovered = SDGAColors.whiteAlpha.alpha80,
        onColorPressed = SDGAColors.whiteAlpha.alpha60,
        onColorVisited = SDGAColors.whiteAlpha.alpha90,
        primary = SDGAColors.primary,
        primaryFocused = SDGAColors.primary,
        primaryHovered = SDGAColors.primary.shade400,
        primaryPressed = SDGAColors.primary.shade300,
        primaryVisited = SDGAColors.primary.shade800,
        secondary = SDGAColors.secondaryGold,
        secondaryFocused = SDGAColors.secondaryGold,
        secondaryHovered = SDGAColors.secondaryGold.shade400,
        secondaryPressed = SDGAColors.secondaryGold.shade300,
        secondaryVisited = SDGAColors.secondaryGold.shade900,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryFocused = SDGAColors.tertiaryLavender,
        tertiaryHovered = SDGAColors.tertiaryLavender.shade400,
        tertiaryPressed = SDGAColors.tertiaryLavender.shade300,
        tertiaryVisited = SDGAColors.tertiaryLavender.shade800;

  LinkColorScheme lerp(LinkColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return LinkColorScheme(
        danger: Color.lerp(danger, other.danger, t)!,
        dangerFocused: Color.lerp(dangerFocused, other.dangerFocused, t)!,
        dangerHovered: Color.lerp(dangerHovered, other.dangerHovered, t)!,
        dangerPressed: Color.lerp(dangerPressed, other.dangerPressed, t)!,
        dangerVisited: Color.lerp(dangerVisited, other.dangerVisited, t)!,
        disabled: Color.lerp(disabled, other.disabled, t)!,
        iconDangerFocused:
            Color.lerp(iconDangerFocused, other.iconDangerFocused, t)!,
        iconDangerHovered:
            Color.lerp(iconDangerHovered, other.iconDangerHovered, t)!,
        iconDangerPressed:
            Color.lerp(iconDangerPressed, other.iconDangerPressed, t)!,
        iconDangerVisited:
            Color.lerp(iconDangerVisited, other.iconDangerVisited, t)!,
        iconNeutralFocused:
            Color.lerp(iconNeutralFocused, other.iconNeutralFocused, t)!,
        iconNeutralHovered:
            Color.lerp(iconNeutralHovered, other.iconNeutralHovered, t)!,
        iconNeutralPressed:
            Color.lerp(iconNeutralPressed, other.iconNeutralPressed, t)!,
        iconNeutralVisited:
            Color.lerp(iconNeutralVisited, other.iconNeutralVisited, t)!,
        iconOnColorDisabled:
            Color.lerp(iconOnColorDisabled, other.iconOnColorDisabled, t)!,
        iconOnColorHovered:
            Color.lerp(iconOnColorHovered, other.iconOnColorHovered, t)!,
        iconOnColorPressed:
            Color.lerp(iconOnColorPressed, other.iconOnColorPressed, t)!,
        iconOnColorVisited:
            Color.lerp(iconOnColorVisited, other.iconOnColorVisited, t)!,
        iconPrimaryFocused:
            Color.lerp(iconPrimaryFocused, other.iconPrimaryFocused, t)!,
        iconPrimaryHovered:
            Color.lerp(iconPrimaryHovered, other.iconPrimaryHovered, t)!,
        iconPrimaryPressed:
            Color.lerp(iconPrimaryPressed, other.iconPrimaryPressed, t)!,
        iconPrimaryVisited:
            Color.lerp(iconPrimaryVisited, other.iconPrimaryVisited, t)!,
        linkOnColorFocused:
            Color.lerp(linkOnColorFocused, other.linkOnColorFocused, t)!,
        neutral: Color.lerp(neutral, other.neutral, t)!,
        neutralFocused: Color.lerp(neutralFocused, other.neutralFocused, t)!,
        neutralHovered: Color.lerp(neutralHovered, other.neutralHovered, t)!,
        neutralPressed: Color.lerp(neutralPressed, other.neutralPressed, t)!,
        neutralVisited: Color.lerp(neutralVisited, other.neutralVisited, t)!,
        onColor: Color.lerp(onColor, other.onColor, t)!,
        onColorDisabled: Color.lerp(onColorDisabled, other.onColorDisabled, t)!,
        onColorFocused: Color.lerp(onColorFocused, other.onColorFocused, t)!,
        onColorHovered: Color.lerp(onColorHovered, other.onColorHovered, t)!,
        onColorPressed: Color.lerp(onColorPressed, other.onColorPressed, t)!,
        onColorVisited: Color.lerp(onColorVisited, other.onColorVisited, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primaryFocused: Color.lerp(primaryFocused, other.primaryFocused, t)!,
        primaryHovered: Color.lerp(primaryHovered, other.primaryHovered, t)!,
        primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
        primaryVisited: Color.lerp(primaryVisited, other.primaryVisited, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        secondaryFocused:
            Color.lerp(secondaryFocused, other.secondaryFocused, t)!,
        secondaryHovered:
            Color.lerp(secondaryHovered, other.secondaryHovered, t)!,
        secondaryPressed:
            Color.lerp(secondaryPressed, other.secondaryPressed, t)!,
        secondaryVisited:
            Color.lerp(secondaryVisited, other.secondaryVisited, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        tertiaryFocused: Color.lerp(tertiaryFocused, other.tertiaryFocused, t)!,
        tertiaryHovered: Color.lerp(tertiaryHovered, other.tertiaryHovered, t)!,
        tertiaryPressed: Color.lerp(tertiaryPressed, other.tertiaryPressed, t)!,
        tertiaryVisited: Color.lerp(tertiaryVisited, other.tertiaryVisited, t)!,
      );
    }
  }
}

@protected
class StepperColorScheme {
  final Color buttonBackground;
  final Color buttonCompleted;
  final Color buttonCompletedHovered;
  final Color buttonCurrent;
  final Color buttonCurrentHovered;
  final Color buttonUpcomming;
  final Color buttonUpcommingHovered;
  final Color lineCompleted;
  final Color lineCompletedHovered;
  final Color lineCurrent;
  final Color lineUpcomming;
  final Color lineUpcommingHovered;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  const StepperColorScheme({
    required this.buttonBackground,
    required this.buttonCompleted,
    required this.buttonCompletedHovered,
    required this.buttonCurrent,
    required this.buttonCurrentHovered,
    required this.buttonUpcomming,
    required this.buttonUpcommingHovered,
    required this.lineCompleted,
    required this.lineCompletedHovered,
    required this.lineCurrent,
    required this.lineUpcomming,
    required this.lineUpcommingHovered,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
  });

  StepperColorScheme.light()
      : buttonBackground = SDGAColors.white,
        buttonCompleted = SDGAColors.primary,
        buttonCompletedHovered = SDGAColors.primary.shade700,
        buttonCurrent = SDGAColors.primary,
        buttonCurrentHovered = SDGAColors.primary.shade700,
        buttonUpcomming = SDGAColors.neutral.shade300,
        buttonUpcommingHovered = SDGAColors.neutral.shade400,
        lineCompleted = SDGAColors.primary,
        lineCompletedHovered = SDGAColors.primary.shade700,
        lineCurrent = SDGAColors.neutral.shade300,
        lineUpcomming = SDGAColors.neutral.shade300,
        lineUpcommingHovered = SDGAColors.neutral.shade400,
        textPrimary = SDGAColors.neutral.shade800,
        textSecondary = SDGAColors.neutral.shade700,
        textTertiary = SDGAColors.neutral.shade500;

  StepperColorScheme.dark()
      : buttonBackground = SDGAColors.white,
        buttonCompleted = SDGAColors.green,
        buttonCompletedHovered = SDGAColors.primary.shade700,
        buttonCurrent = SDGAColors.green,
        buttonCurrentHovered = SDGAColors.primary.shade700,
        buttonUpcomming = SDGAColors.neutral,
        buttonUpcommingHovered = SDGAColors.neutral,
        lineCompleted = SDGAColors.primary,
        lineCompletedHovered = SDGAColors.primary.shade700,
        lineCurrent = SDGAColors.neutral.shade700,
        lineUpcomming = SDGAColors.neutral.shade700,
        lineUpcommingHovered = SDGAColors.neutral.shade700,
        textPrimary = SDGAColors.white,
        textSecondary = SDGAColors.neutral.shade100,
        textTertiary = SDGAColors.neutral.shade200;

  StepperColorScheme lerp(StepperColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return StepperColorScheme(
        buttonBackground:
            Color.lerp(buttonBackground, other.buttonBackground, t)!,
        buttonCompleted: Color.lerp(buttonCompleted, other.buttonCompleted, t)!,
        buttonCompletedHovered: Color.lerp(
            buttonCompletedHovered, other.buttonCompletedHovered, t)!,
        buttonCurrent: Color.lerp(buttonCurrent, other.buttonCurrent, t)!,
        buttonCurrentHovered:
            Color.lerp(buttonCurrentHovered, other.buttonCurrentHovered, t)!,
        buttonUpcomming: Color.lerp(buttonUpcomming, other.buttonUpcomming, t)!,
        buttonUpcommingHovered: Color.lerp(
            buttonUpcommingHovered, other.buttonUpcommingHovered, t)!,
        lineCompleted: Color.lerp(lineCompleted, other.lineCompleted, t)!,
        lineCompletedHovered:
            Color.lerp(lineCompletedHovered, other.lineCompletedHovered, t)!,
        lineCurrent: Color.lerp(lineCurrent, other.lineCurrent, t)!,
        lineUpcomming: Color.lerp(lineUpcomming, other.lineUpcomming, t)!,
        lineUpcommingHovered:
            Color.lerp(lineUpcommingHovered, other.lineUpcommingHovered, t)!,
        textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
        textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
        textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      );
    }
  }
}

@protected
class TableColorScheme {
  final Color backgroundDisabled;
  final Color backgroundHeader;
  final Color backgroundHoverSelected;
  final Color backgroundRow;
  final Color backgroundRowAlt;
  final Color backgroundRowHovered;
  final Color backgroundRowSelect;
  final Color backgroundRowSelectedHovered;
  final Color boarderRowSelectedHovered;
  final Color cellBorder;
  final Color cellBorderInverse;
  final Color textBody;
  final Color textHead;

  const TableColorScheme({
    required this.backgroundDisabled,
    required this.backgroundHeader,
    required this.backgroundHoverSelected,
    required this.backgroundRow,
    required this.backgroundRowAlt,
    required this.backgroundRowHovered,
    required this.backgroundRowSelect,
    required this.backgroundRowSelectedHovered,
    required this.boarderRowSelectedHovered,
    required this.cellBorder,
    required this.cellBorderInverse,
    required this.textBody,
    required this.textHead,
  });

  TableColorScheme.light()
      : backgroundDisabled = SDGAColors.neutral.shade200,
        backgroundHeader = SDGAColors.neutral.shade100,
        backgroundHoverSelected = SDGAColors.neutral.shade50,
        backgroundRow = SDGAColors.neutral.shade50,
        backgroundRowAlt = SDGAColors.neutral.shade50,
        backgroundRowHovered = SDGAColors.neutral.shade100,
        backgroundRowSelect = SDGAColors.primary.shade50,
        backgroundRowSelectedHovered = SDGAColors.primary.shade50,
        boarderRowSelectedHovered = SDGAColors.neutral.shade100,
        cellBorder = SDGAColors.neutral.shade300,
        cellBorderInverse = SDGAColors.black,
        textBody = SDGAColors.black,
        textHead = SDGAColors.neutral.shade700;

  TableColorScheme.dark()
      : backgroundDisabled = SDGAColors.neutral.shade700,
        backgroundHeader = SDGAColors.neutral.shade900,
        backgroundHoverSelected = SDGAColors.neutral.shade900,
        backgroundRow = SDGAColors.neutral.shade900,
        backgroundRowAlt = const Color(0xFFFFFFFF),
        backgroundRowHovered = SDGAColors.neutral.shade100,
        backgroundRowSelect = SDGAColors.primary.shade50,
        backgroundRowSelectedHovered = SDGAColors.primary.shade50,
        boarderRowSelectedHovered = SDGAColors.neutral.shade100,
        cellBorder = SDGAColors.neutral,
        cellBorderInverse = SDGAColors.white,
        textBody = SDGAColors.white,
        textHead = SDGAColors.neutral.shade300;

  TableColorScheme lerp(TableColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return TableColorScheme(
        backgroundDisabled:
            Color.lerp(backgroundDisabled, other.backgroundDisabled, t)!,
        backgroundHeader:
            Color.lerp(backgroundHeader, other.backgroundHeader, t)!,
        backgroundHoverSelected: Color.lerp(
            backgroundHoverSelected, other.backgroundHoverSelected, t)!,
        backgroundRow: Color.lerp(backgroundRow, other.backgroundRow, t)!,
        backgroundRowAlt:
            Color.lerp(backgroundRowAlt, other.backgroundRowAlt, t)!,
        backgroundRowHovered:
            Color.lerp(backgroundRowHovered, other.backgroundRowHovered, t)!,
        backgroundRowSelect:
            Color.lerp(backgroundRowSelect, other.backgroundRowSelect, t)!,
        backgroundRowSelectedHovered: Color.lerp(backgroundRowSelectedHovered,
            other.backgroundRowSelectedHovered, t)!,
        boarderRowSelectedHovered: Color.lerp(
            boarderRowSelectedHovered, other.boarderRowSelectedHovered, t)!,
        cellBorder: Color.lerp(cellBorder, other.cellBorder, t)!,
        cellBorderInverse:
            Color.lerp(cellBorderInverse, other.cellBorderInverse, t)!,
        textBody: Color.lerp(textBody, other.textBody, t)!,
        textHead: Color.lerp(textHead, other.textHead, t)!,
      );
    }
  }
}

@protected
class TagColorScheme {
  final Color backgroundError;
  final Color backgroundErrorLight;
  final Color backgroundInfo;
  final Color backgroundInfoLight;
  final Color backgroundNeutral;
  final Color backgroundNeutralLight;
  final Color backgroundOnColor;
  final Color backgroundSuccess;
  final Color backgroundSuccessLight;
  final Color backgroundWarning;
  final Color backgroundWarningLight;
  final Color borderError;
  final Color borderErrorLight;
  final Color borderInfo;
  final Color borderInfoLight;
  final Color borderNeutral;
  final Color borderNeutralLight;
  final Color borderOnColor;
  final Color borderSuccess;
  final Color borderSuccessLight;
  final Color borderWarning;
  final Color borderWarningLight;
  final Color dot;
  final Color iconError;
  final Color iconInfo;
  final Color iconNeutral;
  final Color iconSuccess;
  final Color iconWarning;
  final Color textError;
  final Color textInfo;
  final Color textNeutral;
  final Color textSuccess;
  final Color textWarning;

  const TagColorScheme({
    required this.backgroundError,
    required this.backgroundErrorLight,
    required this.backgroundInfo,
    required this.backgroundInfoLight,
    required this.backgroundNeutral,
    required this.backgroundNeutralLight,
    required this.backgroundOnColor,
    required this.backgroundSuccess,
    required this.backgroundSuccessLight,
    required this.backgroundWarning,
    required this.backgroundWarningLight,
    required this.borderError,
    required this.borderErrorLight,
    required this.borderInfo,
    required this.borderInfoLight,
    required this.borderNeutral,
    required this.borderNeutralLight,
    required this.borderOnColor,
    required this.borderSuccess,
    required this.borderSuccessLight,
    required this.borderWarning,
    required this.borderWarningLight,
    required this.dot,
    required this.iconError,
    required this.iconInfo,
    required this.iconNeutral,
    required this.iconSuccess,
    required this.iconWarning,
    required this.textError,
    required this.textInfo,
    required this.textNeutral,
    required this.textSuccess,
    required this.textWarning,
  });

  TagColorScheme.light()
      : backgroundError = SDGAColors.red,
        backgroundErrorLight = SDGAColors.red.shade50,
        backgroundInfo = SDGAColors.blue,
        backgroundInfoLight = SDGAColors.blue.shade50,
        backgroundNeutral = SDGAColors.neutral,
        backgroundNeutralLight = SDGAColors.neutral.shade50,
        backgroundOnColor = SDGAColors.whiteAlpha.alpha20,
        backgroundSuccess = SDGAColors.green.shade700,
        backgroundSuccessLight = SDGAColors.green.shade50,
        backgroundWarning = SDGAColors.yellow.shade700,
        backgroundWarningLight = SDGAColors.yellow.shade50,
        borderError = SDGAColors.red.shade700,
        borderErrorLight = SDGAColors.red.shade200,
        borderInfo = SDGAColors.blue.shade700,
        borderInfoLight = SDGAColors.blue.shade200,
        borderNeutral = SDGAColors.neutral,
        borderNeutralLight = SDGAColors.neutral.shade50,
        borderOnColor = SDGAColors.whiteAlpha.alpha60,
        borderSuccess = SDGAColors.green.shade700,
        borderSuccessLight = SDGAColors.green.shade200,
        borderWarning = SDGAColors.yellow.shade700,
        borderWarningLight = SDGAColors.yellow.shade200,
        dot = SDGAColors.whiteAlpha.alpha60,
        iconError = SDGAColors.red.shade800,
        iconInfo = SDGAColors.blue.shade800,
        iconNeutral = SDGAColors.neutral.shade800,
        iconSuccess = SDGAColors.green.shade800,
        iconWarning = SDGAColors.yellow.shade800,
        textError = SDGAColors.red.shade800,
        textInfo = SDGAColors.blue.shade800,
        textNeutral = SDGAColors.neutral.shade800,
        textSuccess = SDGAColors.green.shade800,
        textWarning = SDGAColors.yellow.shade800;

  TagColorScheme.dark()
      : backgroundError = SDGAColors.red,
        backgroundErrorLight = SDGAColors.red.shade50,
        backgroundInfo = SDGAColors.blue,
        backgroundInfoLight = SDGAColors.blue.shade50,
        backgroundNeutral = SDGAColors.primary,
        backgroundNeutralLight = SDGAColors.neutral.shade800,
        backgroundOnColor = SDGAColors.whiteAlpha.alpha20,
        backgroundSuccess = SDGAColors.green.shade700,
        backgroundSuccessLight = SDGAColors.green.shade50,
        backgroundWarning = SDGAColors.yellow.shade700,
        backgroundWarningLight = SDGAColors.yellow.shade50,
        borderError = SDGAColors.red.shade700,
        borderErrorLight = SDGAColors.red.shade200,
        borderInfo = SDGAColors.blue.shade700,
        borderInfoLight = SDGAColors.blue.shade200,
        borderNeutral = SDGAColors.neutral.shade300,
        borderNeutralLight = SDGAColors.neutral.shade800,
        borderOnColor = SDGAColors.whiteAlpha.alpha60,
        borderSuccess = SDGAColors.green.shade700,
        borderSuccessLight = SDGAColors.green.shade200,
        borderWarning = SDGAColors.red.shade700,
        borderWarningLight = SDGAColors.yellow.shade200,
        dot = SDGAColors.whiteAlpha.alpha60,
        iconError = SDGAColors.red.shade800,
        iconInfo = SDGAColors.blue.shade800,
        iconNeutral = SDGAColors.neutral.shade100,
        iconSuccess = SDGAColors.green.shade800,
        iconWarning = SDGAColors.yellow.shade800,
        textError = SDGAColors.red.shade800,
        textInfo = SDGAColors.blue.shade800,
        textNeutral = SDGAColors.neutral.shade100,
        textSuccess = SDGAColors.green.shade800,
        textWarning = SDGAColors.yellow.shade800;

  TagColorScheme lerp(TagColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return TagColorScheme(
        backgroundError: Color.lerp(backgroundError, other.backgroundError, t)!,
        backgroundErrorLight:
            Color.lerp(backgroundErrorLight, other.backgroundErrorLight, t)!,
        backgroundInfo: Color.lerp(backgroundInfo, other.backgroundInfo, t)!,
        backgroundInfoLight:
            Color.lerp(backgroundInfoLight, other.backgroundInfoLight, t)!,
        backgroundNeutral:
            Color.lerp(backgroundNeutral, other.backgroundNeutral, t)!,
        backgroundNeutralLight: Color.lerp(
            backgroundNeutralLight, other.backgroundNeutralLight, t)!,
        backgroundOnColor:
            Color.lerp(backgroundOnColor, other.backgroundOnColor, t)!,
        backgroundSuccess:
            Color.lerp(backgroundSuccess, other.backgroundSuccess, t)!,
        backgroundSuccessLight: Color.lerp(
            backgroundSuccessLight, other.backgroundSuccessLight, t)!,
        backgroundWarning:
            Color.lerp(backgroundWarning, other.backgroundWarning, t)!,
        backgroundWarningLight: Color.lerp(
            backgroundWarningLight, other.backgroundWarningLight, t)!,
        borderError: Color.lerp(borderError, other.borderError, t)!,
        borderErrorLight:
            Color.lerp(borderErrorLight, other.borderErrorLight, t)!,
        borderInfo: Color.lerp(borderInfo, other.borderInfo, t)!,
        borderInfoLight: Color.lerp(borderInfoLight, other.borderInfoLight, t)!,
        borderNeutral: Color.lerp(borderNeutral, other.borderNeutral, t)!,
        borderNeutralLight:
            Color.lerp(borderNeutralLight, other.borderNeutralLight, t)!,
        borderOnColor: Color.lerp(borderOnColor, other.borderOnColor, t)!,
        borderSuccess: Color.lerp(borderSuccess, other.borderSuccess, t)!,
        borderSuccessLight:
            Color.lerp(borderSuccessLight, other.borderSuccessLight, t)!,
        borderWarning: Color.lerp(borderWarning, other.borderWarning, t)!,
        borderWarningLight:
            Color.lerp(borderWarningLight, other.borderWarningLight, t)!,
        dot: Color.lerp(dot, other.dot, t)!,
        iconError: Color.lerp(iconError, other.iconError, t)!,
        iconInfo: Color.lerp(iconInfo, other.iconInfo, t)!,
        iconNeutral: Color.lerp(iconNeutral, other.iconNeutral, t)!,
        iconSuccess: Color.lerp(iconSuccess, other.iconSuccess, t)!,
        iconWarning: Color.lerp(iconWarning, other.iconWarning, t)!,
        textError: Color.lerp(textError, other.textError, t)!,
        textInfo: Color.lerp(textInfo, other.textInfo, t)!,
        textNeutral: Color.lerp(textNeutral, other.textNeutral, t)!,
        textSuccess: Color.lerp(textSuccess, other.textSuccess, t)!,
        textWarning: Color.lerp(textWarning, other.textWarning, t)!,
      );
    }
  }
}

@protected
class TextColorScheme {
  final Color defaultColor;
  final Color display;
  final Color error;
  final Color info;
  final Color onColorPrimary;
  final Color onColorSecondary;
  final Color onColorTertiary;
  final Color primary;
  final Color primaryLight;
  final Color primaryParagraph;
  final Color primarySaFlag;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryParagraph;
  final Color success;
  final Color tertiary;
  final Color tertiaryLight;
  final Color warning;

  const TextColorScheme({
    required this.defaultColor,
    required this.display,
    required this.error,
    required this.info,
    required this.onColorPrimary,
    required this.onColorSecondary,
    required this.onColorTertiary,
    required this.primary,
    required this.primaryLight,
    required this.primaryParagraph,
    required this.primarySaFlag,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryParagraph,
    required this.success,
    required this.tertiary,
    required this.tertiaryLight,
    required this.warning,
  });

  TextColorScheme.light()
      : defaultColor = SDGAColors.black,
        display = SDGAColors.neutral.shade800,
        error = SDGAColors.red.shade700,
        info = SDGAColors.blue.shade700,
        onColorPrimary = SDGAColors.white,
        onColorSecondary = SDGAColors.whiteAlpha.alpha80,
        onColorTertiary = SDGAColors.whiteAlpha.alpha70,
        primary = SDGAColors.primary,
        primaryLight = SDGAColors.primary.shade300,
        primaryParagraph = SDGAColors.neutral.shade700,
        primarySaFlag = SDGAColors.primary.shade800,
        secondary = SDGAColors.secondaryGold,
        secondaryLight = SDGAColors.secondaryGold.shade300,
        secondaryParagraph = SDGAColors.neutral.shade500,
        success = SDGAColors.green.shade700,
        tertiary = SDGAColors.tertiaryLavender,
        tertiaryLight = SDGAColors.tertiaryLavender.shade300,
        warning = SDGAColors.yellow.shade700;

  TextColorScheme.dark()
      : defaultColor = SDGAColors.white,
        display = SDGAColors.neutral.shade50,
        error = SDGAColors.red.shade400,
        info = SDGAColors.blue.shade400,
        onColorPrimary = SDGAColors.white,
        onColorSecondary = SDGAColors.blackAlpha.alpha80,
        onColorTertiary = SDGAColors.blackAlpha.alpha70,
        primary = SDGAColors.primary.shade400,
        primaryLight = SDGAColors.primary.shade400,
        primaryParagraph = SDGAColors.neutral.shade100,
        primarySaFlag = SDGAColors.primary.shade100,
        secondary = SDGAColors.secondaryGold.shade400,
        secondaryLight = SDGAColors.secondaryGold.shade400,
        secondaryParagraph = SDGAColors.neutral.shade200,
        success = SDGAColors.green.shade400,
        tertiary = SDGAColors.tertiaryLavender.shade400,
        tertiaryLight = SDGAColors.tertiaryLavender.shade400,
        warning = SDGAColors.yellow.shade400;

  TextColorScheme lerp(TextColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return TextColorScheme(
        defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
        display: Color.lerp(display, other.display, t)!,
        error: Color.lerp(error, other.error, t)!,
        info: Color.lerp(info, other.info, t)!,
        onColorPrimary: Color.lerp(onColorPrimary, other.onColorPrimary, t)!,
        onColorSecondary:
            Color.lerp(onColorSecondary, other.onColorSecondary, t)!,
        onColorTertiary: Color.lerp(onColorTertiary, other.onColorTertiary, t)!,
        primary: Color.lerp(primary, other.primary, t)!,
        primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
        primaryParagraph:
            Color.lerp(primaryParagraph, other.primaryParagraph, t)!,
        primarySaFlag: Color.lerp(primarySaFlag, other.primarySaFlag, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
        secondaryParagraph:
            Color.lerp(secondaryParagraph, other.secondaryParagraph, t)!,
        success: Color.lerp(success, other.success, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        tertiaryLight: Color.lerp(tertiaryLight, other.tertiaryLight, t)!,
        warning: Color.lerp(warning, other.warning, t)!,
      );
    }
  }
}

@protected
class TooltipColorScheme {
  final Color backgroundDark;
  final Color backgroundLight;
  final Color textHeadingDark;
  final Color textHeadingLight;
  final Color textParagraphDark;
  final Color textParagraphLight;

  const TooltipColorScheme({
    required this.backgroundDark,
    required this.backgroundLight,
    required this.textHeadingDark,
    required this.textHeadingLight,
    required this.textParagraphDark,
    required this.textParagraphLight,
  });

  TooltipColorScheme.light()
      : backgroundDark = SDGAColors.neutral.shade800,
        backgroundLight = SDGAColors.white,
        textHeadingDark = SDGAColors.neutral.shade50,
        textHeadingLight = SDGAColors.neutral.shade800,
        textParagraphDark = SDGAColors.neutral.shade100,
        textParagraphLight = SDGAColors.neutral.shade700;

  TooltipColorScheme.dark()
      : backgroundDark = SDGAColors.white,
        backgroundLight = SDGAColors.neutral.shade800,
        textHeadingDark = SDGAColors.neutral.shade800,
        textHeadingLight = SDGAColors.neutral.shade50,
        textParagraphDark = SDGAColors.neutral.shade700,
        textParagraphLight = SDGAColors.neutral.shade100;

  TooltipColorScheme lerp(TooltipColorScheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return TooltipColorScheme(
        backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
        backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
        textHeadingDark: Color.lerp(textHeadingDark, other.textHeadingDark, t)!,
        textHeadingLight:
            Color.lerp(textHeadingLight, other.textHeadingLight, t)!,
        textParagraphDark:
            Color.lerp(textParagraphDark, other.textParagraphDark, t)!,
        textParagraphLight:
            Color.lerp(textParagraphLight, other.textParagraphLight, t)!,
      );
    }
  }
}
