import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

const double _kPadding = SDGANumbers.spacingXS;

class _RatingBarParentData extends ContainerBoxParentData<RenderBox> {}

/// A widget that displays a rating bar.
///
/// The [SDGARatingBar] widget allows users to rate an item by selecting a
/// number of stars or providing a fractional rating if [allowFractions] is
/// enabled. The rating can be updated by the user, and the [onChanged] callback
/// is called when the rating changes.
///
/// If the [onChanged] callback is null, the rating bar will be non-interactive
/// and will be read-only.
///
/// {@tool sample}
///
/// ```dart
/// SDGARatingBar(
///   size: SDGAWidgetSize.large,
///   useBrandColors: true,
///   allowFractions: false,
///   onChanged: (rating) {
///     print('New rating: $rating');
///   },
/// )
/// ```
/// {@end-tool}
class SDGARatingBar extends StatefulWidget {
  /// Creates a [SDGARatingBar] widget.
  ///
  /// The [SDGARatingBar] widget itself does not maintain any state. Instead,
  /// when the rating changes, the widget calls the [onChanged] callback. Most
  /// widgets that use the [SDGARatingBar] will listen for the [onChanged] callback
  /// and rebuild the rating bar with a new [value] to update the visual appearance.
  const SDGARatingBar({
    super.key,
    this.size = SDGAWidgetSize.large,
    this.useBrandColors = false,
    this.allowFractions = true,
    this.onChanged,
    required this.value,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  }) : assert(value >= 0 && value <= 5, 'The [value] must be between 0 and 5.');

  /// Defines the size of this rating bar.
  ///
  /// The [SDGAWidgetSize] enum provides different size options for the rating
  /// bar, such as small, medium, large, etc.
  final SDGAWidgetSize size;

  /// Determines whether to use brand colors for the rating bar.
  ///
  /// If set to `true`, the rating bar will use the brand's predefined color
  /// scheme. If set to `false` (default), the rating bar will use the secondary
  /// color scheme.
  final bool useBrandColors;

  /// Determines whether to allow fractional ratings or only whole ratings.
  ///
  /// If set to `true` (default), users can select fractional ratings (e.g., 3.5
  /// stars). If set to `false`, only whole ratings (e.g., 3 or 4 stars) are
  /// allowed.
  final bool allowFractions;

  /// Callback function called when the rating is changed by the user.
  ///
  /// The new rating value (a double between 0 and the maximum rating of 5) is
  /// passed as an argument to the callback.
  ///
  /// If this callback is null, the rating bar will be non-interactive and
  /// will be read-only.
  final ValueChanged<double>? onChanged;

  /// The current rating value to be displayed by the rating bar.
  ///
  /// This value should be between 0 and the maximum rating of 5. Any value
  /// above 5 will be capped at 5.
  final double value;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  State<SDGARatingBar> createState() => _SDGARatingBarState();
}

class _SDGARatingBarState extends State<SDGARatingBar> {
  final WidgetStatesController _statesController = WidgetStatesController();
  final GlobalKey _renderObjectKey = GlobalKey();

  // Keyboard mapping for a focused rating.
  static const Map<ShortcutActivator, Intent> _shortcutMap =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustRatingIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustRatingIntent.right(),
  };

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    _AdjustRatingIntent: CallbackAction<_AdjustRatingIntent>(
      onInvoke: _actionHandler,
    ),
  };

  FocusNode? _focusNode;
  FocusNode get focusNode => widget.focusNode ?? _focusNode!;
  double get _increasedValue =>
      (widget.allowFractions ? widget.value + 0.5 : widget.value + 1)
          .clamp(0.5, 5);
  double get _decreasedValue =>
      (widget.allowFractions ? widget.value - 0.5 : widget.value - 1)
          .clamp(0.5, 5);

  void _increase() {
    final double newValue = _increasedValue;
    if (newValue != widget.value) {
      widget.onChanged?.call(newValue);
    }
  }

  void _decrease() {
    final double newValue = _decreasedValue;
    if (newValue != widget.value) {
      widget.onChanged?.call(newValue);
    }
  }

  void _handleStatesControllerChange() {
    setState(() {});
  }

  void _actionHandler(_AdjustRatingIntent intent) {
    final TextDirection directionality =
        Directionality.of(_renderObjectKey.currentContext!);

    final bool shouldIncrease;
    switch (intent.type) {
      case _RatingAdjustmentType.left:
        shouldIncrease = directionality == TextDirection.rtl;
        break;
      case _RatingAdjustmentType.right:
        shouldIncrease = directionality == TextDirection.ltr;
        break;
    }
    return shouldIncrease ? _increase() : _decrease();
  }

  @override
  void initState() {
    _statesController.update(WidgetState.disabled, widget.onChanged == null);
    _statesController.addListener(_handleStatesControllerChange);
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    super.initState();
  }

  @override
  void dispose() {
    _statesController.removeListener(_handleStatesControllerChange);
    _statesController.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SDGARatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.onChanged != null) != (oldWidget.onChanged != null)) {
      _statesController.update(WidgetState.disabled, widget.onChanged == null);
      if (widget.onChanged == null) {
        _statesController.update(WidgetState.focused, false);
      }
    }
  }

  void handleFocusUpdate(bool hasFocus) {
    _statesController.update(WidgetState.focused, hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final Widget bar = _RatingBar(
      key: _renderObjectKey,
      size: _size,
      onChanged: widget.onChanged,
      allowFractions: widget.allowFractions,
      children: List.generate(
        5,
        (index) => _RateItem(
          index: index,
          percent: (widget.value - index).clamp(0, 1),
          selectedColor: widget.useBrandColors
              ? colors.backgrounds.primary
              : colors.backgrounds.secondary,
          unselectedColor: colors.backgrounds.neutral200,
          child: SDGAIcon(SDGAIconsSharpSolid.star, size: _size),
        ),
      ),
    );

    final TargetPlatform platform = Theme.of(context).platform;
    final bool focusOnAccessibility =
        platform == TargetPlatform.macOS || platform == TargetPlatform.windows;
    final double increasedValue = _increasedValue;
    final double decreasedValue = _decreasedValue;
    final bool canIncrease = increasedValue != widget.value;
    final bool canDecrease = decreasedValue != widget.value;

    return MergeSemantics(
      child: Semantics(
        slider: true,
        textDirection: Directionality.maybeOf(context),
        value: widget.value.toString(),
        increasedValue: canIncrease ? increasedValue.toString() : null,
        decreasedValue: canDecrease ? decreasedValue.toString() : null,
        onIncrease:
            canIncrease ? () => widget.onChanged?.call(increasedValue) : null,
        onDecrease:
            canDecrease ? () => widget.onChanged?.call(decreasedValue) : null,
        onDidGainAccessibilityFocus: focusOnAccessibility
            ? () {
                if (!focusNode.hasFocus && focusNode.canRequestFocus) {
                  focusNode.requestFocus();
                }
              }
            : null,
        onDidLoseAccessibilityFocus:
            focusOnAccessibility ? () => focusNode.unfocus() : null,
        child: FocusableActionDetector(
          actions: _actionMap,
          shortcuts: _shortcutMap,
          enabled: widget.onChanged != null,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          onShowFocusHighlight: handleFocusUpdate,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: WidgetStateProperty.resolveWith(
                (states) => SDGAUtils.resolveWidgetStateUnordered(
                  states,
                  fallback: null,
                  focused: Border.all(
                    color: colors.borders.black,
                    width: 2,
                  ),
                ),
              ).resolve(_statesController.value),
            ),
            child: bar,
          ),
        ),
      ),
    );
  }

  double get _size {
    switch (widget.size) {
      case SDGAWidgetSize.small:
        return 32.0;
      case SDGAWidgetSize.medium:
        return 40.0;
      case SDGAWidgetSize.large:
        return 48.0;
    }
  }
}

class _RatingBar extends MultiChildRenderObjectWidget {
  const _RatingBar({
    super.key,
    super.children,
    required this.size,
    required this.allowFractions,
    this.onChanged,
  });

  final double size;
  final bool allowFractions;
  final ValueChanged<double>? onChanged;

  @override
  _RenderRatingBar createRenderObject(BuildContext context) {
    return _RenderRatingBar(
      textDirection: Directionality.maybeOf(context),
      allowFractions: allowFractions,
      childSize: size,
      onChanged: onChanged,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderRatingBar renderObject) {
    renderObject
      ..textDirection = Directionality.maybeOf(context)
      ..allowFractions = allowFractions
      ..childSize = size
      ..onChanged = onChanged;
  }
}

class _RenderRatingBar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RatingBarParentData>,
        DebugOverflowIndicatorMixin
    implements MouseTrackerAnnotation {
  _RenderRatingBar({
    List<RenderBox>? children,
    TextDirection? textDirection,
    required double childSize,
    required bool allowFractions,
    this.onChanged,
  })  : _textDirection = textDirection,
        _childSize = childSize,
        _allowFractions = allowFractions {
    addAll(children);
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  double _overflow = 0;
  bool _validForMouseTracker = true;
  ValueChanged<double>? onChanged;

  @override
  PointerEnterEventListener? get onEnter => (_) {};
  @override
  PointerExitEventListener? get onExit => (_) => _updateValue(null);
  @override
  MouseCursor get cursor =>
      _intractable ? SystemMouseCursors.click : SystemMouseCursors.basic;
  @override
  bool get validForMouseTracker => _validForMouseTracker;
  bool get _hasOverflow => _overflow > precisionErrorTolerance;
  bool get _intractable => onChanged != null;
  Size get preferredSize => Size(
        childSize * childCount +
            _kPadding * (childCount - 1).clamp(0, childCount),
        childSize,
      );

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  double get childSize => _childSize!;
  double? _childSize;
  set childSize(double? value) {
    if (_childSize != value) {
      _childSize = value;
      markNeedsLayout();
    }
  }

  bool get allowFractions => _allowFractions!;
  bool? _allowFractions;
  set allowFractions(bool? value) {
    if (_allowFractions != value) {
      _allowFractions = value;
      markNeedsPaint();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RatingBarParentData) {
      child.parentData = _RatingBarParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return preferredSize.width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return preferredSize.width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return preferredSize.height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return preferredSize.height;
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrain(preferredSize);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final neededSize = preferredSize;
    size = constraints.constrain(neededSize);
    _overflow = max(0, neededSize.width - size.width);

    for (RenderBox? child = firstChild;
        child != null;
        child = childAfter(child)) {
      ChildLayoutHelper.layoutChild(
        child,
        BoxConstraints.loose(Size(childSize, childSize)),
      );
    }
    final bool flipMainAxis = textDirection == TextDirection.rtl;
    final RenderBox? Function(RenderBox child) nextChild =
        flipMainAxis ? childBefore : childAfter;
    final RenderBox? topLeftChild = flipMainAxis ? lastChild : firstChild;
    double childMainPosition = 0;
    for (RenderBox? child = topLeftChild;
        child != null;
        child = nextChild(child)) {
      final _RatingBarParentData childParentData =
          child.parentData! as _RatingBarParentData;
      childParentData.offset = Offset(childMainPosition, 0);
      childMainPosition += child.size.width + _kPadding;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      _paint(context, offset);
      return;
    }

    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      _paint,
      clipBehavior: Clip.hardEdge,
      oldLayer: _clipRectLayer.layer,
    );

    assert(() {
      final List<DiagnosticsNode> debugOverflowHints = <DiagnosticsNode>[
        ErrorDescription(
          'The overflowing $runtimeType has an orientation of Axis.horizontal.',
        ),
        ErrorDescription(
          'The edge of the $runtimeType that is overflowing has been marked '
          'in the rendering with a yellow and black striped pattern. This is '
          'usually caused by the contents being too big for the $runtimeType.',
        ),
        ErrorHint(
          'Consider applying a flex factor (e.g. using an Expanded widget) to '
          'force the children of the $runtimeType to fit within the available '
          'space instead of being sized to their natural size.',
        ),
        ErrorHint(
          'This is considered an error condition because it indicates that there '
          'is content that cannot be seen. If the content is legitimately bigger '
          'than the available space, consider clipping it with a ClipRect widget '
          'before putting it in the flex, or using a scrollable container rather '
          'than a Flex, like a ListView.',
        ),
      ];

      // Simulate a child rect that overflows by the right amount. This child
      // rect is never used for drawing, just for determining the overflow
      // location and amount.
      final Rect overflowChildRect =
          Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0);
      paintOverflowIndicator(
          context, offset, Offset.zero & size, overflowChildRect,
          overflowHints: debugOverflowHints);
      return true;
    }());
  }

  void _paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _RatingBarParentData childParentData =
          child.parentData! as _RatingBarParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestSelf(Offset position) => _intractable;

  @override
  void handleEvent(
      PointerEvent event, covariant HitTestEntry<HitTestTarget> entry) {
    assert(debugHandleEvent(event, entry));
    if (!_intractable) return;
    double? value = _hitTestRatingValue(event.localPosition);
    _updateValue(value);
    if (event is PointerUpEvent) {
      onChanged?.call(value);
    }
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }

  double _hitTestRatingValue(Offset position) {
    final double dx = textDirection == TextDirection.rtl
        ? size.width - position.dx
        : position.dx;
    double rating = (dx / (childSize + _kPadding)).floorToDouble();
    final double actualPosition = dx - (rating * (childSize + _kPadding));
    rating = actualPosition < childSize ? rating : rating + 1;
    if (allowFractions) {
      final double fraction = actualPosition % childSize;
      final double fractionRating = rating + fraction / childSize;
      final int truncated = fractionRating.truncate();
      double fractional = fractionRating - truncated;
      fractional = fractional <= 0.5 ? 0.5 : 1;
      rating = truncated + fractional;
    } else {
      rating += 1.0;
    }
    return rating.clamp(0, 5);
  }

  void _updateValue(double? value) {
    _RenderRateItem? child = firstChild as _RenderRateItem?;
    while (child != null) {
      final _RatingBarParentData childParentData =
          child.parentData! as _RatingBarParentData;
      child.tempPercent =
          value != null ? (value - child.index).clamp(0, 1) : value;
      child = childParentData.nextSibling as _RenderRateItem?;
    }
  }
}

class _RateItem extends SingleChildRenderObjectWidget {
  const _RateItem({
    Key? key,
    required Widget child,
    required this.index,
    required this.percent,
    required this.selectedColor,
    required this.unselectedColor,
  })  : assert(percent >= 0 && percent <= 1),
        super(key: key, child: child);

  final int index;
  final double percent;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderRateItem(
      index: index,
      percent: percent,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderRateItem renderObject) {
    renderObject
      ..index = index
      ..percent = percent
      ..selectedColor = selectedColor
      ..unselectedColor = unselectedColor
      ..textDirection = Directionality.maybeOf(context);
  }
}

class _RenderRateItem extends RenderProxyBox {
  final LayerHandle<ColorFilterLayer> _backgroundHandle =
      LayerHandle<ColorFilterLayer>();
  final LayerHandle<ShaderMaskLayer> _foregroundHandle =
      LayerHandle<ShaderMaskLayer>();

  _RenderRateItem({
    required this.index,
    required double percent,
    required Color selectedColor,
    required Color unselectedColor,
    required TextDirection? textDirection,
  })  : _percent = percent,
        _selectedColor = selectedColor,
        _unselectedColor = unselectedColor,
        _textDirection = textDirection;

  @override
  void dispose() {
    _backgroundHandle.layer = null;
    _foregroundHandle.layer = null;
    super.dispose();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  int index;
  TextDirection? _textDirection;
  TextDirection? get textDirection => _textDirection;
  set textDirection(TextDirection? value) {
    if (value != _textDirection) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  Color _selectedColor;
  Color get selectedColor => _selectedColor;
  set selectedColor(Color value) {
    if (_selectedColor != value) {
      _selectedColor = value;
      markNeedsPaint();
    }
  }

  Color _unselectedColor;
  Color get unselectedColor => _unselectedColor;
  set unselectedColor(Color value) {
    if (value != _unselectedColor) {
      _unselectedColor = value;
      markNeedsPaint();
    }
  }

  double _percent;
  double get percent => _percent;
  set percent(double value) {
    if (_percent != value) {
      _percent = value;
      markNeedsPaint();
    }
  }

  double? _tempPercent;
  double? get tempPercent => _tempPercent;
  set tempPercent(double? value) {
    if (_tempPercent != value) {
      _tempPercent = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(child != null);
    assert(needsCompositing);
    final double width = size.width * (tempPercent ?? percent);
    final double height = size.height;
    final Size maskSize = Size(width, height);
    Rect maskRect = offset & maskSize;
    if (textDirection == TextDirection.rtl) {
      maskRect = maskRect.shift(Offset(size.width - maskRect.width, 0));
    }
    _backgroundHandle.layer ??= ColorFilterLayer();
    _foregroundHandle.layer ??= ShaderMaskLayer();

    _backgroundHandle.layer!.colorFilter = ColorFilter.mode(
      unselectedColor,
      BlendMode.srcIn,
    );

    _foregroundHandle.layer!
      ..shader = LinearGradient(colors: [selectedColor], stops: const [0])
          .createShader(Offset.zero & maskSize)
      ..maskRect = maskRect
      ..blendMode = BlendMode.srcIn;

    context.pushLayer(_foregroundHandle.layer!, (context, offset) {
      context.pushLayer(_backgroundHandle.layer!, super.paint, offset);
    }, offset);
  }
}

class _AdjustRatingIntent extends Intent {
  const _AdjustRatingIntent({
    required this.type,
  });

  const _AdjustRatingIntent.left() : type = _RatingAdjustmentType.left;

  const _AdjustRatingIntent.right() : type = _RatingAdjustmentType.right;

  final _RatingAdjustmentType type;
}

enum _RatingAdjustmentType { left, right }
