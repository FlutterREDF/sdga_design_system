import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_modal_header.dart';
part 'sdga_modal_draggable.dart';
part 'sdga_modal_utils.dart';

class SDGAModal extends StatelessWidget {
  const SDGAModal({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.headerLeadingAction,
    this.headerTrailingAction,
    this.actionsDirection = Axis.vertical,
    this.showCloseButton = true,
    this.padChildHorizontally = true,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro sdga.text_style}
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The title of the accordion.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  ///
  /// {@macro sdga.text_style}
  final Widget title;

  /// The action that will be displayed before the title.
  ///
  /// This is typically a [SDGAButton] widget with [SDGAButton.style] set
  /// to [SDGAButtonStyle.subtle] and [SDGAButton.size] set to
  /// [SDGAWidgetSize.small]; for example:
  ///
  /// ```dart
  /// SDGAModal(
  ///   headerLeadingAction: SDGAButton(
  ///     style: SDGAButtonStyle.subtle,
  ///     size: SDGAWidgetSize.small,
  ///     onPressed: () {},
  ///     child: const Text('Button'),
  ///   ),
  ///   title: const Text('Modal Title'),
  ///   child: const Text('Modal Body'),
  /// )
  /// ```
  final Widget? headerLeadingAction;

  /// The action that will be displayed after the title.
  ///
  /// This is typically a [SDGAButton] widget with [SDGAButton.style] set
  /// to [SDGAButtonStyle.subtle] and [SDGAButton.size] set to
  /// [SDGAWidgetSize.small]; for example:
  ///
  /// ```dart
  /// SDGAModal(
  ///   headerTrailingAction: SDGAButton(
  ///     style: SDGAButtonStyle.subtle,
  ///     size: SDGAWidgetSize.small,
  ///     onPressed: () {},
  ///     child: const Text('Button'),
  ///   ),
  ///   title: const Text('Modal Title'),
  ///   child: const Text('Modal Body'),
  /// )
  /// ```
  final Widget? headerTrailingAction;

  /// The direction in which to place the actions
  ///
  /// It's only recommended that you use [Axis.vertical] if you have more
  /// than two actions.
  ///
  /// If this is set to [Axis.horizontal] actions will be placed within a
  /// [Column] with padding between each action.
  ///
  /// If this is set to [Axis.vertical] actions will be placed within a
  /// [Row] and each action will be wrapped with [Expanded].
  final Axis actionsDirection;

  /// Whether to show the close button next to the [title]  or not.
  ///
  /// This will only take effect if [headerTrailingAction] is null.
  final bool showCloseButton;

  /// The list of widgets to be displayed as actions for the alert.
  ///
  /// These are typically a [SDGAButton] widget; for example:
  ///
  /// ```dart
  /// SDGAModal(
  ///   actions: [
  ///     SDGAButton(
  ///       style: SDGAButtonStyle.primaryNeutral,
  ///       size: SDGAWidgetSize.medium,
  ///       onPressed: () {},
  ///       child: const Text('Confirm'),
  ///     ),
  ///     SDGAButton(
  ///       style: SDGAButtonStyle.secondaryOutline,
  ///       size: SDGAWidgetSize.medium,
  ///       onPressed: () {},
  ///       child: const Text('Cancel'),
  ///     ),
  ///   ],
  ///   title: const Text('Modal Title'),
  ///   child: const Text('Modal Body'),
  /// )
  /// ```
  final List<Widget>? actions;

  /// Whether to apply a horizontal padding to the [child] or not.
  ///
  /// Defaults to `true`
  ///
  /// This is useful if you want to have a horizontal scroll within
  /// the modal
  final bool padChildHorizontally;

  @override
  Widget build(BuildContext context) {
    Widget? effectiveHeaderTrailing = headerTrailingAction;
    if (effectiveHeaderTrailing == null && showCloseButton) {
      effectiveHeaderTrailing = SDGAButton.close(
        size: SDGACloseButtonSize.medium,
        onPressed: () => Navigator.pop(context),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SDGANumbers.spacingXL,
              vertical: SDGANumbers.spacingMD,
            ),
            child: _ModalHeader(
              notch: const _ModalNotch(),
              title: title,
              leading: headerLeadingAction,
              trailing: effectiveHeaderTrailing,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padChildHorizontally ? SDGANumbers.spacingXL : 0,
              vertical: SDGANumbers.spacingMD,
            ),
            child: child,
          ),
          if (actions != null)
            Padding(
              padding: EdgeInsets.only(
                left: SDGANumbers.spacingXL,
                right: SDGANumbers.spacingXL,
                bottom: math.max(
                  MediaQuery.paddingOf(context).bottom,
                  SDGANumbers.spacingXL,
                ),
              ),
              child: Flex(
                direction: actionsDirection,
                crossAxisAlignment: actionsDirection == Axis.vertical
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.center,
                children: _paddedActions!,
              ),
            ),
        ],
      ),
    );
  }

  List<Widget>? get _paddedActions {
    final List<Widget>? actions = this.actions;
    final bool vertical = actionsDirection == Axis.vertical;
    if (actions == null || actions.isEmpty) return actions;
    if (actions.length == 1 && !vertical) return [Expanded(child: actions[0])];
    return List.generate(
      actions.length * 2 - 1,
      (index) {
        final int itemIndex = index ~/ 2;
        if (index.isEven) {
          return vertical
              ? actions[itemIndex]
              : Expanded(child: actions[itemIndex]);
        }
        if (vertical) {
          return const SizedBox(height: SDGANumbers.spacingMD);
        } else {
          return const SizedBox(width: SDGANumbers.spacingMD);
        }
      },
    );
  }
}
