part of 'sdga_feedback_icon.dart';

Path _getCircle() =>
    Path()..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 11));

Path _getCircleOutline() => Path.combine(
      PathOperation.difference,
      _getCircle(),
      Path()..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 9)),
    );

Path _getTriangle() => Path()
  ..moveTo(12.8575, 2.95731)
  ..cubicTo(12.4691, 2.30997, 11.5309, 2.30997, 11.1425, 2.95731)
  ..lineTo(0.9087, 20.0137)
  ..cubicTo(0.508785, 20.6802, 0.988898, 21.5282, 1.76619, 21.5282)
  ..lineTo(22.2338, 21.5282)
  ..cubicTo(23.0111, 21.5282, 23.4912, 20.6802, 23.0913, 20.0137)
  ..lineTo(12.8575, 2.95731)
  ..close();

Path _getTriangleOutline() => Path()
  ..moveTo(12.0, 3.496)
  ..relativeCubicTo(0.203, -0.09, -0.065, 0.111, -0.52, 0.897)
  ..lineTo(3.256, 18.6)
  ..relativeCubicTo(-0.456, 0.788, -0.498, 1.123, -0.522, 0.9)
  ..relativeCubicTo(-0.18, -0.132, 0.13, 0.0, 1.041, 0.0)
  ..relativeLineTo(16.45, 0.0)
  ..relativeCubicTo(0.91, 0.0, 1.222, -0.132, 1.04, 0.0)
  ..relativeCubicTo(-0.023, 0.223, -0.065, -0.112, -0.52, -0.9)
  ..lineTo(12.52, 4.393)
  ..relativeCubicTo(-0.455, -0.786, -0.724, -0.987, -0.52, -0.897)
  ..close()
  ..relativeMoveTo(-0.813, -1.828)
  ..relativeArcToPoint(const Offset(1.6, 0.0),
      radius: const Radius.circular(2.0))
  ..relativeCubicTo(0.796, 0.354, 0.982, 0.937, 1.437, 1.723)
  ..relativeLineTo(8.225, 14.207)
  ..relativeCubicTo(0.456, 0.788, 0.87, 1.24, 0.779, 2.109)
  ..relativeArcToPoint(const Offset(-0.8, 1.4),
      radius: const Radius.circular(2.0))
  ..relativeCubicTo(-0.706, 0.514, -1.306, 0.383, -2.216, 0.383)
  ..lineTo(3.775, 21.5)
  ..relativeCubicTo(-0.91, 0.0, -1.51, 0.131, -2.216, -0.383)
  ..relativeArcToPoint(const Offset(-0.8, -1.4),
      radius: const Radius.circular(2.0))
  ..relativeCubicTo(-0.09, -0.87, 0.325, -1.321, 0.781, -2.11)
  ..lineTo(9.75, 3.392)
  ..relativeCubicTo(0.455, -0.786, 0.64, -1.369, 1.438, -1.723)
  ..close();

Path _getCircleRing() => Path.combine(
      PathOperation.reverseDifference,
      _getCircle(),
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 16)),
    );

Path _getTriangleRing() => Path.combine(
      PathOperation.reverseDifference,
      _getTriangle(),
      Path()
        ..moveTo(13.374, -4.236)
        ..relativeCubicTo(-0.623, -1.019, -2.126, -1.019, -2.748, 0.0)
        ..lineTo(-5.769, 22.616)
        ..cubicTo(-6.41, 23.666, -5.641, 25.0, -4.395, 25.0)
        ..relativeLineTo(32.79, 0.0)
        ..relativeCubicTo(1.246, 0.0, 2.015, -1.335, 1.374, -2.384)
        ..lineTo(13.374, -4.236)
        ..close(),
    );

Path _getSuccess() => Path()
  ..moveTo(7.05, 11.121)
  ..relativeArcToPoint(const Offset(1.4, 0.0),
      radius: const Radius.circular(1.0))
  ..relativeLineTo(2.122, 2.122)
  ..relativeLineTo(4.95, -4.95)
  ..relativeArcToPoint(const Offset(1.4, 1.4),
      radius: const Radius.circular(1.0))
  ..relativeLineTo(-5.657, 5.657)
  ..relativeArcToPoint(const Offset(-1.4, 0.0),
      radius: const Radius.circular(1.0))
  ..lineTo(7.05, 12.536)
  ..relativeArcToPoint(const Offset(0.0, -1.4),
      radius: const Radius.circular(1.0))
  ..close();

Path _getConfirm() => Path()
  ..moveTo(11.91, 16.005)
  ..relativeLineTo(0.01, 0.0)
  ..relativeArcToPoint(const Offset(0.0, 2.0),
      radius: const Radius.circular(1.0), largeArc: true)
  ..relativeLineTo(-0.01, 0.0)
  ..relativeArcToPoint(const Offset(0.0, -2.0),
      radius: const Radius.circular(1.0), largeArc: true)
  ..close()
  ..relativeMoveTo(-1.093, -7.73)
  ..relativeArcToPoint(const Offset(-0.9, 1.1),
      radius: const Radius.circular(2.0), clockwise: false)
  ..relativeArcToPoint(const Offset(-1.9, -0.7),
      radius: const Radius.circular(1.0), largeArc: true)
  ..relativeArcToPoint(const Offset(7.8, 1.3),
      radius: const Radius.circular(4.0))
  ..relativeCubicTo(0.0, 1.53, -1.135, 2.541, -1.945, 3.081)
  ..relativeArcToPoint(const Offset(-1.7, 0.8),
      radius: const Radius.circular(8.0))
  ..relativeLineTo(-0.035, 0.012)
  ..relativeLineTo(-0.01, 0.004)
  ..relativeLineTo(-0.005, 0.001)
  ..relativeLineTo(-0.001, 0.0)
  ..relativeCubicTo(0.0, 0.0, -0.001, 0.001, -0.318, -0.947)
  ..relativeLineTo(0.317, 0.948)
  ..relativeArcToPoint(const Offset(-0.6, -1.9),
      radius: const Radius.circular(1.0))
  ..relativeLineTo(0.015, -0.005)
  ..relativeArcToPoint(const Offset(0.4, -0.1),
      radius: const Radius.circular(5.9), clockwise: false)
  ..relativeCubicTo(0.247, -0.11, 0.568, -0.272, 0.883, -0.482)
  ..relativeCubicTo(0.69, -0.46, 1.054, -0.948, 1.054, -1.417)
  ..relativeLineTo(0.0, -0.002)
  ..relativeArcToPoint(const Offset(-3.0, -1.7),
      radius: const Radius.circular(2.0), clockwise: false)
  ..close();

Path _getInfo() => Path()
  ..moveTo(12.0, 11.0)
  ..cubicTo(11.4477, 11.0, 11.0, 11.4477, 11.0, 12.0)
  ..lineTo(11.0, 16.0)
  ..cubicTo(11.0, 16.5523, 11.4477, 17.0, 12.0, 17.0)
  ..cubicTo(12.5523, 17.0, 13.0, 16.5523, 13.0, 16.0)
  ..lineTo(13.0, 12.0)
  ..cubicTo(13.0, 11.4477, 12.5523, 11.0, 12.0, 11.0)
  ..close()
  ..moveTo(12.0, 7.0)
  ..cubicTo(11.4477, 7.0, 11.0, 7.44772, 11.0, 8.0)
  ..cubicTo(11.0, 8.55228, 11.4477, 9.0, 12.0, 9.0)
  ..cubicTo(12.5523, 9.0, 13.0, 8.55228, 13.0, 8.0)
  ..cubicTo(13.0, 7.44772, 12.5523, 7.0, 12.0, 7.0)
  ..close();

Path _getWarning() => Path()
  ..moveTo(12.0, 15.0)
  ..relativeArcToPoint(const Offset(0.0, 2.0),
      radius: const Radius.circular(1.0))
  ..relativeArcToPoint(const Offset(0.0, -2.0),
      radius: const Radius.circular(1.0), largeArc: true)
  ..close()
  ..relativeMoveTo(0.0, -8.0)
  ..relativeArcToPoint(const Offset(1.0, 1.0),
      radius: const Radius.circular(1.0))
  ..relativeLineTo(0.0, 4.0)
  ..relativeArcToPoint(const Offset(-2.0, 0.0),
      radius: const Radius.circular(1.0), largeArc: true)
  ..lineTo(11.0, 8.0)
  ..relativeArcToPoint(const Offset(1.0, -1.0),
      radius: const Radius.circular(1.0))
  ..close();

Path _getError() => Path()
  ..moveTo(8.70703, 7.29297)
  ..cubicTo(8.31665, 6.90234, 7.68335, 6.90234, 7.29297, 7.29297)
  ..cubicTo(6.90234, 7.68335, 6.90234, 8.31665, 7.29297, 8.70703)
  ..lineTo(10.5857, 12.0)
  ..lineTo(7.29297, 15.293)
  ..cubicTo(6.90234, 15.6833, 6.90234, 16.3167, 7.29297, 16.707)
  ..cubicTo(7.68335, 17.0977, 8.31665, 17.0977, 8.70703, 16.707)
  ..lineTo(12.0, 13.4143)
  ..lineTo(15.293, 16.707)
  ..cubicTo(15.6833, 17.0977, 16.3167, 17.0977, 16.707, 16.707)
  ..cubicTo(17.0977, 16.3167, 17.0977, 15.6833, 16.707, 15.293)
  ..lineTo(13.4143, 12.0)
  ..lineTo(16.707, 8.70703)
  ..cubicTo(17.0977, 8.31665, 17.0977, 7.68335, 16.707, 7.29297)
  ..cubicTo(16.3167, 6.90234, 15.6833, 6.90234, 15.293, 7.29297)
  ..lineTo(12.0, 10.5857)
  ..lineTo(8.70703, 7.29297)
  ..close();
