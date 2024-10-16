import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

import 'toggleables.dart';

const double _kRippleRadius = 24.0;
const double _kOuterRadius = 12.0;
const double _kInnerRadius = 7.5;

/// Taken from material and modified to follow our guidelines
class SDGARadio<T> extends StatefulWidget {
  /// Creates a SDGA Design radio button.
  ///
  /// {@template sdga.radio}
  /// The radio button itself does not maintain any state. Instead, when the
  /// radio button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio button with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  /// {@endtemplate}
  const SDGARadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.readonly = false,
    this.toggleable = false,
    this.focusNode,
    this.autofocus = false,
    this.style = SDGAToggleableStyle.brand,
  })  : label = null,
        alertMessage = null,
        helperText = null,
        alertType = SDGAAlertType.error;

  /// Creates a SDGA Design radio button with a label and optional helper/alert messages.
  ///
  /// {@macro sdga.radio}
  const SDGARadio.layout({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.readonly = false,
    this.toggleable = false,
    this.focusNode,
    this.autofocus = false,
    this.style = SDGAToggleableStyle.brand,
    required String this.label,
    this.helperText,
    this.alertMessage,
    this.alertType = SDGAAlertType.error,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGARadio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter? newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// Set to true if this radio button is allowed to be returned to an
  /// indeterminate state by selecting it again when selected.
  ///
  /// To indicate returning to an indeterminate state, [onChanged] will be
  /// called with null.
  ///
  /// If true, [onChanged] can be called with [value] when selected while
  /// [groupValue] != [value], or with null when selected again while
  /// [groupValue] == [value].
  ///
  /// If false, [onChanged] will be called with [value] when it is selected
  /// while [groupValue] != [value], and only by selecting another radio button
  /// in the group (i.e. changing the value of [groupValue]) can this radio
  /// button be unselected.
  ///
  /// The default is false.
  final bool toggleable;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Whether this is a read only radio or not, this is only reflected
  /// when the [style] is set to [SDGAToggleableStyle.brand] it will draw
  /// the inner circle as green instead of the disabled color
  ///
  /// The default is false.
  final bool readonly;

  /// The style for this radio button, whether to use brand colors or neutral colors
  ///
  /// The default is [SDGAToggleableStyle.brand]
  final SDGAToggleableStyle style;

  /// This is the text associated with a radio input that provides context
  /// or describes the option being selected or deselected.
  final String? label;

  /// Additional information provided to assist users in understanding the
  /// purpose or implications of selecting the radio.
  final String? helperText;

  /// A notification that appears when a user interacts with the radio
  /// in a way that triggers a specific condition or action.
  final String? alertMessage;

  /// The type of alert associated with the radio, which determines the
  /// color and style of the alert.
  final SDGAAlertType alertType;

  bool get _selected => value == groupValue;

  @override
  State<SDGARadio<T>> createState() => _SDGARadioState<T>();
}

class _SDGARadioState<T> extends State<SDGARadio<T>>
    with TickerProviderStateMixin, SDGAToggleableStateMixin {
  final _RadioPainter _painter = _RadioPainter();

  void _handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);
      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(SDGARadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selected != oldWidget._selected) {
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null && !widget.readonly ? _handleChanged : null;

  @override
  bool get tristate => widget.toggleable;

  @override
  bool? get value => widget._selected;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
      return RadioTheme.of(context).mouseCursor?.resolve(states) ??
          WidgetStateProperty.resolveAs<MouseCursor>(
              WidgetStateMouseCursor.clickable, states);
    });

    final bool? accessibilitySelected;
    // Apple devices also use `selected` to annotate radio button's semantics
    // state.
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        accessibilitySelected = widget._selected;
        break;
      default:
        accessibilitySelected = null;
    }

    Widget child = CustomPaint(
      size: const Size.square(32),
      painter: _painter
        ..position = position
        ..reaction = reaction
        ..reactionFocusFade = reactionFocusFade
        ..reactionHoverFade = reactionHoverFade
        ..isPressed =  states.contains(WidgetState.pressed)
        ..isFocused = states.contains(WidgetState.focused)
        ..isHovered = states.contains(WidgetState.hovered)
        ..isActive = states.contains(WidgetState.selected)
        ..isDisabled = states.contains(WidgetState.disabled)
        ..isReadonly = widget.readonly
        ..style = widget.style == SDGAToggleableStyle.brand
            ? _SDGARadioStyle.brand(
                colors: SDGAColorScheme.of(context),
                disableFocusBorder: widget.label != null,
              )
            : _SDGARadioStyle.neutral(
                colors: SDGAColorScheme.of(context),
                disableFocusBorder: widget.label != null,
              ),
    );

    if (widget.label != null) {
      child = SDGAToggleableLayout(
        toggleable: child,
        label: widget.label!,
        helperText: widget.helperText,
        alertMessage: widget.alertMessage,
        alertType: widget.alertType,
        states: states,
      );
    }
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget._selected,
      selected: accessibilitySelected,
      child: buildSDGAToggleable(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: effectiveMouseCursor,
        child: child,
      ),
    );
  }
}

class _RadioPainter extends SDGAToggleablePainter<_SDGARadioStyle> {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    Color color =
        Color.lerp(style.inactiveColor, style.activeColor, position.value)!;
    if (isFocused) {
      final focusColor = Color.lerp(
          style.inactiveColor, style.activeFocusedColor, position.value)!;
      color = Color.lerp(color, focusColor, reactionFocusFade.value)!;
    }
    if (isHovered) {
      final hoverColor = Color.lerp(
          style.inactiveColor, style.activeHoveredColor, position.value)!;
      color = Color.lerp(color, hoverColor, reactionHoverFade.value)!;
    }
    if (isPressed) {
      final pressedColor = Color.lerp(
          style.inactiveColor, style.activePressedColor, position.value)!;
      color = Color.lerp(color, pressedColor, reaction.value)!;
    }
    if (isDisabled) {
      final disabledColor = Color.lerp(style.inactiveDisabledColor,
          style.activeDisabledColor, position.value)!;
      color = disabledColor;
    }

    // Ripple
    if (!reactionHoverFade.isDismissed &&
        (!style.disableFocusBorder || !isFocused)) {
      canvas.drawCircle(center, _kRippleRadius * reactionHoverFade.value,
          Paint()..color = style.rippleColor);
    }

    // Outer circle
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, _kOuterRadius, paint);
    if (isReadonly && style.activeReadonlyColor != null) {
      paint.color = style.activeReadonlyColor!;
    }

    // Inner circle
    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, _kInnerRadius * position.value, paint);
    }

    // Press circle
    if (!reaction.isDismissed && position.isDismissed) {
      canvas.drawCircle(center, _kOuterRadius,
          Paint()..color = style.inactivePressedBackgroundColor);
    }

    // Focus border
    if (isFocused && !style.disableFocusBorder) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size),
          const Radius.circular(SDGANumbers.radiusExtraSmall),
        ),
        Paint()
          ..color = style.focusBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }
}

class _SDGARadioStyle {
  final bool disableFocusBorder;
  final Color focusBorderColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeHoveredColor;
  final Color activeFocusedColor;
  final Color activePressedColor;
  final Color inactivePressedBackgroundColor;
  final Color activeDisabledColor;
  final Color activeBorderDisabledColor;
  final Color inactiveDisabledColor;
  final Color rippleColor;
  final Color? activeReadonlyColor;

  _SDGARadioStyle({
    required this.disableFocusBorder,
    required this.focusBorderColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeHoveredColor,
    required this.activeFocusedColor,
    required this.activePressedColor,
    required this.inactivePressedBackgroundColor,
    required this.activeDisabledColor,
    required this.activeBorderDisabledColor,
    required this.inactiveDisabledColor,
    required this.rippleColor,
    this.activeReadonlyColor,
  });

  factory _SDGARadioStyle.brand({
    required SDGAColorScheme colors,
    bool disableFocusBorder = false,
  }) {
    return _SDGARadioStyle(
      disableFocusBorder: disableFocusBorder,
      focusBorderColor: colors.borders.black,
      activeColor: colors.controls.primaryChecked,
      inactiveColor: colors.controls.border,
      activeHoveredColor: colors.controls.primaryHovered,
      activeFocusedColor: colors.controls.primaryFocused,
      activePressedColor: colors.controls.primaryPressed,
      inactivePressedBackgroundColor: colors.controls.pressed,
      activeDisabledColor: colors.globals.borderDisabled,
      activeBorderDisabledColor: colors.globals.borderDisabled,
      inactiveDisabledColor: colors.globals.borderDisabled,
      rippleColor: colors.controls.rippleEffect,
      activeReadonlyColor: colors.controls.primaryChecked,
    );
  }

  factory _SDGARadioStyle.neutral({
    required SDGAColorScheme colors,
    bool disableFocusBorder = false,
  }) {
    return _SDGARadioStyle(
      disableFocusBorder: disableFocusBorder,
      focusBorderColor: colors.borders.black,
      activeColor: colors.controls.neutralChecked,
      inactiveColor: colors.controls.border,
      activeHoveredColor: colors.controls.neutralHovered,
      activeFocusedColor: colors.controls.neutralFocused,
      activePressedColor: colors.controls.neutralPressed,
      inactivePressedBackgroundColor: colors.controls.pressed,
      activeDisabledColor: colors.controls.disabled,
      activeBorderDisabledColor: colors.globals.borderDisabled,
      inactiveDisabledColor: colors.globals.borderDisabled,
      rippleColor: colors.controls.rippleEffect,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        disableFocusBorder,
        focusBorderColor,
        activeColor,
        inactiveColor,
        activeHoveredColor,
        activeFocusedColor,
        activePressedColor,
        inactivePressedBackgroundColor,
        activeDisabledColor,
        activeBorderDisabledColor,
        inactiveDisabledColor,
        rippleColor,
      ]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _SDGARadioStyle &&
            disableFocusBorder == other.disableFocusBorder &&
            focusBorderColor == other.focusBorderColor &&
            activeColor == other.activeColor &&
            inactiveColor == other.inactiveColor &&
            activeHoveredColor == other.activeHoveredColor &&
            activeFocusedColor == other.activeFocusedColor &&
            activePressedColor == other.activePressedColor &&
            inactivePressedBackgroundColor ==
                other.inactivePressedBackgroundColor &&
            activeDisabledColor == other.activeDisabledColor &&
            activeBorderDisabledColor == other.activeBorderDisabledColor &&
            inactiveDisabledColor == other.inactiveDisabledColor &&
            rippleColor == other.rippleColor;
  }
}
