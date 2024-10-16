part of 'sdga_tab_bar.dart';

class _TabBarParentData extends ContainerBoxParentData<RenderBox> {
  _TabBarParentData();
  int index = -1;
  bool hidden = false;
}

/// A wrapper for the tab bar, to hide the overflowing tabs and show "more" button
class _TabBarWrapper extends MultiChildRenderObjectWidget {
  const _TabBarWrapper({
    super.children,
    required this.selectedIndex,
    required this.onVisibleIndicesChanged,
  });
  final void Function(Set<int> visibleIndices) onVisibleIndicesChanged;
  final int selectedIndex;

  @override
  _RenderTabBarWrapper createRenderObject(BuildContext context) {
    return _RenderTabBarWrapper(
      textDirection: Directionality.maybeOf(context),
      selectedIndex: selectedIndex,
      onVisibleIndicesChanged: onVisibleIndicesChanged,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderTabBarWrapper renderObject) {
    renderObject
      ..textDirection = Directionality.maybeOf(context)
      ..selectedIndex = selectedIndex
      ..onVisibleIndicesChanged = onVisibleIndicesChanged;
  }
}

class _RenderTabBarWrapper extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TabBarParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TabBarParentData> {
  _RenderTabBarWrapper({
    TextDirection? textDirection,
    required int selectedIndex,
    List<RenderBox>? children,
    required this.onVisibleIndicesChanged,
  })  : _textDirection = textDirection,
        _selectedIndex = selectedIndex {
    addAll(children);
  }
  void Function(Set<int> visibleIndices) onVisibleIndicesChanged;

  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  int get selectedIndex => _selectedIndex;
  int _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TabBarParentData) {
      child.parentData = _TabBarParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    size = constraints.biggest;
    final List<double> childWidths = [];
    double totalWidth = 0.0;
    int index = 0;
    for (RenderBox? child = firstChild;
        child != null;
        child = childAfter(child)) {
      final _TabBarParentData childParentData =
          child.parentData! as _TabBarParentData;
      childParentData.index = index++;

      ChildLayoutHelper.layoutChild(child, constraints.loosen());
      final double width = child.size.width;
      childWidths.add(child == lastChild ? width + _kPadding : width);
      if (child != lastChild) totalWidth += width;
    }
    final bool allFit = size.width >= totalWidth;
    final Set<int> visibleIndices = allFit
        ? Set.from(List.generate(childCount - 1, (index) => index))
        : {childCount - 1};
    double neededWidth = totalWidth;
    if (!allFit) {
      if (selectedIndex != -1) visibleIndices.add(selectedIndex);
      index = 0;
      while (true) {
        if (index == childCount) break;
        double usedWidth = 0.0;
        for (var i = 0; i < childCount; i++) {
          if (visibleIndices.contains(i)) usedWidth += childWidths[i];
        }
        if (usedWidth + childWidths[index] > size.width) {
          neededWidth = usedWidth;
          break;
        }
        visibleIndices.add(index++);
      }
    }

    _updatePositions(visibleIndices, neededWidth);
    onVisibleIndicesChanged.call(visibleIndices);
  }

  void _updatePositions(Set<int> visibleIndices, double usedWidth) {
    final bool flipMainAxis = textDirection == TextDirection.rtl;
    final RenderBox? Function(RenderBox child) nextChild =
        flipMainAxis ? childBefore : childAfter;
    final RenderBox? topLeftChild = flipMainAxis ? lastChild : firstChild;
    double dx = flipMainAxis ? size.width - usedWidth : 0;

    for (RenderBox? child = topLeftChild;
        child != null;
        child = nextChild(child)) {
      final _TabBarParentData childParentData =
          child.parentData! as _TabBarParentData;
      childParentData.hidden = !visibleIndices.contains(childParentData.index);
      if (!childParentData.hidden) {
        final double dy = (size.height - child.size.height) / 2;
        if (child == lastChild) {
          childParentData.offset = Offset(
            flipMainAxis
                ? _kPadding
                : size.width - child.size.width - _kPadding,
            dy,
          );
          dx += _kPadding;
        } else {
          childParentData.offset = Offset(dx, dy);
        }
        dx += child.size.width;
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _TabBarParentData childParentData =
          child.parentData! as _TabBarParentData;
      final bool isHit = !childParentData.hidden &&
          result.addWithPaintOffset(
            offset: childParentData.offset,
            position: position,
            hitTest: (BoxHitTestResult result, Offset transformed) {
              assert(transformed == position - childParentData.offset);
              return child!.hitTest(result, position: transformed);
            },
          );
      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _TabBarParentData childParentData =
          child.parentData! as _TabBarParentData;
      if (!childParentData.hidden) {
        context.paintChild(child, childParentData.offset + offset);
      }
      child = childParentData.nextSibling;
    }
  }
}
