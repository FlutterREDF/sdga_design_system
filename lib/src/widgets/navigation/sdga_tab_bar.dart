import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:sdga_design_system/src/src.dart';
import 'package:sdga_icons/sdga_icons.dart';

part 'sdga_tab_wrapper.dart';

const double _kPadding = SDGANumbers.spacingSM;

/// This class represents a single tab item that can be displayed in [SDGATabBar].
class SDGATab {
  const SDGATab({
    required this.title,
    this.icon,
    this.onPressed,
    this.selected = false,
  });

  /// The title of this tab.
  ///
  /// Typically a [Text] widget.
  ///
  /// {@macro sdga.text_style}
  final Widget title;

  /// The icon to be displayed before the title.
  ///
  /// Typically an [Icon] widget
  ///
  /// {@macro sdga.icon_style}
  final Widget? icon;

  /// Called when the tab is tapped.
  ///
  /// If this callback is null, then the tab will be disabled.
  final VoidCallback? onPressed;

  /// Whether this tab is selected or not.
  final bool selected;
}

/// A widget that displays a set of tabs for navigation or content organization.
///
/// The [SDGATabBar] provides a way to organize and navigate between different
/// sections or views in your application. It displays a list of tabs, represented
/// by [SDGATab], and allows the user to switch between them.
///
/// If all tabs cannot fit within the available width of the tab bar, the overflowing
/// tabs will be replaced with a "more" button. Clicking this button will open a
/// menu displaying the overflowing tabs.
///
/// {@tool sample}
/// ```dart
///  SDGATabBar(
///    tabs: List.generate(5, (index) {
///      return SDGATab(
///        title: Text("Tab $index"),
///        selected: _selectedItem == index,
///        icon: const SDGAIcon(SDGAIconsStroke.home06),
///        onPressed: () => setState(() => _selectedItem = index),
///      );
///    }),
///  );
/// ```
/// {@end-tool}
///
///
/// To use the [SDGATabBar] with [TabController] refer to the following example
/// {@tool sample}
/// ```dart
///  ListenableBuilder(
///    listenable: _controller,
///    builder: (context, child) {
///      return SDGATabBar(
///        tabs: List.generate(5, (index) {
///          return SDGATab(
///            title: Text("Tab $index"),
///            selected: _controller.index == index,
///            icon: const SDGAIcon(SDGAIconsStroke.home06),
///            onPressed: () => _controller.animateTo(index),
///          );
///        }),
///      );
///    },
///  );
/// ```
/// {@end-tool}
class SDGATabBar extends StatefulWidget {
  /// Creates an [SDGATabBar] widget
  SDGATabBar({
    super.key,
    this.size = SDGAWidgetSize.large,
    required this.tabs,
    this.showBottomDivider = true,
    this.direction = Axis.horizontal,
  }) : assert(tabs.where((tab) => tab.selected).length <= 1,
            'Only one tab can be selected at a time.');

  /// Defines the size of this tab bar.
  final SDGAWidgetSize size;

  /// Typically a list of two or more [SDGATab] widgets.
  final List<SDGATab> tabs;

  /// Determines whether to show a divider at the bottom of the tab bar or not.
  final bool showBottomDivider;

  /// The orientation of the tab bar (horizontal or vertical).
  final Axis direction;

  @override
  State<SDGATabBar> createState() => _SDGATabBarState();
}

class _SDGATabBarState extends State<SDGATabBar> {
  Set<int> _invisibleTabs = {};

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    Widget child;
    switch (widget.direction) {
      case Axis.horizontal:
        child = SizedBox(
          height: _size,
          child: LayoutBuilder(builder: (context, _) {
            return _TabBarWrapper(
              selectedIndex: widget.tabs.indexWhere((tab) => tab.selected),
              onVisibleIndicesChanged: (visibleIndices) {
                Set<int> invisible = {};
                for (var i = 0; i < widget.tabs.length; i++) {
                  if (!visibleIndices.contains(i)) invisible.add(i);
                }
                _invisibleTabs = invisible;
              },
              children: List.generate(
                widget.tabs.length + 1,
                (index) => index < widget.tabs.length
                    ? _buildTab(context, index)
                    : _buildMoreButton(context),
              ),
            );
          }),
        );
        break;
      case Axis.vertical:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            widget.tabs.length,
            (index) => _buildTab(context, index),
          ),
        );
        break;
    }

    if (widget.showBottomDivider) {
      final BorderSide border = BorderSide(
        width: 3,
        color: colors.borders.neutralPrimary,
        strokeAlign: -1,
      );
      return DecoratedBox(
        decoration: BoxDecoration(
          border: SDGAIndicatorBorder(
            padding: 0,
            border: BorderDirectional(
              bottom: widget.direction == Axis.horizontal
                  ? border
                  : BorderSide.none,
              start:
                  widget.direction == Axis.vertical ? border : BorderSide.none,
            ),
          ),
        ),
        child: child,
      );
    } else {
      return child;
    }
  }

  BoxBorder _getBorder(Color color) => SDGAIndicatorBorder(
        padding: widget.direction == Axis.horizontal
            ? _padding.horizontal / 2
            : _padding.vertical / 2,
        border: BorderDirectional(
          bottom: widget.direction == Axis.horizontal
              ? BorderSide(width: 3, color: color)
              : BorderSide.none,
          start: widget.direction == Axis.vertical
              ? BorderSide(width: 3, color: color)
              : BorderSide.none,
        ),
      );

  Widget _buildTab(BuildContext context, int index) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final SDGATab tab = widget.tabs[index];
    final BoxBorder selectedBorder = _getBorder(colors.backgrounds.primary);

    Widget builder(bool visible) {
      return MergeSemantics(
        key: SaltedKey(context, index),
        child: Semantics(
          excludeSemantics: !visible,
          button: visible ? true : null,
          enabled: visible ? tab.onPressed != null : null,
          child: SDGAAction(
            canRequestFocus: visible,
            selected: tab.selected,
            onTap: tab.onPressed,
            borderRadius: const BorderRadius.all(
                Radius.circular(SDGANumbers.radiusExtraSmall)),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => SDGAUtils.resolveWidgetStateUnordered(
                states,
                fallback: null,
                pressed: colors.buttons.backgroundNeutralPressed,
                hovered: colors.buttons.backgroundNeutralHovered,
              ),
            ),
            textColor: WidgetStateProperty.resolveWith(
              (states) => SDGAUtils.resolveWidgetStateUnordered(
                states,
                fallback: colors.texts.defaultColor,
                disabled: colors.globals.textDefaultDisabled,
              ),
            ),
            border: WidgetStateProperty.resolveWith(
              (states) => SDGAUtils.resolveWidgetStateUnordered(
                states,
                fallback: null,
                focused: tab.selected
                    ? SDGADoubleBorder(
                        firstBorder: Border.all(
                          color: colors.borders.black,
                          width: 2,
                        ),
                        secondBorder: selectedBorder,
                      )
                    : Border.all(
                        color: colors.borders.black,
                        width: 2,
                      ),
                pressed: _getBorder(colors.backgrounds.neutral800),
                selected: selectedBorder,
              ),
            ),
            textStyle: WidgetStateProperty.resolveWith(
              (states) => SDGAUtils.resolveWidgetStateUnordered(
                states,
                fallback: SDGATextStyles.textSmallMedium,
                selected: widget.size == SDGAWidgetSize.large
                    ? SDGATextStyles.textSmallSemiBold
                    : SDGATextStyles.textSmallBold,
              ),
            ),
            child: Padding(
              padding: _padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.icon != null) ...[
                    IconTheme.merge(
                      data: const IconThemeData(size: 16),
                      child: tab.icon!,
                    ),
                    const SizedBox(width: SDGANumbers.spacingXS),
                  ],
                  tab.title,
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (widget.direction == Axis.horizontal) {
      return _buildVisibleAwareWidget(builder);
    } else {
      return builder(true);
    }
  }

  Widget _buildMoreButton(BuildContext context) {
    return _buildVisibleAwareWidget(
      (visible) => SDGAMenu(
        buildItems: (context, controller) {
          return List.generate(
            _invisibleTabs.length,
            (index) {
              final SDGATab tab = widget.tabs[_invisibleTabs.elementAt(index)];
              return SDGAMenuItem(
                label: tab.title,
                leading: tab.icon,
                onTap: tab.onPressed != null
                    ? () {
                        tab.onPressed!();
                        controller.close();
                      }
                    : null,
              );
            },
          );
        },
        builder: (context, controller, child) {
          return SDGAButton.icon(
            key: SaltedKey(context, widget.tabs.length),
            isSemanticButton: visible ? true : null,
            canRequestFocus: visible,
            style: SDGAButtonStyle.subtle,
            size: SDGAWidgetSize.medium,
            onPressed: visible ? controller.open : null,
            icon: const SDGAIcon(
              SDGAIconsStroke.moreHorizontalCircle01,
            ),
          );
        },
      ),
    );
  }

  /// A workaround function to check if the widget is currently visible or not
  ///
  /// This is used to disable focus and accessibility in widgets that are hidden
  Widget _buildVisibleAwareWidget(Widget Function(bool visible) builder) {
    return StatefulBuilder(builder: (context, setState) {
      final _TabBarParentData? parentData =
          context.findRenderObject()?.parentData as _TabBarParentData?;
      final bool visible = parentData?.hidden != true;
      // If parentData is null, the widget is not layed out in the tree yet
      if (parentData == null) {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) => context.mounted ? setState(() {}) : null,
        );
      }
      return builder(visible);
    });
  }

  EdgeInsetsGeometry get _padding {
    bool isVertical = widget.direction == Axis.vertical;
    double vertical;
    switch (widget.size) {
      case SDGAWidgetSize.small:
        vertical = isVertical ? SDGANumbers.spacingXXS : SDGANumbers.spacingMD;
        break;
      case SDGAWidgetSize.medium:
        vertical = isVertical ? SDGANumbers.spacingSM : SDGANumbers.spacingLG;
        break;
      case SDGAWidgetSize.large:
        vertical = isVertical ? SDGANumbers.spacingMD : SDGANumbers.spacingXL;
        break;
    }
    return EdgeInsets.symmetric(
      vertical: vertical,
      horizontal: SDGANumbers.spacingLG,
    );
  }

  double get _size {
    switch (widget.size) {
      case SDGAWidgetSize.small:
        return 36.0;
      case SDGAWidgetSize.medium:
        return 44.0;
      case SDGAWidgetSize.large:
        return 52.0;
    }
  }
}
