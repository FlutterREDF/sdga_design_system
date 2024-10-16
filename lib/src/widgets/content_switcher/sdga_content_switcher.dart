import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

/// A widget that displays a content switcher, allowing the user
/// to switch between different items.
///
/// The [SDGAContentSwitcher] widget provides a tabbed interface
/// for switching between multiple items. It displays a list of
/// items as tabs, and the user can select one of them to display
/// its corresponding content.
///
/// {@tool sample}
///
/// ```dart
/// SDGAContentSwitcher<int>(
///   items: [1, 2, 3],
///   selectedItem: 2,
///   getText: (item) => 'Item $item',
///   onChanged: (item) {
///     print('Selected item: $item');
///   },
///   scrollable: true,
/// )
/// ```
/// {@end-tool}
class SDGAContentSwitcher<T> extends StatelessWidget {
  /// Creates a [SDGAContentSwitcher] widget
  ///
  /// The [SDGAContentSwitcher] widget itself does not maintain any
  /// state. Instead, when the selected item changes, the widget calls
  /// the [onChanged] callback. Most widgets that use the [SDGAContentSwitcher]
  /// will listen for the [onChanged] callback and rebuild the content switcher
  /// with a new [selectedItem] value to update the visual appearance and display
  /// the corresponding content.
  const SDGAContentSwitcher({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.getText,
    this.scrollable = true,
    this.onColor = false,
    this.physics,
    this.padding,
  }) : assert(items.length > 0,
            'The [items] array must contain at least one item');

  /// The list of items to be displayed in the content switcher.
  ///
  /// This list must contain at least one item.
  final List<T> items;

  /// The currently selected item.
  final T? selectedItem;

  /// Callback function called when the selected item is changed by the user.
  ///
  /// The new selected item is passed as an argument to the callback.
  ///
  /// If this callback is null, the content switcher will be disabled.
  final ValueChanged<T>? onChanged;

  /// A function that converts an item to a string representation for display.
  ///
  /// This function will be used to display the text for each item in the content switcher.
  final String Function(T item) getText;

  /// Determines whether the content switcher should be scrollable.
  ///
  /// If set to `true` (default), the content switcher will be scrollable if the items cannot fit within the available space.
  /// If set to `false`, the content switcher will not be scrollable, and items will share the same width.
  final bool scrollable;

  /// Indicates whether the button is on a darker background.
  final bool onColor;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// The amount of space by which to inset the content inside he scroll view.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    Widget child = SizedBox(
      height: 32.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          items.length,
          (index) {
            final child = _buildTab(index, colors);
            if (scrollable) return child;
            return Expanded(child: child);
          },
        ),
      ),
    );
    if (scrollable) {
      child = SingleChildScrollView(
        padding: padding,
        physics: physics,
        scrollDirection: Axis.horizontal,
        child: child,
      );
    }

    return DefaultTextStyle(
      style: SDGATextStyles.textMediumRegular,
      child: child,
    );
  }

  Widget _buildTab(int index, SDGAColorScheme colors) {
    const Radius radius = Radius.circular(SDGANumbers.radiusMedium);
    final T item = items[index];
    final String text = getText(item);
    final bool startCorner = index == 0;
    final bool endCorner = index == items.length - 1;

    return SDGAAction(
      key: ValueKey(item),
      animationDuration:
          onColor ? Duration.zero : const Duration(milliseconds: 100),
      borderRadius: BorderRadiusDirectional.only(
        topStart: startCorner ? radius : Radius.zero,
        bottomStart: startCorner ? radius : Radius.zero,
        topEnd: endCorner ? radius : Radius.zero,
        bottomEnd: endCorner ? radius : Radius.zero,
      ),
      selected: selectedItem == item,
      border: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: null,
          focused: onColor
              ? Border.all(
                  color: colors.borders.white,
                  width: 2,
                )
              : SDGADoubleBorder(
                  firstBorder: Border.all(
                    color: onColor
                        ? colors.borders.black
                        : colors.texts.onColorPrimary,
                    width: 3,
                  ),
                  secondBorder: Border.all(
                    color:
                        onColor ? colors.borders.white : colors.borders.black,
                    width: 2,
                  ),
                ),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: onColor
              ? colors.buttons.backgroundTransparentHovered
              : colors.buttons.backgroundNeutralDefault,
          pressed: onColor
              ? colors.buttons.backgroundTransparentPressed
              : colors.buttons.backgroundNeutralPressed,
          focused: selectedItem == item
              ? onColor
                  ? colors.buttons.backgroundPrimaryDefault
                  : colors.buttons.backgroundBlackDefault
              : onColor
                  ? colors.buttons.backgroundTransparentFocused
                  : colors.buttons.backgroundNeutralFocused,
          hovered: onColor
              ? colors.buttons.backgroundTransparentSelected
              : colors.buttons.backgroundNeutralHovered,
          /* Note
            The selected color was changed to something that looks better on darker theme
            The original colors are:
              onColor
              ? colors.buttons.backgroundPrimaryDefault
              : colors.buttons.backgroundBlackDefault,
          */
          selected:
              onColor ? colors.icons.primary : colors.controls.neutralChecked,
        ),
      ),
      textColor: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback:
              onColor ? colors.texts.onColorPrimary : colors.texts.defaultColor,
          hovered:
              onColor ? colors.texts.onColorPrimary : colors.texts.defaultColor,
          focused: selectedItem == item
              ? colors.texts.onColorPrimary
              : onColor
                  ? colors.texts.onColorPrimary
                  : colors.texts.defaultColor,
          selected: colors.texts.onColorPrimary,
        ),
      ),
      onTap: onChanged != null ? () => onChanged?.call(item) : null,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SDGANumbers.spacingLG,
            vertical: SDGANumbers.spacingXS,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
