import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_menu_item.dart';
part 'sdga_menu_actions.dart';

// How close to the edge of the safe area the menu will be placed.
const double _kMenuViewPadding = 8;

typedef SDGAMenuBuilder = Widget Function(
  BuildContext context,
  SDGAMenuController controller,
  Widget? child,
);
typedef SDGAMenuBuildItems = List<SDGAMenuItem> Function(
  BuildContext context,
  SDGAMenuController controller,
);

// Navigation shortcuts that we need to make sure are active when menus are
// open.
const Map<ShortcutActivator, Intent> _kMenuTraversalShortcuts =
    <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
  SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
  SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
  SingleActivator(LogicalKeyboardKey.tab, shift: true): PreviousFocusIntent(),
  SingleActivator(LogicalKeyboardKey.arrowDown):
      DirectionalFocusIntent(TraversalDirection.down),
  SingleActivator(LogicalKeyboardKey.arrowUp):
      DirectionalFocusIntent(TraversalDirection.up),
  SingleActivator(LogicalKeyboardKey.arrowLeft):
      DirectionalFocusIntent(TraversalDirection.left),
  SingleActivator(LogicalKeyboardKey.arrowRight):
      DirectionalFocusIntent(TraversalDirection.right),
};

class SDGAMenu extends StatefulWidget {
  const SDGAMenu({
    super.key,
    this.controller,
    this.childFocusNode,
    this.alignmentOffset,
    this.alignment,
    this.consumeOutsideTap = false,
    this.onOpen,
    this.onClose,
    required this.buildItems,
    this.builder,
    this.child,
  });

  /// An optional controller that allows opening and closing of the menu from
  /// other widgets.
  final SDGAMenuController? controller;

  /// The [childFocusNode] attribute is the optional [FocusNode] also associated
  /// the [child] or [builder] widget that opens the menu.
  ///
  /// The focus node should be attached to the widget that should receive focus
  /// if keyboard focus traversal moves the focus off of the submenu with the
  /// arrow keys.
  ///
  /// If not supplied, then keyboard traversal from the menu back to the
  /// controlling button when the menu is open is disabled.
  final FocusNode? childFocusNode;

  /// The offset of the menu relative to the alignment origin determined by
  /// [alignment] attribute and the ambient [Directionality].
  ///
  /// Use this for adjustments of the menu placement.
  ///
  /// Increasing [Offset.dy] values of [alignmentOffset] move the menu position
  /// down.
  ///
  /// If the [alignment] is not an [AlignmentDirectional]
  /// (e.g. [Alignment]), then increasing [Offset.dx] values of
  /// [alignmentOffset] move the menu position to the right.
  ///
  /// If the [alignment] is an [AlignmentDirectional],
  /// then in a [TextDirection.ltr] [Directionality], increasing [Offset.dx]
  /// values of [alignmentOffset] move the menu position to the right. In a
  /// [TextDirection.rtl] directionality, increasing [Offset.dx] values of
  /// [alignmentOffset] move the menu position to the left.
  ///
  /// Defaults to [Offset.zero].
  final Offset? alignmentOffset;

  /// Determines the desired alignment of the submenu when opened relative to
  /// the button that opens it.
  ///
  /// If there isn't sufficient space to open the menu with the given alignment,
  /// and there's space on the other side of the button, then the alignment is
  /// swapped to it's opposite (1 becomes -1, etc.), and the menu will try to
  /// appear on the other side of the button. If there isn't enough space there
  /// either, then the menu will be pushed as far over as necessary to display
  /// as much of itself as possible, possibly overlapping the parent button.
  final AlignmentGeometry? alignment;

  /// Whether or not a tap event that closes the menu will be permitted to
  /// continue on to the gesture arena.
  ///
  /// If false, then tapping outside of a menu when the menu is open will both
  /// close the menu, and allow the tap to participate in the gesture arena. If
  /// true, then it will only close the menu, and the tap event will be
  /// consumed.
  ///
  /// Defaults to false.
  final bool consumeOutsideTap;

  /// A callback that is invoked when the menu is opened.
  final VoidCallback? onOpen;

  /// A callback that is invoked when the menu is closed.
  final VoidCallback? onClose;

  // /// A list of children containing the menu items that are the contents of the
  // /// menu surrounded by this [SDGAMenu].
  // final List<Widget> menuChildren;

  /// A callback that builds the list of menu items that are the contents of the
  /// menu surrounded by this [SDGAMenu].
  final SDGAMenuBuildItems buildItems;

  /// The widget that this [SDGAMenu] surrounds.
  ///
  /// Typically this is a button used to open the menu by calling
  /// [SDGAMenuController.open] on the `controller` passed to the builder.
  ///
  /// If not supplied, then the [SDGAMenu] will be the size that its parent
  /// allocates for it.
  final SDGAMenuBuilder? builder;

  /// The optional child to be passed to the [builder].
  ///
  /// Supply this child if there is a portion of the widget tree built in
  /// [builder] that doesn't depend on the `controller` or `context` supplied to
  /// the [builder]. It will be more efficient, since Flutter doesn't then need
  /// to rebuild this child when those change.
  final Widget? child;

  @override
  State<SDGAMenu> createState() => _SDGAMenuState();
}

class _SDGAMenuState extends State<SDGAMenu> {
  // This is the global key that is used later to determine the bounding rect
  // for the anchor's region that the CustomSingleChildLayout's delegate
  // uses to determine where to place the menu on the screen and to avoid the
  // view's edges.
  final OverlayPortalController _overlayController = OverlayPortalController();
  final GlobalKey<_SDGAMenuState> _anchorKey = GlobalKey<_SDGAMenuState>();
  final List<_SDGAMenuState> _anchorChildren = <_SDGAMenuState>[];
  late final FocusScopeNode _menuScopeNode;
  SDGAMenuController? _internalMenuController;
  ScrollPosition? _scrollPosition;
  Offset? _menuPosition;
  Size? _viewSize;
  _SDGAMenuState? _parent;

  bool get _isOpen => _overlayController.isShowing;
  bool get _isRoot => _parent == null;
  bool get _isTopLevel => _parent?._isRoot ?? false;
  SDGAMenuController get _menuController =>
      widget.controller ?? _internalMenuController!;

  @override
  void initState() {
    super.initState();
    _menuScopeNode = FocusScopeNode();
    if (widget.controller == null) {
      _internalMenuController = SDGAMenuController();
    }
    _menuController._attach(this);
  }

  @override
  void dispose() {
    if (_isOpen) {
      _close(inDispose: true);
    }

    _parent?._removeChild(this);
    _parent = null;
    _anchorChildren.clear();
    _menuController._detach(this);
    _internalMenuController = null;
    _menuScopeNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _SDGAMenuState? newParent = _SDGAMenuState._maybeOf(context);
    if (newParent != _parent) {
      _parent?._removeChild(this);
      _parent = newParent;
      _parent?._addChild(this);
    }
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScroll);
    _scrollPosition = Scrollable.maybeOf(context)?.position;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScroll);
    final Size newSize = MediaQuery.sizeOf(context);
    if (_viewSize != null && newSize != _viewSize) {
      // Close the menus if the view changes size.
      _root._close();
    }
    _viewSize = newSize;
  }

  @override
  void didUpdateWidget(SDGAMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      if (widget.controller != null) {
        _internalMenuController?._detach(this);
        _internalMenuController = null;
        widget.controller?._attach(this);
      } else {
        assert(_internalMenuController == null);
        _internalMenuController = SDGAMenuController().._attach(this);
      }
    }
    assert(_menuController._anchor == this);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (BuildContext context) {
        return _Submenu(
          anchor: this,
          alignment: widget.alignment,
          alignmentOffset: widget.alignmentOffset ?? Offset.zero,
          menuPosition: _menuPosition,
          menuChildren: widget.buildItems(context, _menuController),
        );
      },
      child: _buildContents(context),
    );

    child = TapRegion(
      groupId: _root,
      consumeOutsideTaps: _root._isOpen && widget.consumeOutsideTap,
      onTapOutside: (PointerDownEvent event) {
        _closeChildren();
      },
      child: child,
    );

    return _SDGAMenuScope(
      anchorKey: _anchorKey,
      anchor: this,
      isOpen: _isOpen,
      child: child,
    );
  }

  Widget _buildContents(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        DirectionalFocusIntent: _MenuDirectionalFocusAction(),
        PreviousFocusIntent: _MenuPreviousFocusAction(),
        NextFocusIntent: _MenuNextFocusAction(),
        DismissIntent: _MenuDismissAction(controller: _menuController),
      },
      child: Builder(
        key: _anchorKey,
        builder: (BuildContext context) {
          return widget.builder?.call(context, _menuController, widget.child) ??
              widget.child ??
              const SizedBox();
        },
      ),
    );
  }

  // Returns the first focusable item in the submenu, where "first" is
  // determined by the focus traversal policy.
  FocusNode? get _firstItemFocusNode {
    if (_menuScopeNode.context == null) {
      return null;
    }
    final FocusTraversalPolicy policy =
        FocusTraversalGroup.maybeOf(_menuScopeNode.context!) ??
            ReadingOrderTraversalPolicy();
    return policy.findFirstFocus(_menuScopeNode, ignoreCurrentFocus: true);
  }

  void _addChild(_SDGAMenuState child) {
    assert(_isRoot);
    assert(!_anchorChildren.contains(child));
    _anchorChildren.add(child);
  }

  void _removeChild(_SDGAMenuState child) {
    assert(_isRoot);
    assert(_anchorChildren.contains(child));
    _anchorChildren.remove(child);
  }

  List<_SDGAMenuState> _getFocusableChildren() {
    if (_parent == null) {
      return <_SDGAMenuState>[];
    }
    return _parent!._anchorChildren.where(
      (_SDGAMenuState menu) {
        return menu.widget.childFocusNode?.canRequestFocus ?? false;
      },
    ).toList();
  }

  _SDGAMenuState? get _nextFocusableSibling {
    final List<_SDGAMenuState> focusable = _getFocusableChildren();
    if (focusable.isEmpty) {
      return null;
    }
    return focusable[(focusable.indexOf(this) + 1) % focusable.length];
  }

  _SDGAMenuState? get _previousFocusableSibling {
    final List<_SDGAMenuState> focusable = _getFocusableChildren();
    if (focusable.isEmpty) {
      return null;
    }
    return focusable[
        (focusable.indexOf(this) - 1 + focusable.length) % focusable.length];
  }

  _SDGAMenuState get _root {
    _SDGAMenuState anchor = this;
    while (anchor._parent != null) {
      anchor = anchor._parent!;
    }
    return anchor;
  }

  _SDGAMenuState get _topLevel {
    _SDGAMenuState handle = this;
    while (handle._parent != null && !handle._parent!._isTopLevel) {
      handle = handle._parent!;
    }
    return handle;
  }

  void _childChangedOpenState() {
    _parent?._childChangedOpenState();
    assert(mounted);
    if (SchedulerBinding.instance.schedulerPhase !=
        SchedulerPhase.persistentCallbacks) {
      setState(() {
        // Mark dirty now, but only if not in a build.
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((Duration _) {
        setState(() {
          // Mark dirty after this frame, but only if in a build.
        });
      });
    }
  }

  void _focusButton() {
    if (widget.childFocusNode == null) {
      return;
    }
    widget.childFocusNode!.requestFocus();
  }

  void _handleScroll() {
    // If an ancestor scrolls, and we're a root anchor, then close the menus.
    // Don't just close it on *any* scroll, since we want to be able to scroll
    // menus themselves if they're too big for the view.
    if (_isRoot) {
      _close();
    }
  }

  KeyEventResult _checkForEscape(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Open the menu, optionally at a position relative to the [MenuAnchor].
  ///
  /// Call this when the menu should be shown to the user.
  ///
  /// The optional `position` argument will specify the location of the menu in
  /// the local coordinates of the [MenuAnchor], ignoring any
  /// [MenuStyle.alignment] and/or [MenuAnchor.alignmentOffset] that were
  /// specified.
  void _open({Offset? position}) {
    assert(_menuController._anchor == this);
    if (_isOpen && position == null) {
      return;
    }
    if (_isOpen && position != null) {
      // The menu is already open, but we need to move to another location, so
      // close it first.
      _close();
    }
    _parent?._closeChildren(); // Close all siblings.
    assert(!_overlayController.isShowing);

    _parent?._childChangedOpenState();
    _menuPosition = position;
    _overlayController.show();

    widget.onOpen?.call();
  }

  /// Close the menu.
  ///
  /// Call this when the menu should be closed. Has no effect if the menu is
  /// already closed.
  void _close({bool inDispose = false}) {
    if (!_isOpen) {
      return;
    }
    if (_isRoot) {
      FocusManager.instance.removeEarlyKeyEventHandler(_checkForEscape);
    }
    _closeChildren(inDispose: inDispose);
    // Don't hide if we're in the middle of a build.
    if (SchedulerBinding.instance.schedulerPhase !=
        SchedulerPhase.persistentCallbacks) {
      _overlayController.hide();
    } else if (!inDispose) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _overlayController.hide();
      }, debugLabel: 'MenuAnchor.hide');
    }
    if (!inDispose) {
      // Notify that _childIsOpen changed state, but only if not
      // currently disposing.
      _parent?._childChangedOpenState();
      widget.onClose?.call();
      if (mounted &&
          SchedulerBinding.instance.schedulerPhase !=
              SchedulerPhase.persistentCallbacks) {
        setState(() {
          // Mark dirty, but only if mounted and not in a build.
        });
      }
    }
  }

  void _closeChildren({bool inDispose = false}) {
    for (final _SDGAMenuState child
        in List<_SDGAMenuState>.from(_anchorChildren)) {
      child._close(inDispose: inDispose);
    }
  }

  // Returns the active anchor in the given context, if any, and creates a
  // dependency relationship that will rebuild the context when the node
  // changes.
  static _SDGAMenuState? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SDGAMenuScope>()?.anchor;
  }
}

class SDGAMenuController {
  /// The anchor that this controller controls.
  ///
  /// This is set automatically when a [SDGAMenuController] is given to the anchor
  /// it controls.
  _SDGAMenuState? _anchor;

  /// Whether or not the associated menu is currently open.
  bool get isOpen {
    assert(_anchor != null);
    return _anchor!._isOpen;
  }

  /// Close the menu that this menu controller is associated with.
  ///
  /// Associating with a menu is done by passing a [SDGAMenuController] to a
  /// [SDGAMenu]. A [SDGAMenuController] is also be received by the
  /// [SDGAMenu.builder] when invoked.
  ///
  /// If the menu's anchor point is scrolled by an ancestor, or the
  /// view changes size, then any open menu will automatically close.
  void close() {
    assert(_anchor != null);
    _anchor!._close();
  }

  /// Opens the menu that this menu controller is associated with.
  ///
  /// If `position` is given, then the menu will open at the position given, in
  /// the coordinate space of the [SDGAMenu] this controller is attached to.
  ///
  /// If given, the `position` will override the [SDGAMenu.alignmentOffset]
  /// given to the [SDGAMenu].
  ///
  /// If the menu's anchor point is scrolled by an ancestor, or the view
  /// changes size, then any open menu will automatically close.
  void open({Offset? position}) {
    assert(_anchor != null);
    _anchor!._open(position: position);
  }

  // ignore: use_setters_to_change_properties
  void _attach(_SDGAMenuState anchor) {
    _anchor = anchor;
  }

  void _detach(_SDGAMenuState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

class _SDGAMenuScope extends InheritedWidget {
  const _SDGAMenuScope({
    required super.child,
    required this.anchorKey,
    required this.anchor,
    required this.isOpen,
  });

  final GlobalKey anchorKey;
  final _SDGAMenuState anchor;
  final bool isOpen;

  @override
  bool updateShouldNotify(_SDGAMenuScope oldWidget) {
    return anchorKey != oldWidget.anchorKey ||
        anchor != oldWidget.anchor ||
        isOpen != oldWidget.isOpen;
  }
}

// A widget that defines the menu drawn in the overlay.
class _Submenu extends StatelessWidget {
  const _Submenu({
    required this.anchor,
    required this.alignment,
    required this.menuPosition,
    required this.alignmentOffset,
    required this.menuChildren,
  });

  final _SDGAMenuState anchor;
  final AlignmentGeometry? alignment;
  final Offset? menuPosition;
  final Offset alignmentOffset;
  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    // Use the text direction of the context where the button is.
    final TextDirection textDirection = Directionality.of(context);

    final BuildContext anchorContext = anchor._anchorKey.currentContext!;
    final RenderBox overlay =
        Overlay.of(anchorContext).context.findRenderObject()! as RenderBox;
    final RenderBox anchorBox = anchorContext.findRenderObject()! as RenderBox;
    final Offset upperLeft =
        anchorBox.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight = anchorBox
        .localToGlobal(anchorBox.paintBounds.bottomRight, ancestor: overlay);
    final Rect anchorRect = Rect.fromPoints(upperLeft, bottomRight);

    return ConstrainedBox(
      constraints: BoxConstraints.loose(overlay.paintBounds.size),
      child: CustomSingleChildLayout(
        delegate: _MenuLayout(
          anchorRect: anchorRect,
          textDirection: textDirection,
          alignment: alignment ?? Alignment.bottomLeft,
          alignmentOffset: alignmentOffset,
          menuPosition: menuPosition,
          avoidBounds:
              DisplayFeatureSubScreen.avoidBounds(MediaQuery.of(context))
                  .toSet(),
        ),
        child: TapRegion(
          groupId: anchor._root,
          consumeOutsideTaps:
              anchor._root._isOpen && anchor.widget.consumeOutsideTap,
          onTapOutside: (PointerDownEvent event) {
            anchor._close();
          },
          child: MouseRegion(
            cursor: MouseCursor.uncontrolled,
            hitTestBehavior: HitTestBehavior.deferToChild,
            child: FocusScope(
              node: anchor._menuScopeNode,
              skipTraversal: true,
              child: Actions(
                actions: <Type, Action<Intent>>{
                  DirectionalFocusIntent: _MenuDirectionalFocusAction(),
                  DismissIntent:
                      _MenuDismissAction(controller: anchor._menuController),
                },
                child: Shortcuts(
                  shortcuts: _kMenuTraversalShortcuts,
                  child: _MenuPanel(children: menuChildren),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Positions the menu in the view while trying to keep as much as possible
// visible in the view.
class _MenuLayout extends SingleChildLayoutDelegate {
  const _MenuLayout({
    required this.anchorRect,
    required this.textDirection,
    required this.alignment,
    required this.alignmentOffset,
    required this.menuPosition,
    required this.avoidBounds,
  });

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final Rect anchorRect;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The alignment to use when finding the ideal location for the menu.
  final AlignmentGeometry alignment;

  // The offset from the alignment position to find the ideal location for the
  // menu.
  final Offset alignmentOffset;

  // The position passed to the open method, if any.
  final Offset? menuPosition;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus _kMenuViewPadding
    // pixels in each direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuViewPadding),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    final Rect overlayRect = Offset.zero & size;
    double x;
    double y;
    if (menuPosition == null) {
      Offset desiredPosition =
          alignment.resolve(textDirection).withinRect(anchorRect);
      final Offset directionalOffset;
      if (alignment is AlignmentDirectional) {
        switch (textDirection) {
          case TextDirection.rtl:
            directionalOffset = Offset(-alignmentOffset.dx, alignmentOffset.dy);
            break;
          case TextDirection.ltr:
            directionalOffset = alignmentOffset;
        }
      } else {
        directionalOffset = alignmentOffset;
      }
      desiredPosition += directionalOffset;
      x = desiredPosition.dx;
      y = desiredPosition.dy;
      switch (textDirection) {
        case TextDirection.rtl:
          x -= childSize.width;
          break;
        case TextDirection.ltr:
          break;
      }
    } else {
      final Offset adjustedPosition = menuPosition! + anchorRect.topLeft;
      x = adjustedPosition.dx + _kMenuViewPadding;
      y = adjustedPosition.dy;
    }

    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(overlayRect, avoidBounds);
    final Rect allowedRect = _closestScreen(subScreens, anchorRect.center);
    bool offLeftSide(double x) => x < allowedRect.left;
    bool offRightSide(double x) => x + childSize.width > allowedRect.right;
    bool offTop(double y) => y < allowedRect.top;
    bool offBottom(double y) => y + childSize.height > allowedRect.bottom;
    // Avoid going outside an area defined as the rectangle offset from the
    // edge of the screen by the button padding. If the menu is off of the screen,
    // move the menu to the other side of the button first, and then if it
    // doesn't fit there, then just move it over as much as needed to make it
    // fit.
    if (childSize.width >= allowedRect.width) {
      // It just doesn't fit, so put as much on the screen as possible.
      x = allowedRect.left;
    } else {
      if (offLeftSide(x)) {
        x = allowedRect.left + _kMenuViewPadding;
      } else if (offRightSide(x)) {
        x = allowedRect.right - childSize.width - _kMenuViewPadding;
      }
    }
    if (childSize.height >= allowedRect.height) {
      // Too tall to fit, fit as much on as possible.
      y = allowedRect.top;
    } else {
      if (offTop(y)) {
        final double newY = anchorRect.bottom;
        if (!offBottom(newY)) {
          y = newY;
        } else {
          y = allowedRect.top;
        }
      } else if (offBottom(y)) {
        final double newY =
            anchorRect.top - childSize.height - _kMenuViewPadding;
        if (!offTop(newY)) {
          y = newY - alignmentOffset.dy;
        } else {
          y = allowedRect.bottom - childSize.height;
        }
      }
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) {
    return anchorRect != oldDelegate.anchorRect ||
        textDirection != oldDelegate.textDirection ||
        alignment != oldDelegate.alignment ||
        alignmentOffset != oldDelegate.alignmentOffset ||
        menuPosition != oldDelegate.menuPosition ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }
}

/// A widget that manages a list of menu buttons in a menu.
///
/// It sizes itself to the widest/tallest item it contains, and then sizes all
/// the other entries to match.
class _MenuPanel extends StatefulWidget {
  const _MenuPanel({required this.children});

  /// The list of widgets to use as children of this menu bar.
  ///
  /// These are the top level [SubmenuButton]s.
  final List<Widget> children;

  @override
  State<_MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends State<_MenuPanel> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240),
      child: IntrinsicWidth(
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.none,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.backgrounds.white,
              boxShadow: SDGAShadows.shadow2XL,
              border: Border.all(color: colors.borders.backgroundNeutral),
              borderRadius: const BorderRadius.all(
                Radius.circular(SDGANumbers.radiusMedium),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: SDGANumbers.spacingMD),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                ),
                child: PrimaryScrollController(
                  controller: scrollController,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: Directionality.of(context),
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
