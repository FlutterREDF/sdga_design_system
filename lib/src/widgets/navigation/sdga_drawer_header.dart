import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

/// A widget that displays a header for the [SDGADrawer].
///
/// The [SDGADrawerHeader] is typically used as a header for the [SDGADrawer]
/// widget, providing a space for displaying user information, an avatar, and
/// additional content or actions.
///
/// {@tool sample}
///
/// ```dart
/// SDGADrawerHeader(
///   title: const Text('Username', maxLines: 1),
///   description: const Text(
///     'user@example.com',
///     overflow: TextOverflow.ellipsis,
///     maxLines: 1,
///   ),
///   leading: SDGAAvatar(
///     type: SDGAAvatarType.initials,
///     initials: 'OG',
///     size: SDGAAvatarSizes.small,
///   ),
///   trailing: const SDGATag.status(
///     label: Text('Status'),
///     size: SDGATagSize.extraSmall,
///     status: SDGATagStatus.warning,
///     style: SDGATagStyle.subtle,
///   ),
///   onClosePressed: (context) {
///     Scaffold.of(context).closeDrawer();
///   },
/// )
/// ```
/// {@end-tool}
class SDGADrawerHeader extends StatelessWidget {
  const SDGADrawerHeader({
    super.key,
    this.onColor = false,
    this.leading,
    this.title,
    this.description,
    this.trailing,
    this.onClosePressed,
  });

  /// Indicates whether the button is on a darker background.
  final bool onColor;

  /// A widget to display before the title.
  ///
  /// Typically an [SDGAAvatar] widget; for example:
  ///
  /// ```dart
  ///  SDGADrawerHeader(
  ///    title: const Text('Username', maxLines: 1),
  ///    leading: SDGAAvatar(
  ///      type: SDGAAvatarType.initials,
  ///      initials: 'OG',
  ///      size: SDGAAvatarSizes.small,
  ///    ),
  ///  );
  /// ```
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  ///
  /// {@macro sdga.text_style}
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// You can use [Text.maxLines] to enforce the number of lines.
  ///
  /// {@macro sdga.text_style}
  final Widget? description;

  /// A widget to display after the title.
  ///
  /// Typically an [SDGATag.status] widget; for example:
  ///
  /// ```dart
  ///  SDGADrawerHeader(
  ///    title: const Text('Username', maxLines: 1),
  ///    trailing: const SDGATag.status(
  ///      label: Text('Status'),
  ///      size: SDGATagSize.extraSmall,
  ///      status: SDGATagStatus.warning,
  ///      style: SDGATagStyle.subtle,
  ///    ),
  ///  );
  /// ```
  final Widget? trailing;

  /// The callback to be called when the close button is pressed.
  ///
  /// If null, the close button will be hidden.
  final void Function(BuildContext context)? onClosePressed;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: onColor
            ? SDGAColors.whiteAlpha.alpha10
            : colors.backgrounds.neutral50,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: SDGANumbers.spacingXL,
          right: SDGANumbers.spacingXL,
          bottom: SDGANumbers.spacingXL,
          top: SDGANumbers.spacingXL + MediaQuery.viewPaddingOf(context).top,
        ),
        child: Column(
          children: [
            if (onClosePressed != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SDGAButton.close(
                  onColor: onColor,
                  onPressed: () => onClosePressed!(context),
                  removeBackground: true,
                  size: SDGACloseButtonSize.xSmall,
                ),
              ),
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: SDGANumbers.spacingLG),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style: SDGATextStyles.textSmallSemiBold.copyWith(
                              color: onColor
                                  ? colors.texts.onColorPrimary
                                  : colors.texts.display),
                          child: title!,
                        ),
                      if (description != null)
                        DefaultTextStyle(
                          style: SDGATextStyles.textExtraSmallRegular.copyWith(
                              color: onColor
                                  ? colors.texts.onColorPrimary
                                  : colors.texts.secondaryParagraph),
                          child: description!,
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  trailing!,
                  const SizedBox(width: SDGANumbers.spacingLG),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
