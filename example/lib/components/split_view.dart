library split_view;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A SplitView class.
class SplitView extends StatefulWidget {
  static const Color defaultGripColor = Colors.grey;
  static const Color defaultGripColorActive = Color(0xFF666666);
  static const double defaultGripSize = 12.0;
  static const double _weightLimit = 0.01;

  final List<Widget> children;

  /// Controls the views being splitted.
  final SplitViewController? controller;

  /// The [viewMode] specifies how to arrange views.
  final SplitViewMode viewMode;

  /// The grip size.
  final double gripSize;

  /// Grip color.
  final Color gripColor;

  /// Active grip color.
  final Color gripColorActive;

  /// Called when the user moves the grip.
  final ValueChanged<UnmodifiableListView<double?>>? onWeightChanged;

  /// Grip indicator.
  final Widget? indicator;

  /// Grip indicator for active state.
  final Widget? activeIndicator;

  /// Creates a [SplitView].
  const SplitView({
    super.key,
    required this.children,
    this.viewMode = SplitViewMode.vertical,
    this.gripSize = defaultGripSize,
    this.controller,
    this.gripColor = defaultGripColor,
    this.gripColorActive = defaultGripColorActive,
    this.onWeightChanged,
    this.indicator,
    this.activeIndicator,
  });

  @override
  State createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late SplitViewController _controller;
  late Color _gripColor;
  bool _dragging = false;
  int _activeIndex = -1;

  late double _startWeight1;
  late double _startWeight2;
  late double _startSize;
  late Offset _startDragPos;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? SplitViewController();
    _controller.addListener(_handleWeightsChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleWeightsChange);
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(SplitView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleWeightsChange);
      widget.controller?.addListener(_handleWeightsChange);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = SplitViewController(
          weights: _controller.weights,
          limits: _controller.limits,
        );
      } else {
        if (widget.controller != null && oldWidget.controller == null) {
          _controller.dispose();
        }
        _controller = widget.controller!;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _gripColor = widget.gripColor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _controller._init(widget.children.length);
        if (widget.viewMode == SplitViewMode.vertical) {
          return _buildVerticalView(
              context, constraints, _controller.weights, _controller.limits);
        } else {
          return _buildHorizontalView(
              context, constraints, _controller.weights);
        }
      },
    );
  }

  Stack _buildVerticalView(BuildContext context, BoxConstraints constraints,
      List<double?> weights, List<WeightLimit?> limits) {
    double viewsHeight = constraints.maxHeight -
        (widget.gripSize * (widget.children.length - 1));
    double top = 0;

    var children = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      double weight = weights[i] ?? 0.1;
      var child = widget.children[i];
      children.add(Positioned(
        top: top,
        height: viewsHeight * weight,
        left: 0,
        right: 0,
        child: child,
      ));
      top += (viewsHeight * weight);
      if (i != widget.children.length - 1) {
        children.add(Positioned(
          top: top,
          height: widget.gripSize,
          left: 0,
          right: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeRow,
            onEnter: (event) {
              setState(() {
                _activeIndex = i;
                _gripColor = widget.gripColorActive;
              });
            },
            onExit: (_) {
              if (_dragging == false) {
                _activeIndex = -1;
                setState(() => _gripColor = widget.gripColor);
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragDown: (details) {
                _dragging = true;
                _activeIndex = i;
                _gripColor = widget.gripColorActive;
                _startDragPos =
                    _getLocalPosition(context, details.globalPosition);
                _startWeight1 = _controller.weights[i]!;
                _startWeight2 = _controller.weights[i + 1]!;
                _startSize = viewsHeight * _startWeight1;
                setState(() {});
              },
              onVerticalDragEnd: (details) {
                _dragging = false;
                _activeIndex = -1;
                setState(() => _gripColor = widget.gripColor);
              },
              onVerticalDragUpdate: (detail) {
                final pos = _getLocalPosition(context, detail.globalPosition);
                var diff = pos.dy - _startDragPos.dy;
                _changeWeights(diff, viewsHeight, i);
              },
              child: Container(
                color: _activeIndex == i ? _gripColor : widget.gripColor,
                alignment: Alignment.center,
                child: _activeIndex == i
                    ? widget.activeIndicator ?? widget.indicator
                    : widget.indicator,
              ),
            ),
          ),
        ));
        top += widget.gripSize;
      }
    }

    return Stack(
      children: children,
    );
  }

  Widget _buildHorizontalView(
      BuildContext context, BoxConstraints constraints, List<double?> weights) {
    double viewsWidth =
        constraints.maxWidth - (widget.gripSize * (widget.children.length - 1));
    double left = 0;

    var children = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      double weight = weights[i] ?? 0.1;
      var child = widget.children[i];
      children.add(Positioned(
        left: left,
        width: viewsWidth * weight,
        top: 0,
        bottom: 0,
        child: child,
      ));
      left += (viewsWidth * weight);
      if (i != widget.children.length - 1) {
        children.add(Positioned(
          left: left,
          width: widget.gripSize,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            onEnter: (event) {
              setState(() {
                _gripColor = widget.gripColorActive;
                _activeIndex = i;
              });
            },
            onExit: (_) {
              if (_dragging == false) {
                _activeIndex = -1;
                setState(() => _gripColor = widget.gripColor);
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragDown: (details) {
                _dragging = true;
                _activeIndex = i;
                _gripColor = widget.gripColorActive;
                _startDragPos =
                    _getLocalPosition(context, details.globalPosition);
                _startWeight1 = _controller.weights[i]!;
                _startWeight2 = _controller.weights[i + 1]!;
                _startSize = viewsWidth * _startWeight1;
              },
              onHorizontalDragEnd: (details) {
                _dragging = false;
                _activeIndex = -1;
                setState(() => _gripColor = widget.gripColor);
              },
              onHorizontalDragUpdate: (detail) {
                final pos = _getLocalPosition(context, detail.globalPosition);
                var diff = pos.dx - _startDragPos.dx;
                _changeWeights(diff, viewsWidth, i);
              },
              child: Container(
                color: _activeIndex == i ? _gripColor : widget.gripColor,
                alignment: Alignment.center,
                child: _activeIndex == i
                    ? widget.activeIndicator ?? widget.indicator
                    : widget.indicator,
              ),
            ),
          ),
        ));
        left += widget.gripSize;
      }
    }

    return Stack(
      children: children,
    );
  }

  void _changeWeights(double diff, double size, int index) {
    var newWeight1 = (_startSize + diff) / size;
    newWeight1 = _adjustWeight(newWeight1, _controller.limits[index]);
    if (_controller.limits[index] != null) {
      if (_controller.limits[index]!.min != null) {
        newWeight1 = max(newWeight1, _controller.limits[index]!.min!);
      }
      if (_controller.limits[index]!.max != null) {
        newWeight1 = min(newWeight1, _controller.limits[index]!.max!);
      }
    }
    var newWeight2 = _startWeight1 + _startWeight2 - newWeight1;
    if (_controller.limits[index + 1] != null) {
      if (_controller.limits[index + 1]!.min != null) {
        newWeight2 = max(newWeight2, _controller.limits[index + 1]!.min!);
      }
      if (_controller.limits[index + 1]!.max != null) {
        newWeight2 = min(newWeight2, _controller.limits[index + 1]!.max!);
      }
      newWeight1 = _startWeight1 + _startWeight2 - newWeight2;
    }

    final weights = List.of(_controller._weights);
    weights[index] = newWeight1;
    weights[index + 1] = newWeight2;
    _controller.weights = weights;
  }

  void _handleWeightsChange() {
    setState(() {/* build() uses _controller.weights */});
    widget.onWeightChanged?.call(_controller.weights);
  }

  Offset _getLocalPosition(BuildContext context, Offset pos) {
    var container = context.findRenderObject() as RenderBox;
    return container.globalToLocal(pos);
  }

  double _adjustWeight(double weight, WeightLimit? limit) {
    var w = min(weight, _startWeight1 + _startWeight2 - SplitView._weightLimit);
    w = max(w, SplitView._weightLimit);
    return w;
  }
}

/// Controller for [SplitView]
class SplitViewController extends ChangeNotifier {
  /// Specifies the weight of each views.
  UnmodifiableListView<double?> get weights => UnmodifiableListView(_weights);
  set weights(List<double?> weights) {
    if (const ListEquality().equals(_weights, weights)) return;
    _weights = weights;
    notifyListeners();
  }

  /// Specifies the limits of each views.
  UnmodifiableListView<WeightLimit?> get limits =>
      UnmodifiableListView(_limits);

  List<double?> _weights;
  List<WeightLimit?> _limits;

  SplitViewController._(this._weights, this._limits);

  /// Creates a [SplitViewController]
  ///
  /// The [weights] specifies the ratio in the view. The sum of the [weights] cannot exceed 1.
  factory SplitViewController(
      {List<double?>? weights, List<WeightLimit?>? limits}) {
    weights ??= List.empty(growable: true);
    limits ??= List.empty(growable: true);
    return SplitViewController._(weights, limits);
  }

  void _init(int length) {
    if (_weights.length < length) {
      _weights.length = length;
    }
    if (_limits.length < length) {
      _limits.length = length;
    }
    int nullCnt = _weights.where((element) => element == null).length;
    double weightSum = 0.0;
    for (var weight in _weights) {
      weightSum += weight ?? 0;
    }
    double weightRemain = 1.0 - weightSum;
    double calcWeight = weightRemain / nullCnt;
    for (int i = 0; i < _weights.length; i++) {
      if (_weights[i] == null) {
        _weights[i] = calcWeight;
      }
    }
  }
}

/// A WeightLimit class.
class WeightLimit {
  /// Minimal weight limit.
  final double? min;

  /// Maximum weight limit.
  final double? max;

  WeightLimit({this.min, this.max});
}

/// A SplitIndicator class.
class SplitIndicator extends StatelessWidget {
  /// The [viewMode] specifies how to arrange views.
  final SplitViewMode viewMode;

  /// Specifies true when it is used in the active state.
  final bool isActive;

  /// Specified indicator color.
  final Color color;

  const SplitIndicator({
    super.key,
    required this.viewMode,
    this.isActive = false,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _SplitIndicatorPainter(
          viewMode: viewMode,
          isActive: isActive,
          color: color,
        ),
      ),
    );
  }
}

class _SplitIndicatorPainter extends CustomPainter {
  final SplitViewMode viewMode;
  final bool isActive;
  final Color color;

  static const double defaultStrokeWidthRatio = 0.2;
  static const double activeStrokeWidthRatio = 0.4;
  static const double strokeLength = 0.15;

  _SplitIndicatorPainter({
    required this.viewMode,
    required this.isActive,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    double x1, x2, y1, y2;
    double strokeWidthRatio =
        isActive ? activeStrokeWidthRatio : defaultStrokeWidthRatio;
    if (viewMode == SplitViewMode.horizontal) {
      x1 = x2 = size.width / 2;
      y1 = size.height * (1 - strokeLength) / 2;
      y2 = y1 + size.height * strokeLength;
      paint.strokeWidth = size.width * strokeWidthRatio;
      paint.strokeCap = StrokeCap.round;
    } else {
      x1 = size.width * (1 - strokeLength) / 2;
      x2 = x1 + size.width * strokeLength;
      y1 = y2 = size.height / 2;
      paint.strokeWidth = size.height * strokeWidthRatio;
      paint.strokeCap = StrokeCap.round;
    }
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Arranges view order.
enum SplitViewMode {
  /// Arranges vertically.
  vertical,

  /// Arranges horizontally.
  horizontal,
}
