part of 'sdga_modal.dart';

// TODO(Osama)
// Create a method to show modal

Future<T?> showSDGAModal<T>({
  required BuildContext context,
  required ScrollableWidgetBuilder builder,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool shouldCloseOnMinExtent = true,
}) {
  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  // TODO duplicate this? or use theirs?
  return navigator.push(ModalBottomSheetRoute<T>(
    builder: (context) => SDGADraggableScrollable(
      builder: builder,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent,
    ),
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    isScrollControlled: true,
    // scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    // barrierLabel: barrierLabel ?? localizations.scrimLabel,
    // barrierOnTapHint:
    //     localizations.scrimOnTapHint(localizations.bottomSheetLabel),
    // backgroundColor: backgroundColor,
    // elevation: elevation,
    // shape: shape,
    // clipBehavior: clipBehavior,
    // constraints: constraints,
    // isDismissible: isDismissible,
    // modalBarrierColor:
    //     barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
    // enableDrag: enableDrag,
    // showDragHandle: showDragHandle,
    // settings: routeSettings,
    // transitionAnimationController: transitionAnimationController,
    // anchorPoint: anchorPoint,
    // useSafeArea: useSafeArea,
    // sheetAnimationStyle: sheetAnimationStyle,
  ));
}
