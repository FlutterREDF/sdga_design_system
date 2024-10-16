import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

part 'sdga_button_style.dart';

const double _kGap = 4.0;

enum SDGACloseButtonSize { xSmall, small, medium, large }
/// A customizable button widget with various styles and options.
///
/// The [SDGAButton] widget provides several constructors to create different
/// types of buttons, including regular buttons, destructive buttons, icon
/// buttons, floating action buttons (FABs), menu buttons, and close buttons.
///
/// You can customize the appearance and behavior of the button by specifying
/// various properties such as size, style, icon, text, and callback functions.
///
/// {@tool sample}
///
/// ```dart
/// // Regular button
/// SDGAButton(
///   style: SDGAButtonStyle.primaryBrand,
///   onPressed: () {
///     // Handle button press
///   },
///   child: Text('Click me'),
/// )
///
/// // Destructive button
/// SDGAButton.destructive(
///   style: SDGADestructiveButtonStyle.primary,
///   onPressed: () {
///     // Handle destructive action
///   },
///   child: Text('Delete'),
/// )
///
/// // Icon button
/// SDGAButton.icon(
///   icon: Icon(Icons.add),
///   onPressed: () {
///     // Handle icon button press
///   },
/// )
///
/// // Floating action button
/// SDGAButton.fab(
///   style: SDGAFabButtonStyle.primaryBrand,
///   icon: Icon(Icons.camera),
///   onPressed: () {
///     // Handle FAB press
///   },
/// )
///
/// // Close button
/// SDGAButton.close(
///   onPressed: () {
///     // Handle close button press
///   },
/// )
/// ```
/// {@end-tool}
class SDGAButton extends StatelessWidget {
  /// Creates a regular [SDGAButton] widget.
  const SDGAButton({
    Key? key,
    this.size = SDGAWidgetSize.large,
    SDGAButtonStyle this.style = SDGAButtonStyle.primaryBrand,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.button,
        closeSize = SDGACloseButtonSize.large,
        destructiveStyle = null,
        fabStyle = null,
        icon = null,
        super(key: key);

  /// Creates a destructive [SDGAButton] widget.
  const SDGAButton.destructive({
    Key? key,
    this.size = SDGAWidgetSize.large,
    SDGADestructiveButtonStyle style = SDGADestructiveButtonStyle.primary,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.destructiveButton,
        closeSize = SDGACloseButtonSize.large,
        destructiveStyle = style,
        style = null,
        fabStyle = null,
        icon = null,
        super(key: key);

  /// Creates an icon [SDGAButton] widget.
  const SDGAButton.icon({
    Key? key,
    this.size = SDGAWidgetSize.large,
    SDGAButtonStyle this.style = SDGAButtonStyle.primaryBrand,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    required Widget this.icon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.icon,
        closeSize = SDGACloseButtonSize.large,
        destructiveStyle = null,
        fabStyle = null,
        child = null,
        trailingIcon = null,
        leadingIcon = null,
        super(key: key);

  /// Creates a destructive icon [SDGAButton] widget.
  const SDGAButton.destructiveIcon({
    Key? key,
    this.size = SDGAWidgetSize.large,
    SDGADestructiveButtonStyle style = SDGADestructiveButtonStyle.primary,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    required Widget this.icon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.destructiveIcon,
        closeSize = SDGACloseButtonSize.large,
        destructiveStyle = style,
        style = null,
        fabStyle = null,
        child = null,
        trailingIcon = null,
        leadingIcon = null,
        super(key: key);

  /// Creates a floating action button (FAB) [SDGAButton] widget.
  const SDGAButton.fab({
    Key? key,
    SDGAFabButtonStyle style = SDGAFabButtonStyle.primaryBrand,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    this.child,
    required Widget this.icon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.fab,
        closeSize = SDGACloseButtonSize.large,
        size = SDGAWidgetSize.large,
        fabStyle = style,
        destructiveStyle = null,
        style = null,
        trailingIcon = null,
        leadingIcon = null,
        super(key: key);

  /// Creates a menu [SDGAButton] widget.
  const SDGAButton.menu({
    Key? key,
    this.size = SDGAWidgetSize.large,
    SDGAButtonStyle this.style = SDGAButtonStyle.primaryBrand,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.child,
    this.leadingIcon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.menu,
        closeSize = SDGACloseButtonSize.large,
        onColor = false,
        removeBackground = false,
        destructiveStyle = null,
        fabStyle = null,
        icon = null,
        trailingIcon = null,
        super(key: key);

  /// Creates a close [SDGAButton] widget.
  const SDGAButton.close({
    Key? key,
    SDGACloseButtonSize size = SDGACloseButtonSize.large,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.canRequestFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onColor = false,
    this.removeBackground = false,
    this.icon,
    this.statesController,
    this.isSemanticButton,
  })  : _type = _SDGAButtonType.close,
        size = SDGAWidgetSize.large,
        closeSize = size,
        style = null,
        destructiveStyle = null,
        fabStyle = null,
        child = null,
        trailingIcon = null,
        leadingIcon = null,
        super(key: key);

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
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

  /// {@macro flutter.widgets.Focus.canRequestFocus}
  final bool canRequestFocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// Determine whether this subtree represents a button.
  ///
  /// If this is null, the screen reader will not announce "button" when this
  /// is focused. This is useful when we traverse the menu system.
  ///
  /// Defaults to true.
  final bool? isSemanticButton;

  /// Typically the button's label.
  ///
  /// {@template sdga.text_style}
  /// The [TextStyle] of the text widgets is configured automatically using
  /// a [DefaultTextStyle] and therefore should not be explicitly given in the
  /// text widgets.
  /// {@endtemplate}
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Defines the size of this button.
  final SDGAWidgetSize size;

  /// Defines the size of this button.
  final SDGACloseButtonSize closeSize;

  /// Customizes this button's appearance.
  final SDGAButtonStyle? style;

  /// Customizes this destructive button's appearance.
  final SDGADestructiveButtonStyle? destructiveStyle;

  /// Customizes this fab's appearance.
  final SDGAFabButtonStyle? fabStyle;

  /// Indicates whether the button is on a darker background.
  final bool onColor;

  /// The icon to display inside the button.
  ///
  /// {@template sdga.icon_style}
  /// The [Icon.size] and [Icon.color] of the icon is configured automatically
  /// using an [IconTheme] and therefore should not be explicitly given in the
  /// icon widget.
  /// {@endtemplate}
  ///
  /// See [Icon], [ImageIcon].
  final Widget? icon;

  /// A widget to display before the child.
  ///
  /// Typically an [Icon].
  ///
  /// {@macro sdga.icon_style}
  ///
  /// See [Icon], [ImageIcon].
  final Widget? leadingIcon;

  /// A widget to display after the child.
  ///
  /// Typically an [Icon].
  ///
  /// {@macro sdga.icon_style}
  ///
  /// See [Icon], [ImageIcon].
  final Widget? trailingIcon;

  /// Determines whether the background of the widget should be removed.
  final bool removeBackground;

  final _SDGAButtonType _type;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final buttonStyle = _SDGAButtonStyle.fromStyle(
      _type,
      style ?? fabStyle?.normalStyle ?? SDGAButtonStyle.primaryBrand,
      destructiveStyle ?? SDGADestructiveButtonStyle.primary,
      onColor,
      colors,
    );

    return MergeSemantics(
      child: Semantics(
        container: true,
        enabled: onPressed != null || onLongPress != null,
        button: isSemanticButton ?? true,
        child: DefaultTextStyle(
          style: _textStyle,
          child: IconTheme.merge(
            data: IconThemeData(size: _iconSize),
            child: SDGAAction(
              onTap: onPressed,
              onLongPress: onLongPress,
              autofocus: autofocus,
              onFocusChange: onFocusChange,
              canRequestFocus: canRequestFocus,
              onHover: onHover,
              focusNode: focusNode,
              statesController: statesController,
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => SDGAUtils.resolveWidgetStateUnordered(
                  states,
                  fallback: removeBackground
                      ? SDGAColorScheme.of(context)
                          .backgrounds
                          .white
                          .withOpacity(0)
                      : buttonStyle.background,
                  disabled: buttonStyle.backgroundDisabled,
                  pressed: buttonStyle.backgroundPressed,
                  selected: buttonStyle.backgroundSelected,
                  hovered: buttonStyle.backgroundHovered,
                  focused: buttonStyle.backgroundFocused,
                ),
              ),
              border: WidgetStateProperty.resolveWith(
                (states) => SDGAUtils.resolveWidgetStateUnordered(
                  states,
                  fallback: buttonStyle.border,
                  disabled: buttonStyle.borderDisabled,
                  focused: buttonStyle.borderFocused,
                ),
              ),
              textColor: WidgetStateProperty.resolveWith(
                (states) => SDGAUtils.resolveWidgetStateUnordered(
                  states,
                  fallback: buttonStyle.text,
                  disabled: buttonStyle.textDisabled,
                  hovered: buttonStyle.textHovered ?? buttonStyle.text,
                  pressed: buttonStyle.textPressed ?? buttonStyle.text,
                  selected: buttonStyle.textSelected ?? buttonStyle.text,
                ),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  _type == _SDGAButtonType.fab || _type == _SDGAButtonType.close
                      ? SDGAConstants.radius9999
                      : SDGANumbers.radiusSmall,
                ),
              ),
              child: ConstrainedBox(
                constraints: _getButtonConstraints(
                  type: _type,
                  size: size,
                  closeSize: closeSize,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _verticalPadding,
                    horizontal: _horizontalPadding,
                  ),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_type == _SDGAButtonType.close) {
      return icon ?? const SDGAIcon(SDGAIconsStroke.cancel01);
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            if (trailingIcon != null || child != null || icon != null)
              const SizedBox(width: _kGap),
          ],
          if (icon != null) ...[
            icon!,
            if (trailingIcon != null || child != null)
              const SizedBox(width: _kGap),
          ],
          if (child != null) child!,
          if (trailingIcon != null || _type == _SDGAButtonType.menu) ...[
            if (child != null) const SizedBox(width: _kGap),
            trailingIcon ?? const SDGAIcon(SDGAIconsStroke.arrowDown01),
          ],
        ],
      );
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case SDGAWidgetSize.small:
        return SDGATextStyles.textExtraSmallMedium;
      case SDGAWidgetSize.medium:
        return SDGATextStyles.textSmallMedium;
      case SDGAWidgetSize.large:
        return SDGATextStyles.textMediumMedium;
    }
  }

  double get _iconSize {
    if (_type == _SDGAButtonType.close) {
      switch (closeSize) {
        case SDGACloseButtonSize.xSmall:
          return 12;
        case SDGACloseButtonSize.small:
          return 16;
        case SDGACloseButtonSize.medium:
          return 20;
        case SDGACloseButtonSize.large:
          return 24;
      }
    } else {
      switch (size) {
        case SDGAWidgetSize.small:
          return _type == _SDGAButtonType.menu ? 12 : 16;
        case SDGAWidgetSize.medium:
          return _type == _SDGAButtonType.menu ? 16 : 20;
        case SDGAWidgetSize.large:
          return _type == _SDGAButtonType.menu ? 20 : 24;
      }
    }
  }

  bool get _removePadding {
    return (_type == _SDGAButtonType.close ||
        _type == _SDGAButtonType.icon ||
        _type == _SDGAButtonType.destructiveIcon ||
        (_type == _SDGAButtonType.fab && child == null));
  }

  double get _horizontalPadding {
    if (_removePadding) return 0;
    switch (size) {
      case SDGAWidgetSize.small:
        return SDGAConstants.spacing2;
      case SDGAWidgetSize.medium:
        return SDGAConstants.spacing2;
      case SDGAWidgetSize.large:
        return SDGAConstants.spacing4;
    }
  }

  double get _verticalPadding {
    if (_removePadding) return 0;
    switch (size) {
      case SDGAWidgetSize.small:
        return _type == _SDGAButtonType.menu ? 3 : 7;
      case SDGAWidgetSize.medium:
        return _type == _SDGAButtonType.menu ? 6 : 8;
      case SDGAWidgetSize.large:
        return _type == _SDGAButtonType.menu ? 8 : 10;
    }
  }
}
