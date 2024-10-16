import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_spinner_sizes.dart';

const int _kDuration = 500;

class SDGASpinner extends StatefulWidget {
  final SDGAWidgetStyle style;
  final SDGASpinnerSizes size;

  /// The [SemanticsProperties.label] for this spinner.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this spinner.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate spinners to announce
  /// how far along they are.
  final String? semanticsValue;

  const SDGASpinner({
    super.key,
    this.style = SDGAWidgetStyle.brand,
    this.size = SDGASpinnerSizes.small,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  State<SDGASpinner> createState() => _SDGASpinnerState();

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    return Semantics(
      label: semanticsLabel,
      value: semanticsValue,
      child: child,
    );
  }
}

class _SDGASpinnerState extends State<SDGASpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kDuration),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return widget._buildSemanticsWrapper(
          context: context,
          child: SizedBox.square(
            dimension: widget.size.size,
            child: CustomPaint(
              painter: _SpinnerPainter(
                backgroundColor: _getBackgroundColor(colors),
                valueColor: _getColor(colors),
                value: _controller.value,
                strokeWidth: widget.size.strokeWidth,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(SDGAColorScheme colors) {
    switch (widget.style) {
      case SDGAWidgetStyle.neutral:
      case SDGAWidgetStyle.brand:
        return colors.backgrounds.neutral100;
      case SDGAWidgetStyle.onColor:
        return colors.alphas.white30;
    }
  }

  Color _getColor(SDGAColorScheme colors) {
    switch (widget.style) {
      case SDGAWidgetStyle.neutral:
        return colors.backgrounds.black;
      case SDGAWidgetStyle.brand:
        return colors.backgrounds.primary;
      case SDGAWidgetStyle.onColor:
        return colors.backgrounds.surfaceOnColor;
    }
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.strokeWidth,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double strokeWidth;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Offset.zero & size,
      0,
      _sweep,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Offset.zero & size,
      _startAngle + (value * math.pi * 2),
      math.pi / 2.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.strokeWidth != strokeWidth;
  }
}
