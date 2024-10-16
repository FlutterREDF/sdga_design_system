import 'package:flutter/material.dart';

class _SDGAAnimatedTween<T> extends Tween<T> {
  _SDGAAnimatedTween({super.begin, super.end, required this.lerpFunction});

  final T Function(T? a, T? b, double t) lerpFunction;

  /// Returns the value this variable has at the given animation clock value.
  @override
  T lerp(double t) => lerpFunction(begin, end, t);
}

class SDGAAnimatedWidget<T> extends ImplicitlyAnimatedWidget {
  final T value;
  final T Function(T? a, T? b, double t) lerp;
  final Widget? child;
  final Widget Function(BuildContext context, T value, Widget? child) builder;

  const SDGAAnimatedWidget({
    super.key,
    required super.duration,
    required this.value,
    required this.lerp,
    required this.builder,
    this.child,
  });

  @override
  AnimatedWidgetBaseState<SDGAAnimatedWidget> createState() =>
      _SDGAAnimatedWidgetState<T>();
}

class _SDGAAnimatedWidgetState<T>
    extends AnimatedWidgetBaseState<SDGAAnimatedWidget<T>> {
  _SDGAAnimatedTween<T>? _value;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      widget.value,
      (dynamic value) =>
          _SDGAAnimatedTween<T>(begin: value as T, lerpFunction: widget.lerp),
    ) as _SDGAAnimatedTween<T>?;

    // _padding = visitor(_padding, widget.padding, (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry)) as EdgeInsetsGeometryTween?;
    // _decoration = visitor(_decoration, widget.decoration, (dynamic value) => DecorationTween(begin: value as Decoration)) as DecorationTween?;
    // _foregroundDecoration = visitor(_foregroundDecoration, widget.foregroundDecoration, (dynamic value) => DecorationTween(begin: value as Decoration)) as DecorationTween?;
    // _constraints = visitor(_constraints, widget.constraints, (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints)) as BoxConstraintsTween?;
    // _margin = visitor(_margin, widget.margin, (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry)) as EdgeInsetsGeometryTween?;
    // _transform = visitor(_transform, widget.transform, (dynamic value) => Matrix4Tween(begin: value as Matrix4)) as Matrix4Tween?;
    // _transformAlignment = visitor(_transformAlignment, widget.transformAlignment, (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry)) as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;
    _value?.evaluate(animation);
    return widget.builder(
      context,
      _value!.evaluate(animation)!,
      widget.child,
    );
  }
}
