import 'package:flutter/material.dart';
import 'package:sdga_design_system/src/src.dart';

class SDGAInputHelper extends StatelessWidget {
  const SDGAInputHelper(
    this.text, {
    super.key,
    this.error,
  });

  /// The text content of the helper.
  final String text;

  /// Determines whether the help text should be displayed as an error or not.
  ///
  /// If this is `null` (default), the helper will read the error state
  /// from the nearest [SDGAInputDecorator] in the tree.
  final bool? error;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final SDGAInputDecoratorWrapper? decoratorWrapper =
        SDGAInputDecoratorWrapper.maybeOf(context);
    final bool effectiveError = error ?? decoratorWrapper?.error ?? false;
    final Color color =
        effectiveError ? colors.texts.error : colors.texts.primaryParagraph;
    return Row(
      children: [
        SDGAFeedbackIcon.customColor(
          type: SDGAFeedbackIconType.info,
          size: SDGAWidgetSize.medium,
          iconColor: color,
        ),
        const SizedBox(width: SDGANumbers.spacingMD),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: decoratorWrapper?.maxLines,
            style: SDGATextStyles.textSmallRegular.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
