import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

enum SDGALinkSize { small, medium }

class SDGALink extends StatelessWidget {
  const SDGALink({
    super.key,
    this.style = SDGAWidgetStyle.brand,
    this.size = SDGALinkSize.medium,
    this.inline = false,
    this.visited = false,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.icon,
    this.child,
  });

  /// Called when the link is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the link will be disabled.
  final VoidCallback? onPressed;

  /// Called when the link is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the link will be disabled.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the link response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// The label of this link.
  /// 
  /// Typically a [Text] widget.
  ///
  /// {@macro sdga.text_style}
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The icon to display inside the link.
  ///
  /// {@template sdga.icon_style}
  /// The [Icon.size] and [Icon.color] of the icon is configured automatically
  /// using an [IconTheme] and therefore should not be explicitly given in the
  /// icon widget.
  /// {@endtemplate}
  ///
  /// See [Icon], [ImageIcon].
  final Widget? icon;

  /// Customizes this link's appearance.
  final SDGAWidgetStyle style;

  /// Defines the size of this link.
  final SDGALinkSize size;

  /// Whether to add an [TextDecoration.underline] under the link's text.
  final bool inline;

  /// Whether the link has been visited.
  final bool visited;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return MergeSemantics(
      child: Semantics(
        container: true,
        link: true,
        enabled: onPressed != null || onLongPress != null,
        child: DefaultTextStyle(
          style: _textStyle,
          child: IconTheme.merge(
            data: IconThemeData(size: _iconSize),
            child: SDGAAction(
              onTap: onPressed,
              onLongPress: onLongPress,
              autofocus: autofocus,
              onFocusChange: onFocusChange,
              onHover: onHover,
              focusNode: focusNode,
              statesController: statesController,
              border: WidgetStateProperty.resolveWith(
                (states) => SDGAUtils.resolveWidgetStateUnordered(
                  states,
                  fallback: null,
                  focused: Border.all(
                    color: style == SDGAWidgetStyle.onColor
                        ? colors.borders.white
                        : colors.borders.black,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
              ),
              textColor: WidgetStateProperty.resolveWith(
                (states) => _getForegroundColor(states, colors),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(SDGANumbers.radiusExtraSmall),
              ),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (child != null) child!,
        if (icon != null) ...[
          if (child != null) const SizedBox(width: SDGANumbers.spacingMD),
          icon!,
        ],
      ],
    );
  }

  TextStyle get _textStyle {
    TextStyle style;
    switch (size) {
      case SDGALinkSize.small:
        style = SDGATextStyles.textSmallRegular;
        break;
      case SDGALinkSize.medium:
        style = SDGATextStyles.textMediumRegular;
        break;
    }
    return style.copyWith(decoration: inline ? TextDecoration.underline : null);
  }

  double get _iconSize {
    switch (size) {
      case SDGALinkSize.small:
        return 16.0;
      case SDGALinkSize.medium:
        return 20.0;
    }
  }

  Color _getForegroundColor(Set<WidgetState> states, SDGAColorScheme colors) {
    switch (style) {
      case SDGAWidgetStyle.neutral:
        return _getNeutralColors(states, colors);
      case SDGAWidgetStyle.brand:
        return _getBrandColors(states, colors);
      case SDGAWidgetStyle.onColor:
        return _getOnColorColors(states, colors);
    }
  }

  Color _getBrandColors(Set<WidgetState> states, SDGAColorScheme colors) {
    return SDGAUtils.resolveWidgetStateUnordered(
      states,
      fallback: visited ? colors.links.primaryVisited : colors.links.primary,
      hovered: colors.links.primaryHovered,
      pressed: colors.links.primaryPressed,
      focused: colors.links.primaryFocused,
      selected: colors.links.primaryFocused,
      disabled: colors.links.disabled,
    );
  }

  Color _getNeutralColors(Set<WidgetState> states, SDGAColorScheme colors) {
    return SDGAUtils.resolveWidgetStateUnordered(
      states,
      fallback: visited ? colors.links.neutralVisited : colors.links.neutral,
      hovered: colors.links.neutralHovered,
      pressed: colors.links.neutralPressed,
      focused: colors.links.neutralFocused,
      selected: colors.links.neutralFocused,
      disabled: colors.links.disabled,
    );
  }

  Color _getOnColorColors(Set<WidgetState> states, SDGAColorScheme colors) {
    return SDGAUtils.resolveWidgetStateUnordered(
      states,
      fallback: visited ? colors.links.onColorVisited : colors.links.onColor,
      hovered: colors.links.onColorHovered,
      pressed: colors.links.onColorPressed,
      focused: colors.links.onColorFocused,
      selected: colors.links.onColorFocused,
      disabled: colors.links.onColorDisabled,
    );
  }
}
