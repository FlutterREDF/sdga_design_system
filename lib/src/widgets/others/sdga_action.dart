import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGAAction extends StatefulWidget {
  const SDGAAction({
    super.key,
    this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.onSecondaryTapUp,
    this.onSecondaryTapDown,
    this.onSecondaryTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
    this.selected,
    this.mouseCursor,
    this.statesController,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Called when the user taps this part of the material.
  final GestureTapCallback? onTap;

  /// Called when the user taps down this part of the material.
  final GestureTapDownCallback? onTapDown;

  /// Called when the user releases a tap that was started on this part of the
  /// material. [onTap] is called immediately after.
  final GestureTapUpCallback? onTapUp;

  /// Called when the user cancels a tap that was started on this part of the
  /// material.
  final GestureTapCallback? onTapCancel;

  /// Called when the user double taps this part of the material.
  final GestureTapCallback? onDoubleTap;

  /// Called when the user long-presses on this part of the material.
  final GestureLongPressCallback? onLongPress;

  /// Called when the user taps this part of the material with a secondary button.
  final GestureTapCallback? onSecondaryTap;

  /// Called when the user taps down on this part of the material with a
  /// secondary button.
  final GestureTapDownCallback? onSecondaryTapDown;

  /// Called when the user releases a secondary button tap that was started on
  /// this part of the material. [onSecondaryTap] is called immediately after.
  final GestureTapUpCallback? onSecondaryTapUp;

  /// Called when the user cancels a secondary button tap that was started on
  /// this part of the material.
  final GestureTapCallback? onSecondaryTapCancel;

  /// Called when this part of the material either becomes highlighted or stops
  /// being highlighted.
  ///
  /// The value passed to the callback is true if this part of the material has
  /// become highlighted and false if this part of the material has stopped
  /// being highlighted.
  ///
  /// If all of [onTap], [onDoubleTap], and [onLongPress] become null while a
  /// gesture is ongoing, then [onTapCancel] will be fired and
  /// [onHighlightChanged] will be fired with the value false _during the
  /// build_. This means, for instance, that in that scenario [State.setState]
  /// cannot be called.
  final ValueChanged<bool>? onHighlightChanged;

  /// Called when a pointer enters or exits the ink response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// The border radius of the containing rectangle.
  ///
  /// If this is null, it is interpreted as [BorderRadius.zero].
  final BorderRadiusGeometry? borderRadius;

  /// A list of shadows cast by the containing rectangle.
  final List<BoxShadow>? boxShadow;

  /// The border of the containing rectangle.
  final WidgetStateProperty<BoxBorder?>? border;

  // /// The border of the containing rectangle when it's focused.
  // final Border? focusedBorder;

  // /// The border of the containing rectangle when it's disabled.
  // final Border? disabledBorder;

  /// The background color based on different widget states.
  ///
  /// You can provide a `WidgetStateProperty` instance that maps each widget state to a specific [Color] value.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The text color based on different widget states.
  ///
  /// You can provide a `WidgetStateProperty` instance that maps each widget state to a specific [Color] value.
  final WidgetStateProperty<Color?>? textColor;

  /// The text style based on different widget states.
  ///
  /// You can provide a `WidgetStateProperty` instance that maps each widget state to a specific [TextStyle] value.
  final WidgetStateProperty<TextStyle?>? textStyle;

  // /// The background color of the widget.
  // final Color? color;

  // /// The background color of the widget when it's focused.
  // final Color? focusColor;

  // /// The background color of the widget when a pointer is hovering over it.
  // final Color? hoverColor;

  // /// The background color of the widget when pressed.
  // final Color? highlightColor;

  // /// The background color of the widget when it's disabled.
  // final Color? disabledColor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  /// Whether to exclude the gestures introduced by this widget from the
  /// semantics tree.
  ///
  /// For example, a long-press gesture for showing a tooltip is usually
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.canRequestFocus}
  final bool canRequestFocus;

  /// Whether this widget is selected or not
  final bool? selected;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [WidgetStateProperty<MouseCursor>],
  /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
  ///
  ///  * [WidgetState.hovered].
  ///  * [WidgetState.focused].
  ///  * [WidgetState.disabled].
  ///
  /// If this property is null, [WidgetStateMouseCursor.clickable] will be used.
  final MouseCursor? mouseCursor;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// The animation duration for the colors and borders when the [statesController]
  /// changes
  final Duration animationDuration;

  @override
  State<SDGAAction> createState() => _SDGAActionState();
}

class _SDGAActionState extends State<SDGAAction> {
  bool _hovering = false;
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activateOnIntent),
    ButtonActivateIntent:
        CallbackAction<ButtonActivateIntent>(onInvoke: _activateOnIntent),
  };
  WidgetStatesController? internalStatesController;

  static const Duration _activationDuration = Duration(milliseconds: 100);
  Timer? _activationTimer;

  void _updatePressed(bool value) {
    _activationTimer?.cancel();
    _activationTimer = null;
    if (value) {
      _statesController.update(WidgetState.pressed, true);
    } else {
      // Delay the call to `updateHighlight` to simulate a pressed delay
      // and give WidgetStatesController listeners a chance to react.
      _activationTimer = Timer(_activationDuration, () {
        _statesController.update(WidgetState.pressed, false);
      });
    }
  }

  void _activateOnIntent(Intent? intent) {
    _updatePressed(true);
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
    _updatePressed(false);
  }

  void _simulateTap([Intent? intent]) {
    _handleTap();
  }

  void _simulateLongPress() {
    _handleLongPress();
  }

  void _handleStatesControllerChange() {
    // Force a rebuild to resolve update the background color
    setState(() {});
  }

  WidgetStatesController get _statesController =>
      widget.statesController ?? internalStatesController!;

  void _initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = WidgetStatesController();
    }
    _statesController.update(WidgetState.disabled, !enabled);
    _statesController.update(WidgetState.selected, widget.selected ?? false);
    _statesController.addListener(_handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    _initStatesController();
  }

  @override
  void didUpdateWidget(SDGAAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(_handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      _initStatesController();
    }
    if (enabled != _isWidgetEnabled(oldWidget)) {
      
      _statesController.update(WidgetState.disabled, !enabled);
      if (!enabled) {
        _updatePressed(false);
      }
    }
    if (widget.selected != oldWidget.selected) {
      _statesController.update(WidgetState.selected, widget.selected ?? false);
    }
  }

  @override
  void dispose() {
    _statesController.removeListener(_handleStatesControllerChange);
    internalStatesController?.dispose();
    _activationTimer?.cancel();
    _activationTimer = null;
    super.dispose();
  }

  void _handleFocusUpdate(bool hasFocus) {
    _statesController.update(WidgetState.focused, hasFocus);
    widget.onFocusChange?.call(hasFocus);
  }

  void _handleAnyTapDown(TapDownDetails details) {
    _updatePressed(true);
    widget.onHighlightChanged?.call(true);
  }

  void _handleTapDown(TapDownDetails details) {
    _handleAnyTapDown(details);
    widget.onTapDown?.call(details);
  }

  void _handleTapUp(TapUpDetails details) {
    widget.onTapUp?.call(details);
  }

  void _handleSecondaryTapDown(TapDownDetails details) {
    _handleAnyTapDown(details);
    widget.onSecondaryTapDown?.call(details);
  }

  void _handleSecondaryTapUp(TapUpDetails details) {
    widget.onSecondaryTapUp?.call(details);
  }

  void _handleTap() {
    _updatePressed(false);
    widget.onHighlightChanged?.call(false);
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    widget.onTapCancel?.call();
    widget.onHighlightChanged?.call(false);
    _updatePressed(false);
  }

  void _handleDoubleTap() {
    _updatePressed(false);
    widget.onDoubleTap?.call();
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      widget.onLongPress!();
    }
  }

  void _handleSecondaryTap() {
    _updatePressed(false);
    widget.onSecondaryTap?.call();
  }

  void _handleSecondaryTapCancel() {
    widget.onSecondaryTapCancel?.call();
    _updatePressed(false);
  }

  bool _isWidgetEnabled(SDGAAction widget) {
    return _primaryButtonEnabled(widget) || _secondaryButtonEnabled(widget);
  }

  bool _primaryButtonEnabled(SDGAAction widget) {
    return widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null ||
        widget.onTapUp != null ||
        widget.onTapDown != null;
  }

  bool _secondaryButtonEnabled(SDGAAction widget) {
    return widget.onSecondaryTap != null ||
        widget.onSecondaryTapUp != null ||
        widget.onSecondaryTapDown != null;
  }

  bool get enabled => _isWidgetEnabled(widget);
  bool get _primaryEnabled => _primaryButtonEnabled(widget);
  bool get _secondaryEnabled => _secondaryButtonEnabled(widget);

  void _handleMouseEnter(PointerEnterEvent event) {
    _hovering = true;
    if (enabled) {
      _handleHoverChange();
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    _hovering = false;
    // If the exit occurs after we've been disabled, we still
    // want to take down the highlights and run widget.onHover.
    _handleHoverChange();
  }

  void _handleHoverChange() {
    _statesController.update(WidgetState.hovered, _hovering);
    widget.onHover?.call(_hovering);
  }

  bool get _canRequestFocus {
    switch (MediaQuery.maybeNavigationModeOf(context)) {
      case NavigationMode.traditional:
      case null:
        return enabled && widget.canRequestFocus;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MouseCursor effectiveMouseCursor =
        WidgetStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? WidgetStateMouseCursor.clickable,
      _statesController.value,
    );
    final textColor = widget.textColor?.resolve(_statesController.value);
    final textStyle = widget.textStyle?.resolve(_statesController.value);
    final color = widget.backgroundColor?.resolve(_statesController.value);
    final border = widget.border?.resolve(_statesController.value);
    final radius = widget.borderRadius;
    final shadows = widget.boxShadow;
    final BoxDecoration? decoration;
    if (color != null || border != null || radius != null) {
      decoration = BoxDecoration(
        color: color,
        border: border,
        borderRadius: radius,
        boxShadow: shadows,
      );
    } else {
      decoration = null;
    }
    final style = _StyleData(
      decoration: decoration,
      textColor: textColor,
      textStyle: textStyle,
    );

    return Actions(
      actions: _actionMap,
      child: Focus(
        focusNode: widget.focusNode,
        canRequestFocus: _canRequestFocus,
        onFocusChange: _handleFocusUpdate,
        autofocus: widget.autofocus,
        child: MouseRegion(
          cursor: effectiveMouseCursor,
          onEnter: _handleMouseEnter,
          onExit: _handleMouseExit,
          child: DefaultSelectionStyle.merge(
            mouseCursor: effectiveMouseCursor,
            child: Semantics(
              selected: widget.selected,
              onTap: widget.excludeFromSemantics || widget.onTap == null
                  ? null
                  : _simulateTap,
              onLongPress:
                  widget.excludeFromSemantics || widget.onLongPress == null
                      ? null
                      : _simulateLongPress,
              child: GestureDetector(
                onTapDown: _primaryEnabled ? _handleTapDown : null,
                onTapUp: _primaryEnabled ? _handleTapUp : null,
                onTap: _primaryEnabled ? _handleTap : null,
                onTapCancel: _primaryEnabled ? _handleTapCancel : null,
                onDoubleTap:
                    widget.onDoubleTap != null ? _handleDoubleTap : null,
                onLongPress:
                    widget.onLongPress != null ? _handleLongPress : null,
                onSecondaryTapDown:
                    _secondaryEnabled ? _handleSecondaryTapDown : null,
                onSecondaryTapUp:
                    _secondaryEnabled ? _handleSecondaryTapUp : null,
                onSecondaryTap: _secondaryEnabled ? _handleSecondaryTap : null,
                onSecondaryTapCancel:
                    _secondaryEnabled ? _handleSecondaryTapCancel : null,
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                child: SDGAAnimatedWidget<_StyleData?>(
                  value: style,
                  duration: widget.animationDuration,
                  lerp: (a, b, t) => _StyleData.lerp(a, b, t),
                  builder: (context, value, child) {
                    child ??= const SizedBox.shrink();
                    if (value == null) return child;
                    if (value.decoration != null) {
                      child = DecoratedBox(
                          decoration: value.decoration!, child: child);
                    }
                    if (value.textColor != null) {
                      child = IconTheme.merge(
                        data: IconThemeData(color: value.textColor),
                        child: child,
                      );
                    }
                    if (value.textStyle != null || value.textColor != null) {
                      TextStyle style = value.textStyle ?? const TextStyle();
                      if (value.textColor != null) {
                        style = style.copyWith(color: value.textColor);
                      }
                      child = DefaultTextStyle.merge(
                        style: style,
                        child: child,
                      );
                    }

                    return child;
                  },
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleData {
  final BoxDecoration? decoration;
  final Color? textColor;
  final TextStyle? textStyle;

  _StyleData({this.decoration, this.textColor, this.textStyle});

  _StyleData scale(double t) {
    return _StyleData(
      decoration: decoration?.scale(t),
      textColor: Color.lerp(null, textColor, t),
      textStyle: TextStyle.lerp(null, textStyle, t),
    );
  }

  static _StyleData? lerp(_StyleData? a, _StyleData? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return _StyleData(
      decoration: _lerpDecoration(a.decoration, b.decoration, t),
      textColor: Color.lerp(a.textColor, b.textColor, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  /// This is a copy of BoxDecoration.lerp with handle to [SDGADoubleBorder]
  static BoxDecoration? _lerpDecoration(
      BoxDecoration? a, BoxDecoration? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return BoxDecoration(
        color: Color.lerp(null, b!.color, t),
        image: DecorationImage.lerp(null, b.image, t),
        border: SDGACustomBorder.lerp(null, b.border, t),
        borderRadius: BorderRadiusGeometry.lerp(null, b.borderRadius, t),
        boxShadow: BoxShadow.lerpList(null, b.boxShadow, t),
        gradient: b.gradient?.scale(t),
        shape: b.shape,
      );
    }
    if (b == null) {
      t = 1.0 - t;
      return BoxDecoration(
        color: Color.lerp(null, a.color, t),
        image: DecorationImage.lerp(null, a.image, t),
        border: SDGACustomBorder.lerp(null, a.border, t),
        borderRadius: BorderRadiusGeometry.lerp(null, a.borderRadius, t),
        boxShadow: BoxShadow.lerpList(null, a.boxShadow, t),
        gradient: a.gradient?.scale(t),
        shape: a.shape,
      );
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return BoxDecoration(
      color: Color.lerp(a.color, b.color, t),
      image: DecorationImage.lerp(a.image, b.image, t),
      border: SDGACustomBorder.lerp(a.border, b.border, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }
}
