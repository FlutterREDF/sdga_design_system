import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

/// A widget that displays a notification toast with customizable appearance and behavior.
///
/// The SDGANotificationToast provides a way to show temporary notifications or alerts
/// that typically appear at the top or bottom of the screen. It supports various
/// alert types, custom icons, and optional actions.
///
/// {@tool sample}
/// ```dart
/// SDGANotificationToast(
///   type: SDGAAlertType.info,
///   title: const Text('Notification'),
///   icon: const SDGAIcon(SDGAIconsStroke.helpCircle),
///   onDismissPressed: () {},
///   helperText: const Text('Helper Text'),
///   actions: [
///     SDGAButton(
///       style: SDGAButtonStyle.subtle,
///       size: SDGAWidgetSize.small,
///       child: const Text('Button'),
///       onPressed: () {},
///     ),
///     SDGAButton(
///       style: SDGAButtonStyle.subtle,
///       size: SDGAWidgetSize.small,
///       child: const Text('Button'),
///       onPressed: () {},
///     ),
///   ],
/// );
/// ```
/// {@end-tool}
class SDGANotificationToast extends StatelessWidget {
  /// Creates an SDGANotificationToast.
  const SDGANotificationToast({
    super.key,
    this.type = SDGAAlertType.neutral,
    required this.title,
    required this.icon,
    this.helperText,
    this.onDismissPressed,
    this.actions,
  });

  /// The type of the notification.
  ///
  /// This can be used to apply different visual styles to the notification, such
  /// as different colors or icons.
  final SDGAAlertType type;

  /// The title of this notification.
  ///
  /// {@macro sdga.text_style}
  final Widget title;

  /// The icon to be displayed before the notification's title.
  ///
  /// {@macro sdga.icon_style}
  final Widget icon;

  /// Additional information or context about the notification.
  ///
  /// This can be used to provide more details or explanations to the user.
  ///
  /// {@macro sdga.text_style}
  final Widget? helperText;

  /// The callback function to be called when the user taps the close button.
  ///
  /// If this parameter is `null`, the close button will be hidden.
  final VoidCallback? onDismissPressed;

  /// The list of widgets to be displayed as actions for the notification.
  ///
  /// These are typically [SDGAButton] with [SDGAButton.style] set
  /// to [SDGAButtonStyle.subtle] and [SDGAButton.size] set to
  /// [SDGAWidgetSize.small]; for example:
  ///
  /// ```dart
  /// SDGANotificationToast(
  ///   title: Text('Notification'),
  ///   icon: Icon(Icons.info),
  ///   actions: [
  ///     SDGAButton(
  ///       style: SDGAButtonStyle.subtle,
  ///       size: SDGAWidgetSize.small,
  ///       onPressed: () {},
  ///       child: Text('Confirm'),
  ///     ),
  ///   ],
  /// )
  /// ```
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SDGANumbers.spacingXL,
        horizontal: SDGANumbers.spacing3XL,
      ),
      child: Row(
        crossAxisAlignment: helperText != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SDGAFeaturedIcon(
            circular: true,
            icon: icon,
            color: type.color,
            size: SDGAFeaturedIconSizes.small,
            style: SDGAFeaturedIconStyle.light,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextStyle(
                  style: SDGATextStyles.textMediumSemiBold
                      .copyWith(color: colors.texts.defaultColor),
                  child: title,
                ),
                if (helperText != null) ...[
                  const SizedBox(height: 8),
                  DefaultTextStyle(
                    style: SDGATextStyles.textSmallRegular
                        .copyWith(color: colors.texts.secondaryParagraph),
                    child: helperText!,
                  ),
                ],
              ],
            ),
          ),
          if (onDismissPressed != null) ...[
            const SizedBox(width: 8),
            SDGAButton.close(
              size: SDGACloseButtonSize.medium,
              onPressed: onDismissPressed,
            )
          ],
        ],
      ),
    );
    if (actions != null && actions!.isNotEmpty) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          const SizedBox(width: SDGANumbers.spacingXL),
          SizedBox(
            height: 32,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.only(
                    start: SDGANumbers.spacing3XL + 32),
                scrollDirection: Axis.horizontal,
                itemCount: actions!.length,
                itemBuilder: (context, index) => actions![index],
                separatorBuilder: (context, index) =>
                    const SizedBox(width: SDGANumbers.spacingMD),
              ),
            ),
          ),
          const SizedBox(height: SDGANumbers.spacingXL),
        ],
      );
    }
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgrounds.card,
          boxShadow: SDGAShadows.shadow3XL,
          borderRadius: const BorderRadius.all(
            Radius.circular(SDGANumbers.radiusMedium),
          ),
          border: BorderDirectional(
            start: BorderSide(
              width: 8,
              color: _getColor(colors).withOpacity(0.7),
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  Color _getColor(SDGAColorScheme colors) {
    switch (type) {
      case SDGAAlertType.neutral:
        return colors.backgrounds.neutral200;
      case SDGAAlertType.info:
        return colors.backgrounds.info;
      case SDGAAlertType.success:
        return colors.backgrounds.success;
      case SDGAAlertType.warning:
        return colors.backgrounds.warning;
      case SDGAAlertType.error:
        return colors.backgrounds.error;
    }
  }
}
