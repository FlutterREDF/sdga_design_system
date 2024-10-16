import 'package:flutter/widgets.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_banner_style.dart';

class SDGABanner extends StatelessWidget {
  final SDGAAlertType type;
  final bool showIcon;
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final Widget? linkChild;
  final Widget? buttonChild;
  final VoidCallback? onDismissPressed;
  final VoidCallback? onLinkPressed;
  final VoidCallback? onButtonPressed;

  const SDGABanner({
    super.key,
    this.type = SDGAAlertType.success,
    this.showIcon = true,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.onDismissPressed,
    this.onLinkPressed,
    this.onButtonPressed,
    this.linkChild,
    this.buttonChild,
  }) : assert(content != null || contentWidget != null,
            'You must provide a [content] or [contentWidget]');

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final child = Container(
      decoration: BoxDecoration(
        color: type.color.getLightColor(colors),
        border: Border(
          bottom: BorderSide(color: _getBorderColor(colors), width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SDGANumbersNotifications.alertHorizontalPadding,
        vertical: SDGANumbersNotifications.alertVerticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24.0),
            child: Row(
              children: [
                if (showIcon) ...[
                  _buildIcon(),
                  const SizedBox(width: SDGANumbersNotifications.gap),
                ],
                if (title != null || titleWidget != null)
                  DefaultTextStyle(
                    style: SDGATextStyles.textMediumBold
                        .copyWith(color: type.color.getTextColor(colors)),
                    child: Expanded(child: titleWidget ?? Text(title!)),
                  ),
                if (onDismissPressed != null)
                  const SizedBox(width: SDGANumbersNotifications.gap + 32),
              ],
            ),
          ),
          const SizedBox(height: SDGANumbersNotifications.gap),
          if (content != null || contentWidget != null)
            DefaultTextStyle(
              style: SDGATextStyles.textMediumRegular
                  .copyWith(color: type.color.getTextColor(colors)),
              child: contentWidget ?? Text(content!),
            ),
          const SizedBox(height: SDGANumbersNotifications.gap),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (linkChild != null) ...[
                  SDGALink(
                    onPressed: onLinkPressed,
                    inline: true,
                    style: SDGAWidgetStyle.neutral,
                    child: linkChild,
                  ),
                  if (buttonChild != null)
                    const SizedBox(width: SDGAConstants.spacing2),
                ],
                if (buttonChild != null) ...[
                  SDGAButton(
                    size: SDGAWidgetSize.small,
                    style: SDGAButtonStyle.primaryNeutral,
                    onPressed: onButtonPressed,
                    child: buttonChild,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
    if (onDismissPressed != null) {
      return Stack(
        children: [
          child,
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: SDGANumbersNotifications.alertHorizontalPadding / 2,
            top: SDGANumbersNotifications.alertVerticalPadding / 2,
            child: SDGAButton.close(
              size: SDGACloseButtonSize.medium,
              onPressed: onDismissPressed,
              removeBackground: true,
            ),
          ),
        ],
      );
    } else {
      return child;
    }
  }

  Color _getBorderColor(SDGAColorScheme colors) {
    switch (type) {
      case SDGAAlertType.neutral:
        return colors.backgrounds.black;
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

  Widget _buildIcon() {
    SDGAFeedbackIconType iconType;
    switch (type) {
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
      color: type.color,
      size: SDGAWidgetSize.large,
      useTriangle: type == SDGAAlertType.warning,
    );
  }
}
