import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

enum _BeakPosition { none, left, right, top, bottom }

Offset _positionTooltip({
  required Size size,
  required Size tooltipSize,
  required Size childSize,
  required Offset childCenter,
}) {
  const double margin = 8.0;
  final double verticalOffset = childSize.height / 2;
  final double horizontalOffset = childSize.width / 2;
  final bool fitsBelow = childCenter.dy + verticalOffset + tooltipSize.height <=
      size.height - margin;
  final bool fitsBefore =
      childCenter.dx - horizontalOffset - tooltipSize.width >= margin;
  final bool fitsAfter =
      childCenter.dx + horizontalOffset + tooltipSize.width <=
          size.width - margin;
  final double dx = math.min(childCenter.dx, size.width - childCenter.dx);
  final double dy = math.min(childCenter.dy, size.height - childCenter.dy);
  if (dy > dx && (fitsAfter || fitsBefore)) {
    final double x;
    if (fitsAfter) {
      x = math.min(childCenter.dx + horizontalOffset, size.width - margin);
    } else {
      x = math.max(
          childCenter.dx - horizontalOffset - tooltipSize.width, margin);
    }
    final double flexibleSpace = size.height - tooltipSize.height;
    final double y = flexibleSpace <= 2 * margin
        ? flexibleSpace / 2.0
        : clampDouble(childCenter.dy - tooltipSize.height / 2, margin,
            flexibleSpace - margin);
    return Offset(x, y);
  } else {
    final double y;
    if (fitsBelow) {
      y = math.min(childCenter.dy + verticalOffset, size.height - margin);
    } else {
      y = math.max(
          childCenter.dy - verticalOffset - tooltipSize.height, margin);
    }
    final double flexibleSpace = size.width - tooltipSize.width;
    final double x = flexibleSpace <= 2 * margin
        ? flexibleSpace / 2.0
        : clampDouble(childCenter.dx - tooltipSize.width / 2, margin,
            flexibleSpace - margin);
    return Offset(x, y);
  }
}

/// A special [MouseRegion] that when nested, only the first [_ExclusiveMouseRegion]
/// to be hit in hit-testing order will be added to the BoxHitTestResult (i.e.,
/// child over parent, last sibling over first sibling).
///
/// The [onEnter] method will be called when a mouse pointer enters this
/// [MouseRegion], and there is no other [_ExclusiveMouseRegion]s obstructing
/// this [_ExclusiveMouseRegion] from receiving the events. This includes the
/// case where the mouse cursor stays within the paint bounds of an outer
/// [_ExclusiveMouseRegion], but moves outside of the bounds of the inner
/// [_ExclusiveMouseRegion] that was initially blocking the outer widget.
///
/// Likewise, [onExit] is called when the a mouse pointer moves out of the paint
/// bounds of this widget, or moves into another [_ExclusiveMouseRegion] that
/// overlaps this widget in hit-testing order.
///
/// This widget doesn't affect [MouseRegion]s that aren't [_ExclusiveMouseRegion]s,
/// or other [HitTestTarget]s in the tree.
class _ExclusiveMouseRegion extends MouseRegion {
  const _ExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
    super.child,
  });

  @override
  _RenderExclusiveMouseRegion createRenderObject(BuildContext context) {
    return _RenderExclusiveMouseRegion(
      onEnter: onEnter,
      onExit: onExit,
    );
  }
}

class _RenderExclusiveMouseRegion extends RenderMouseRegion {
  _RenderExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
  });

  static bool isOutermostMouseRegion = true;
  static bool foundInnermostMouseRegion = false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    final bool outermost = isOutermostMouseRegion;
    isOutermostMouseRegion = false;
    if (size.contains(position)) {
      isHit =
          hitTestChildren(result, position: position) || hitTestSelf(position);
      if ((isHit || behavior == HitTestBehavior.translucent) &&
          !foundInnermostMouseRegion) {
        foundInnermostMouseRegion = true;
        result.add(BoxHitTestEntry(this, position));
      }
    }

    if (outermost) {
      // The outermost region resets the global states.
      isOutermostMouseRegion = true;
      foundInnermostMouseRegion = false;
    }
    return isHit;
  }
}

class SDGATooltip extends StatefulWidget {
  const SDGATooltip({
    super.key,
    this.title,
    this.icon,
    this.semanticMessage,
    this.showBeak = true,
    this.inverted = false,
    this.waitDuration = Duration.zero,
    this.showDuration = const Duration(milliseconds: 1500),
    this.exitDuration = const Duration(milliseconds: 100),
    this.enableTapToDismiss = true,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.enableFeedback = true,
    this.onTriggered,
    required this.body,
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro sdga.text_style}
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The title of this alert.
  ///
  /// {@macro sdga.text_style}
  final Widget? title;

  /// Additional information or context.
  ///
  /// This can be used to provide more details or explanations to the user.
  ///
  /// {@macro sdga.text_style}
  final Widget body;

  /// The icon to be displayed before the title.
  ///
  /// Typically a [SDGAFeedbackIcon.customSize] with size of 18
  ///
  /// {@macro sdga.icon_style}
  final Widget? icon;

  /// The semantic message for the tooltip that will be announced by screen readers.
  ///
  /// This is announced in accessibility modes (e.g TalkBack/VoiceOver).
  ///
  /// This message does not show in the UI.
  final String? semanticMessage;

  /// Whether to draw the beak (the small arrow) or not
  ///
  /// Defaults to `true`
  final bool showBeak;

  /// Whether to use darker background for the tooltip
  ///
  /// Defaults to `false`
  final bool inverted;

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  final Duration waitDuration;

  /// The length of time that the tooltip will be shown after a long press is
  /// released (if triggerMode is [TooltipTriggerMode.longPress]) or a tap is
  /// released (if triggerMode is [TooltipTriggerMode.tap]). This property
  /// does not affect mouse pointer devices.
  ///
  /// Defaults to 1.5 seconds for long press and tap released
  ///
  /// See also:
  ///
  ///  * [exitDuration], which allows configuring the time until a pointer
  /// disappears when hovering.
  final Duration showDuration;

  /// The length of time that a pointer must have stopped hovering over a
  /// tooltip's widget before the tooltip will be hidden.
  ///
  /// Defaults to 100 milliseconds.
  ///
  /// See also:
  ///
  ///  * [showDuration], which allows configuring the length of time that a
  /// tooltip will be visible after touch events are released.
  final Duration exitDuration;

  /// Whether the tooltip can be dismissed by tap.
  ///
  /// The default value is true.
  final bool enableTapToDismiss;

  /// The [TooltipTriggerMode] that will show the tooltip.
  ///
  /// If this property is null, then [TooltipThemeData.triggerMode] is used.
  /// If [TooltipThemeData.triggerMode] is also null, the default mode is
  /// [TooltipTriggerMode.longPress].
  ///
  /// This property does not affect mouse devices. Setting [triggerMode] to
  /// [TooltipTriggerMode.manual] will not prevent the tooltip from showing when
  /// the mouse cursor hovers over it.
  final TooltipTriggerMode triggerMode;

  /// Whether the tooltip should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback], for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  /// Called when the Tooltip is triggered.
  ///
  /// The tooltip is triggered after a tap when [triggerMode] is [TooltipTriggerMode.tap]
  /// or after a long press when [triggerMode] is [TooltipTriggerMode.longPress].
  final TooltipTriggeredCallback? onTriggered;

  static final List<SDGATooltipState> _openedTooltips = <SDGATooltipState>[];

  /// Dismiss all of the tooltips that are currently shown on the screen,
  /// including those with mouse cursors currently hovering over them.
  ///
  /// This method returns true if it successfully dismisses the tooltips. It
  /// returns false if there is no tooltip shown on the screen.
  static bool dismissAllToolTips() {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<SDGATooltipState> openedTooltips = _openedTooltips.toList();
      for (final SDGATooltipState state in openedTooltips) {
        assert(state.mounted);
        state._scheduleDismissTooltip(withDelay: Duration.zero);
      }
      return true;
    }
    return false;
  }

  @override
  State<SDGATooltip> createState() => SDGATooltipState();
}

/// Contains the state for a [SDGATooltip].
///
/// This class can be used to programmatically show the Tooltip, see the
/// [ensureTooltipVisible] method.
class SDGATooltipState extends State<SDGATooltip>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlayController = OverlayPortalController();
  late bool _visible;

  Timer? _timer;
  AnimationController? _backingController;
  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
  }

  CurvedAnimation? _backingOverlayAnimation;
  CurvedAnimation get _overlayAnimation {
    return _backingOverlayAnimation ??= CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  LongPressGestureRecognizer? _longPressRecognizer;
  TapGestureRecognizer? _tapRecognizer;

  // The ids of mouse devices that are keeping the tooltip from being dismissed.
  //
  // Device ids are added to this set in _handleMouseEnter, and removed in
  // _handleMouseExit. The set is cleared in _handleTapToDismiss, typically when
  // a PointerDown event interacts with some other UI component.
  final Set<int> _activeHoveringPointerDevices = <int>{};

  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  void _handleStatusChanged(AnimationStatus status) {
    assert(mounted);
    if (!_animationStatus.isDismissed && status.isDismissed) {
      SDGATooltip._openedTooltips.remove(this);
      _overlayController.hide();
    } else if (_animationStatus.isDismissed && !status.isDismissed) {
      _overlayController.show();
      SDGATooltip._openedTooltips.add(this);
      if (widget.semanticMessage != null) {
        SemanticsService.tooltip(widget.semanticMessage!);
      }
    }
    _animationStatus = status;
  }

  void _scheduleShowTooltip(
      {required Duration withDelay, Duration? showDuration}) {
    assert(mounted);
    void show() {
      assert(mounted);
      if (!_visible) {
        return;
      }
      _controller.forward();
      _timer?.cancel();
      _timer = showDuration == null
          ? null
          : Timer(showDuration, _controller.reverse);
    }

    assert(
      !(_timer?.isActive ?? false) ||
          _controller.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );
    if (_controller.isDismissed && withDelay.inMicroseconds > 0) {
      _timer?.cancel();
      _timer = Timer(withDelay, show);
    } else {
      show(); // If the tooltip is already fading in or fully visible, skip the
      // animation and show the tooltip immediately.
    }
  }

  void _scheduleDismissTooltip({required Duration withDelay}) {
    assert(mounted);
    assert(
      !(_timer?.isActive ?? false) ||
          _backingController?.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );

    _timer?.cancel();
    _timer = null;
    // Use _backingController instead of _controller to prevent the lazy getter
    // from instantiating an AnimationController unnecessarily.
    if (_backingController?.isForwardOrCompleted ?? false) {
      // Dismiss when the tooltip is fading in: if there's a dismiss delay we'll
      // allow the fade in animation to continue until the delay timer fires.
      if (withDelay.inMicroseconds > 0) {
        _timer = Timer(withDelay, _controller.reverse);
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    assert(mounted);
    // PointerDeviceKinds that don't support hovering.
    const Set<PointerDeviceKind> triggerModeDeviceKinds = <PointerDeviceKind>{
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.stylus,
      PointerDeviceKind.touch,
      PointerDeviceKind.unknown,
      // MouseRegion only tracks PointerDeviceKind == mouse.
      PointerDeviceKind.trackpad,
    };
    switch (widget.triggerMode) {
      case TooltipTriggerMode.longPress:
        final LongPressGestureRecognizer recognizer =
            _longPressRecognizer ??= LongPressGestureRecognizer(
          debugOwner: this,
          supportedDevices: triggerModeDeviceKinds,
        );
        recognizer
          ..onLongPressCancel = _handleTapToDismiss
          ..onLongPress = _handleLongPress
          ..onLongPressUp = _handlePressUp
          ..addPointer(event);
        break;
      case TooltipTriggerMode.tap:
        final TapGestureRecognizer recognizer = _tapRecognizer ??=
            TapGestureRecognizer(
                debugOwner: this, supportedDevices: triggerModeDeviceKinds);
        recognizer
          ..onTapCancel = _handleTapToDismiss
          ..onTap = _handleTap
          ..addPointer(event);
        break;
      case TooltipTriggerMode.manual:
        break;
    }
  }

  // For PointerDownEvents, this method will be called after _handlePointerDown.
  void _handleGlobalPointerEvent(PointerEvent event) {
    assert(mounted);
    if (_tapRecognizer?.primaryPointer == event.pointer ||
        _longPressRecognizer?.primaryPointer == event.pointer) {
      // This is a pointer of interest specified by the trigger mode, since it's
      // picked up by the recognizer.
      //
      // The recognizer will later determine if this is indeed a "trigger"
      // gesture and dismiss the tooltip if that's not the case. However there's
      // still a chance that the PointerEvent was cancelled before the gesture
      // recognizer gets to emit a tap/longPress down, in which case the onCancel
      // callback (_handleTapToDismiss) will not be called.
      return;
    }
    if ((_timer == null && _controller.isDismissed) ||
        event is! PointerDownEvent) return;
    _handleTapToDismiss();
  }

  // The primary pointer is not part of a "trigger" gesture so the tooltip
  // should be dismissed.
  void _handleTapToDismiss() {
    if (!widget.enableTapToDismiss) return;
    _scheduleDismissTooltip(withDelay: Duration.zero);
    _activeHoveringPointerDevices.clear();
  }

  void _handleTap() {
    if (!_visible) return;
    final bool tooltipCreated = _controller.isDismissed;
    if (tooltipCreated && widget.enableFeedback) {
      assert(widget.triggerMode == TooltipTriggerMode.tap);
      Feedback.forTap(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(
      withDelay: Duration.zero,
      // _activeHoveringPointerDevices keep the tooltip visible.
      showDuration:
          _activeHoveringPointerDevices.isEmpty ? widget.showDuration : null,
    );
  }

  // When a "trigger" gesture is recognized and the pointer down even is a part
  // of it.
  void _handleLongPress() {
    if (!_visible) return;
    final bool tooltipCreated = _visible && _controller.isDismissed;
    if (tooltipCreated && widget.enableFeedback) {
      assert(widget.triggerMode == TooltipTriggerMode.longPress);
      Feedback.forLongPress(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(withDelay: Duration.zero);
  }

  void _handlePressUp() {
    if (_activeHoveringPointerDevices.isNotEmpty) return;
    _scheduleDismissTooltip(withDelay: widget.showDuration);
  }

  // # Current Hovering Behavior:
  // 1. Hovered tooltips don't show more than one at a time, for each mouse
  //    device. For example, a chip with a delete icon typically shouldn't show
  //    both the delete icon tooltip and the chip tooltip at the same time.
  // 2. Hovered tooltips are dismissed when:
  //    i. [dismissAllToolTips] is called, even these tooltips are still hovered
  //    ii. a unrecognized PointerDownEvent occurred within the application
  //    (even these tooltips are still hovered),
  //    iii. The last hovering device leaves the tooltip.
  void _handleMouseEnter(PointerEnterEvent event) {
    // _handleMouseEnter is only called when the mouse starts to hover over this
    // tooltip (including the actual tooltip it shows on the overlay), and this
    // tooltip is the first to be hit in the widget tree's hit testing order.
    // See also _ExclusiveMouseRegion for the exact behavior.
    _activeHoveringPointerDevices.add(event.device);
    // Dismiss other open tooltips unless they're kept visible by other mice.
    // The mouse tracker implementation always dispatches all `onExit` events
    // before dispatching any `onEnter` events, so `event.device` must have
    // already been removed from _activeHoveringPointerDevices of the tooltips
    // that are no longer being hovered over.
    final List<SDGATooltipState> tooltipsToDismiss = SDGATooltip._openedTooltips
        .where((SDGATooltipState tooltip) =>
            tooltip._activeHoveringPointerDevices.isEmpty)
        .toList();
    for (final SDGATooltipState tooltip in tooltipsToDismiss) {
      assert(tooltip.mounted);
      tooltip._scheduleDismissTooltip(withDelay: Duration.zero);
    }
    _scheduleShowTooltip(
        withDelay:
            tooltipsToDismiss.isNotEmpty ? Duration.zero : widget.waitDuration);
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_activeHoveringPointerDevices.isEmpty) return;
    _activeHoveringPointerDevices.remove(event.device);
    if (_activeHoveringPointerDevices.isEmpty) {
      _scheduleDismissTooltip(withDelay: widget.exitDuration);
    }
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// After made visible by this method, The tooltip does not automatically
  /// dismiss after `waitDuration`, until the user dismisses/re-triggers it, or
  /// [SDGATooltip.dismissAllToolTips] is called.
  ///
  /// Returns `false` when the tooltip shouldn't be shown or when the tooltip
  /// was already visible.
  bool ensureTooltipVisible() {
    if (!_visible) {
      return false;
    }

    _timer?.cancel();
    _timer = null;
    if (_controller.isForwardOrCompleted) {
      return false;
    }
    _scheduleShowTooltip(withDelay: Duration.zero);
    return true;
  }

  @override
  void initState() {
    super.initState();
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on. Pointer events are dispatched to
    // global routes **after** other routes.
    GestureBinding.instance.pointerRouter
        .addGlobalRoute(_handleGlobalPointerEvent);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handleGlobalPointerEvent);
    SDGATooltip._openedTooltips.remove(this);
    // _longPressRecognizer.dispose() and _tapRecognizer.dispose() may call
    // their registered onCancel callbacks if there's a gesture in progress.
    // Remove the onCancel callbacks to prevent the registered callbacks from
    // triggering unnecessary side effects (such as animations).
    _longPressRecognizer?.onLongPressCancel = null;
    _longPressRecognizer?.dispose();
    _tapRecognizer?.onTapCancel = null;
    _tapRecognizer?.dispose();
    _timer?.cancel();
    _backingController?.dispose();
    _backingOverlayAnimation?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));

    Widget result = Semantics(
      tooltip: widget.semanticMessage,
      child: widget.child,
    );

    // Only check for gestures if tooltip should be visible.
    if (_visible) {
      result = _ExclusiveMouseRegion(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        child: Listener(
          onPointerDown: _handlePointerDown,
          behavior: HitTestBehavior.opaque,
          child: result,
        ),
      );
    }

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildTooltipOverlay,
      child: result,
    );
  }

  Widget _buildTooltipOverlay(BuildContext context) {
    final OverlayState overlayState =
        Overlay.of(context, debugRequiredFor: widget);
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    Widget result = _ExclusiveMouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      child: _buildContent(target),
    );

    final colors = SDGAColorScheme.of(context);
    final color = widget.inverted
        ? colors.tooltips.backgroundDark
        : colors.tooltips.backgroundLight;

    final overlayChild = Positioned.fill(
      bottom: MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0,
      child: FadeTransition(
        opacity: _overlayAnimation,
        child: _SDGATooltip(
          color: color,
          showBeak: widget.showBeak,
          target: target,
          targetSize: box.size,
          child: result,
        ),
      ),
    );

    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  Widget _buildContent(Offset target) {
    final colors = SDGAColorScheme.of(context);
    Widget child = DefaultTextStyle(
      style: SDGATextStyles.textExtraSmallRegular.copyWith(
          color: widget.inverted
              ? colors.tooltips.textParagraphDark
              : colors.tooltips.textParagraphLight),
      child: widget.body,
    );
    if (widget.title != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle(
            style: SDGATextStyles.textExtraSmallSemiBold.copyWith(
                color: widget.inverted
                    ? colors.tooltips.textHeadingDark
                    : colors.tooltips.textHeadingLight),
            child: widget.title!,
          ),
          const SizedBox(height: SDGANumbers.spacingXS),
          child,
        ],
      );
    }
    if (widget.icon != null) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.icon!,
          const SizedBox(width: SDGANumbers.spacingMD),
          Expanded(child: child),
        ],
      );
    }
    return child;
  }
}

class _SDGATooltip extends SingleChildRenderObjectWidget {
  const _SDGATooltip({
    required this.showBeak,
    required this.target,
    required this.targetSize,
    required this.color,
    super.child,
  });

  final bool showBeak;
  final Offset target;
  final Size targetSize;
  final Color color;

  @override
  _RenderSDGATooltip createRenderObject(BuildContext context) {
    return _RenderSDGATooltip(
      showBeak: showBeak,
      target: target,
      targetSize: targetSize,
      color: color,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSDGATooltip renderObject) {
    renderObject
      ..showBeak = showBeak
      ..target = target
      ..color = color;
  }
}

class _RenderSDGATooltip extends RenderShiftedBox {
  Offset _containerOffset = Offset.zero;
  Offset _childOffset = Offset.zero;
  _BeakPosition _beak = _BeakPosition.none;

  _RenderSDGATooltip({
    required bool showBeak,
    required Color color,
    required Offset target,
    required Size targetSize,
    RenderBox? child,
  })  : _showBeak = showBeak,
        _color = color,
        _target = target,
        _targetSize = targetSize,
        super(child);

  EdgeInsets get _resolvedPadding {
    return const EdgeInsets.all(SDGANumbers.spacingMD);
  }

  bool get showBeak => _showBeak;
  bool _showBeak;
  set showBeak(bool value) {
    if (_showBeak == value) return;
    _showBeak = value;
    markNeedsLayout();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsLayout();
  }

  Offset get target => _target;
  Offset _target;
  set target(Offset value) {
    if (_target == value) return;
    _target = value;
    markNeedsLayout();
  }

  Size get targetSize => _targetSize;
  Size _targetSize;
  set targetSize(Size value) {
    if (_targetSize == value) return;
    _targetSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final EdgeInsets padding = _resolvedPadding;
    if (child != null) {
      // Relies on double.infinity absorption.
      return child!
              .getMinIntrinsicWidth(math.max(0.0, height - padding.vertical)) +
          padding.horizontal;
    }
    return padding.horizontal;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final EdgeInsets padding = _resolvedPadding;
    if (child != null) {
      // Relies on double.infinity absorption.
      return child!
              .getMaxIntrinsicWidth(math.max(0.0, height - padding.vertical)) +
          padding.horizontal;
    }
    return padding.horizontal;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final EdgeInsets padding = _resolvedPadding;
    if (child != null) {
      // Relies on double.infinity absorption.
      return child!.getMinIntrinsicHeight(
              math.max(0.0, width - padding.horizontal)) +
          padding.vertical;
    }
    return padding.vertical;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final EdgeInsets padding = _resolvedPadding;
    if (child != null) {
      // Relies on double.infinity absorption.
      return child!.getMaxIntrinsicHeight(
              math.max(0.0, width - padding.horizontal)) +
          padding.vertical;
    }
    return padding.vertical;
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final EdgeInsets padding = _resolvedPadding;
    if (child == null) {
      return constraints.constrain(Size(padding.horizontal, padding.vertical));
    }
    final BoxConstraints innerConstraints = constraints.deflate(padding);
    final Size childSize = child!.getDryLayout(innerConstraints);
    return constraints.constrain(Size(
      padding.horizontal + childSize.width,
      padding.vertical + childSize.height,
    ));
  }

  @override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final EdgeInsets padding = _resolvedPadding;
    final BoxConstraints innerConstraints = constraints.deflate(padding);
    final BaselineOffset result =
        BaselineOffset(child.getDryBaseline(innerConstraints, baseline)) +
            padding.top;
    return result.offset;
  }

  @override
  void performLayout() {
    Offset getPosition() => _positionTooltip(
          size: Size(
              this.constraints.biggest.width, this.constraints.biggest.height),
          tooltipSize: child!.size,
          childCenter: target,
          childSize: targetSize,
        );
    final BoxConstraints constraints =
        this.constraints.enforce(const BoxConstraints(maxWidth: 240));
    final EdgeInsets padding = _resolvedPadding;
    if (child == null) {
      size = constraints.constrain(Size(padding.horizontal, padding.vertical));
      return;
    }
    BoxConstraints innerConstraints = constraints.deflate(padding);
    child!.layout(innerConstraints.loosen(), parentUsesSize: true);
    Offset tooltipPosition = getPosition();
    if (target.dy < tooltipPosition.dy ||
        target.dy > tooltipPosition.dy + child!.size.height) {
      innerConstraints =
          innerConstraints.deflate(const EdgeInsets.only(top: 6));
    } else {
      innerConstraints =
          innerConstraints.deflate(const EdgeInsets.only(left: 6));
    }
    child!.layout(innerConstraints.loosen(), parentUsesSize: true);
    tooltipPosition = getPosition();
    _calculatePositions(tooltipPosition);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(_childOffset.dx, _childOffset.dy);
    size = this.constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      super.paint(context, offset);
    } else {
      final Size containerSize =
          Size(child!.size.width + 16, child!.size.height + 16);
      final Matrix4 matrix = Matrix4.translationValues(
          _containerOffset.dx, _containerOffset.dy, 0);
      final Path path =
          _getPath(containerSize, _beak, target - _containerOffset);

      for (final BoxShadow shadow in SDGAShadows.shadowLarge) {
        final Paint paint = shadow.toPaint();
        final Matrix4 shadowMatrix = Matrix4.identity()
          ..translate(containerSize.width / 2, containerSize.height / 2)
          ..scale(
              (containerSize.width + shadow.spreadRadius * 2) /
                  containerSize.width,
              (containerSize.height + shadow.spreadRadius * 2) /
                  containerSize.height)
          ..translate(-containerSize.width / 2, -containerSize.height / 2);
        final Path shadowPath = path
            .shift(Offset(
              shadow.offset.dx,
              shadow.offset.dy * (_beak == _BeakPosition.bottom ? -1 : 1),
            ))
            .transform(shadowMatrix.storage);
        assert(() {
          if (debugDisableShadows && shadow.blurStyle == BlurStyle.outer) {
            context.canvas.save();
            context.canvas.clipPath(shadowPath);
          }
          return true;
        }());
        context.canvas.drawPath(shadowPath.transform(matrix.storage), paint);
        assert(() {
          if (debugDisableShadows && shadow.blurStyle == BlurStyle.outer) {
            context.canvas.restore();
          }
          return true;
        }());
      }
      context.canvas
          .drawPath(path.transform(matrix.storage), Paint()..color = color);
      context.paintChild(child!, _childOffset);
    }
  }

  void _calculatePositions(Offset tooltipPosition) {
    if (target.dx < tooltipPosition.dx) {
      _containerOffset = tooltipPosition.translate(6, -8);
      _childOffset = tooltipPosition.translate(14, 0);
      _beak = _BeakPosition.left;
    } else if (target.dy < tooltipPosition.dy) {
      _containerOffset = tooltipPosition.translate(-8, 6);
      _childOffset = tooltipPosition.translate(0, 14);
      _beak = _BeakPosition.top;
    } else if (target.dy > tooltipPosition.dy + child!.size.height) {
      _containerOffset = tooltipPosition.translate(-8, -22);
      _childOffset = tooltipPosition.translate(0, -14);
      _beak = _BeakPosition.bottom;
    } else {
      _containerOffset = tooltipPosition.translate(-22, -8);
      _childOffset = tooltipPosition.translate(-14, 0);
      _beak = _BeakPosition.right;
    }
    if (!showBeak) {
      switch (_beak) {
        case _BeakPosition.left:
          _containerOffset = _containerOffset.translate(-6, 0);
          _childOffset = _childOffset.translate(-6, 0);
          break;
        case _BeakPosition.right:
          _containerOffset = _containerOffset.translate(6, 0);
          _childOffset = _childOffset.translate(6, 0);
          break;
        case _BeakPosition.top:
          _containerOffset = _containerOffset.translate(0, -6);
          _childOffset = _childOffset.translate(0, -6);
          break;
        case _BeakPosition.bottom:
          _containerOffset = _containerOffset.translate(0, 6);
          _childOffset = _childOffset.translate(0, 6);
          break;
        case _BeakPosition.none:
          break;
      }
      _beak = _BeakPosition.none;
    }
  }

  Path _getPath(Size size, _BeakPosition position, Offset target) {
    const double radius = SDGANumbers.radiusSmall;
    const double br = SDGANumbers.radiusExtraSmall;
    const double bs = 6.0;

    Path path = Path();
    path.moveTo(radius, 0);
    if (position == _BeakPosition.top) {
      final cp = Offset(target.dx, -bs);
      path.lineTo(target.dx - bs, 0);
      path.lineTo(cp.dx - br, cp.dy + br);
      path.quadraticBezierTo(cp.dx, cp.dy, cp.dx + br, cp.dy + br);
      path.lineTo(target.dx + bs, 0);
    }
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    if (position == _BeakPosition.right) {
      final cp = Offset(size.width + bs, target.dy);
      path.lineTo(size.width, target.dy - bs);
      path.lineTo(cp.dx - br, cp.dy - br);
      path.quadraticBezierTo(cp.dx, cp.dy, cp.dx - br, cp.dy + br);
      path.lineTo(size.width, target.dy + bs);
    }
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    if (position == _BeakPosition.bottom) {
      final cp = Offset(target.dx, size.height + bs);
      path.lineTo(target.dx - bs, size.height);
      path.lineTo(cp.dx - br, cp.dy - br);
      path.quadraticBezierTo(cp.dx, cp.dy, cp.dx + br, cp.dy - br);
      path.lineTo(target.dx + bs, size.height);
    }
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    if (position == _BeakPosition.left) {
      final cp = Offset(-bs, target.dy);
      path.lineTo(0, target.dy - bs);
      path.lineTo(cp.dx + br, cp.dy - br);
      path.quadraticBezierTo(cp.dx, cp.dy, cp.dx + br, cp.dy + br);
      path.lineTo(0, target.dy + bs);
    }
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    return path;
  }
}
