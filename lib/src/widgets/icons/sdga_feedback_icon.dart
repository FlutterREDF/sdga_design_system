import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_feedback_icon_type.dart';
part 'sdga_feedback_icon_paths.dart';

/// A widget that displays a feedback icon with various customization options.
///
/// The [SDGAFeedbackIcon] widget allows you to display an icon that represents
/// different types of feedback, such as success, warning, error, or information.
/// You can customize the icon's color, size, and appearance by using different
/// constructors and properties.
///
/// {@tool sample}
///
/// ```dart
/// // Default success icon
/// SDGAFeedbackIcon(
///   type: SDGAFeedbackIconType.success,
///   color: SDGAWidgetColor.success,
///   size: SDGAWidgetSize.large,
///   addRing: true,
/// )
///
/// // Custom color icon
/// SDGAFeedbackIcon.customColor(
///   type: SDGAFeedbackIconType.warning,
///   iconColor: Colors.orange,
///   size: SDGAWidgetSize.medium,
///   useTriangle: true,
/// )
///
/// // Custom size icon
/// SDGAFeedbackIcon.customSize(
///   type: SDGAFeedbackIconType.error,
///   color: SDGAWidgetColor.error,
///   size: 32.0,
///   outlineBorder: true,
/// )
/// ```
/// {@end-tool}
class SDGAFeedbackIcon extends StatelessWidget {
  /// Creates an [SDGAFeedbackIcon] widget with the default constructor.
  const SDGAFeedbackIcon({
    super.key,
    this.type = SDGAFeedbackIconType.success,
    this.color = SDGAWidgetColor.success,
    this.size = SDGAWidgetSize.large,
    this.addRing = false,
    this.outlineBorder = false,
    this.useTriangle = false,
    this.iconFillColor,
  })  : iconColor = null,
        _dimension = null;

  /// Creates an [SDGAFeedbackIcon] widget with a custom color.
  const SDGAFeedbackIcon.customColor({
    super.key,
    this.type = SDGAFeedbackIconType.success,
    this.size = SDGAWidgetSize.large,
    this.useTriangle = false,
    required Color this.iconColor,
  })  : _dimension = null,
        iconFillColor = null,
        addRing = false,
        outlineBorder = true,
        color = SDGAWidgetColor.success;

  /// Creates an [SDGAFeedbackIcon] widget with a custom size.
  const SDGAFeedbackIcon.customSize({
    super.key,
    this.type = SDGAFeedbackIconType.success,
    this.color = SDGAWidgetColor.success,
    required double size,
    this.addRing = false,
    this.outlineBorder = false,
    this.useTriangle = false,
    this.iconFillColor,
  })  : iconColor = null,
        _dimension = size,
        size = SDGAWidgetSize.small;

  /// The type of feedback icon to display.
  final SDGAFeedbackIconType type;

  /// The color of the feedback icon.
  final SDGAWidgetColor color;

  /// The size of the feedback icon.
  final SDGAWidgetSize size;

  /// Determines whether to add a ring around the icon or not.
  ///
  /// If [outlineBorder] is set to `true`; this property will not
  /// have any effects.
  final bool addRing;

  /// Determines whether to use an outline border for the icon or not.
  final bool outlineBorder;

  /// Determines whether to use a triangle shape for the icon or not.
  final bool useTriangle;

  /// The fill color for the icon when [outlineBorder] is set to `false`.
  final Color? iconFillColor;

  /// The custom color for the icon.
  final Color? iconColor;

  final double? _dimension;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return SizedBox.square(
      dimension: _getDimension(),
      child: CustomPaint(
        painter: _FeedbackIconPainter(
          type: type,
          color: iconColor ?? color.getIconColor(colors),
          ringColor: _getRingColor(colors),
          outline: outlineBorder,
          triangle: useTriangle,
          fillColor: iconFillColor,
        ),
      ),
    );
  }

  Color? _getRingColor(SDGAColorScheme colors) {
    if (!addRing || outlineBorder) return null;
    switch (color) {
      case SDGAWidgetColor.neutral:
        return SDGAColors.neutral.shade100;
      case SDGAWidgetColor.info:
        return SDGAColors.blue.shade100;
      case SDGAWidgetColor.success:
        return SDGAColors.primary.shade100;
      case SDGAWidgetColor.warning:
        return SDGAColors.yellow.shade100;
      case SDGAWidgetColor.error:
        return SDGAColors.red.shade100;
    }
  }

  double _getDimension() {
    if (_dimension != null) return _dimension!;
    switch (size) {
      case SDGAWidgetSize.small:
        return 16.0;
      case SDGAWidgetSize.medium:
        return 20.0;
      case SDGAWidgetSize.large:
        return 24.0;
    }
  }
}

class _FeedbackIconPainter extends CustomPainter {
  _FeedbackIconPainter({
    required this.type,
    required this.outline,
    required this.triangle,
    required this.color,
    this.ringColor,
    this.fillColor,
  });

  final SDGAFeedbackIconType type;
  final bool outline;
  final bool triangle;
  final Color color;
  final Color? ringColor;
  final Color? fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final scale =
        Matrix4.diagonal3Values(size.width / 24, size.height / 24, 0).storage;
    if (ringColor != null) {
      final ring = triangle ? _getTriangleRing() : _getCircleRing();

      canvas.drawPath(
        ring.transform(scale),
        Paint()
          ..color = ringColor!
          ..blendMode = BlendMode.multiply,
      );
    }
    Path path;
    switch (type) {
      case SDGAFeedbackIconType.success:
        path = _getSuccess();
        break;
      case SDGAFeedbackIconType.error:
        path = _getError();
        break;
      case SDGAFeedbackIconType.confirmation:
        path = _getConfirm();
        break;
      case SDGAFeedbackIconType.info:
        path = _getInfo();
        break;
      case SDGAFeedbackIconType.warning:
        path = _getWarning();
        break;
    }
    if (triangle) {
      if (type != SDGAFeedbackIconType.warning &&
          type != SDGAFeedbackIconType.info) {
        const scaleBy = 0.75;
        final matrix = Matrix4.identity()
          ..translate(12.0, 12.0)
          ..scale(scaleBy, scaleBy)
          ..translate(-12.0, -12.0)
          ..translate(0.0, 1.5);
        path = path.transform(matrix.storage);
      }
      path = path.transform(Matrix4.translationValues(0, 1.5, 0).storage);
    }
    if (outline) {
      final outline = triangle ? _getTriangleOutline() : _getCircleOutline();
      canvas.drawPath(outline.transform(scale), Paint()..color = color);
      canvas.drawPath(path.transform(scale), Paint()..color = color);
    } else {
      final bg = triangle ? _getTriangle() : _getCircle();
      if (fillColor != null) {
        canvas.drawPath(bg.transform(scale), Paint()..color = color);
        canvas.drawPath(path.transform(scale), Paint()..color = fillColor!);
      } else {
        canvas.drawPath(
          Path.combine(PathOperation.difference, bg, path).transform(scale),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FeedbackIconPainter oldPainter) {
    return oldPainter.ringColor != ringColor ||
        oldPainter.color != color ||
        oldPainter.type != type ||
        oldPainter.outline != outline ||
        oldPainter.triangle != triangle;
  }
}
