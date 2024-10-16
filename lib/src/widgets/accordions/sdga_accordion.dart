import 'package:flutter/material.dart';
import 'package:sdga_design_system/src/src.dart';

part 'sdga_accordion_enums.dart';

/// Signature for the callback that's called when an [SDGAAccordion] is
/// expanded or collapsed.
///
/// The position of the accordion within an [SDGAAccordionList] is given by
/// [accordionIndex].
typedef SDGAAccordionCallback = void Function(
    int accordionIndex, bool isExpanded);

/// The accordion is used to collapse and expand content to
/// organize it more efficiently. It allows for hiding and
/// displaying content as needed. It reduces clutter and
/// helps maintain the user’s focus by showing only the
/// relevant content at a time. The body of the accordion
/// is only visible when it is expanded.
///
/// Accordions are only intended to be used as children for
/// [SDGAAccordionList].
///
/// See [SDGAAccordionList] for a sample implementation.
class SDGAAccordion<T> {
  const SDGAAccordion({
    required this.title,
    required this.body,
    required this.value,
    this.disabled = false,
  });

  /// The title of the accordion.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  ///
  /// {@macro sdga.text_style}
  final Widget title;

  /// The body of the accordion that's displayed below the title.
  ///
  /// This widget is visible only when the accordion is expanded.
  final Widget body;

  /// The value that uniquely identifies this accordion so that
  /// the currently selected one can be identified.
  final T value;

  /// Whether this accordion is disabled or not.
  final bool disabled;
}

/// A widget that displays a list of expandable accordion items.
///
/// This widget allows for a customizable list of accordion items, where each item
/// can be expanded or collapsed. It's generic over type [T], which represents
/// the type of value associated with each accordion item.
/// 
/// {@tool sample}
/// ```dart
/// SDGAAccordionList(
///   initialOpenAccordionValue: 1,
///   children: const [
///     SDGAAccordion(
///       value: 1,
///       title: Text('Accordion 1', maxLines: 1),
///       body: Text('Accordion content'),
///     ),
///     SDGAAccordion(
///       value: 2,
///       title: Text('Accordion 2', maxLines: 1),
///       body: Text('Accordion content'),
///     ),
///     SDGAAccordion(
///       value: 3,
///       title: Text('Accordion 3', maxLines: 1),
///       body: Text('Accordion content'),
///     ),
///   ],
/// );
/// ```
/// {@end-tool}
class SDGAAccordionList<T> extends StatefulWidget {
  /// Creates an SDGAAccordionList.
  const SDGAAccordionList({
    super.key,
    this.size = SDGAWidgetSize.large,
    this.iconAffinity = SDGAAccordionIconAffinity.trailing,
    this.initialOpenAccordionValue,
    this.children = const [],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.flushPadding = false,
  });

  /// Defines the size of this accordion's header.
  final SDGAWidgetSize size;

  /// Where to place the arrow icon for the accordion widgets.
  final SDGAAccordionIconAffinity iconAffinity;

  /// The value of the accordion that initially begins open.
  final T? initialOpenAccordionValue;

  /// The children of the accordion list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<SDGAAccordion<T>> children;

  /// The callback that gets called whenever an expand/collapse event
  /// is occurred. The arguments passed to the callback are the index of the
  /// pressed accordion and whether the accordion is currently expanded or not.
  ///
  /// This callback may be called a second time if a different accordion was previously
  /// open. The arguments passed to the second callback are the index of the accordion
  /// that will close and false, marking that it will be closed.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// accordions in a parent widget that may need to react to these changes.
  final SDGAAccordionCallback? expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  /// Determines whether to remove the horizontal padding or not.
  final bool flushPadding;

  @override
  State<SDGAAccordionList<T>> createState() => _SDGAAccordionListState<T>();
}

class _SDGAAccordionListState<T> extends State<SDGAAccordionList<T>> {
  SDGAAccordion<T>? _currentOpenAccordion;

  @override
  void initState() {
    super.initState();
    assert(_allIdentifiersUnique(),
        'All SDGAAccordion<T> identifier values must be unique.');
    if (widget.initialOpenAccordionValue != null) {
      for (final SDGAAccordion<T> accordion in widget.children) {
        if (accordion.value == widget.initialOpenAccordionValue) {
          _currentOpenAccordion = accordion;
        }
      }
    }
  }

  @override
  void didUpdateWidget(SDGAAccordionList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(_allIdentifiersUnique(),
        'All SDGAAccordion<T> identifier values must be unique.');
  }

  bool _allIdentifiersUnique() {
    final Map<T, bool> identifierMap = <T, bool>{};
    for (final SDGAAccordion<T> child
        in widget.children.cast<SDGAAccordion<T>>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    return _currentOpenAccordion?.value == widget.children[index].value;
  }

  void _handlePressed(bool isExpanded, int index) {
    final SDGAAccordion<T> pressedChild = widget.children[index];

    // If another SDGAAccordion<T> was already open, apply its
    // expansionCallback (if any) to false, because it's closing.
    for (int childIndex = 0;
        childIndex < widget.children.length;
        childIndex += 1) {
      final SDGAAccordion<T> child = widget.children[childIndex];
      if (widget.expansionCallback != null &&
          childIndex != index &&
          child.value == _currentOpenAccordion?.value) {
        widget.expansionCallback!(childIndex, false);
      }
    }

    setState(() {
      _currentOpenAccordion = isExpanded ? null : pressedChild;
    });

    widget.expansionCallback?.call(index, !isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final EdgeInsets padding = widget.flushPadding
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingXL);
    final List<Widget> items = <Widget>[];

    for (int index = 0; index < widget.children.length; index++) {
      final SDGAAccordion<T> child = widget.children[index];
      final bool isExpanded = child.value == _currentOpenAccordion?.value;
      final String onTapHint = isExpanded
          ? localizations.expandedIconTapHint
          : localizations.collapsedIconTapHint;
      Widget header = SDGAAction(
        onTap: !child.disabled
            ? () => _handlePressed(_isChildExpanded(index), index)
            : null,
        border: WidgetStateProperty.resolveWith(
          (states) => SDGAUtils.resolveWidgetStateUnordered(
            states,
            fallback:
                Border(top: BorderSide(color: colors.borders.neutralPrimary)),
            focused: Border.all(color: colors.borders.black, width: 2),
          ),
        ),
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
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: _headerSize),
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                if (widget.iconAffinity ==
                    SDGAAccordionIconAffinity.leading) ...[
                  SDGAExpandIcon(isExpanded: isExpanded),
                  const SizedBox(width: SDGANumbers.spacingXL),
                ],
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: SDGATextStyles.textMediumSemiBold,
                    child: child.title,
                  ),
                ),
                if (widget.iconAffinity ==
                    SDGAAccordionIconAffinity.trailing) ...[
                  const SizedBox(width: SDGANumbers.spacingXL),
                  SDGAExpandIcon(isExpanded: isExpanded),
                ],
              ],
            ),
          ),
        ),
      );
      items.add(Column(
        key: SaltedKey<BuildContext, int>(context, index),
        children: [
          MergeSemantics(
            child: Semantics(
              container: true,
              button: !child.disabled,
              label: !child.disabled ? onTapHint : null,
              onTapHint: !child.disabled ? onTapHint : null,
              child: header,
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsetsDirectional.only(
                top: SDGANumbers.spacingMD,
                bottom: SDGANumbers.spacing3XL,
                start: widget.flushPadding ? 0 : SDGANumbers.spacingXL,
                end: widget.flushPadding
                    ? SDGANumbers.spacing4XL
                    : SDGANumbers.spacing6XL,
              ),
              child: child.body,
            ),
            firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
            crossFadeState: _isChildExpanded(index)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: widget.animationDuration,
          ),
        ],
      ));
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borders.neutralPrimary),
        ),
      ),
      child: ListBody(
        children: items,
      ),
    );
  }

  double get _headerSize {
    switch (widget.size) {
      case SDGAWidgetSize.small:
        return 40.0;
      case SDGAWidgetSize.medium:
        return 48.0;
      case SDGAWidgetSize.large:
        return 56.0;
    }
  }
}
