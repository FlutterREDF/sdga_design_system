part of 'sdga_modal.dart';

/// A modified version of [DraggableScrollableSheet] that automatically calculate
/// the child height and use that as maxExtent
class SDGADraggableScrollable extends StatefulWidget {
  const SDGADraggableScrollable({
    super.key,
    this.shouldCloseOnMinExtent = true,
    required this.builder,
    this.snap = true,
    this.minExtent,
    this.padding,
  })  : assert(minExtent == null || 0.0 <= minExtent),
        assert(minExtent == null || minExtent <= 1.0);

  /// Whether the sheet, when dragged (or flung) to its minimum size, should
  /// cause its parent sheet to close.
  final bool shouldCloseOnMinExtent;

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [ScrollController] to enable dragging and scrolling
  /// of the contents.
  final ScrollableWidgetBuilder builder;

  /// Whether the widget should snap between [minExtent] and maxSize when the user lifts
  /// their finger during a drag.
  ///
  /// If the user's finger was still moving when they lifted it, the widget will
  /// snap to the next snap size in the direction of the drag.
  /// If their finger was still, the widget will snap to the nearest snap size.
  final bool snap;

  /// The minimum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  /// The maximum extent will be calculated based on the child widget, if the max
  /// extent is less than [minExtent], the maxExtent value will be used instead of this.
  ///
  /// If this is null, the [minExtent] will be same value as maxExtent.
  final double? minExtent;

  /// The padding to be applied to this modal.
  ///
  /// If this is null, the modal will be padded with a top margin of
  /// `kToolbarHeight + MediaQuery.viewInsetsOf(context).top` to ensure it
  /// appears above the app bar and status bar.
  final EdgeInsetsGeometry? padding;

  @override
  State<SDGADraggableScrollable> createState() =>
      _SDGADraggableScrollableState();
}

class _SDGADraggableScrollableState extends State<SDGADraggableScrollable> {
  late _ModalScrollController _scrollController;
  late _ModalExtent _extent;

  @override
  void initState() {
    super.initState();
    _extent = _ModalExtent(
      snap: widget.snap,
      minChildSize: widget.minExtent,
      shouldCloseOnMinExtent: widget.shouldCloseOnMinExtent,
    );
    _scrollController = _ModalScrollController(extent: _extent);
  }

  @override
  void dispose() {
    _extent.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ModalExtentWrapper(
      extent: _extent,
      child: ValueListenableBuilder<double?>(
        valueListenable: _extent._currentSize,
        builder: (BuildContext context, double? currentSize, Widget? child) {
          return _ModalContainer(
            extent: _extent,
            currentSize: currentSize,
            padding: widget.padding ??
                EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.viewInsetsOf(context).top,
                ),
            child: child,
          );
        },
        child: widget.builder(context, _scrollController),
      ),
    );
  }
}

class _ModalExtentWrapper extends InheritedWidget {
  const _ModalExtentWrapper({
    required super.child,
    required this.extent,
  });

  final _ModalExtent extent;

  @override
  bool updateShouldNotify(covariant _ModalExtentWrapper oldWidget) {
    return false;
  }

  static _ModalExtentWrapper? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ModalExtentWrapper>();
}

class _ModalContainer extends SingleChildRenderObjectWidget {
  const _ModalContainer({
    super.child,
    required this.extent,
    this.currentSize,
    required this.padding,
  });
  final _ModalExtent extent;
  final double? currentSize;
  final EdgeInsetsGeometry padding;

  @override
  _RenderModalContainer createRenderObject(BuildContext context) {
    return _RenderModalContainer(
      extent: extent,
      padding: padding,
      currentSize: currentSize,
      decoration: _getDecoration(context),
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderModalContainer renderObject) {
    renderObject
      ..extent = extent
      ..padding = padding
      ..currentSize = currentSize
      ..decoration = _getDecoration(context)
      ..textDirection = Directionality.maybeOf(context);
  }

  BoxDecoration _getDecoration(BuildContext context) => BoxDecoration(
        boxShadow: SDGAShadows.shadow3XL,
        color: SDGAColorScheme.of(context).backgrounds.menu,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SDGANumbers.radiusLarge),
          topRight: Radius.circular(SDGANumbers.radiusLarge),
        ),
      );
}

class _RenderModalContainer extends RenderShiftedBox {
  _RenderModalContainer({
    RenderBox? child,
    required _ModalExtent extent,
    required EdgeInsetsGeometry padding,
    required BoxDecoration decoration,
    double? currentSize,
    required TextDirection? textDirection,
  })  : _extent = extent,
        _padding = padding,
        _decoration = decoration,
        _painter = decoration.createBoxPainter(),
        _currentSize = currentSize,
        _textDirection = textDirection,
        super(child);

  BoxPainter? _painter;
  double? _heightFactor;
  double? _currentSize;
  double? get currentSize => _currentSize;
  set currentSize(double? value) {
    if (_currentSize == value) return;
    _currentSize = value;
    markNeedsLayout();
  }

  _ModalExtent _extent;
  _ModalExtent get extent => _extent;
  set extent(_ModalExtent value) {
    if (_extent == value) return;
    _extent = value;
    markNeedsLayout();
  }

  EdgeInsetsGeometry _padding;
  EdgeInsetsGeometry get padding => _padding;
  set padding(EdgeInsetsGeometry value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  BoxDecoration _decoration;
  BoxDecoration get decoration => _decoration;
  set decoration(BoxDecoration value) {
    if (_decoration == value) return;
    _painter?.dispose();
    _painter = value.createBoxPainter();
    _decoration = value;
    markNeedsPaint();
  }

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  BoxConstraints _getInnerConstraints(
      BoxConstraints constraints, double horizontalPadding) {
    double minHeight = constraints.minHeight;
    double maxHeight = constraints.maxHeight;
    double? heightFactor = _currentSize ?? _heightFactor;
    if (heightFactor != null) {
      final double height = maxHeight * heightFactor;
      minHeight = height;
      maxHeight = height;
    }
    return BoxConstraints(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth - horizontalPadding,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double result;
    if (child == null) {
      result = super.computeMinIntrinsicWidth(height);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMinIntrinsicWidth(height * (_currentSize ?? 1.0));
    }
    assert(result.isFinite);
    return result;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double result;
    if (child == null) {
      result = super.computeMaxIntrinsicWidth(height);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMaxIntrinsicWidth(height * (_currentSize ?? 1.0));
    }
    assert(result.isFinite);
    return result;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double result;
    if (child == null) {
      result = super.computeMinIntrinsicHeight(width);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMinIntrinsicHeight(width);
    }
    assert(result.isFinite);
    return result / (_currentSize ?? 1.0);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double result;
    if (child == null) {
      result = super.computeMaxIntrinsicHeight(width);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMaxIntrinsicHeight(width);
    }
    assert(result.isFinite);
    return result / (_currentSize ?? 1.0);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (child != null) {
      final Size childSize = child!
          .getDryLayout(_getInnerConstraints(constraints, padding.horizontal));
      return constraints.constrain(childSize);
    }
    return constraints.constrain(
        _getInnerConstraints(constraints, padding.horizontal)
            .constrain(Size.zero));
  }

  @override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final BoxConstraints childConstraints =
        _getInnerConstraints(constraints, padding.horizontal);
    final double? result = child.getDryBaseline(childConstraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(childConstraints);
    final Size size = getDryLayout(constraints);

    return result +
        Alignment.bottomCenter.alongOffset(size - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final EdgeInsets padding = this.padding.resolve(textDirection);
    final BoxConstraints innerConstraints =
        _getInnerConstraints(constraints, padding.horizontal);
    if (child == null) {
      size = innerConstraints
          .constrain(Size(padding.horizontal, padding.vertical));
      return;
    }
    child!.layout(constraints.deflate(padding), parentUsesSize: true);
    final double height = child!.size.height / constraints.biggest.height;
    _heightFactor = height;
    child!.layout(innerConstraints, parentUsesSize: true);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(padding.left, 0);
    size = constraints.constrain(Size(
      padding.horizontal + child!.size.width,
      child!.size.height,
    ));
    final double oldMaxSize = _extent.maxSize;
    final double oldMinSize = _extent.minSize;
    final bool isAtMin = _extent.isAtMin;
    _extent.availablePixels = constraints.maxHeight;
    _extent.initialSize = height.clamp(0.1, 1.0);
    _extent.maxSize = height.clamp(0.1, 1.0);
    _extent.minSize = _extent.minChildSize == null
        ? (_extent.maxSize - 0.1).clamp(0.1, 1.0)
        : _extent.minChildSize!.clamp(0.1, _extent.maxSize);
    if (extent._currentSize.value == null) return;
    if (oldMaxSize != _extent.maxSize || oldMinSize != _extent.minSize) {
      extent.animationController?.value = extent.currentSize;
      if (extent.snap) {
        if (isAtMin) {
          extent.animationController?.animateTo(_extent.minSize);
        } else {
          extent.animationController?.animateTo(_extent.maxSize);
        }
      } else {
        extent.animationController?.animateTo(
          extent.currentSize.clamp(_extent.minSize, _extent.maxSize),
        );
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final EdgeInsets resolvedPadding = padding.resolve(textDirection);
    _painter?.paint(
      context.canvas,
      offset + Offset(resolvedPadding.left, 0),
      ImageConfiguration.empty.copyWith(
        size: size - Offset(resolvedPadding.horizontal, 0) as Size,
      ),
    );

    super.paint(context, offset);
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
  }
}

class _ModalExtent {
  _ModalExtent({
    required this.snap,
    required this.minChildSize,
    this.shouldCloseOnMinExtent = true,
  });

  final bool snap;
  final bool shouldCloseOnMinExtent;
  final ValueNotifier<double?> _currentSize = ValueNotifier<double?>(null);
  final double? minChildSize;
  AnimationController? animationController;
  double minSize = 0.0;
  double maxSize = 1.0;
  double initialSize = 0.5;
  double availablePixels = double.infinity;

  // Used to disable snapping until the user has dragged on the sheet.
  bool hasDragged = false;

  bool get isAtMin => minSize >= currentSize;
  bool get isAtMax => maxSize <= currentSize;

  double get currentSize => _currentSize.value ?? maxSize;
  double get currentPixels => sizeToPixels(currentSize);

  List<double> get snapSizes => [minSize, maxSize];

  List<double> get pixelSnapSizes => snapSizes.map(sizeToPixels).toList();

  /// The scroll position gets inputs in terms of pixels, but the size is
  /// expected to be expressed as a number between 0..1.
  ///
  /// This should only be called to respond to a user drag. To update the
  /// size in response to a programmatic call, use [updateSize] directly.
  void addPixelDelta(double delta, BuildContext context) {
    // The user has interacted with the sheet, set `hasDragged` to true so that
    // we'll snap if applicable.
    hasDragged = true;
    if (availablePixels == 0) {
      return;
    }
    updateSize(currentSize + pixelsToSize(delta), context);
  }

  /// Set the size to the new value. [newSize] should be a number between
  /// [minSize] and [maxSize].
  ///
  /// This can be triggered by a programmatic (e.g. controller triggered) change
  /// or a user drag.
  void updateSize(double newSize, BuildContext context) {
    final double clampedSize = clampDouble(newSize, minSize, maxSize);
    if (_currentSize.value == clampedSize) {
      return;
    }
    _currentSize.value = clampedSize;
    //TODO change
    DraggableScrollableNotification(
      minExtent: minSize,
      maxExtent: maxSize,
      extent: currentSize,
      initialExtent: initialSize,
      context: context,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent,
    ).dispatch(context);
  }

  double pixelsToSize(double pixels) {
    return pixels / availablePixels * maxSize;
  }

  double sizeToPixels(double size) {
    return size / maxSize * availablePixels;
  }

  double getSnapSize([double velocity = 0]) {
    final int indexOfNextSize =
        snapSizes.indexWhere((double size) => size >= currentSize);
    if (indexOfNextSize <= 0) {
      return snapSizes.last;
    }
    final double size = currentSize - velocity;
    final double nextSize = snapSizes[indexOfNextSize];
    final double previousSize = snapSizes[indexOfNextSize - 1];
    if (size - previousSize < nextSize - size) {
      return previousSize;
    } else {
      return nextSize;
    }
  }

  void dispose() {
    _currentSize.dispose();
  }
}

class _ModalScrollController extends ScrollController {
  _ModalScrollController({
    required this.extent,
  });

  _ModalExtent extent;
  VoidCallback? onPositionDetached;

  @override
  _ModalScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _ModalScrollPosition(
      physics: physics.applyTo(const AlwaysScrollableScrollPhysics()),
      context: context,
      oldPosition: oldPosition,
      getExtent: () => extent,
    );
  }

  @override
  _ModalScrollPosition get position => super.position as _ModalScrollPosition;

  @override
  void detach(ScrollPosition position) {
    onPositionDetached?.call();
    super.detach(position);
  }
}

class _ModalScrollPosition extends ScrollPositionWithSingleContext {
  _ModalScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    required this.getExtent,
  });

  VoidCallback? _dragCancelCallback;
  final _ModalExtent Function() getExtent;
  final Set<AnimationController> _ballisticControllers =
      <AnimationController>{};
  bool get listShouldScroll => pixels > 0.0;

  _ModalExtent get extent => getExtent();

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    assert(_dragCancelCallback == null);

    if (other is! _ModalScrollPosition) {
      return;
    }

    if (other._dragCancelCallback != null) {
      _dragCancelCallback = other._dragCancelCallback;
      other._dragCancelCallback = null;
    }
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    // Cancel the running ballistic simulations
    for (final AnimationController ballisticController
        in _ballisticControllers) {
      ballisticController.stop();
    }
    super.beginActivity(newActivity);
  }

  @override
  void applyUserOffset(double delta) {
    if (!listShouldScroll &&
        (!(extent.isAtMin || extent.isAtMax) ||
            (extent.isAtMin && delta < 0) ||
            (extent.isAtMax && delta > 0))) {
      extent.addPixelDelta(-delta, context.notificationContext!);
    } else {
      super.applyUserOffset(delta);
    }
  }

  bool get _isAtSnapSize {
    return extent.snapSizes.any(
      (double snapSize) {
        return (extent.currentSize - snapSize).abs() <=
            extent.pixelsToSize(physics.toleranceFor(this).distance);
      },
    );
  }

  bool get _shouldSnap => extent.snap && extent.hasDragged && !_isAtSnapSize;

  @override
  void dispose() {
    for (final AnimationController ballisticController
        in _ballisticControllers) {
      ballisticController.dispose();
    }
    _ballisticControllers.clear();
    super.dispose();
  }

  @override
  void goBallistic(double velocity) {
    if ((velocity == 0.0 && !_shouldSnap) ||
        (velocity < 0.0 && listShouldScroll) ||
        (velocity > 0.0 && extent.isAtMax)) {
      super.goBallistic(velocity);
      return;
    }
    // Scrollable expects that we will dispose of its current _dragCancelCallback
    _dragCancelCallback?.call();
    _dragCancelCallback = null;

    late final Simulation simulation;
    if (extent.snap) {
      // Snap is enabled, simulate snapping instead of clamping scroll.
      simulation = _SnappingSimulation(
        position: extent.currentPixels,
        initialVelocity: velocity,
        pixelSnapSize: extent.pixelSnapSizes,
        tolerance: physics.toleranceFor(this),
      );
    } else {
      // The iOS bouncing simulation just isn't right here - once we delegate
      // the ballistic back to the ScrollView, it will use the right simulation.
      simulation = ClampingScrollSimulation(
        // Run the simulation in terms of pixels, not extent.
        position: extent.currentPixels,
        velocity: velocity,
        tolerance: physics.toleranceFor(this),
      );
    }

    final AnimationController ballisticController =
        AnimationController.unbounded(
      vsync: context.vsync,
    );
    _ballisticControllers.add(ballisticController);

    double lastPosition = extent.currentPixels;
    void tick() {
      final double delta = ballisticController.value - lastPosition;
      lastPosition = ballisticController.value;
      extent.addPixelDelta(delta, context.notificationContext!);
      if ((velocity > 0 && extent.isAtMax) ||
          (velocity < 0 && extent.isAtMin)) {
        // Make sure we pass along enough velocity to keep scrolling - otherwise
        // we just "bounce" off the top making it look like the list doesn't
        // have more to scroll.
        velocity = ballisticController.velocity +
            (physics.toleranceFor(this).velocity *
                ballisticController.velocity.sign);
        super.goBallistic(velocity);
        ballisticController.stop();
      } else if (ballisticController.isCompleted) {
        super.goBallistic(0);
      }
    }

    ballisticController
      ..addListener(tick)
      ..animateWith(simulation).whenCompleteOrCancel(
        () {
          if (_ballisticControllers.contains(ballisticController)) {
            _ballisticControllers.remove(ballisticController);
            ballisticController.dispose();
          }
        },
      );
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    // Save this so we can call it later if we have to [goBallistic] on our own.
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }
}

class _SnappingSimulation extends Simulation {
  _SnappingSimulation({
    required this.position,
    required double initialVelocity,
    required List<double> pixelSnapSize,
    super.tolerance,
  }) {
    _pixelSnapSize = _getSnapSize(initialVelocity, pixelSnapSize);

    if (_pixelSnapSize < position) {
      velocity = math.min(-minimumSpeed, initialVelocity);
    } else {
      velocity = math.max(minimumSpeed, initialVelocity);
    }
  }

  final double position;
  late final double velocity;

  // A minimum speed to snap at. Used to ensure that the snapping animation
  // does not play too slowly.
  static const double minimumSpeed = 1600.0;

  late final double _pixelSnapSize;

  @override
  double dx(double time) {
    if (isDone(time)) {
      return 0;
    }
    return velocity;
  }

  @override
  bool isDone(double time) {
    return x(time) == _pixelSnapSize;
  }

  @override
  double x(double time) {
    final double newPosition = position + velocity * time;
    if ((velocity >= 0 && newPosition > _pixelSnapSize) ||
        (velocity < 0 && newPosition < _pixelSnapSize)) {
      // We're passed the snap size, return it instead.
      return _pixelSnapSize;
    }
    return newPosition;
  }

  // Find the two closest snap sizes to the position. If the velocity is
  // non-zero, select the size in the velocity's direction. Otherwise,
  // the nearest snap size.
  double _getSnapSize(double initialVelocity, List<double> pixelSnapSizes) {
    final int indexOfNextSize =
        pixelSnapSizes.indexWhere((double size) => size >= position);
    if (indexOfNextSize == 0) {
      return pixelSnapSizes.first;
    }
    final double nextSize = pixelSnapSizes[indexOfNextSize];
    final double previousSize = pixelSnapSizes[indexOfNextSize - 1];
    if (initialVelocity.abs() <= tolerance.velocity) {
      // If velocity is zero, snap to the nearest snap size with the minimum velocity.
      if (position - previousSize < nextSize - position) {
        return previousSize;
      } else {
        return nextSize;
      }
    }
    // Snap forward or backward depending on current velocity.
    if (initialVelocity < 0.0) {
      return pixelSnapSizes[indexOfNextSize - 1];
    }
    return pixelSnapSizes[indexOfNextSize];
  }
}
