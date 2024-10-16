import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

import 'toggleables.dart';

const double _kThumbRadius = 14.0;

/// Taken from material and modified to follow our guidelines
class SDGASwitch extends StatefulWidget {
  /// Creates a SDGA Design switch.
  ///
  /// {@template sdga.switch}
  /// The switch itself does not maintain any state. Instead, when the state of
  /// the switch changes, the widget calls the [onChanged] callback. Most widgets
  /// that use a switch will listen for the [onChanged] callback and rebuild the
  /// switch with a new [value] to update the visual appearance of the switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onChanged] is called when the user toggles the switch on or off.
  /// {@endtemplate}
  const SDGASwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.autofocus = false,
  })  : label = null,
        alertMessage = null,
        helperText = null,
        trailSwitch = false,
        alertType = SDGAAlertType.error;

  /// Creates a SDGA Design switch with a label and optional helper/alert messages.
  ///
  /// {@macro sdga.switch}
  const SDGASwitch.layout({
    super.key,
    required this.value,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.autofocus = false,
    required String this.label,
    this.helperText,
    this.alertMessage,
    this.alertType = SDGAAlertType.error,
    this.trailSwitch = false,
  });

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// style.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGASwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// This is the text associated with a switch input that provides context
  /// or describes the option being selected or deselected.
  final String? label;

  /// Additional information provided to assist users in understanding the
  /// purpose or implications of toggling the switch.
  final String? helperText;

  /// A notification that appears when a user interacts with the radio
  /// in a way that triggers a specific condition or action.
  final String? alertMessage;

  /// The type of alert associated with the switch, which determines the
  /// color and style of the alert.
  final SDGAAlertType alertType;

  /// Whether to place the switch after the label or not
  ///
  /// The default is false
  final bool trailSwitch;

  @override
  State<SDGASwitch> createState() => _SDGASwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
  }
}

class _SDGASwitchState extends State<SDGASwitch>
    with TickerProviderStateMixin, SDGAToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged?.call(value!);
  }

  @override
  void didUpdateWidget(SDGASwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      animateToValue();
    }
  }

  @override
  void initState() {
    super.initState();
    reactionController.duration = const Duration(milliseconds: 300);
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / 24;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value += -delta;
          break;
        case TextDirection.ltr:
          positionController.value += delta;
          break;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged?.call(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
      return SwitchTheme.of(context).mouseCursor?.resolve(states) ??
          WidgetStateProperty.resolveAs<MouseCursor>(
              WidgetStateMouseCursor.clickable, states);
    });

    Widget child = GestureDetector(
      excludeFromSemantics: true,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      dragStartBehavior: widget.dragStartBehavior,
      child: CustomPaint(
        size: const Size(52, 32),
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..isPressed = states.contains(WidgetState.pressed)
          ..isFocused = states.contains(WidgetState.focused)
          ..isHovered = states.contains(WidgetState.hovered)
          ..isActive = states.contains(WidgetState.selected)
          ..isDisabled = states.contains(WidgetState.disabled)
          ..textDirection = Directionality.of(context)
          ..style = _SDGASwitchStyle(
            colors: SDGAColorScheme.of(context),
            disableFocusBorder: widget.label != null,
          ),
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
        toggleableWidth: 52,
        trailToggleable: widget.trailSwitch,
      );
    }
    return Semantics(
      toggled: widget.value,
      child: buildSDGAToggleable(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: effectiveMouseCursor,
        child: child,
      ),
    );
  }
}

class _SwitchPainter extends SDGAToggleablePainter<_SDGASwitchStyle> {
  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    notifyListeners();
  }

  Color _lerpByPosition(Color a, Color b) => Color.lerp(a, b, position.value)!;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect roundedRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(SDGANumbers.radiusFull),
    );
    final double currentValue = position.value;
    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    Color color =
        _lerpByPosition(style.activeColor.withOpacity(0), style.activeColor);
    Color outlineColor = _lerpByPosition(
        style.inactiveColor, style.inactiveColor.withOpacity(0));
    Color thumbColor =
        _lerpByPosition(style.inactiveColor, style.activeThumbColor);
    void lerp(Color active, Color inactive, double t) {
      final newColor = _lerpByPosition(active.withOpacity(0), active);
      final newThumbColor = _lerpByPosition(inactive, style.activeThumbColor);
      final newOutlineColor =
          _lerpByPosition(inactive, inactive.withOpacity(0));
      color = Color.lerp(color, newColor, t)!;
      thumbColor = Color.lerp(thumbColor, newThumbColor, t)!;
      outlineColor = Color.lerp(outlineColor, newOutlineColor, t)!;
    }

    if (isFocused) {
      lerp(style.activeFocusedColor, style.inactiveFocusedColor,
          reactionFocusFade.value);
    }
    if (isHovered) {
      lerp(style.activeHoveredColor, style.inactiveHoveredColor,
          reactionHoverFade.value);
    }
    if (isPressed) {
      lerp(
          style.activePressedColor, style.inactivePressedColor, reaction.value);
    }
    if (isDisabled) {
      lerp(style.activeDisabledColor, style.inactiveDisabledColor, 1);
    }

    // Ripple
    if (!reactionHoverFade.isDismissed &&
        (!style.disableFocusBorder || !isFocused)) {
      canvas.drawRRect(
          roundedRect.inflate(4), Paint()..color = style.rippleColor);
    }

    // Outline
    canvas.drawRRect(
      roundedRect,
      Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    // Fill color
    canvas.drawRRect(roundedRect, Paint()..color = color);

    // Thumb
    canvas.drawCircle(
      Offset(
        lerpDouble(
          _kThumbRadius + 2,
          size.width - _kThumbRadius - 2,
          visualPosition,
        )!,
        size.height / 2,
      ),
      _kThumbRadius,
      Paint()..color = thumbColor,
    );
    // }

    // Focus border
    if (isFocused && !style.disableFocusBorder) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.inflate(4),
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

class _SDGASwitchStyle {
  final bool disableFocusBorder;
  final Color focusBorderColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeHoveredColor;
  final Color inactiveHoveredColor;
  final Color activeFocusedColor;
  final Color inactiveFocusedColor;
  final Color activePressedColor;
  final Color inactivePressedColor;
  final Color activeDisabledColor;
  final Color inactiveDisabledColor;
  final Color activeThumbColor;
  final Color rippleColor;

  _SDGASwitchStyle({
    required SDGAColorScheme colors,
    this.disableFocusBorder = false,
  })  : focusBorderColor = colors.borders.black,
        activeColor = colors.controls.primaryChecked,
        inactiveColor = colors.controls.neutralChecked,
        activeHoveredColor = colors.controls.primaryHovered,
        inactiveHoveredColor = colors.controls.neutralHovered,
        activeFocusedColor = colors.controls.primaryFocused,
        inactiveFocusedColor = colors.controls.neutralFocused,
        activePressedColor = colors.controls.primaryPressed,
        inactivePressedColor = colors.controls.neutralPressed,
        activeDisabledColor = colors.globals.backgroundDisabledPrimary,
        inactiveDisabledColor = colors.globals.backgroundDisabled,
        activeThumbColor = colors.backgrounds.surfaceOnColor,
        rippleColor = colors.controls.rippleEffect;

  @override
  int get hashCode => Object.hashAll([
        disableFocusBorder,
        focusBorderColor,
        activeColor,
        inactiveColor,
        activeHoveredColor,
        inactiveHoveredColor,
        activeFocusedColor,
        inactiveFocusedColor,
        activePressedColor,
        inactivePressedColor,
        activeDisabledColor,
        inactiveDisabledColor,
        activeThumbColor,
        rippleColor,
      ]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _SDGASwitchStyle &&
            disableFocusBorder == other.disableFocusBorder &&
            focusBorderColor == other.focusBorderColor &&
            activeColor == other.activeColor &&
            inactiveColor == other.inactiveColor &&
            activeHoveredColor == other.activeHoveredColor &&
            inactiveHoveredColor == other.inactiveHoveredColor &&
            activeFocusedColor == other.activeFocusedColor &&
            inactiveFocusedColor == other.inactiveFocusedColor &&
            activePressedColor == other.activePressedColor &&
            inactivePressedColor == other.inactivePressedColor &&
            activeDisabledColor == other.activeDisabledColor &&
            inactiveDisabledColor == other.inactiveDisabledColor &&
            activeThumbColor == other.activeThumbColor &&
            rippleColor == other.rippleColor;
  }
}
