part of 'sdga_stepper.dart';

class _StepperParentData extends ContainerBoxParentData<RenderBox> {}

typedef _ChildSizingFunction = double Function(RenderBox child, double extent);

class _Stepper extends MultiChildRenderObjectWidget {
  const _Stepper({
    super.children,
    this.direction = Axis.horizontal,
    this.constraints,
    this.padding = SDGANumbers.spacingXL,
  });

  final Axis direction;
  final double padding;
  final BoxConstraints? constraints;

  @override
  _RenderStepper createRenderObject(BuildContext context) {
    return _RenderStepper(
      textDirection: Directionality.maybeOf(context),
      direction: direction,
      padding: padding,
      childConstraints: constraints,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderStepper renderObject) {
    renderObject
      .._textDirection = Directionality.maybeOf(context)
      .._direction = direction
      .._padding = padding
      .._childConstraints = constraints
      ..markNeedsLayout();
  }
}

class _RenderStepper extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _StepperParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _StepperParentData>,
        DebugOverflowIndicatorMixin {
  _RenderStepper({
    required double padding,
    Axis direction = Axis.horizontal,
    TextDirection? textDirection,
    BoxConstraints? childConstraints,
    List<RenderBox>? children,
  })  : _padding = padding,
        _direction = direction,
        _textDirection = textDirection,
        _childConstraints = childConstraints {
    addAll(children);
  }

  double _padding;
  Axis _direction;
  TextDirection? _textDirection;
  BoxConstraints? _childConstraints;

  // Set during layout if overflow occurred on the main axis.
  double _overflow = 0;
  // Check whether any meaningful overflow is present. Values below an epsilon
  // are treated as not overflowing.
  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _StepperParentData) {
      child.parentData = _StepperParentData();
    }
  }

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double
        extent, // the extent in the direction that isn't the sizing direction
    required _ChildSizingFunction
        childSize, // a method to find the size in the sizing direction
  }) {
    if (_direction == sizingDirection) {
      // INTRINSIC MAIN SIZE
      // Intrinsic main size is the smallest size the flex container can take
      // while maintaining the min/max-content contributions of its flex items.
      double totalFlex = 0.0;
      double inflexibleSpace = 0.0;
      double maxFlexFractionSoFar = 0.0;
      for (RenderBox? child = firstChild;
          child != null;
          child = childAfter(child)) {
        final int flex = _getFlex(child);
        totalFlex += flex;
        if (flex > 0) {
          final double flexFraction = childSize(child, extent) / flex;
          maxFlexFractionSoFar = math.max(maxFlexFractionSoFar, flexFraction);
        } else {
          inflexibleSpace += childSize(child, extent);
        }
      }
      return maxFlexFractionSoFar * totalFlex + inflexibleSpace;
    } else {
      // INTRINSIC CROSS SIZE
      // Intrinsic cross size is the max of the intrinsic cross sizes of the
      // children, after the flexible children are fit into the available space,
      // with the children sized using their max intrinsic dimensions.
      final bool isHorizontal = _direction == Axis.horizontal;

      Size layoutChild(RenderBox child, BoxConstraints constraints) {
        final double mainAxisSizeFromConstraints =
            isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        final double maxMainAxisSize = mainAxisSizeFromConstraints.isFinite
            ? mainAxisSizeFromConstraints
            : (isHorizontal
                ? child.getMaxIntrinsicWidth(double.infinity)
                : child.getMaxIntrinsicHeight(double.infinity));
        return isHorizontal
            ? Size(maxMainAxisSize, childSize(child, maxMainAxisSize))
            : Size(childSize(child, maxMainAxisSize), maxMainAxisSize);
      }

      return _computeSizes(
        constraints: isHorizontal
            ? BoxConstraints(maxWidth: extent)
            : BoxConstraints(maxHeight: extent),
        layoutChild: layoutChild,
        getBaseline: ChildLayoutHelper.getDryBaseline,
      ).axisSize.crossAxisExtent;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicWidth(extent),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicWidth(extent),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicHeight(extent),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicHeight(extent),
    );
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    switch (_direction) {
      case Axis.horizontal:
        return defaultComputeDistanceToHighestActualBaseline(baseline);
      case Axis.vertical:
        return defaultComputeDistanceToFirstActualBaseline(baseline);
    }
  }

  double _getMainSize(Size size) {
    switch (_direction) {
      case Axis.horizontal:
        return size.width;
      case Axis.vertical:
        return size.height;
    }
  }

  BoxConstraints _constraintsForNonFlexChild(BoxConstraints constraints) {
    switch (_direction) {
      case Axis.horizontal:
        return BoxConstraints(maxHeight: constraints.maxHeight);
      case Axis.vertical:
        return BoxConstraints(maxWidth: constraints.maxWidth);
    }
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      getBaseline: ChildLayoutHelper.getDryBaseline,
    ).axisSize.toSize(_direction);
  }

  _LayoutSizes _computeSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
    required ChildBaselineGetter getBaseline,
  }) {
    final BoxConstraints childConstraints;
    if (_childConstraints != null) {
      final Size padding = Size(_padding, 0).toSize(_direction);
      childConstraints = BoxConstraints(
        minWidth: _childConstraints!.minWidth + padding.width,
        maxWidth: _childConstraints!.maxWidth + padding.width,
        minHeight: _childConstraints!.minHeight + padding.height,
        maxHeight: _childConstraints!.maxHeight + padding.height,
      );
    } else {
      final BoxConstraints nonFlexChildConstraints =
          _constraintsForNonFlexChild(constraints);

      Size largestSize = Size.zero;
      for (RenderBox? child = firstChild;
          child != null;
          child = childAfter(child)) {
        final Size childSize = layoutChild(child, nonFlexChildConstraints);
        largestSize = Size(
          math.max(largestSize.width, childSize.width),
          math.max(largestSize.height, childSize.height),
        );
      }
      final Size padding = Size(_padding, 0).toSize(_direction);
      childConstraints = BoxConstraints.tightFor(
        width: largestSize.width + padding.width,
        height: largestSize.height + padding.height,
      );
    }

    Size accumulatedSize = Size.zero;
    for (RenderBox? child = firstChild;
        child != null;
        child = childAfter(child)) {
      final Size childSize =
          layoutChild(child, childConstraints).toSize(_direction);
      accumulatedSize = Size(
        accumulatedSize.width + childSize.width,
        math.max(accumulatedSize.height, childSize.height),
      );
    }

    final Size constrainedSize =
        accumulatedSize.applyConstraints(constraints, _direction);
    return _LayoutSizes(
      axisSize: constrainedSize,
      mainAxisFreeSpace:
          constrainedSize.mainAxisExtent - accumulatedSize.mainAxisExtent,
    );
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final _LayoutSizes sizes = _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
      getBaseline: ChildLayoutHelper.getBaseline,
    );

    size = sizes.axisSize.toSize(_direction);
    _overflow = math.max(0.0, -sizes.mainAxisFreeSpace);

    final double remainingSpace = math.max(0.0, sizes.mainAxisFreeSpace);
    final bool flipMainAxis =
        _textDirection == TextDirection.rtl && _direction == Axis.horizontal;
    final RenderBox? Function(RenderBox child) nextChild =
        flipMainAxis ? childBefore : childAfter;
    final RenderBox? topLeftChild = flipMainAxis ? lastChild : firstChild;
    double childMainPosition = flipMainAxis ? remainingSpace : 0;

    for (RenderBox? child = topLeftChild;
        child != null;
        child = nextChild(child)) {
      final _StepperParentData childParentData =
          child.parentData! as _StepperParentData;
      switch (_direction) {
        case Axis.horizontal:
          childParentData.offset = Offset(childMainPosition, 0.0);
          break;
        case Axis.vertical:
          childParentData.offset = Offset(0.0, childMainPosition);
          break;
      }
      childMainPosition += _getMainSize(child.size);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      _paint(context, offset);
      return;
    }

    // There's no point in drawing the children if we're empty.
    if (size.isEmpty) {
      return;
    }

    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      _paint,
      clipBehavior: Clip.none,
      oldLayer: _clipRectLayer.layer,
    );

    assert(() {
      final List<DiagnosticsNode> debugOverflowHints = <DiagnosticsNode>[
        ErrorDescription(
          'The overflowing $runtimeType has an orientation of $_direction.',
        ),
        ErrorDescription(
          'The edge of the $runtimeType that is overflowing has been marked '
          'in the rendering with a yellow and black striped pattern. This is '
          'usually caused by the contents being too big for the $runtimeType.',
        ),
      ];

      // Simulate a child rect that overflows by the right amount. This child
      // rect is never used for drawing, just for determining the overflow
      // location and amount.

      final Rect overflowChildRect;
      switch (_direction) {
        case Axis.horizontal:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0);
          break;
        case Axis.vertical:
          overflowChildRect =
              Rect.fromLTWH(0.0, 0.0, 0.0, size.height + _overflow);
          break;
      }
      paintOverflowIndicator(
          context, offset, Offset.zero & size, overflowChildRect,
          overflowHints: debugOverflowHints);
      return true;
    }());
  }

  void _paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _StepperParentData childParentData =
          child.parentData! as _StepperParentData;
      context.paintChild(child, childParentData.offset + offset);
      // context.canvas.drawRect(
      //   (childParentData.offset + offset) & child.size,
      //   Paint()
      //     ..color = Colors.red
      //     ..style = PaintingStyle.stroke,
      // );
      child = childParentData.nextSibling;
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }

  static int _getFlex(RenderBox child) {
    return 0;
  }
}

extension _SizeExt on Size {
  double get mainAxisExtent => width;
  double get crossAxisExtent => height;

  Size toSize(Axis direction) => _convert(this, direction);

  Size applyConstraints(BoxConstraints constraints, Axis direction) {
    final BoxConstraints effectiveConstraints;
    switch (direction) {
      case Axis.horizontal:
        effectiveConstraints = constraints;
        break;
      case Axis.vertical:
        effectiveConstraints = constraints.flipped;
        break;
    }

    return effectiveConstraints.constrain(this);
  }

  static Size _convert(Size size, Axis direction) {
    switch (direction) {
      case Axis.horizontal:
        return size;
      case Axis.vertical:
        return size.flipped;
    }
  }
}

class _LayoutSizes {
  _LayoutSizes({
    required this.axisSize,
    required this.mainAxisFreeSpace,
  });

  final Size axisSize;

  final double mainAxisFreeSpace;
}
