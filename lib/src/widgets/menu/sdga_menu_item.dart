part of 'sdga_menu.dart';

enum _SDGAMenuItemType { item, title, divider }

/// A widget that is typically used within the [SDGAMenu].
class SDGAMenuItem extends StatelessWidget {
  /// Creates a menu item.
  const SDGAMenuItem({
    super.key,
    this.leading,
    required Widget this.label,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.excludeTrailingFocus = true,
    this.excludeLeadingFocus = true,
    this.selected,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
  })  : _type = _SDGAMenuItemType.item,
        enabled = onTap != null;

  /// Creates an group title.
  const SDGAMenuItem.groupTitle(Widget this.label, {super.key})
      : _type = _SDGAMenuItemType.title,
        enabled = true,
        excludeTrailingFocus = true,
        excludeLeadingFocus = true,
        leading = null,
        trailing = null,
        autofocus = false,
        enableFeedback = null,
        focusNode = null,
        onFocusChange = null,
        selected = null,
        onTap = null,
        onLongPress = null;

  /// Creates a divider between items.
  const SDGAMenuItem.divider({super.key})
      : _type = _SDGAMenuItemType.divider,
        excludeTrailingFocus = true,
        excludeLeadingFocus = true,
        enabled = true,
        leading = null,
        label = null,
        trailing = null,
        autofocus = false,
        enableFeedback = null,
        focusNode = null,
        onFocusChange = null,
        selected = null,
        onTap = null,
        onLongPress = null;

  /// A widget to display before the label.
  ///
  /// Typically an [Icon] widget.
  ///
  /// {@macro sdga.icon_style}
  final Widget? leading;

  /// The label for this menu item.
  ///
  /// {@macro sdga.text_style}
  final Widget? label;

  /// A widget to display after the label.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Whether this menu item is interactive.
  ///
  /// If false, this menu item is styled with the disabled color and
  /// the [onTap] and [onLongPress] callbacks are inoperative.
  final bool enabled;

  /// Called when the user taps this menu item.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this menu item.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback? onLongPress;

  /// Whether to wrap the[trailing] widget with an [ExcludeFocus] or not
  ///
  /// The is useful if the [onTap] callback has the same functionality as
  /// the widget placed as a [trailing]
  ///
  /// Defaults to `true`.
  final bool excludeTrailingFocus;

  /// Whether to wrap the[leading] widget with an [ExcludeFocus] or not
  ///
  /// The is useful if the [onTap] callback has the same functionality as
  /// the widget placed as a [leading]
  ///
  /// Defaults to `true`.
  final bool excludeLeadingFocus;

  /// Whether this drawer item is selected or not.
  ///
  /// This is passed to [Semantics] widget to indicate that this item is selected.
  final bool? selected;

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

  final _SDGAMenuItemType _type;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    switch (_type) {
      case _SDGAMenuItemType.item:
        return _buildItem(colors);
      case _SDGAMenuItemType.title:
        return AnimatedDefaultTextStyle(
          style: SDGATextStyles.textExtraSmallBold
              .copyWith(color: colors.texts.secondaryParagraph),
          duration: kThemeChangeDuration,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              top: SDGANumbers.spacingMD,
              start: SDGANumbers.spacingXL,
              end: SDGANumbers.spacing3XL,
            ),
            child: label,
          ),
        );
      case _SDGAMenuItemType.divider:
        return Container(
          height: 1,
          color: colors.borders.backgroundNeutral,
          margin: const EdgeInsets.symmetric(
            vertical: SDGANumbers.spacingMD,
            horizontal: 0,
          ),
        );
    }
  }

  Widget _buildItem(SDGAColorScheme colors) {
    final TextStyle mainStyle = SDGATextStyles.textMediumRegular.copyWith(
      color: enabled
          ? colors.texts.defaultColor
          : colors.globals.textDefaultDisabled,
    );

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
      child: label!,
    );

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: mainStyle,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingMD),
      child: SDGAAction(
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
          selected: selected,
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingIcon != null) ...[
                      leadingIcon,
                      const SizedBox(width: SDGANumbers.spacingMD),
                    ],
                    Expanded(child: titleText),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: SDGANumbers.spacingMD),
                      trailingIcon,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
