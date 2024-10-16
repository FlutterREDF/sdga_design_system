import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sdga_design_system/src/src.dart';

/// The base class of SDGA borders, used to make lerping easy between
/// SDGA borders
abstract class SDGACustomBorder extends BoxBorder {
  const SDGACustomBorder();

  BoxBorder? lerpBorder(BoxBorder? b, double t);

  BoxBorder? lerpFromBorder(double t);

  BoxBorder? lerpToBorder(double t);

  static BoxBorder? lerp(BoxBorder? a, BoxBorder? b, double t) {
    if (a is SDGACustomBorder && b is SDGACustomBorder) {
      return a.lerpBorder(b, t);
    } else if (a is SDGACustomBorder && b == null) {
      return a.lerpFromBorder(t);
    } else if (a == null && b is SDGACustomBorder) {
      return b.lerpToBorder(t);
    } else if (a is! SDGACustomBorder && b is! SDGACustomBorder) {
      return BoxBorder.lerp(a, b, t);
    } else {
      return t < 0.5 ? a : b;
    }
  }
}

/// A border that acts like an indicator with some padding from the edges.
class SDGAIndicatorBorder extends SDGACustomBorder {
  const SDGAIndicatorBorder({
    required this.border,
    this.padding = SDGANumbers.spacingXS,
  });

  final BorderDirectional border;
  final double padding;

  @override
  BorderSide get bottom => border.bottom;

  @override
  BorderSide get top => border.top;

  @override
  EdgeInsetsGeometry get dimensions {
    return border.dimensions;
  }

  @override
  bool get isUniform => border.isUniform;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (border.bottom.width > 0) {
      canvas.drawLine(
        Offset(rect.left + padding, rect.bottom - border.bottom.strokeInset),
        Offset(rect.right - padding, rect.bottom - border.bottom.strokeInset),
        border.bottom.toPaint()..strokeCap = StrokeCap.round,
      );
    }
    if (border.top.width > 0) {
      canvas.drawLine(
        Offset(rect.left + padding, rect.top + border.top.strokeInset),
        Offset(rect.right - padding, rect.top + border.top.strokeInset),
        border.top.toPaint()..strokeCap = StrokeCap.round,
      );
    }
    final BorderSide left =
        textDirection == TextDirection.rtl ? border.end : border.start;
    final BorderSide right =
        textDirection == TextDirection.rtl ? border.start : border.end;
    if (left.width > 0) {
      canvas.drawLine(
        Offset(rect.left + left.strokeInset, rect.top + padding),
        Offset(rect.left + left.strokeInset, rect.bottom - padding),
        left.toPaint()..strokeCap = StrokeCap.round,
      );
    }
    if (right.width > 0) {
      canvas.drawLine(
        Offset(rect.right - right.strokeInset, rect.top + padding),
        Offset(rect.right - right.strokeInset, rect.bottom - padding),
        right.toPaint()..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  SDGAIndicatorBorder scale(double t) {
    return SDGAIndicatorBorder(
      border: border.scale(t),
      padding: padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SDGAIndicatorBorder &&
        other.border == border &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(border, padding);

  @override
  BoxBorder? lerpBorder(BoxBorder? b, double t) {
    return lerp(this, b, t);
  }

  @override
  BoxBorder? lerpFromBorder(double t) {
    return scale(1.0 - t);
  }

  @override
  BoxBorder? lerpToBorder(double t) {
    return scale(t);
  }

  static BoxBorder? lerp(BoxBorder? a, BoxBorder? b, double t) {
    if (a is SDGAIndicatorBorder && b is SDGAIndicatorBorder) {
      return SDGAIndicatorBorder(
        border: BorderDirectional.lerp(a.border, b.border, t)!,
        padding: lerpDouble(a.padding, b.padding, t)!,
      );
    } else if (a is SDGAIndicatorBorder && b == null) {
      return a.lerpFromBorder(t);
    } else if (a == null && b is SDGAIndicatorBorder) {
      return b.lerpToBorder(t);
    } else if (a is! SDGAIndicatorBorder && b is! SDGAIndicatorBorder) {
      return BoxBorder.lerp(a, b, t);
    } else {
      return t < 0.5 ? a : b;
    }
  }
}

/// A border that combines two borders and draw them.
class SDGADoubleBorder extends SDGACustomBorder {
  const SDGADoubleBorder({
    required this.firstBorder,
    required this.secondBorder,
  });

  final BoxBorder firstBorder;
  final BoxBorder secondBorder;

  @override
  BorderSide get bottom => firstBorder.bottom;

  @override
  BorderSide get top => firstBorder.top;

  @override
  EdgeInsetsGeometry get dimensions {
    final dim1 = firstBorder.dimensions;
    final dim2 = secondBorder.dimensions;
    return dim1.collapsedSize > dim2.collapsedSize ? dim1 : dim2;
  }

  @override
  bool get isUniform => firstBorder.isUniform && secondBorder.isUniform;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    firstBorder.paint(
      canvas,
      rect,
      textDirection: textDirection,
      shape: shape,
      borderRadius: borderRadius,
    );
    secondBorder.paint(
      canvas,
      rect,
      textDirection: textDirection,
      shape: shape,
      borderRadius: borderRadius,
    );
  }

  @override
  SDGADoubleBorder scale(double t) {
    // BoxBorder.lerp
    return SDGADoubleBorder(
      firstBorder: firstBorder.scale(t) as BoxBorder,
      secondBorder: secondBorder.scale(t) as BoxBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SDGADoubleBorder &&
        other.firstBorder == firstBorder &&
        other.secondBorder == secondBorder;
  }

  @override
  int get hashCode => Object.hash(firstBorder, secondBorder);

  @override
  BoxBorder? lerpBorder(BoxBorder? b, double t) {
    return lerp(this, b, t);
  }

  @override
  BoxBorder? lerpFromBorder(double t) {
    return scale(1.0 - t);
  }

  @override
  BoxBorder? lerpToBorder(double t) {
    return scale(t);
  }

  static BoxBorder? lerp(BoxBorder? a, BoxBorder? b, double t) {
    if (a is SDGADoubleBorder && b is SDGADoubleBorder) {
      return SDGADoubleBorder(
        firstBorder: SDGACustomBorder.lerp(a.firstBorder, b.firstBorder, t)!,
        secondBorder: SDGACustomBorder.lerp(a.secondBorder, b.secondBorder, t)!,
      );
    } else if (a is SDGADoubleBorder && b == null) {
      return a.lerpFromBorder(t);
    } else if (a == null && b is SDGADoubleBorder) {
      return b.lerpToBorder(t);
    } else if (a is! SDGADoubleBorder && b is! SDGADoubleBorder) {
      return BoxBorder.lerp(a, b, t);
    } else {
      return t < 0.5 ? a : b;
    }
  }
}

/// A border that creates a dashed line effect.
class SDGADashedBorder extends SDGACustomBorder {
  const SDGADashedBorder({
    required this.border,
    this.circularInterval = const [10.0, 5.0],
  });

  final BorderSide border;

  /// A circular array of dash offsets and lengths.
  ///
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// followed by blank spaces 10 pixels long.  The array `[5, 10, 5]` would
  /// result in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap,
  /// a 10 pixel dash, etc.
  final List<double> circularInterval;

  @override
  BorderSide get top => border;

  @override
  BorderSide get bottom => border;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(border.strokeInset);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = top.toPaint();
    final Path path = _getPath(rect: rect, shape: shape, radius: borderRadius);
    canvas.drawPath(_dashPath(path), paint);
  }

  @override
  SDGADashedBorder scale(double t) {
    return SDGADashedBorder(
      border: border.scale(t),
      circularInterval:
          circularInterval.map((e) => math.max(0.0, e * t)).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SDGADashedBorder &&
        other.border == border &&
        other.circularInterval == circularInterval;
  }

  @override
  int get hashCode => Object.hash(border, circularInterval);

  @override
  BoxBorder? lerpBorder(BoxBorder? b, double t) {
    return lerp(this, b, t);
  }

  @override
  BoxBorder? lerpFromBorder(double t) {
    return scale(1.0 - t);
  }

  @override
  BoxBorder? lerpToBorder(double t) {
    return scale(t);
  }

  static BoxBorder? lerp(BoxBorder? a, BoxBorder? b, double t) {
    if (a is SDGADashedBorder && b is SDGADashedBorder) {
      return SDGADashedBorder(
        border: BorderSide.lerp(a.border, b.border, t),
        circularInterval: a.circularInterval.length == b.circularInterval.length
            ? List.generate(
                a.circularInterval.length,
                (i) => lerpDouble(
                    a.circularInterval[i], b.circularInterval[i], t)!,
              )
            : t < 0.5
                ? a.circularInterval
                : b.circularInterval,
      );
    } else if (a is SDGADashedBorder && b == null) {
      return a.lerpFromBorder(t);
    } else if (a == null && b is SDGADashedBorder) {
      return b.lerpToBorder(t);
    } else if (a is! SDGADashedBorder && b is! SDGADashedBorder) {
      return BoxBorder.lerp(a, b, t);
    } else {
      return t < 0.5 ? a : b;
    }
  }

  static Path _getPath(
      {required Rect rect, required BoxShape shape, BorderRadius? radius}) {
    Path path;
    switch (shape) {
      case BoxShape.rectangle:
        if (radius != null) {
          path = Path()..addRRect(radius.toRRect(rect));
        } else {
          path = Path()..addRect(rect);
        }
        break;
      case BoxShape.circle:
        path = Path()..addOval(rect);
        break;
    }
    return path;
  }

  Path _dashPath(Path source) {
    final Path dest = Path();
    int index = 0;
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = circularInterval[index % circularInterval.length];
        if (draw) {
          dest.addPath(
              metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
        index++;
      }
    }

    return dest;
  }
}
