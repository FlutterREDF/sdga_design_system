part of 'sdga_modal.dart';

const double _kHandleHeight = 4.0;
const double _kHandleWidth = 36.0;
const double _kPadding = SDGANumbers.spacingMD;

enum _HeaderSlot { notch, title, leading, trailing }

class _ModalHeader
    extends SlottedMultiChildRenderObjectWidget<_HeaderSlot, RenderBox> {
  const _ModalHeader({
    required this.notch,
    this.title,
    this.leading,
    this.trailing,
  });

  final Widget notch;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Iterable<_HeaderSlot> get slots => _HeaderSlot.values;

  @override
  Widget? childForSlot(_HeaderSlot slot) {
    switch (slot) {
      case _HeaderSlot.notch:
        return notch;
      case _HeaderSlot.title:
        return title;
      case _HeaderSlot.leading:
        return leading;
      case _HeaderSlot.trailing:
        return trailing;
    }
  }

  @override
  SlottedContainerRenderObjectMixin<_HeaderSlot, RenderBox> createRenderObject(
    BuildContext context,
  ) {
    return _RenderModalHeader();
  }
}

class _RenderModalHeader extends RenderBox
    with SlottedContainerRenderObjectMixin<_HeaderSlot, RenderBox> {
  _RenderModalHeader();
  // Getters to simplify accessing the slotted children.
  RenderBox? get _notch => childForSlot(_HeaderSlot.notch);
  RenderBox? get _title => childForSlot(_HeaderSlot.title);
  RenderBox? get _leading => childForSlot(_HeaderSlot.leading);
  RenderBox? get _trailing => childForSlot(_HeaderSlot.trailing);

  // Returns children in hit test order.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (_notch != null) _notch!,
      if (_leading != null) _leading!,
      if (_trailing != null) _trailing!,
      if (_title != null) _title!,
    ];
  }

  @override
  void performLayout() {
    const BoxConstraints childConstraints = BoxConstraints();

    Size layout(RenderBox? child, [BoxConstraints? constraints]) {
      if (child == null) return Size.zero;
      child.layout(constraints ?? childConstraints, parentUsesSize: true);
      return child.size;
    }

    Size notchSize = layout(_notch);
    Size leadingSize = layout(_leading);
    Size trailingSize = layout(_trailing);
    final double actionWidth = math.max(leadingSize.width, trailingSize.width);
    double titleWidth = constraints.maxWidth - actionWidth * 2 - _kPadding * 2;
    Size titleSize = layout(_title, BoxConstraints(maxWidth: titleWidth));

    if (titleWidth == double.infinity) titleWidth = titleSize.width;
    final double height = math.max(
        titleSize.height, math.max(leadingSize.height, trailingSize.height));
    final double width = titleWidth + actionWidth * 2 + _kPadding * 2;

    _positionChild(
      _notch,
      Offset((width - notchSize.width) / 2, 0),
    );
    _positionChild(
      _leading,
      Offset(0, (height - leadingSize.height) / 2 + notchSize.height),
    );
    _positionChild(
      _trailing,
      Offset(width - trailingSize.width,
          (height - trailingSize.height) / 2 + notchSize.height),
    );
    _positionChild(
      _title,
      Offset(
        actionWidth + _kPadding + (titleWidth - titleSize.width) / 2,
        (height - titleSize.height) / 2 + notchSize.height,
      ),
    );

    size = constraints.constrain(Size(width, notchSize.height + height));
  }

  void _positionChild(RenderBox? child, Offset offset) {
    if (child != null) (child.parentData! as BoxParentData).offset = offset;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void paintChild(RenderBox? child) {
      if (child == null) return;
      final BoxParentData childParentData = child.parentData! as BoxParentData;
      context.paintChild(child, childParentData.offset + offset);
    }

    // Paint the children at the offset calculated during layout.
    paintChild(_notch);
    paintChild(_leading);
    paintChild(_trailing);
    paintChild(_title);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool hitTestChild(RenderBox? child) {
      if (child == null) return false;
      final BoxParentData childParentData = child.parentData! as BoxParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    }

    return hitTestChild(_notch) ||
        hitTestChild(_leading) ||
        hitTestChild(_trailing) ||
        hitTestChild(_title);
  }
}

class _ModalNotch extends StatefulWidget {
  const _ModalNotch();

  @override
  State<_ModalNotch> createState() => _ModalNotchState();
}

class _ModalNotchState extends State<_ModalNotch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250));
  bool _isGrabbing = false;

  @override
  void initState() {
    _controller.addListener(
      () {
        final _ModalExtent? extent =
            _ModalExtentWrapper.maybeOf(context)?.extent;
        extent?._currentSize.value = _controller.value;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final _ModalExtent? extent = _ModalExtentWrapper.maybeOf(context)?.extent;
    extent?.animationController = _controller;
    final Widget child = Container(
      margin: const EdgeInsets.symmetric(vertical: SDGANumbers.spacingMD),
      width: _kHandleWidth,
      height: _kHandleHeight,
      decoration: BoxDecoration(
        color: colors.borders.neutralPrimary,
        borderRadius: const BorderRadius.all(
          Radius.circular(SDGANumbers.radiusExtraSmall),
        ),
      ),
    );
    final TargetPlatform platform = Theme.of(context).platform;

    if (extent == null ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.android) {
      return child;
    }
    return MouseRegion(
      cursor:
          _isGrabbing ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) {
          setState(() => _isGrabbing = true);
        },
        onVerticalDragEnd: (details) {
          if ((details.velocity.pixelsPerSecond.dy > 1500 &&
                  extent.shouldCloseOnMinExtent) ||
              (extent.currentSize < extent.minSize * 0.8)) {
            Navigator.pop(context);
            return;
          } else if (extent.snap) {
            final snapTo =
                extent.getSnapSize(details.velocity.pixelsPerSecond.dy);
            if (extent.currentSize != snapTo) {
              _controller.value = extent.currentSize;
              _controller.animateTo(snapTo);
            }
          } else if (extent.currentSize < extent.minSize) {
            _controller.value = extent.currentSize;
            _controller.animateTo(extent.minSize);
          } else if (extent.currentSize > extent.maxSize) {
            _controller.value = extent.currentSize;
            _controller.animateTo(extent.maxSize);
          }

          setState(() => _isGrabbing = false);
        },
        onVerticalDragUpdate: (details) =>
            _onVerticalDragUpdate(details, extent),
        child: child,
      ),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, _ModalExtent extent) {
    double current = extent._currentSize.value ?? extent.maxSize;
    current -= details.delta.dy / extent.availablePixels;
    extent._currentSize.value = current.clamp(0, extent.maxSize);
  }
}
