import 'package:flutter/material.dart';
import 'package:sdga_design_system/src/src.dart';

/// Defines the size of the label.
enum SDGALabelSize {
  /// Displays the label with a medium font size.
  medium,

  /// Displays the label with a large font size.
  large,
}

/// A widget that displays a label with customizable size, required indicator, and font weight.
///
/// The [SDGALabel] widget allows you to display a label with a specified text
/// content. You can customize the size of the label using the [SDGALabelSize]
/// enum, indicate if the label is required or not, and adjust the font weight
/// to be either regular or semi-bold.
///
/// {@tool sample}
///
/// ```dart
/// SDGALabel(
///   'Label Text',
///   size: SDGALabelSize.large,
///   required: true,
///   semiBold: true,
/// )
/// ```
/// {@end-tool}
class SDGALabel extends StatelessWidget {
  /// Creates an [SDGALabel] widget.
  const SDGALabel(
    this.text, {
    super.key,
    this.size = SDGALabelSize.medium,
    this.required = false,
    this.semiBold = false,
    this.disabled,
  });

  /// The text content of the label.
  final String text;

  /// The size of the label.
  ///
  /// Defaults to [SDGALabelSize.medium].
  final SDGALabelSize size;

  /// Indicates whether the label is required or not.
  ///
  /// If set to `true`, an asterisk will be displayed before the label.
  final bool required;

  /// Determines whether the label text should be displayed in semi-bold font weight or not.
  ///
  /// If set to `true`, the label text will be displayed in semi-bold font weight.
  /// If set to `false` (default), the label text will be displayed in regular font weight.
  final bool semiBold;

  /// Determines whether the label text should be displayed as disabled or not.
  ///
  /// If this is `null` (default), the label will read the disabled state
  /// from the nearest [SDGAInputDecorator] in the tree.
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final TextStyle style;
    final bool effectiveDisabled = disabled ??
        SDGAInputDecoratorWrapper.maybeOf(context)?.disabled ??
        false;
    switch (size) {
      case SDGALabelSize.medium:
        style = semiBold
            ? SDGATextStyles.textSmallSemiBold
            : SDGATextStyles.textSmallRegular;
        break;
      case SDGALabelSize.large:
        style = semiBold
            ? SDGATextStyles.textMediumSemiBold
            : SDGATextStyles.textMediumRegular;
        break;
    }
    return Text.rich(
      TextSpan(
        children: [
          if (required)
            TextSpan(
              text: '* ',
              style: style.copyWith(
                  color: effectiveDisabled
                      ? colors.globals.textDefaultDisabled
                      : colors.forms.fieldBorderError),
            ),
          TextSpan(
            text: text,
            style: style.copyWith(
                color: effectiveDisabled
                    ? colors.globals.textDefaultDisabled
                    : colors.forms.fieldTextLabel),
          ),
        ],
      ),
    );
  }
}
