part of 'sdga_menu.dart';

class _MenuDismissAction extends DismissAction {
  /// Creates a [_MenuDismissAction].
  _MenuDismissAction({required this.controller});

  /// The [MenuController] associated with the menus that should be closed.
  final SDGAMenuController controller;

  @override
  void invoke(DismissIntent intent) {
    controller._anchor!._root._close();
  }

  @override
  bool isEnabled(DismissIntent intent) {
    return controller.isOpen;
  }
}

class _MenuPreviousFocusAction extends PreviousFocusAction {
  @override
  bool invoke(PreviousFocusIntent intent) {
    final BuildContext? context = FocusManager.instance.primaryFocus?.context;
    if (context == null) {
      return super.invoke(intent);
    }
    final _SDGAMenuState? anchor = _SDGAMenuState._maybeOf(context);
    if (anchor == null || !anchor._root._isOpen) {
      return super.invoke(intent);
    }

    return _moveToPreviousFocusable(anchor);
  }

  static bool _moveToPreviousFocusable(_SDGAMenuState currentMenu) {
    final _SDGAMenuState? sibling = currentMenu._previousFocusableSibling;
    sibling?._focusButton();
    return true;
  }
}

class _MenuNextFocusAction extends NextFocusAction {
  @override
  bool invoke(NextFocusIntent intent) {
    final BuildContext? context = FocusManager.instance.primaryFocus?.context;
    if (context == null) {
      return super.invoke(intent);
    }
    final _SDGAMenuState? anchor = _SDGAMenuState._maybeOf(context);
    if (anchor == null || !anchor._root._isOpen) {
      return super.invoke(intent);
    }

    return _moveToNextFocusable(anchor);
  }

  static bool _moveToNextFocusable(_SDGAMenuState currentMenu) {
    final _SDGAMenuState? sibling = currentMenu._nextFocusableSibling;
    sibling?._focusButton();
    return true;
  }
}

class _MenuDirectionalFocusAction extends DirectionalFocusAction {
  /// Creates a [DirectionalFocusAction].
  _MenuDirectionalFocusAction();

  @override
  void invoke(DirectionalFocusIntent intent) {
    final BuildContext? context = FocusManager.instance.primaryFocus?.context;
    if (context == null) {
      super.invoke(intent);
      return;
    }
    final _SDGAMenuState? anchor = _SDGAMenuState._maybeOf(context);
    if (anchor == null || !anchor._root._isOpen) {
      super.invoke(intent);
      return;
    }
    final bool buttonIsFocused =
        anchor.widget.childFocusNode?.hasPrimaryFocus ?? false;
    final bool firstItemIsFocused =
        anchor._firstItemFocusNode?.hasPrimaryFocus ?? false;
    final bool rtl = Directionality.of(context) == TextDirection.rtl;

    final bool Function(_SDGAMenuState) traversal;
    switch (intent.direction) {
      case TraversalDirection.up:
        traversal = firstItemIsFocused ? _moveToParent : _moveToPrevious;
        break;
      case TraversalDirection.down:
        traversal = _moveToNext;
        break;
      case TraversalDirection.left:
        if (rtl) {
          traversal =
              buttonIsFocused ? _moveToSubmenu : _moveToNextFocusableTopLevel;
        } else {
          traversal = buttonIsFocused
              ? _moveToPreviousFocusableTopLevel
              : _moveToParent;
        }
        break;
      case TraversalDirection.right:
        if (!rtl) {
          traversal =
              buttonIsFocused ? _moveToSubmenu : _moveToNextFocusableTopLevel;
        } else {
          traversal = buttonIsFocused
              ? _moveToPreviousFocusableTopLevel
              : _moveToParent;
        }
        break;
      default:
        throw ArgumentError('Invalid intent.direction: ${intent.direction}');
    }

    if (!traversal(anchor)) {
      super.invoke(intent);
    }
  }

  bool _moveToNext(_SDGAMenuState currentMenu) {
    // Need to invalidate the scope data because we're switching scopes, and
    // otherwise the anti-hysteresis code will interfere with moving to the
    // correct node.
    if (currentMenu.widget.childFocusNode != null) {
      if (currentMenu.widget.childFocusNode!.nearestScope != null) {
        final FocusTraversalPolicy? policy =
            FocusTraversalGroup.maybeOf(primaryFocus!.context!);
        policy?.invalidateScopeData(
            currentMenu.widget.childFocusNode!.nearestScope!);
      }
    }
    return false;
  }

  bool _moveToNextFocusableTopLevel(_SDGAMenuState currentMenu) {
    final _SDGAMenuState? sibling = currentMenu._topLevel._nextFocusableSibling;
    sibling?._focusButton();
    return true;
  }

  bool _moveToParent(_SDGAMenuState currentMenu) {
    if (!(currentMenu.widget.childFocusNode?.hasPrimaryFocus ?? true)) {
      currentMenu._focusButton();
    }
    // else {
    //   currentMenu._parent?._firstItemFocusNode
    //       ?.focusInDirection(TraversalDirection.up);
    // }
    return true;
  }

  bool _moveToPrevious(_SDGAMenuState currentMenu) {
    // Need to invalidate the scope data because we're switching scopes, and
    // otherwise the anti-hysteresis code will interfere with moving to the
    // correct node.
    if (currentMenu.widget.childFocusNode != null) {
      if (currentMenu.widget.childFocusNode!.nearestScope != null) {
        final FocusTraversalPolicy? policy =
            FocusTraversalGroup.maybeOf(primaryFocus!.context!);
        policy?.invalidateScopeData(
            currentMenu.widget.childFocusNode!.nearestScope!);
      }
    }
    return false;
  }

  bool _moveToPreviousFocusableTopLevel(_SDGAMenuState currentMenu) {
    final _SDGAMenuState? sibling =
        currentMenu._topLevel._previousFocusableSibling;
    sibling?._focusButton();
    return true;
  }

  bool _moveToSubmenu(_SDGAMenuState currentMenu) {
    if (!currentMenu._isOpen) {
      // If no submenu is open, then an arrow opens the submenu.
      currentMenu._open();
      return true;
    } else {
      final FocusNode? firstNode = currentMenu._firstItemFocusNode;
      if (firstNode != null && firstNode.nearestScope != firstNode) {
        // Don't request focus if the "first" found node is a focus scope, since
        // that means that nothing else in the submenu is focusable.
        firstNode.requestFocus();
      }
      return true;
    }
  }
}
