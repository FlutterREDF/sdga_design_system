import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class SDGAPagination extends StatelessWidget {
  /// Creates a SDGA Pagination.
  ///
  /// The pagination widget itself does not maintain any state. Instead, when the current page
  /// changes, the widget calls the [onPageChange] callback. Most widgets that use pagination
  /// will listen for the [onPageChange] callback and rebuild the pagination widget with a new
  /// [currentPage] to update the visual appearance of the pagination controls.
  ///
  /// The following arguments are required:
  ///
  /// * [onPageChange], which is called when the value of the [currentPage] should change.
  ///   It can be set to null to disable the pagination interaction.
  const SDGAPagination({
    super.key,
    required this.onPageChange,
    this.currentPage = 1,
    this.totalPageCount = 1,
    this.size = SDGAWidgetSize.medium,
  })  : assert(totalPageCount >= 1,
            "The [totalPageCount] must be at least 1 or more"),
        assert(currentPage >= 1 && currentPage <= totalPageCount,
            "The [currentPage] must be between 1 <= $currentPage <= $totalPageCount");

  /// A callback function that triggers when the page is changed.
  ///
  /// [onPageChange] takes an integer [page] parameter representing
  /// the new page number. Pages are indexed starting from 1, not zero.
  /// This is an optional callback, so if null, all buttons will be disabled.
  final void Function(int page)? onPageChange;

  /// The currently selected page.
  ///
  /// [currentPage] represents the page number that is currently active.
  /// Note that page indexing starts from 1, so the first page will be 1.
  final int currentPage;

  /// The total number of pages available.
  ///
  /// [totalPageCount] defines the total number of pages in the pagination system.
  /// This value must be greater than or equal to 1.
  final int totalPageCount;

  /// Specifies the size of the navigation buttons.
  final SDGAWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return SizedBox(
      height: _size,
      child: LayoutBuilder(builder: (context, constraints) {
        final items = _generateItems(constraints.maxWidth);
        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: items.length + 2,
          separatorBuilder: (context, index) =>
              const SizedBox(width: SDGANumbers.spacingMD),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildButton(
                  context: context, colors: colors, pageIndex: 0);
            } else if (index == items.length + 1) {
              return _buildButton(
                  context: context, colors: colors, pageIndex: -1);
            }
            final int realIndex = (index - 1).clamp(0, items.length - 1);
            final int? page = items[realIndex];
            return _buildButton(
                context: context, colors: colors, pageIndex: page);
          },
        );
      }),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required int? pageIndex,
    required SDGAColorScheme colors,
  }) {
    Widget child;
    bool enabled = pageIndex != null && onPageChange != null;
    if (pageIndex == 0) {
      child = const SDGAIcon(SDGAIconsStroke.arrowLeft01, size: 16);
      enabled = enabled && currentPage > 1;
    } else if (pageIndex == -1) {
      child = const SDGAIcon(SDGAIconsStroke.arrowRight01, size: 16);
      enabled = enabled && currentPage < totalPageCount;
    } else if (pageIndex != null) {
      child = Text("$pageIndex");
    } else {
      child = const Text("...");
    }

    return SDGAAction(
      selected: currentPage == pageIndex,
      textColor: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered<Color?>(
          states,
          fallback: colors.texts.defaultColor,
          disabled: colors.globals.textDefaultDisabled,
        ),
      ),
      borderRadius:
          const BorderRadius.all(Radius.circular(SDGANumbers.radiusSmall)),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered<Color?>(
          states,
          fallback: null,
          focused: colors.buttons.backgroundNeutralFocused,
          hovered: colors.buttons.backgroundNeutralHovered,
          pressed: colors.buttons.backgroundNeutralPressed,
        ),
      ),
      border: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: null,
          selected: SDGAIndicatorBorder(
            padding: 4,
            border: BorderDirectional(
              bottom: BorderSide(
                width: 3.0,
                color: colors.backgrounds.primary,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          ),
          focused: Border.all(
            color: colors.borders.black,
            width: 2,
          ),
        ),
      ),
      onTap: enabled
          ? () {
              if (pageIndex == 0) {
                onPageChange!(currentPage - 1);
              } else if (pageIndex == -1) {
                onPageChange!(currentPage + 1);
              } else if (pageIndex! != currentPage) {
                onPageChange!(pageIndex);
              }
            }
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: _size),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: DefaultTextStyle.merge(
            style: SDGATextStyles.textMediumRegular,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  /// A function that generates the page numbers depending on the available width
  List<int?> _generateItems(double width) {
    // Subtract the arrow buttons width and the padding
    final double availableWidth = width - _size * 2 - SDGANumbers.spacingMD;
    final int totalAvailable =
        (availableWidth / (_size + SDGANumbers.spacingMD)).floor().clamp(0, 7);
    if (totalPageCount <= totalAvailable) {
      return List.generate(totalPageCount, (index) => index + 1);
    }
    final int firstPages = totalAvailable - 2;
    List<int?> items = [];
    if (currentPage < firstPages) {
      for (var i = 1; i <= firstPages; i++) {
        items.add(i);
      }
      items.add(null);
      items.add(totalPageCount);
    } else if (currentPage > totalPageCount - firstPages + 1) {
      items.add(1);
      items.add(null);
      for (var i = totalPageCount - firstPages + 1; i <= totalPageCount; i++) {
        items.add(i);
      }
    } else if (totalAvailable >= 5) {
      items.add(1);
      items.add(null);
      if (totalAvailable >= 7) items.add(currentPage - 1);
      items.add(currentPage);
      if (totalAvailable >= 7) items.add(currentPage + 1);
      items.add(null);
      items.add(totalPageCount);
    } else if (totalAvailable >= 3) {
      if (currentPage > 1) items.add(null);
      if (currentPage == totalPageCount) items.add(currentPage - 1);
      items.add(currentPage);
      if (currentPage == 1) items.add(currentPage + 1);
      if (currentPage < totalPageCount) items.add(null);
    } else if (totalAvailable > 0) {
      items.add(currentPage);
    }
    return items;
  }

  double get _size {
    switch (size) {
      case SDGAWidgetSize.small:
        return 24.0;
      case SDGAWidgetSize.medium:
        return 32.0;
      case SDGAWidgetSize.large:
        return 40.0;
    }
  }
}
