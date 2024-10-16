import 'package:flutter/material.dart';
import 'package:sdga_icons/sdga_icons.dart';

class SDGAExpandIcon extends StatefulWidget {
  const SDGAExpandIcon({
    super.key,
    this.isExpanded = false,
    this.iconSize = 16.0,
  });

  /// Whether the icon is in an expanded state.
  ///
  /// Rebuilding the widget with a different [isExpanded] value will trigger
  /// the animation.
  final bool isExpanded;

  /// The icon size of the down arrow.
  final double iconSize;

  @override
  State<SDGAExpandIcon> createState() => _SDGAExpandIconState();
}

class _SDGAExpandIconState extends State<SDGAExpandIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _iconTurns;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isExpanded ? 1 : 0,
    );
    _iconTurns =
        Tween<double>(begin: 0.0, end: 0.5).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SDGAExpandIcon oldWidget) {
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: SDGAIcon(SDGAIconsStroke.arrowDown01, size: widget.iconSize),
    );
  }
}
