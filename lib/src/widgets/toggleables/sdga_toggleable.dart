// This is the a copy of the flutter's toggleable.dart file with some modifications
// to meet our needs like the press state when pressing the toggleable

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Duration of the animation that moves the toggle from one state to another.
const Duration _kToggleDuration = Duration(milliseconds: 200);

// Duration of the fade animation for the reaction when focus and hover occur.
const Duration _kReactionFadeDuration = Duration(milliseconds: 50);

/// A mixin for [StatefulWidget]s that implement toggleable
/// controls with toggle animations (e.g. [Switch]es, [CupertinoSwitch]es,
/// [Checkbox]es, [CupertinoCheckbox]es, [Radio]s, and [CupertinoRadio]s).
///
/// The mixin implements the logic for toggling the control (e.g. when tapped)
/// and provides a series of animation controllers to transition the control
/// from one state to another. It does not have any opinion about the visual
/// representation of the toggleable widget. The visuals are defined by a
/// [CustomPainter] passed to the [buildSDGAToggleable]. [State] objects using this
/// mixin should call that method from their [build] method.
@optionalTypeArgs
mixin SDGAToggleableStateMixin<S extends StatefulWidget>
    on TickerProviderStateMixin<S> {
  /// Used by subclasses to manipulate the visual value of the control.
  ///
  /// Some controls respond to user input by updating their visual value. For
  /// example, the thumb of a switch moves from one position to another when
  /// dragged. These controls manipulate this animation controller to update
  /// their [position] and eventually trigger an [onChanged] callback when the
  /// animation reaches either 0.0 or 1.0.
  AnimationController get positionController => _positionController;
  late AnimationController _positionController;

  /// The visual value of the control.
  ///
  /// When the control is inactive, the [value] is false and this animation has
  /// the value 0.0. When the control is active, the value is either true or
  /// tristate is true and the value is null. When the control is active the
  /// animation has a value of 1.0. When the control is changing from inactive
  /// to active (or vice versa), [value] is the target value and this animation
  /// gradually updates from 0.0 to 1.0 (or vice versa).
  CurvedAnimation get position => _position;
  late CurvedAnimation _position;

  /// Used by subclasses to control the radial reaction animation.
  ///
  /// Some controls have a radial ink reaction to user input. This animation
  /// controller can be used to start or stop these ink reactions.
  ///
  /// To paint the actual radial reaction, [SDGAToggleablePainter.paintRadialReaction]
  /// may be used.
  AnimationController get reactionController => _reactionController;
  late AnimationController _reactionController;

  /// The visual value of the radial reaction animation.
  ///
  /// Some controls have a radial ink reaction to user input. This animation
  /// controls the progress of these ink reactions.
  ///
  /// To paint the actual radial reaction, [SDGAToggleablePainter.paintRadialReaction]
  /// may be used.
  CurvedAnimation get reaction => _reaction;
  late CurvedAnimation _reaction;

  /// Controls the radial reaction's opacity animation for hover changes.
  ///
  /// Some controls have a radial ink reaction to pointer hover. This animation
  /// controls these ink reaction fade-ins and
  /// fade-outs.
  ///
  /// To paint the actual radial reaction, [SDGAToggleablePainter.paintRadialReaction]
  /// may be used.
  CurvedAnimation get reactionHoverFade => _reactionHoverFade;
  late CurvedAnimation _reactionHoverFade;
  late AnimationController _reactionHoverFadeController;

  /// Controls the radial reaction's opacity animation for focus changes.
  ///
  /// Some controls have a radial ink reaction to focus. This animation
  /// controls these ink reaction fade-ins and fade-outs.
  ///
  /// To paint the actual radial reaction, [SDGAToggleablePainter.paintRadialReaction]
  /// may be used.
  CurvedAnimation get reactionFocusFade => _reactionFocusFade;
  late CurvedAnimation _reactionFocusFade;
  late AnimationController _reactionFocusFadeController;

  /// The amount of time a circular ink response should take to expand to its
  /// full size if a radial reaction is drawn using
  /// [SDGAToggleablePainter.paintRadialReaction].
  Duration? get reactionAnimationDuration => _reactionAnimationDuration;
  final Duration _reactionAnimationDuration = const Duration(milliseconds: 100);

  /// Whether [value] of this control can be changed by user interaction.
  ///
  /// The control is considered interactive if the [onChanged] callback is
  /// non-null. If the callback is null, then the control is disabled, and
  /// non-interactive. A disabled checkbox, for example, is displayed using a
  /// grey color and its value cannot be changed.
  bool get isInteractive => onChanged != null;

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  /// Called when the control changes value.
  ///
  /// If the control is tapped, [onChanged] is called immediately with the new
  /// value.
  ///
  /// The control is considered interactive (see [isInteractive]) if this
  /// callback is non-null. If the callback is null, then the control is
  /// disabled, and non-interactive. A disabled checkbox, for example, is
  /// displayed using a grey color and its value cannot be changed.
  ValueChanged<bool?>? get onChanged;

  /// False if this control is "inactive" (not checked, off, or unselected).
  ///
  /// If value is true then the control "active" (checked, on, or selected). If
  /// tristate is true and value is null, then the control is considered to be
  /// in its third or "indeterminate" state.
  ///
  /// When the value changes, this object starts the [positionController] and
  /// [position] animations to animate the visual appearance of the control to
  /// the new value.
  bool? get value;

  /// If true, [value] can be true, false, or null, otherwise [value] must
  /// be true or false.
  ///
  /// When [tristate] is true and [value] is null, then the control is
  /// considered to be in its third or "indeterminate" state.
  bool get tristate;

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: value == false ? 0.0 : 1.0,
      vsync: this,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    _reactionController = AnimationController(
      duration: _reactionAnimationDuration,
      vsync: this,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.fastOutSlowIn,
    );
    _reactionHoverFadeController = AnimationController(
      duration: _kReactionFadeDuration,
      value: _hovering || _focused ? 1.0 : 0.0,
      vsync: this,
    );
    _reactionHoverFade = CurvedAnimation(
      parent: _reactionHoverFadeController,
      curve: Curves.fastOutSlowIn,
    );
    _reactionFocusFadeController = AnimationController(
      duration: _kReactionFadeDuration,
      value: _hovering || _focused ? 1.0 : 0.0,
      vsync: this,
    );
    _reactionFocusFade = CurvedAnimation(
      parent: _reactionFocusFadeController,
      curve: Curves.fastOutSlowIn,
    );
  }

  /// Runs the [position] animation to transition the SDGAToggleable's appearance
  /// to match [value].
  ///
  /// This method must be called whenever [value] changes to ensure that the
  /// visual representation of the SDGAToggleable matches the current [value].
  void animateToValue() {
    if (tristate) {
      if (value == null) {
        _positionController.value = 0.0;
      }
      if (value ?? true) {
        _positionController.forward();
      } else {
        _positionController.reverse();
      }
    } else {
      if (value ?? false) {
        _positionController.forward();
      } else {
        _positionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _position.dispose();
    _reactionController.dispose();
    _reaction.dispose();
    _reactionHoverFadeController.dispose();
    _reactionHoverFade.dispose();
    _reactionFocusFadeController.dispose();
    _reactionFocusFade.dispose();
    super.dispose();
  }

  /// The most recent [Offset] at which a pointer touched the SDGAToggleable.
  ///
  /// This is null if currently no pointer is touching the SDGAToggleable or if
  /// [isInteractive] is false.
  Offset? get downPosition => _downPosition;
  Offset? _downPosition;

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      setState(() {
        _downPosition = details.localPosition;
      });
      _reactionController.forward();
    }
  }

  void _handleTap([Intent? _]) {
    if (!isInteractive) {
      return;
    }
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
  }

  void _handleTapEnd([TapUpDetails? _]) {
    if (_downPosition != null) {
      setState(() {
        _downPosition = null;
      });
    }
    _reactionController.reverse();
  }

  bool _focused = false;
  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      setState(() {
        _focused = focused;
      });
      if (focused) {
        _reactionFocusFadeController.forward();
      } else {
        _reactionFocusFadeController.reverse();
      }
    }
  }

  bool _hovering = false;
  void _handleHoverChanged(bool hovering) {
    if (hovering != _hovering) {
      setState(() {
        _hovering = hovering;
      });
      if (hovering) {
        _reactionHoverFadeController.forward();
      } else {
        _reactionHoverFadeController.reverse();
      }
    }
  }

  /// Describes the current [WidgetState] of the SDGAToggleable.
  ///
  /// The returned set will include:
  ///
  ///  * [WidgetState.disabled], if [isInteractive] is false
  ///  * [WidgetState.hovered], if a pointer is hovering over the SDGAToggleable
  ///  * [WidgetState.focused], if the SDGAToggleable has input focus
  ///  * [WidgetState.selected], if [value] is true or null
  Set<WidgetState> get states => <WidgetState>{
        if (!isInteractive) WidgetState.disabled,
        if (_downPosition != null) WidgetState.pressed,
        if (_hovering) WidgetState.hovered,
        if (_focused) WidgetState.focused,
        if (value ?? true) WidgetState.selected,
      };

  /// Typically wraps a `painter` that draws the actual visuals of the
  /// SDGAToggleable with logic to toggle it.
  ///
  /// If drawing a radial ink reaction is desired (in Material Design for
  /// example), consider providing a subclass of [SDGAToggleablePainter] as a
  /// `painter`, which implements logic to draw a radial ink reaction for this
  /// control. The painter is usually configured with the [reaction],
  /// [position], [reactionHoverFade], and [reactionFocusFade] animation
  /// provided by this mixin. It is expected to draw the visuals of the
  /// SDGAToggleable based on the current value of these animations. The animations
  /// are triggered by this mixin to transition the SDGAToggleable from one state
  /// to another.
  ///
  /// Material SDGAToggleables must provide a [mouseCursor] which resolves to a
  /// [MouseCursor] based on the current [WidgetState] of the SDGAToggleable.
  /// Cupertino SDGAToggleables may not provide a [mouseCursor]. If no [mouseCursor]
  /// is provided, [SystemMouseCursors.basic] will be used as the [mouseCursor]
  /// across all [WidgetState]s.
  ///
  /// This method must be called from the [build] method of the [State] class
  /// that uses this mixin. The returned [Widget] must be returned from the
  /// build method - potentially after wrapping it in other widgets.
  Widget buildSDGAToggleable({
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    WidgetStateProperty<MouseCursor>? mouseCursor,
    required Widget child,
  }) {
    return FocusableActionDetector(
      actions: _actionMap,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      enabled: isInteractive,
      onShowFocusHighlight: _handleFocusHighlightChanged,
      onShowHoverHighlight: _handleHoverChanged,
      mouseCursor: mouseCursor?.resolve(states) ?? SystemMouseCursors.basic,
      child: GestureDetector(
        excludeFromSemantics: !isInteractive,
        onTapDown: isInteractive ? _handleTapDown : null,
        onTap: isInteractive ? _handleTap : null,
        onTapUp: isInteractive ? _handleTapEnd : null,
        onTapCancel: isInteractive ? _handleTapEnd : null,
        child: Semantics(
          enabled: isInteractive,
          child: child,
        ),
      ),
    );
  }
}

/// A base class for a [CustomPainter] that may be passed to
/// [SDGAToggleableStateMixin.buildSDGAToggleable] to draw the visual representation of
/// a SDGAToggleable.
///
/// Subclasses must implement the [paint] method to draw the actual visuals of
/// the SDGAToggleable.
///
/// If drawing a radial ink reaction is desired (in Material
/// Design for example), subclasses may call [paintRadialReaction] in their
/// [paint] method.
abstract class SDGAToggleablePainter<T> extends ChangeNotifier
    implements CustomPainter {
  /// The visual value of the control.
  ///
  /// Usually set to [SDGAToggleableStateMixin.position].
  Animation<double> get position => _position!;
  Animation<double>? _position;
  set position(Animation<double> value) {
    if (value == _position) {
      return;
    }
    _position?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _position = value;
    notifyListeners();
  }

  /// The visual value of the radial reaction animation.
  ///
  /// Usually set to [SDGAToggleableStateMixin.reaction].
  Animation<double> get reaction => _reaction!;
  Animation<double>? _reaction;
  set reaction(Animation<double> value) {
    if (value == _reaction) {
      return;
    }
    _reaction?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _reaction = value;
    notifyListeners();
  }

  /// Controls the radial reaction's opacity animation for focus changes.
  ///
  /// Usually set to [SDGAToggleableStateMixin.reactionFocusFade].
  Animation<double> get reactionFocusFade => _reactionFocusFade!;
  Animation<double>? _reactionFocusFade;
  set reactionFocusFade(Animation<double> value) {
    if (value == _reactionFocusFade) {
      return;
    }
    _reactionFocusFade?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _reactionFocusFade = value;
    notifyListeners();
  }

  /// Controls the radial reaction's opacity animation for hover changes.
  ///
  /// Usually set to [SDGAToggleableStateMixin.reactionHoverFade].
  Animation<double> get reactionHoverFade => _reactionHoverFade!;
  Animation<double>? _reactionHoverFade;
  set reactionHoverFade(Animation<double> value) {
    if (value == _reactionHoverFade) {
      return;
    }
    _reactionHoverFade?.removeListener(notifyListeners);
    value.addListener(notifyListeners);
    _reactionHoverFade = value;
    notifyListeners();
  }

  /// The style of this painter that stores the required data to paint this toggleable
  T get style => _style!;
  T? _style;
  set style(T value) {
    if (_style == value) {
      return;
    }
    _style = value;
    notifyListeners();
  }

  /// True if this toggleable has the input focus.
  bool get isFocused => _isFocused!;
  bool? _isFocused;
  set isFocused(bool? value) {
    if (value == _isFocused) {
      return;
    }
    _isFocused = value;
    notifyListeners();
  }

  /// True if this toggleable is being hovered over by a pointer.
  bool get isHovered => _isHovered!;
  bool? _isHovered;
  set isHovered(bool? value) {
    if (value == _isHovered) {
      return;
    }
    _isHovered = value;
    notifyListeners();
  }

  /// True if this toggleable has the input pressed.
  bool get isPressed => _isPressed!;
  bool? _isPressed;
  set isPressed(bool? value) {
    if (value == _isPressed) {
      return;
    }
    _isPressed = value;
    notifyListeners();
  }

  /// Determines whether the toggleable shows as active.
  bool get isActive => _isActive!;
  bool? _isActive;
  set isActive(bool? value) {
    if (value == _isActive) {
      return;
    }
    _isActive = value;
    notifyListeners();
  }

  /// Determines whether the toggleable shows as disabled.
  bool get isDisabled => _isDisabled!;
  bool? _isDisabled;
  set isDisabled(bool? value) {
    if (value == _isDisabled) {
      return;
    }
    _isDisabled = value;
    notifyListeners();
  }

  /// Determines whether the toggleable shows as readonly.
  bool get isReadonly => _isReadonly!;
  bool? _isReadonly;
  set isReadonly(bool? value) {
    if (value == _isReadonly) {
      return;
    }
    _isReadonly = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _position?.removeListener(notifyListeners);
    _reaction?.removeListener(notifyListeners);
    _reactionFocusFade?.removeListener(notifyListeners);
    _reactionHoverFade?.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  String toString() => describeIdentity(this);
}
