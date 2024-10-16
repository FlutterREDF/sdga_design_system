import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

import 'toggleables.dart';

/// Taken from material and modified to follow our guidelines
class SDGACheckbox extends StatefulWidget {
  /// Creates a SDGA Design checkbox.
  ///
  /// {@template sdga.checkbox}
  /// The checkbox itself does not maintain any state. Instead, when the state of
  /// the checkbox changes, the widget calls the [onChanged] callback. Most
  /// widgets that use a checkbox will listen for the [onChanged] callback and
  /// rebuild the checkbox with a new [value] to update the visual appearance of
  /// the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  /// {@endtemplate}
  const SDGACheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.readonly = false,
    this.focusNode,
    this.autofocus = false,
    this.style = SDGAToggleableStyle.brand,
    this.size = SDGACheckBoxSize.medium,
    this.semanticLabel,
    this.disableRipple = false,
  })  : label = null,
        alertMessage = null,
        helperText = null,
        alertType = SDGAAlertType.error,
        assert(tristate || value != null);

  /// Creates a SDGA Design checkbox with a label and optional helper/alert messages.
  ///
  /// {@macro sdga.checkbox}
  const SDGACheckbox.layout({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.readonly = false,
    this.focusNode,
    this.autofocus = false,
    this.style = SDGAToggleableStyle.brand,
    this.size = SDGACheckBoxSize.medium,
    this.semanticLabel,
    required String this.label,
    this.helperText,
    this.alertMessage,
    this.alertType = SDGAAlertType.error,
    this.disableRipple = false,
  }) : assert(tristate || value != null);

  /// Whether this checkbox is checked.
  ///
  /// When [tristate] is true, a value of null corresponds to the mixed state.
  /// When [tristate] is false, this value must not be null.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox with the new
  /// style.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// When the checkbox is tapped, if [tristate] is false (the default) then
  /// the [onChanged] callback will be applied to `!value`. If [tristate] is
  /// true this callback cycle from false to true to null.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGACheckbox(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool?>? onChanged;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// [SDGACheckbox] displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Whether this is a read only checkbox or not
  ///
  /// The default is false.
  final bool readonly;

  /// The style for this radio button, whether to use brand colors or neutral colors
  ///
  /// The default is [SDGAToggleableStyle.brand]
  final SDGAToggleableStyle style;

  /// The size of this checkbox
  ///
  /// The default is [SDGACheckBoxSize.medium]
  final SDGACheckBoxSize size;

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

  /// The semantic label for the checkbox that will be announced by screen readers.
  ///
  /// This is announced in accessibility modes (e.g TalkBack/VoiceOver).
  ///
  /// This label does not show in the UI.
  final String? semanticLabel;

  /// Whether to disable the ripple or not.
  ///
  /// This is useful if the checkbox is above another widget.
  ///
  /// The default is false.
  final bool disableRipple;
  @override
  State<SDGACheckbox> createState() => _SDGACheckboxState();
}

class _SDGACheckboxState extends State<SDGACheckbox>
    with TickerProviderStateMixin, SDGAToggleableStateMixin {
  final _RadioPainter _painter = _RadioPainter();
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(SDGACheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
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
      widget.readonly ? null : widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool? get value => widget.value;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final WidgetStateProperty<MouseCursor> effectiveMouseCursor =
        WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
      return CheckboxTheme.of(context).mouseCursor?.resolve(states) ??
          WidgetStateProperty.resolveAs<MouseCursor>(
              WidgetStateMouseCursor.clickable, states);
    });

    Widget child = CustomPaint(
      size: Size.square(widget.size.size),
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
        ..isReadonly = widget.readonly
        ..value = value
        ..previousValue = _previousValue
        ..style = widget.style == SDGAToggleableStyle.brand
            ? _SDGACheckboxStyle.brand(
                colors: SDGAColorScheme.of(context),
                disableFocusBorder: widget.label != null,
                disableRipple: widget.disableRipple,
                size: widget.size,
              )
            : _SDGACheckboxStyle.neutral(
                colors: SDGAColorScheme.of(context),
                disableFocusBorder: widget.label != null,
                disableRipple: widget.disableRipple,
                size: widget.size,
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
        toggleableWidth: widget.size.size,
      );
    }
    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value ?? false,
      mixed: widget.tristate ? widget.value == null : null,
      child: buildSDGAToggleable(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: effectiveMouseCursor,
        child: child,
      ),
    );
  }
}

class _RadioPainter extends SDGAToggleablePainter<_SDGACheckboxStyle> {
  bool? get value => _value;
  bool? _value;
  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;
  bool? _previousValue;
  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final RRect roundedRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(SDGANumbers.radiusExtraSmall),
    );
    final Color borderColor = Color.lerp(
      isDisabled ? style.inactiveDisabledColor : style.inactiveBorderColor,
      isReadonly ? style.activeBorderDisabledColor : Colors.transparent,
      position.value,
    )!;
    Color color = Color.lerp(
        style.activeColor.withOpacity(0), style.activeColor, position.value)!;
    void lerp(Color active, double t) {
      final focusColor =
          Color.lerp(active.withOpacity(0), active, position.value)!;
      color = Color.lerp(color, focusColor, t)!;
    }

    if (isFocused) {
      lerp(style.activeFocusedColor, reactionFocusFade.value);
    }
    if (isHovered) {
      lerp(style.activeHoveredColor, reactionHoverFade.value);
    }
    if (isPressed) {
      lerp(style.activePressedColor, reaction.value);
    }
    if (isDisabled && !isReadonly) {
      lerp(style.activeDisabledColor, 1);
    }

    // Ripple
    if (style.rippleColor != null &&
        !reactionHoverFade.isDismissed &&
        !style.disableFocusBorder &&
        !isFocused) {
      canvas.drawCircle(
        (Offset.zero & size).center,
        ((size.width + 16) / 2) * reactionHoverFade.value,
        Paint()..color = style.rippleColor!,
      );
    }

    // Border
    canvas.drawRRect(
      roundedRect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Background
    if (!position.isDismissed && !isReadonly) {
      canvas.drawRRect(roundedRect, Paint()..color = color);
    }

    Paint iconPaint = Paint()
      ..color = isReadonly ? color : style.iconColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = style.iconStrokeWidth;
    double tNormalized;
    switch (position.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        tNormalized = position.value;
        break;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        tNormalized = 1.0 - position.value;
        break;
    }

    // Four cases: false to null, false to true, null to false, true to false
    if (previousValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      if (t > 0.5) {
        final double tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null) {
          canvas.drawPath(_getDash(tShrink, size), iconPaint);
        } else {
          canvas.drawPath(_getCheck(tShrink, size), iconPaint);
        }
      }
    } else {
      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue ?? false) {
          canvas.drawPath(_getCheck(tShrink, size), iconPaint);
        } else {
          canvas.drawPath(_getDash(tShrink, size), iconPaint);
        }
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value ?? false) {
          canvas.drawPath(_getCheck(tExpand, size), iconPaint);
        } else {
          canvas.drawPath(_getDash(tExpand, size), iconPaint);
        }
      }
    }

    // Press circle
    if (!reaction.isDismissed && position.isDismissed) {
      canvas.drawRRect(
          roundedRect, Paint()..color = style.inactivePressedBackgroundColor);
    }

    // Focus border
    if (isFocused && !style.disableFocusBorder) {
      canvas.drawRRect(
        roundedRect.inflate(4),
        Paint()
          ..color = style.focusBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  Path _getCheck(double t, Size size) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    const Offset start = Offset(7.5, 12);
    const Offset mid = Offset(10.11, 14.7);
    const Offset end = Offset(16.7, 8.4);
    final Path path = Path();
    final scaleBy = size.width / 24;

    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT)!;
      path.moveTo(start.dx * scaleBy, start.dy * scaleBy);
      path.lineTo(drawMid.dx * scaleBy, drawMid.dy * scaleBy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT)!;
      path.moveTo(start.dx * scaleBy, start.dy * scaleBy);
      path.lineTo(mid.dx * scaleBy, mid.dy * scaleBy);
      path.lineTo(drawEnd.dx * scaleBy, drawEnd.dy * scaleBy);
    }

    return path;
  }

  Path _getDash(double t, Size size) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    const Offset start = Offset(6.0, 12.0);
    const Offset mid = Offset(12.0, 12.0);
    const Offset end = Offset(18.0, 12.0);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final Offset drawEnd = Offset.lerp(mid, end, t)!;
    final Path path = Path();
    final scaleBy = size.width / 24;

    path.moveTo(drawStart.dx * scaleBy, drawStart.dy * scaleBy);
    path.lineTo(drawEnd.dx * scaleBy, drawEnd.dy * scaleBy);

    return path;
  }
}

class _SDGACheckboxStyle {
  final bool disableFocusBorder;
  final Color focusBorderColor;
  final Color activeColor;
  final Color activeHoveredColor;
  final Color activeFocusedColor;
  final Color activePressedColor;
  final Color inactivePressedBackgroundColor;
  final Color activeDisabledColor;
  final Color activeBorderDisabledColor;
  final Color inactiveDisabledColor;
  final Color iconColor;
  final Color? rippleColor;
  final Color inactiveBorderColor;
  final double iconStrokeWidth;

  _SDGACheckboxStyle({
    required this.disableFocusBorder,
    required this.focusBorderColor,
    required this.activeColor,
    required this.activeHoveredColor,
    required this.activeFocusedColor,
    required this.activePressedColor,
    required this.inactivePressedBackgroundColor,
    required this.activeDisabledColor,
    required this.activeBorderDisabledColor,
    required this.inactiveDisabledColor,
    required this.iconColor,
    required this.rippleColor,
    required this.inactiveBorderColor,
    required this.iconStrokeWidth,
  });

  factory _SDGACheckboxStyle.brand({
    required SDGAColorScheme colors,
    bool disableFocusBorder = false,
    bool disableRipple = false,
    SDGACheckBoxSize size = SDGACheckBoxSize.medium,
  }) {
    return _SDGACheckboxStyle(
      disableFocusBorder: disableFocusBorder,
      focusBorderColor: colors.borders.black,
      activeColor: colors.controls.primaryChecked,
      activeHoveredColor: colors.controls.primaryHovered,
      activeFocusedColor: colors.controls.primaryFocused,
      activePressedColor: colors.controls.primaryPressed,
      inactivePressedBackgroundColor: colors.controls.pressed,
      activeDisabledColor: colors.globals.borderDisabled,
      activeBorderDisabledColor: colors.globals.borderDisabled,
      inactiveDisabledColor: colors.globals.borderDisabled,
      iconColor: colors.icons.onColor,
      inactiveBorderColor: colors.controls.border,
      iconStrokeWidth: size == SDGACheckBoxSize.extraSmall ? 2 : 3,
      rippleColor: disableRipple ? null : colors.controls.rippleEffect,
    );
  }

  factory _SDGACheckboxStyle.neutral({
    required SDGAColorScheme colors,
    bool disableFocusBorder = false,
    bool disableRipple = false,
    SDGACheckBoxSize size = SDGACheckBoxSize.medium,
  }) {
    return _SDGACheckboxStyle(
      disableFocusBorder: disableFocusBorder,
      focusBorderColor: colors.borders.black,
      activeColor: colors.controls.neutralChecked,
      activeHoveredColor: colors.controls.neutralHovered,
      activeFocusedColor: colors.controls.neutralFocused,
      activePressedColor: colors.controls.neutralPressed,
      inactivePressedBackgroundColor: colors.controls.pressed,
      activeDisabledColor: colors.controls.disabled,
      activeBorderDisabledColor: colors.globals.borderDisabled,
      inactiveDisabledColor: colors.globals.borderDisabled,
      iconColor: colors.icons.onColor,
      inactiveBorderColor: colors.controls.border,
      iconStrokeWidth: size == SDGACheckBoxSize.extraSmall ? 2 : 3,
      rippleColor: disableRipple ? null : colors.controls.rippleEffect,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        disableFocusBorder,
        focusBorderColor,
        activeColor,
        activeHoveredColor,
        activeFocusedColor,
        activePressedColor,
        inactivePressedBackgroundColor,
        activeDisabledColor,
        activeBorderDisabledColor,
        inactiveDisabledColor,
        iconColor,
        rippleColor,
        inactiveBorderColor,
        iconStrokeWidth,
      ]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _SDGACheckboxStyle &&
            disableFocusBorder == other.disableFocusBorder &&
            focusBorderColor == other.focusBorderColor &&
            activeColor == other.activeColor &&
            activeHoveredColor == other.activeHoveredColor &&
            activeFocusedColor == other.activeFocusedColor &&
            activePressedColor == other.activePressedColor &&
            inactivePressedBackgroundColor ==
                other.inactivePressedBackgroundColor &&
            activeDisabledColor == other.activeDisabledColor &&
            activeBorderDisabledColor == other.activeBorderDisabledColor &&
            inactiveDisabledColor == other.inactiveDisabledColor &&
            iconColor == other.iconColor &&
            rippleColor == other.rippleColor &&
            inactiveBorderColor == other.inactiveBorderColor &&
            iconStrokeWidth == other.iconStrokeWidth;
  }
}
