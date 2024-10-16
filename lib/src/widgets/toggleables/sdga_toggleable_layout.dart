import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGAToggleableLayout extends StatelessWidget {
  final Widget toggleable;

  /// This is the text associated with a toggleable input that provides context
  /// or describes the option being selected or deselected.
  final String label;

  /// Additional information provided to assist users in understanding the
  /// purpose or implications of selecting the toggleable.
  final String? helperText;

  /// A notification that appears when a user interacts with the toggleable
  /// in a way that triggers a specific condition or action.
  final String? alertMessage;

  /// The type of alert associated with the toggleable, which determines the
  /// color and style of the alert.
  final SDGAAlertType alertType;

  /// The width of the toggleable, this is used to calculate the padding
  /// for label and other widgets
  final double toggleableWidth;

  /// Whether to place the toggleable after the label or not
  ///
  /// The default is false
  final bool trailToggleable;

  /// The current states for the toggleable
  ///
  /// This is used to draw the focus border or change the label color
  /// if the toggleable is on
  final Set<WidgetState> states;

  const SDGAToggleableLayout({
    super.key,
    required this.toggleable,
    required this.label,
    this.helperText,
    this.alertMessage,
    this.alertType = SDGAAlertType.error,
    this.toggleableWidth = 32,
    this.trailToggleable = false,
    required this.states,
  });

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    Widget child = Row(
      children: [
        if (!trailToggleable) ...[
          toggleable,
          const SizedBox(width: SDGAConstants.spacing4),
        ],
        Expanded(
          child: Text(
            label,
            style: SDGATextStyles.textMediumMedium
                .copyWith(color: colors.texts.display),
          ),
        ),
        if (trailToggleable) ...[
          const SizedBox(width: SDGAConstants.spacing4),
          toggleable,
        ],
      ],
    );
    if (helperText != null || alertMessage != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (helperText != null) ...[
            const SizedBox(height: SDGAConstants.spacing1),
            Padding(
              padding: trailToggleable
                  ? EdgeInsets.zero
                  : EdgeInsetsDirectional.only(
                      start: SDGAConstants.spacing4 + toggleableWidth),
              child: Text(
                helperText!,
                style: SDGATextStyles.textSmallRegular
                    .copyWith(color: colors.texts.secondaryParagraph),
              ),
            ),
          ],
          if (alertMessage != null) ...[
            const SizedBox(height: SDGAConstants.spacing1),
            Row(
              children: [
                Padding(
                  padding: trailToggleable
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(
                          horizontal: (toggleableWidth - 24) / 2,
                          vertical: 4,
                        ),
                  child: _buildIcon(),
                ),
                const SizedBox(width: SDGAConstants.spacing4),
                Text(
                  alertMessage!,
                  style: SDGATextStyles.textSmallMedium.copyWith(
                    color: alertType.color.getTextColor(colors),
                  ),
                ),
              ],
            )
          ],
        ],
      );
    }
    return DecoratedBox(
      decoration: states.contains(WidgetState.focused)
          ? BoxDecoration(
              border: Border.all(color: colors.borders.black, width: 2),
              borderRadius: const BorderRadius.all(
                  Radius.circular(SDGANumbers.radiusSmall)),
            )
          : const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }

  Widget _buildIcon() {
    SDGAFeedbackIconType iconType;
    switch (alertType) {
      case SDGAAlertType.neutral:
        iconType = SDGAFeedbackIconType.info;
        break;
      case SDGAAlertType.info:
        iconType = SDGAFeedbackIconType.info;
        break;
      case SDGAAlertType.success:
        iconType = SDGAFeedbackIconType.success;
        break;
      case SDGAAlertType.warning:
        iconType = SDGAFeedbackIconType.warning;
        break;
      case SDGAAlertType.error:
        iconType = SDGAFeedbackIconType.warning;
        break;
    }
    return SDGAFeedbackIcon(
      type: iconType,
      color: alertType.color,
      outlineBorder: true,
      size: SDGAWidgetSize.large,
      useTriangle: alertType == SDGAAlertType.warning,
    );
  }
}
