part of 'sdga_stepper.dart';

const double _kCircleDimension = 32.0;
const double _kDotDimension = 16.0;

enum _State { current, completed, upcoming }

class _Step extends StatefulWidget {
  const _Step({
    super.key,
    this.direction = Axis.horizontal,
    required this.step,
    required this.index,
    required this.currentIndex,
    this.selectedIndex,
    this.lastSelectedIndex,
    this.isCircle = true,
    this.lastStep = false,
    required this.currentStepIndex,
    required this.selectedValue,
    this.onSelected,
    this.scrollAlignment = 0.5,
  });

  final Axis direction;
  final SDGAStep step;
  final int index;
  final int currentIndex;
  final int? selectedIndex;
  final int? lastSelectedIndex;
  final bool isCircle;
  final bool lastStep;
  final Animation<double> currentStepIndex;
  final Animation<double> selectedValue;
  final VoidCallback? onSelected;
  final double scrollAlignment;

  @override
  State<_Step> createState() => __StepState();
}

class __StepState extends State<_Step> {
  final WidgetStatesController _controller = WidgetStatesController();
  bool get _upcoming => widget.index > widget.currentIndex;
  bool get _selected =>
      (widget.index == widget.currentIndex && widget.selectedIndex == null) ||
      widget.index == widget.selectedIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _Step oldWidget) {
    if ((widget.index == widget.currentIndex &&
            widget.index != oldWidget.currentIndex) ||
        (widget.index == widget.selectedIndex &&
            widget.index != oldWidget.selectedIndex)) {
      Scrollable.ensureVisible(
        context,
        alignment: widget.scrollAlignment,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final TextStyle titleStyle = _selected
        ? SDGATextStyles.textMediumMedium
        : SDGATextStyles.textMediumRegular;

    return SDGAAction(
      statesController: _controller,
      onTap: widget.onSelected,
      child: Flex(
        direction: widget.direction == Axis.horizontal
            ? Axis.vertical
            : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              final _StepData data = SDGAUtils.resolveWidgetStateUnordered(
                _controller.value,
                fallback: _StepData(
                  index: widget.index,
                  direction: widget.direction,
                  isCircle: widget.isCircle,
                  lastStep: widget.lastStep,
                  selected: _selected,
                  wasSelected: widget.index == widget.lastSelectedIndex,
                  textColorCompleted: colors.icons.onColor,
                  fillColorCompleted: colors.steppers.buttonCompleted,
                  fillColorSelected: colors.steppers.buttonCurrent,
                  fillColorUpcoming: colors.steppers.buttonUpcomming,
                  lineColorCompleted: colors.steppers.lineCompleted,
                  lineColorSelected: colors.steppers.lineCurrent,
                  lineColorUpcoming: colors.steppers.lineUpcomming,
                ),
                hovered: _StepData(
                  index: widget.index,
                  direction: widget.direction,
                  isCircle: widget.isCircle,
                  lastStep: widget.lastStep,
                  selected: _selected,
                  wasSelected: widget.index == widget.lastSelectedIndex,
                  textColorCompleted: colors.icons.onColor,
                  fillColorCompleted: colors.steppers.buttonCompletedHovered,
                  fillColorSelected: colors.steppers.buttonCurrentHovered,
                  fillColorUpcoming: colors.steppers.buttonUpcommingHovered,
                  lineColorCompleted: colors.steppers.lineCompletedHovered,
                  lineColorSelected: colors.steppers.lineCurrent,
                  lineColorUpcoming: colors.steppers.lineUpcommingHovered,
                ),
              );
              return _StepIndicator(
                data: data,
                currentStepIndex: widget.currentStepIndex,
                selectedValue: widget.selectedValue,
              );
            },
          ),
          if (widget.step.title != null || widget.step.description != null)
            const SizedBox.square(dimension: SDGANumbers.spacingMD),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              final bool focused =
                  _controller.value.contains(WidgetState.focused);
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: focused
                      ? Border.all(
                          color: colors.borders.black,
                          width: 2,
                          strokeAlign: -1)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.step.title != null)
                  AnimatedDefaultTextStyle(
                    key: SaltedKey(context, 'title'),
                    duration: _kSelectedStepDuration,
                    style: titleStyle.copyWith(
                        color: _upcoming
                            ? colors.steppers.textSecondary
                            : colors.steppers.textPrimary),
                    child: Text(widget.step.title!),
                  ),
                if (widget.step.title != null &&
                    widget.step.description != null)
                  const SizedBox(height: SDGANumbers.spacingXS),
                if (widget.step.description != null)
                  AnimatedDefaultTextStyle(
                    key: SaltedKey(context, 'description'),
                    duration: _kSelectedStepDuration,
                    style: SDGATextStyles.textSmallRegular
                        .copyWith(color: colors.steppers.textSecondary),
                    child: Text(widget.step.description!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends LeafRenderObjectWidget {
  const _StepIndicator({
    required this.data,
    required this.currentStepIndex,
    required this.selectedValue,
  });

  final _StepData data;
  final Animation<double> currentStepIndex;
  final Animation<double> selectedValue;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderStep(
      data: data,
      currentStepIndex: currentStepIndex,
      selectedValue: selectedValue,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderStep renderObject) {
    renderObject
      ..data = data
      ..currentStepIndex = currentStepIndex
      ..selectedValue = selectedValue;
  }
}

class _RenderStep extends RenderBox {
  _RenderStep({
    required _StepData data,
    required Animation<double> currentStepIndex,
    required Animation<double> selectedValue,
  })  : _data = data,
        _currentStepIndex = currentStepIndex,
        _selectedValue = selectedValue {
    currentStepIndex.addListener(_updateCurrentStepIndex);
    selectedValue.addListener(_updateSelectedValue);
    _setupParagraph();
    // Using final so the icon doesn't get deleted with tree shaking
    // ignore: prefer_const_declarations
    final IconData icon = SDGAIconsStroke.tick02;
    final ParagraphBuilder builder = ParagraphBuilder(
      TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontSize: 16.0,
      ).getParagraphStyle(textAlign: TextAlign.center),
    );
    builder.addText(String.fromCharCode(icon.codePoint));
    _tickParagraph = builder.build()
      ..layout(const ParagraphConstraints(width: _kCircleDimension));
  }

  @override
  bool get isRepaintBoundary => true;

  final LayerHandle<ColorFilterLayer> _textHandle =
      LayerHandle<ColorFilterLayer>();
  final LayerHandle<ColorFilterLayer> _overTextHandle =
      LayerHandle<ColorFilterLayer>();
  final LayerHandle<ClipRectLayer> _clipRectHandle =
      LayerHandle<ClipRectLayer>();

  late Paragraph _tickParagraph;
  Paragraph? _paragraph;

  Animation<double> get currentStepIndex => _currentStepIndex!;
  Animation<double>? _currentStepIndex;
  set currentStepIndex(Animation<double> value) {
    if (value == _currentStepIndex) {
      return;
    }
    _currentStepIndex?.removeListener(_updateCurrentStepIndex);
    value.addListener(_updateCurrentStepIndex);
    _currentStepIndex = value;
    _updateCurrentStepIndex();
  }

  Animation<double> get selectedValue => _selectedValue!;
  Animation<double>? _selectedValue;
  set selectedValue(Animation<double> value) {
    if (value == _selectedValue) {
      return;
    }
    _selectedValue?.removeListener(_updateSelectedValue);
    value.addListener(_updateSelectedValue);
    _selectedValue = value;
    _updateCurrentStepIndex();
  }

  _StepData get data => _data;
  _StepData _data;
  set data(_StepData value) {
    if (_data != value) {
      final bool needsLayout = _StepData.needsUpdateLayout(_data, value);
      final bool updateParagraph = _StepData.needsUpdateParagraph(_data, value);
      _data = value;
      if (updateParagraph) _setupParagraph();
      if (needsLayout) {
        markNeedsLayout();
      } else {
        markNeedsPaint();
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double dimension = data.isCircle ? _kCircleDimension : _kDotDimension;
    final double animationValue =
        (currentStepIndex.value - data.index).clamp(0, 1);
    _drawLine(context, offset, animationValue);

    if (animationValue == 0) {
      _drawIndicator(context, offset, _State.upcoming);
    } else if (animationValue < 0.5) {
      // Animating from upcoming to current
      final double progress = (animationValue * 4).clamp(0, 1);
      final bool isHorizontal = data.direction == Axis.horizontal;
      final Offset progressOffset =
          Offset(isHorizontal ? progress : 1, isHorizontal ? 1 : progress);

      _drawIndicator(context, offset, _State.upcoming);
      _clipRectHandle.layer ??= ClipRectLayer();
      _clipRectHandle.layer!.clipRect = offset &
          Size(
            dimension * progressOffset.dx,
            dimension * progressOffset.dy,
          );
      context.pushLayer(_clipRectHandle.layer!, (context, offset) {
        _drawIndicator(context, offset, _State.current, true);
      }, offset);
    } else if (animationValue == 0.5) {
      _drawIndicator(context, offset, _State.current);
    } else if (animationValue > 0.5 && animationValue < 1) {
      // Animating from current to completed
      final double progress = ((animationValue - 0.5) * 4).clamp(0, 1);
      final bool isHorizontal = data.direction == Axis.horizontal;
      final Offset progressOffset =
          Offset(isHorizontal ? progress : 1, isHorizontal ? 1 : progress);
      _drawIndicator(context, offset, _State.current);

      _clipRectHandle.layer ??= ClipRectLayer();
      _clipRectHandle.layer!.clipRect = offset &
          Size(
            dimension * progressOffset.dx,
            dimension * progressOffset.dy,
          );
      context.pushLayer(_clipRectHandle.layer!, (context, offset) {
        _drawIndicator(context, offset, _State.completed, true);
      }, offset);
    } else {
      _drawIndicator(context, offset, _State.completed);
    }
  }

  void _drawIndicator(PaintingContext context, Offset offset, _State state,
      [bool secondLayer = false]) {
    final double dimension = data.isCircle ? _kCircleDimension : _kDotDimension;
    final Offset center = offset + Offset(dimension / 2, dimension / 2);
    final bool completed = state == _State.completed;
    final bool selected =
        data.selected || (data.wasSelected && selectedValue.isAnimating);
    final Color fillColor;
    switch (state) {
      case _State.current:
        fillColor = data.fillColorSelected;
        break;
      case _State.completed:
        fillColor = data.fillColorCompleted;
        break;
      case _State.upcoming:
        fillColor = data.fillColorUpcoming;
        break;
    }
    Color textColor =
        state == _State.completed ? data.textColorCompleted : fillColor;

    if (completed && selected && !currentStepIndex.isAnimating) {
      _drawCircle(
        context,
        center,
        radius: dimension / 2,
        strokeWidth: data.wasSelected
            ? lerpDouble(2, dimension / 2, selectedValue.value)!
            : lerpDouble(dimension / 2, 2, selectedValue.value)!,
        color: fillColor,
        filled: false,
      );
      if (data.selected) {
        textColor =
            Color.lerp(textColor, data.fillColorSelected, selectedValue.value)!;
      } else if (data.wasSelected) {
        textColor =
            Color.lerp(data.fillColorSelected, textColor, selectedValue.value)!;
      }
    } else {
      _drawCircle(
        context,
        center,
        radius: dimension / 2,
        strokeWidth: 2,
        color: fillColor,
        filled: completed,
      );
    }

    if (state == _State.upcoming && selected) {
      if (data.selected) {
        textColor =
            Color.lerp(textColor, data.fillColorSelected, selectedValue.value)!;
      } else if (data.wasSelected) {
        textColor =
            Color.lerp(data.fillColorSelected, textColor, selectedValue.value)!;
      }
    } else if (data.selected &&
        state != _State.completed &&
        !currentStepIndex.isAnimating) {
      textColor = data.fillColorSelected;
    }

    _drawParagraph(
      context,
      offset,
      secondLayer ? _overTextHandle : _textHandle,
      textColor,
      state == _State.completed,
    );
  }

  void _drawLine(
      PaintingContext context, Offset offset, double animationValue) {
    if (data.lastStep) return;
    final double dimension = data.isCircle ? _kCircleDimension : _kDotDimension;
    final Offset p1;
    final Offset p2;
    switch (data.direction) {
      case Axis.horizontal:
        p1 = offset + Offset(dimension - 1, dimension / 2);
        p2 = offset + Offset(size.width, dimension / 2);
        break;
      case Axis.vertical:
        p1 = offset + Offset(dimension / 2, dimension - 1);
        p2 = offset + Offset(dimension / 2, size.height);
        break;
    }
    final Paint paint = Paint()..strokeWidth = 2;
    final Color color;
    if (animationValue == 0) {
      color = data.lineColorUpcoming;
    } else if (animationValue <= 0.5) {
      final double progress = ((animationValue - 0.25) * 4).clamp(0, 1);
      color =
          Color.lerp(data.lineColorUpcoming, data.lineColorSelected, progress)!;
    } else if (animationValue < 1) {
      final double progress = ((animationValue - 0.75) * 4).clamp(0, 1);
      context.canvas.drawLine(p1, p2, paint..color = data.lineColorSelected);
      context.canvas.drawLine(p1, Offset.lerp(p1, p2, progress)!,
          paint..color = data.lineColorCompleted);
      return;
    } else {
      color = data.lineColorCompleted;
    }

    context.canvas.drawLine(p1, p2, paint..color = color);
  }

  void _drawParagraph(PaintingContext context, Offset offset,
      LayerHandle<ColorFilterLayer> handle, Color color, bool tick) {
    final Paragraph? paragraph = tick ? _tickParagraph : _paragraph;
    if (paragraph == null) return;
    final double dx = (_kCircleDimension - paragraph.width) / 2;
    final double dy = (_kCircleDimension - paragraph.height) / 2;
    handle.layer ??= ColorFilterLayer();
    handle.layer!.colorFilter = ColorFilter.mode(
      color,
      BlendMode.srcIn,
    );
    context.pushLayer(handle.layer!, (context, offset) {
      context.canvas.drawParagraph(paragraph, offset + Offset(dx, dy));
    }, offset);
  }

  void _drawCircle(
    PaintingContext context,
    Offset center, {
    required Color color,
    required double radius,
    required double strokeWidth,
    required bool filled,
  }) {
    context.canvas.drawCircle(
      center,
      radius - (filled ? 0 : strokeWidth / 2),
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke,
    );
  }

  @override
  void performLayout() {
    final double dimension = data.isCircle ? _kCircleDimension : _kDotDimension;
    if (constraints.hasBoundedWidth) {
      size = constraints.tighten(height: dimension).biggest;
    } else if (constraints.hasBoundedHeight) {
      size = constraints.tighten(width: dimension).biggest;
    } else {
      size = constraints.constrain(Size.square(dimension));
    }
  }

  @override
  void dispose() {
    _paragraph?.dispose();
    _tickParagraph.dispose();
    _textHandle.layer = null;
    _clipRectHandle.layer = null;
    _overTextHandle.layer = null;
    _currentStepIndex?.removeListener(_updateCurrentStepIndex);
    _selectedValue?.removeListener(_updateSelectedValue);
    super.dispose();
  }

  void _setupParagraph() {
    if (!data.isCircle) {
      _paragraph?.dispose();
      _paragraph = null;
      return;
    }
    final double dimension = data.isCircle ? _kCircleDimension : _kDotDimension;
    final ParagraphBuilder builder = ParagraphBuilder(
      SDGATextStyles.textMediumMedium.getParagraphStyle(
        textAlign: TextAlign.center,
      ),
    );
    builder.addText((data.index + 1).toString());

    _paragraph?.dispose();
    _paragraph = builder.build()
      ..layout(ParagraphConstraints(width: dimension));
  }

  double _lastAnimationValue = 0.0;
  void _updateCurrentStepIndex() {
    final double animationValue =
        (currentStepIndex.value - data.index).clamp(0, 1);

    if (_lastAnimationValue != animationValue) {
      _lastAnimationValue = animationValue;
      markNeedsPaint();
    }
  }

  void _updateSelectedValue() {
    if (data.selected || data.wasSelected) {
      markNeedsPaint();
    }
  }
}

class _StepData {
  final int index;
  final Axis direction;
  final bool isCircle;
  final bool lastStep;
  final bool selected;
  final bool wasSelected;
  final Color textColorCompleted;
  final Color fillColorCompleted;
  final Color fillColorSelected;
  final Color fillColorUpcoming;
  final Color lineColorCompleted;
  final Color lineColorSelected;
  final Color lineColorUpcoming;

  const _StepData({
    required this.index,
    required this.direction,
    required this.isCircle,
    required this.lastStep,
    required this.selected,
    required this.wasSelected,
    required this.textColorCompleted,
    required this.fillColorCompleted,
    required this.fillColorSelected,
    required this.fillColorUpcoming,
    required this.lineColorCompleted,
    required this.lineColorSelected,
    required this.lineColorUpcoming,
  });

  static bool needsUpdateLayout(_StepData a, _StepData b) =>
      a.direction != b.direction || a.isCircle != b.isCircle;

  static bool needsUpdateParagraph(_StepData a, _StepData b) =>
      a.index != b.index || a.isCircle != b.isCircle;

  @override
  int get hashCode => Object.hash(
        index,
        direction,
        isCircle,
        lastStep,
        selected,
        wasSelected,
        textColorCompleted,
        fillColorCompleted,
        fillColorSelected,
        fillColorUpcoming,
        lineColorCompleted,
        lineColorSelected,
        lineColorUpcoming,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StepData &&
          index == other.index &&
          direction == other.direction &&
          isCircle == other.isCircle &&
          lastStep == other.lastStep &&
          selected == other.selected &&
          wasSelected == other.wasSelected &&
          textColorCompleted == other.textColorCompleted &&
          fillColorCompleted == other.fillColorCompleted &&
          fillColorSelected == other.fillColorSelected &&
          fillColorUpcoming == other.fillColorUpcoming &&
          lineColorCompleted == other.lineColorCompleted &&
          lineColorSelected == other.lineColorSelected &&
          lineColorUpcoming == other.lineColorUpcoming;
}
