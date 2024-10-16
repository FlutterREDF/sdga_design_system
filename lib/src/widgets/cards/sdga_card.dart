import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

part 'sdga_card_effect.dart';

enum _SDGACardType { normal, selectable, expandable }

/// A card serves as a container for information and actions related
/// to a specific concept or object. It typically resembles a rectangular
/// box that combines images, text, and potentially some interactive elements.
///
/// Cards enhance the visibility of information and facilitate predictable patterns.
class SDGACard extends StatefulWidget {
  /// Creates a normal card.
  const SDGACard({
    super.key,
    this.effect = SDGACardEffect.shadow,
    this.primaryAction,
    this.secondaryAction,
    this.image,
    this.imageAspectRatio = 16.0 / 9.0,
    this.icon,
    this.title,
    this.description,
    this.child,
    this.semanticContainer = true,
    this.padChildHorizontally = true,
    this.enabled = true,
  })  : _type = _SDGACardType.normal,
        padExpandedChildHorizontally = true,
        isSelected = false,
        isExpanded = false,
        expandedChild = null,
        onSelectionChanged = null,
        onExpandedChanged = null,
        onFocusChange = null,
        focusNode = null,
        autofocus = false;

  /// Creates a selectable card.
  ///
  /// The card itself does not maintain any state. Instead, when the state of
  /// the card changes, the widget calls the [onSelectionChanged] callback. Most
  /// widgets that use the selectable card will listen for the [onSelectionChanged]
  /// callback and rebuild the card with a new [isSelected] to update the visual
  /// appearance of the card.
  ///
  /// The following arguments are required:
  ///
  /// * [isSelected], which determines whether the card is selected.
  /// * [onSelectionChanged], which is called when the value of the selection
  ///   should change. It can be set to null to disable the checkbox.
  const SDGACard.selectable({
    super.key,
    this.effect = SDGACardEffect.shadow,
    this.image,
    this.imageAspectRatio = 16.0 / 9.0,
    this.icon,
    this.title,
    this.description,
    this.child,
    this.semanticContainer = true,
    this.padChildHorizontally = true,
    required this.isSelected,
    required this.onSelectionChanged,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
  })  : _type = _SDGACardType.selectable,
        padExpandedChildHorizontally = true,
        isExpanded = false,
        expandedChild = null,
        onExpandedChanged = null,
        primaryAction = null,
        secondaryAction = null,
        enabled = onSelectionChanged != null;

  /// Creates an expandable card
  ///
  /// The card itself does not maintain any state. Instead, when the state of
  /// the expansion changes, the widget calls the [onExpandedChanged] callback.
  /// Most widgets that use the expandable card will listen for the [onExpandedChanged]
  /// callback and rebuild the card with a new [isExpanded] to update the visual
  /// appearance of the card.
  ///
  /// The following arguments are required:
  ///
  /// * [isExpanded] determines whether this card is expanded or not.
  /// * [onExpandedChanged] is called when the user expands the card or collapse it.
  /// * [expandedChild] the child to display when expanded.
  const SDGACard.expandable({
    super.key,
    this.effect = SDGACardEffect.shadow,
    this.image,
    this.imageAspectRatio = 16.0 / 9.0,
    this.icon,
    this.title,
    this.description,
    this.child,
    this.semanticContainer = true,
    this.padChildHorizontally = true,
    this.padExpandedChildHorizontally = true,
    required this.isExpanded,
    required Widget this.expandedChild,
    required this.onExpandedChanged,
  })  : _type = _SDGACardType.expandable,
        isSelected = false,
        primaryAction = null,
        secondaryAction = null,
        onSelectionChanged = null,
        enabled = onExpandedChanged != null,
        onFocusChange = null,
        focusNode = null,
        autofocus = false;

  /// The visual effect to be applied to the card.
  final SDGACardEffect effect;

  /// The image to be displayed at the top of the card.
  ///
  /// The image will be automatically wrapped with a [ClipRRect] to
  /// clip the corners and it will have an aspect ratio of [imageAspectRatio]
  final Widget? image;

  /// The aspect ratio to attempt to use.
  ///
  /// The aspect ratio is expressed as a ratio of width to height. For example,
  /// a 16:9 width:height aspect ratio would have a value of 16.0/9.0.
  final double imageAspectRatio;

  /// The icon above the title to visually indicate the type of card.
  ///
  /// This is typically a [SDGAFeaturedIcon] with [SDGAFeaturedIcon.circular]
  /// set to `true`; for example:
  ///
  /// ```dart
  /// SDGACard(
  ///   title: Text('Card Title'),
  ///   icon: SDGAFeaturedIcon(
  ///     icon: SDGAIcon(SDGAIconsStroke.checkmarkCircle02),
  ///     circular: true,
  ///     size: SDGAFeaturedIconSizes.large,
  ///     color: SDGAWidgetColor.success,
  ///     style: SDGAFeaturedIconStyle.light,
  ///   ),
  /// );
  /// ```
  final Widget? icon;

  /// The main heading or label that provides a brief description or
  /// title for the content within the card.
  ///
  /// Typically a [Text] widget.
  ///
  /// {@macro sdga.text_style}
  final Widget? title;

  /// The description for the card.
  ///
  /// Typically a [Text] widget.
  ///
  /// {@macro sdga.text_style}
  final Widget? description;

  /// The widget below the title and description of the card.
  ///
  /// This is used to render a custom component within the card layout.
  /// It allows for integrating specialized UI elements to provide unique
  /// functionality or display tailored content.
  ///
  /// This will be wrapped with a [DefaultTextStyle] the uses the same
  /// text style of the [description] which is [SDGATextStyles.textMediumRegular]
  ///
  /// To lay out multiple children you can use a [Column] with
  /// [Column.mainAxisSize] set to [MainAxisSize.min] and use
  /// `const SizedBox(width: SDGANumbers.spacing3XL);` as a separator
  /// between the widgets; for example:
  ///
  /// {@template sdga.card_example_code}
  /// ```dart
  /// SDGACard(
  ///   title: Text('Card Title'),
  ///   padChildHorizontally: false,
  ///   child: Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       SizedBox(
  ///         height: 24,
  ///         child: ListView.separated(
  ///           padding: const EdgeInsetsDirectional.only(
  ///             start: SDGANumbers.spacingXL,
  ///           ),
  ///           scrollDirection: Axis.horizontal,
  ///           itemCount: 3,
  ///           itemBuilder: (context, index) => SDGATag(
  ///             size: SDGATagSize.small,
  ///             label: Text('Label $index'),
  ///           ),
  ///           separatorBuilder: (context, index) =>
  ///               const SizedBox(width: SDGANumbers.spacingMD),
  ///         ),
  ///       ),
  ///       const SizedBox(height: SDGANumbers.spacing3XL),
  ///       Padding(
  ///         padding: const EdgeInsets.symmetric(
  ///           horizontal: SDGANumbers.spacingXL,
  ///         ),
  ///         child: Column(
  ///           crossAxisAlignment: CrossAxisAlignment.stretch,
  ///           children: [
  ///             const SDGARatingBar(
  ///               size: SDGAWidgetSize.small,
  ///               useBrandColors: false,
  ///               value: 3.5,
  ///             ),
  ///             const SizedBox(height: SDGANumbers.spacingXS),
  ///             Text(
  ///               '12 reviews',
  ///               style: SDGATextStyles.textExtraSmallRegular.copyWith(
  ///                 color: SDGAColorScheme.of(context)
  ///                     .links
  ///                     .iconNeutralVisited,
  ///               ),
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     ],
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  final Widget? child;

  /// The primary action for this card.
  ///
  /// This is typically a [SDGAButton] with [SDGAButton.style] set
  /// to [SDGAButtonStyle.primaryBrand] and [SDGAButton.size] set to
  /// [SDGAWidgetSize.large]; for example:
  ///
  /// ```dart
  /// SDGACard(
  ///   title: Text('Card Title'),
  ///   primaryAction: SDGAButton(
  ///     style: SDGAButtonStyle.primaryBrand,
  ///     size: SDGAWidgetSize.large,
  ///     onPressed: () {},
  ///     child: Text('Action'),
  ///   ),
  /// )
  /// ```
  final Widget? primaryAction;

  /// The secondary action for this card.
  ///
  /// This is typically a [SDGAButton] with [SDGAButton.style] set
  /// to [SDGAButtonStyle.secondaryOutline] and [SDGAButton.size] set to
  /// [SDGAWidgetSize.large]; for example:
  ///
  /// ```dart
  /// SDGACard(
  ///   title: Text('Card Title'),
  ///   primaryAction: SDGAButton(
  ///     style: SDGAButtonStyle.secondaryOutline,
  ///     size: SDGAWidgetSize.large,
  ///     onPressed: () {},
  ///     child: Text('Action'),
  ///   ),
  /// )
  /// ```
  final Widget? secondaryAction;

  /// Whether the card is selected or not.
  final bool isSelected;

  /// Called when the value of the card's selection should change.
  ///
  /// The card passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the card with the new
  /// style.
  ///
  /// If this callback is null, the checkbox will be displayed as disabled
  /// and will not respond to input gestures.
  ///
  /// The callback provided to [onSelectionChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGACard(
  ///   isSelected: _cardSelected,
  ///   onSelectionChanged: (bool? newValue) {
  ///     setState(() {
  ///       _cardSelected = newValue!;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onSelectionChanged;

  /// The widget to show when this card is expanded.
  ///
  /// This will be wrapped with a [DefaultTextStyle] the uses the same
  /// text style of the [description] which is [SDGATextStyles.textMediumRegular]
  ///
  /// To lay out multiple children you can use a [Column] with
  /// [Column.mainAxisSize] set to [MainAxisSize.min] and use
  /// `const SizedBox(width: SDGANumbers.spacing3XL);` as a separator
  /// between the widgets; for example:
  ///
  /// {@template sdga.card_example_code2}
  /// ```dart
  /// SDGACard.expandable(
  ///   title: Text('Card Title'),
  ///   padExpandedChildHorizontally: false,
  ///   expandedChild: Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       SizedBox(
  ///         height: 24,
  ///         child: ListView.separated(
  ///           padding: const EdgeInsetsDirectional.only(
  ///             start: SDGANumbers.spacingXL,
  ///           ),
  ///           scrollDirection: Axis.horizontal,
  ///           itemCount: 3,
  ///           itemBuilder: (context, index) => SDGATag(
  ///             size: SDGATagSize.small,
  ///             label: Text('Label $index'),
  ///           ),
  ///           separatorBuilder: (context, index) =>
  ///               const SizedBox(width: SDGANumbers.spacingMD),
  ///         ),
  ///       ),
  ///       const SizedBox(height: SDGANumbers.spacing3XL),
  ///       Padding(
  ///         padding: const EdgeInsets.symmetric(
  ///           horizontal: SDGANumbers.spacingXL,
  ///         ),
  ///         child: SDGARating(
  ///           size: SDGAWidgetSize.small,
  ///           brand: false,
  ///           rating: 3.5,
  ///         ),
  ///       ),
  ///     ],
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  final Widget? expandedChild;

  /// Whether to apply a horizontal padding to the [child] or not.
  ///
  /// Defaults to `true`
  ///
  /// This is useful if you want to have a horizontal scroll within
  /// the card, see the following example code in which we set this to
  /// `false` and apply padding manually to other widgets inside the [Column].
  ///
  /// {@macro sdga.card_example_code}
  final bool padChildHorizontally;

  /// Whether to apply a horizontal padding to the [expandedChild] or not.
  ///
  /// Defaults to `true`
  ///
  /// This is useful if you want to have a horizontal scroll within
  /// the card, see the following example code in which we set this to
  /// `false` and apply padding manually to other widgets inside the [Column].
  ///
  /// {@macro sdga.card_example_code2}
  final bool padExpandedChildHorizontally;

  /// Whether the card is expanded or not.
  final bool isExpanded;

  /// Whether the card is enabled or not.
  final bool enabled;

  /// Called when the user expands the card or collapse it.
  ///
  /// The card passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the card with the new
  /// [isExpanded].
  ///
  /// If null, the card's expand button will be displayed as disabled.
  ///
  /// The callback provided to [onExpandedChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGACard.expandable(
  ///   onExpandedChanged: _isExpanded,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _isExpanded = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onExpandedChanged;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Whether this widget represents a single semantic container, or if false
  /// a collection of individual semantic nodes.
  ///
  /// Defaults to true.
  ///
  /// Setting this flag to true will attempt to merge all child semantics into
  /// this node. Setting this flag to false will force all child semantic nodes
  /// to be explicit.
  ///
  /// This flag should be false if the card contains multiple different types
  /// of content.
  final bool semanticContainer;
  final _SDGACardType _type;

  @override
  State<SDGACard> createState() => _SDGACardState();
}

class _SDGACardState extends State<SDGACard>
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
  void didUpdateWidget(covariant SDGACard oldWidget) {
    if (widget._type == _SDGACardType.expandable) {
      if (widget.isExpanded != oldWidget.isExpanded) {
        if (widget.isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final bool focusable = widget._type == _SDGACardType.selectable;

    return Semantics(
      container: widget.semanticContainer,
      explicitChildNodes: !widget.semanticContainer,
      child: SDGAAction(
        onFocusChange: widget.onFocusChange,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onTap: widget.enabled
            ? () {
                if (widget._type == _SDGACardType.selectable) {
                  widget.onSelectionChanged?.call(!widget.isSelected);
                }
              }
            : null,
        canRequestFocus: focusable,
        border: WidgetStateProperty.resolveWith(
          (states) => SDGAUtils.resolveWidgetStateUnordered<Border?>(
            states,
            fallback: widget.effect == SDGACardEffect.stroke
                ? Border.all(
                    color: colors.borders.neutralPrimary,
                  )
                : null,
            focused: focusable
                ? Border.all(color: colors.borders.black, width: 2)
                : null,
          ),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(SDGANumbers.radiusLarge),
        ),
        boxShadow: widget.effect == SDGACardEffect.shadow
            ? SDGAShadows.shadowMedium
            : null,
        mouseCursor: widget._type != _SDGACardType.selectable
            ? SystemMouseCursors.basic
            : null,
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => SDGAUtils.resolveWidgetStateUnordered(
            states,
            fallback: colors.backgrounds.card,
            disabled: colors.globals.backgroundDisabled,
            hovered: colors.backgrounds.neutral50,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(vertical: SDGANumbers.spacingXL),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget._type != _SDGACardType.selectable
              ? SDGANumbers.spacingXL
              : 44,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getChildren().toList(),
        ),
      ),
    );
    if (widget._type == _SDGACardType.selectable) {
      return Stack(
        children: [
          child,
          PositionedDirectional(
            end: 28,
            top: 28,
            child: ExcludeFocus(
              child: SDGACheckbox(
                disableRipple: true,
                value: widget.isSelected,
                size: SDGACheckBoxSize.small,
                onChanged: widget.onSelectionChanged != null
                    ? (value) => widget.onSelectionChanged!(value ?? false)
                    : null,
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  Iterable<Widget> _getChildren() sync* {
    const EdgeInsets padding =
        EdgeInsets.symmetric(horizontal: SDGANumbers.spacingXL);
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final List<Widget> children = [];
    final TextStyle defaultStyle = SDGATextStyles.textMediumRegular.copyWith(
      color: colors.texts.display,
    );
    final Widget? title = widget.title != null
        ? Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: SDGATextStyles.textLargeBold.copyWith(
                color: colors.texts.display,
              ),
              child: widget.title!,
            ),
          )
        : null;
    final Widget? description = widget.description != null
        ? Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: defaultStyle,
              child: widget.description!,
            ),
          )
        : null;
    if (widget.image != null) {
      children.add(Padding(
        padding: padding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(SDGANumbers.radiusMedium),
          ),
          child: AspectRatio(
            aspectRatio: widget.imageAspectRatio,
            child: widget.image!,
          ),
        ),
      ));
    }
    if (widget.icon != null) {
      children.add(Padding(
        padding: padding,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: 1,
          heightFactor: 1,
          child: widget.icon!,
        ),
      ));
    }

    if (title != null && description != null) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: SDGANumbers.spacingMD),
          description,
        ],
      ));
    } else if (title != null) {
      children.add(title);
    } else if (description != null) {
      children.add(description);
    }
    if (widget.child != null) {
      children.add(Padding(
        padding: widget.padChildHorizontally ? padding : EdgeInsets.zero,
        child: DefaultTextStyle(style: defaultStyle, child: widget.child!),
      ));
    }
    if (widget.primaryAction != null || widget.secondaryAction != null) {
      children.add(Padding(
        padding: padding,
        child: Row(
          children: [
            if (widget.secondaryAction != null) widget.secondaryAction!,
            if (widget.primaryAction != null) ...[
              if (widget.secondaryAction != null)
                const SizedBox(width: SDGANumbers.spacingXL),
              widget.primaryAction!
            ],
          ],
        ),
      ));
    }
    if (widget._type == _SDGACardType.expandable) {
      children.add(Padding(
        padding: padding,
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: SDGAButton.icon(
            style: SDGAButtonStyle.subtle,
            size: SDGAWidgetSize.large,
            onPressed: widget.onExpandedChanged != null
                ? () => widget.onExpandedChanged!(!widget.isExpanded)
                : null,
            icon: RotationTransition(
              turns: _iconTurns,
              child: const SDGAIcon(SDGAIconsStroke.arrowUp01),
            ),
          ),
        ),
      ));
    }
    bool isFirst = true;
    for (final child in children) {
      if (!isFirst) {
        yield const SizedBox(height: SDGANumbers.spacing3XL);
      }
      isFirst = false;
      yield child;
    }
    if (children.isEmpty) {
      // To enforce the minHeight to the card
      yield const SizedBox();
    }
    if (widget.expandedChild != null) {
      const EdgeInsets topPadding =
          EdgeInsets.only(top: SDGANumbers.spacing3XL);
      yield SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: _animationController,
        child: Padding(
          padding: widget.padExpandedChildHorizontally
              ? padding + topPadding
              : topPadding,
          child: DefaultTextStyle(
              style: defaultStyle, child: widget.expandedChild!),
        ),
      );
    }
  }
}
