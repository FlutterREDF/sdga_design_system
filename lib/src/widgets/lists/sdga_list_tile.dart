import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGAListTile extends StatelessWidget {
  /// Creates a list tile.
  const SDGAListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
  });

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// {@macro sdga.icon_style}
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  ///
  /// {@macro sdga.text_style}
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// You can use [Text.maxLines] to enforce the number of lines.
  ///
  /// {@macro sdga.text_style}
  final Widget? subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  ///
  /// {@macro sdga.icon_style}
  final Widget? trailing;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color and
  /// the [onTap] and [onLongPress] callbacks are inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback? onLongPress;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.ListTile.enableFeedback}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final TextStyle mainStyle = SDGATextStyles.textMediumMedium.copyWith(
        color: enabled
            ? colors.texts.defaultColor
            : colors.globals.textDefaultDisabled);

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: mainStyle,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    final Widget titleText = AnimatedDefaultTextStyle(
      style: mainStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    if (subtitle != null) {
      subtitleText = AnimatedDefaultTextStyle(
        style: SDGATextStyles.textSmallRegular.copyWith(
            color: enabled
                ? colors.texts.defaultColor
                : colors.globals.textDefaultDisabled),
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: mainStyle,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }

    return SDGAAction(
      borderRadius:
          const BorderRadius.all(Radius.circular(SDGANumbers.radiusSmall)),
      border: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered<Border?>(
          states,
          fallback: null,
          focused: Border.all(color: colors.controls.neutralFocused),
        ),
      ),
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      onFocusChange: onFocusChange,
      canRequestFocus: enabled,
      focusNode: focusNode,
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered<Color?>(
          states,
          fallback: null,
          focused: colors.buttons.backgroundNeutralFocused,
          hovered: colors.buttons.backgroundNeutralHovered,
          pressed: colors.buttons.backgroundNeutralPressed,
        ),
      ),
      autofocus: autofocus,
      enableFeedback: enableFeedback ?? true,
      child: Semantics(
        // selected: selected,
        enabled: enabled,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum:
              const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingMD),
          child: SDGAAnimatedWidget<IconThemeData>(
            duration: kThemeChangeDuration,
            value: IconThemeData(
              size: 24.0,
              color: enabled
                  ? colors.icons.defaultColor
                  : colors.globals.iconDefaultDisabled,
            ),
            lerp: (a, b, t) => IconThemeData.lerp(a, b, t),
            builder: (context, value, child) {
              return IconTheme.merge(
                data: value,
                child: child!,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon,
                  const SizedBox(width: SDGANumbers.spacingMD),
                ],
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        titleText,
                        if (subtitleText != null) subtitleText,
                      ],
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: SDGANumbers.spacingMD),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
