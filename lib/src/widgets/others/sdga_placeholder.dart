import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGAPlaceholder extends StatelessWidget {
  const SDGAPlaceholder({
    super.key,
    this.message = 'CONTENT',
    this.fallbackWidth = 280.0,
    this.fallbackHeight = 280.0,
  });

  final String message;

  /// The width to use when the placeholder is in a situation with an unbounded
  /// width.
  ///
  /// See also:
  ///
  ///  * [fallbackHeight], the same but vertically.
  final double fallbackWidth;

  /// The height to use when the placeholder is in a situation with an unbounded
  /// height.
  ///
  /// See also:
  ///
  ///  * [fallbackWidth], the same but horizontally.
  final double fallbackHeight;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return LimitedBox(
      maxWidth: fallbackWidth,
      maxHeight: fallbackHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: SDGADashedBorder(
            border: BorderSide(color: SDGAColors.green.shade600),
          ),
          color: SDGAColors.green.shade50,
        ),
        child: Container(
          height: 280,
          alignment: Alignment.center,
          child: Text(
            message,
            style: SDGATextStyles.textSmallSemiBold
                .copyWith(color: colors.texts.primary),
          ),
        ),
      ),
    );
  }
}
