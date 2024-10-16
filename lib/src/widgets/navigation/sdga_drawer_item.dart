part of 'sdga_drawer.dart';

enum _SDGADrawerItemType { link, expandable, divider }

/// A widget that represent a drawer item in the [SDGADrawer].
class SDGADrawerItem extends StatefulWidget {
  /// Creates a link drawer item.
  const SDGADrawerItem({
    super.key,
    this.leading,
    required String this.label,
    this.trailing,
    this.onTap,
    this.excludeTrailingFocus = true,
    this.excludeLeadingFocus = true,
    this.selected = false,
  })  : _type = _SDGADrawerItemType.link,
        enabled = onTap != null,
        initiallyExpanded = false,
        items = null;

  /// Creates an expandable drawer item.
  const SDGADrawerItem.expandable({
    super.key,
    this.initiallyExpanded = false,
    this.leading,
    required String this.label,
    this.enabled = true,
    required List<SDGADrawerSubItem> this.items,
  })  : _type = _SDGADrawerItemType.expandable,
        selected = false,
        excludeTrailingFocus = true,
        excludeLeadingFocus = true,
        trailing = null,
        onTap = null;

  /// Creates a divider between items.
  const SDGADrawerItem.divider({super.key})
      : _type = _SDGADrawerItemType.divider,
        selected = false,
        excludeTrailingFocus = true,
        excludeLeadingFocus = true,
        enabled = true,
        initiallyExpanded = false,
        leading = null,
        label = null,
        trailing = null,
        items = null,
        onTap = null;

  /// A widget to display before the label.
  ///
  /// Typically an [Icon] widget.
  ///
  /// {@macro sdga.icon_style}
  final Widget? leading;

  /// The label for this drawer item.
  final String? label;

  /// A widget to display after the label.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Whether this drawer item is selected or not.
  final bool selected;

  /// Whether this drawer item is interactive.
  ///
  /// If false, this drawer item is styled with the disabled color.
  final bool enabled;

  /// Called when the user taps this drawer item.
  ///
  /// If null, this drawer item is styled with the disabled color.
  final GestureTapCallback? onTap;

  /// Specifies if the drawer item is initially expanded (true) or
  /// collapsed (false, the default).
  final bool initiallyExpanded;

  /// Whether to wrap the[trailing] widget with an [ExcludeFocus] or not
  ///
  /// The is useful if the [onTap] callback has the same functionality as
  /// the widget placed as a [trailing]
  ///
  /// Defaults to `true`.
  final bool excludeTrailingFocus;

  /// Whether to wrap the[leading] widget with an [ExcludeFocus] or not
  ///
  /// The is useful if the [onTap] callback has the same functionality as
  /// the widget placed as a [leading]
  ///
  /// Defaults to `true`.
  final bool excludeLeadingFocus;

  /// The items of this parent drawer item. They are laid out in a similar
  /// fashion to [ListBody].
  final List<SDGADrawerSubItem>? items;

  final _SDGADrawerItemType _type;

  @override
  State<SDGADrawerItem> createState() => _SDGADrawerItemState();
}

class _SDGADrawerItemState extends State<SDGADrawerItem>
    with _SDGADrawerItemStyle {
  bool _isExpanded = false;

  bool get _onColor => _SDGADrawerOptions.maybeOf(context)?.onColor ?? false;

  @override
  void initState() {
    _isExpanded = widget.initiallyExpanded;
    if (widget._type == _SDGADrawerItemType.expandable) {
      final hasSelection = widget.items?.any((item) => item.selected);
      if (hasSelection == true && !_isExpanded) _isExpanded = true;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SDGADrawerItem oldWidget) {
    if (widget._type == _SDGADrawerItemType.expandable) {
      final hasSelection = widget.items?.any((item) => item.selected);
      if (hasSelection == true && !_isExpanded) _isExpanded = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    switch (widget._type) {
      case _SDGADrawerItemType.link:
        return _buildItem(colors: colors);
      case _SDGADrawerItemType.expandable:
        return Column(
          children: [
            _buildItem(colors: colors, expandable: true),
            AnimatedCrossFade(
              duration: kThemeAnimationDuration,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Column(children: widget.items ?? []),
              firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
              secondCurve:
                  const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
              sizeCurve: Curves.fastOutSlowIn,
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            )
          ],
        );
      case _SDGADrawerItemType.divider:
        return _buildDivider(colors);
    }
  }

  Widget _buildDivider(SDGAColorScheme colors) {
    return Container(
      height: 1,
      color:
          _onColor ? colors.alphas.white30 : colors.borders.backgroundNeutral,
      margin: const EdgeInsets.symmetric(
        vertical: SDGANumbers.spacingLG,
        horizontal: SDGANumbers.spacingXL,
      ),
    );
  }

  Widget _buildItem({
    required SDGAColorScheme colors,
    bool expandable = false,
  }) {
    final bool onColor = _onColor;
    Widget? trailing = widget.trailing;
    VoidCallback? onTap = widget.onTap;
    if (expandable) {
      trailing = SDGAExpandIcon(isExpanded: _isExpanded);
      onTap = widget.enabled
          ? () => setState(() => _isExpanded = !_isExpanded)
          : null;
    }
    return SDGAAction(
      selected: widget.selected,
      onTap: onTap,
      borderRadius:
          const BorderRadius.all(Radius.circular(SDGANumbers.radiusSmall)),
      border: _getBorder(colors, onColor, expandable),
      backgroundColor: _getBackgroundColor(colors, onColor),
      textColor: _getTextColor(colors, onColor),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: SDGATextStyles.textSmallSemiBold,
          selected: SDGATextStyles.textSmallSemiBold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SDGANumbers.spacingLG,
          horizontal: SDGANumbers.spacingXL,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(size: 16),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                if (widget.excludeLeadingFocus)
                  ExcludeFocus(child: widget.leading!)
                else
                  widget.leading!,
                const SizedBox(width: SDGANumbers.spacingMD),
              ],
              Expanded(child: Text(widget.label!)),
              if (trailing != null) ...[
                const SizedBox(width: SDGANumbers.spacingMD),
                if (widget.excludeTrailingFocus)
                  ExcludeFocus(child: trailing)
                else
                  trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that represent a sub-item for the [SDGADrawerItem.expandable].
class SDGADrawerSubItem extends StatelessWidget with _SDGADrawerItemStyle {
  /// Creates a sub item link for the expandable drawer item.
  const SDGADrawerSubItem({
    super.key,
    required this.label,
    this.trailing,
    this.selected = false,
    this.onTap,
    this.excludeTrailingFocus = true,
  });

  /// The label for this drawer sub-item.
  final String label;

  /// A widget to display after the label.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Whether this drawer sub-item is selected or not.
  final bool selected;

  /// Called when the user taps this drawer sub-item.
  ///
  /// If null, this drawer sub-item is styled with the disabled color.
  final GestureTapCallback? onTap;

  /// Whether to wrap the[trailing] widget with an [ExcludeFocus] or not
  ///
  /// The is useful if the [onTap] callback has the same functionality as
  /// the widget placed as a [trailing]
  ///
  /// Default to `true`
  final bool excludeTrailingFocus;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final bool onColor = _SDGADrawerOptions.maybeOf(context)?.onColor ?? false;

    return SDGAAction(
      selected: selected,
      onTap: onTap,
      borderRadius:
          const BorderRadius.all(Radius.circular(SDGANumbers.radiusSmall)),
      border: _getBorder(colors, onColor),
      backgroundColor: _getBackgroundColor(colors, onColor),
      textColor: _getTextColor(colors, onColor),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: SDGATextStyles.textSmallRegular,
          selected: SDGATextStyles.textSmallSemiBold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: SDGANumbers.spacingLG,
          horizontal: SDGANumbers.spacingXL,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(size: 16),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Expanded(child: Text(label)),
              if (trailing != null) ...[
                const SizedBox(width: SDGANumbers.spacingMD),
                if (excludeTrailingFocus)
                  ExcludeFocus(child: trailing!)
                else
                  trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

mixin _SDGADrawerItemStyle {
  WidgetStateProperty<Color?> _getBackgroundColor(
    SDGAColorScheme colors,
    bool onColor,
  ) =>
      WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: null,
          pressed: onColor
              ? colors.buttons.backgroundTransparentPressed
              : colors.buttons.backgroundNeutralPressed,
          hovered: onColor
              ? colors.buttons.backgroundTransparentHovered
              : colors.buttons.backgroundNeutralHovered,
          selected: onColor
              ? colors.buttons.backgroundTransparentSelected
              : colors.buttons.backgroundNeutralSelected,
        ),
      );

  WidgetStateProperty<Color?> _getTextColor(
    SDGAColorScheme colors,
    bool onColor,
  ) =>
      WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback:
              onColor ? colors.texts.onColorPrimary : colors.texts.defaultColor,
          selected:
              onColor ? colors.texts.onColorPrimary : colors.texts.primary,
          pressed:
              onColor ? colors.texts.onColorPrimary : colors.texts.defaultColor,
          disabled: onColor
              ? colors.globals.textDefaultOnColorDisabled
              : colors.globals.textDefaultDisabled,
        ),
      );

  WidgetStateProperty<BoxBorder?> _getBorder(
    SDGAColorScheme colors,
    bool onColor, [
    bool expandable = false,
  ]) =>
      WidgetStateProperty.resolveWith(
        (states) => SDGAUtils.resolveWidgetStateUnordered(
          states,
          fallback: null,
          focused: Border.all(
            color: onColor ? colors.borders.white : colors.borders.black,
            width: 2,
          ),
          selected: SDGAIndicatorBorder(
            padding: 6,
            border: BorderDirectional(
              start: BorderSide(
                width: 6,
                color: onColor
                    ? colors.backgrounds.white
                    : colors.backgrounds.primary,
              ),
            ),
          ),
          pressed: !expandable
              ? SDGAIndicatorBorder(
                  padding: 6,
                  border: BorderDirectional(
                    start: BorderSide(
                      width: 6,
                      color: onColor
                          ? colors.alphas.white60
                          : colors.backgrounds.neutral800,
                    ),
                  ),
                )
              : null,
        ),
      );
}
