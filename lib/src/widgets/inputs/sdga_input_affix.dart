import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

enum SDGAInputAffixStyle { solid, subtle }

class SDGAInputAffix extends StatelessWidget {
  const SDGAInputAffix.text(
    String this.text, {
    super.key,
    this.style = SDGAInputAffixStyle.solid,
  })  : child = null,
        icon = null,
        padded = true;

  const SDGAInputAffix.custom({
    super.key,
    required Widget this.child,
    this.padded = true,
    this.style = SDGAInputAffixStyle.solid,
  })  : text = null,
        icon = null;

  final String? text;
  final Widget? child;
  final Widget? icon;
  final bool padded;
  final SDGAInputAffixStyle style;

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(SDGANumbers.radiusSmall);
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final SDGAInputAffixWrapper? wrapper =
        SDGAInputAffixWrapper.maybeOf(context);
    final bool disabled = wrapper?.disabled == true;
    final Color? color = style == SDGAInputAffixStyle.solid
        ? disabled
            ? colors.globals.backgroundDisabled
            : colors.buttons.backgroundNeutralDefault
        : null;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: wrapper != null
            ? BorderRadiusDirectional.only(
                topStart: wrapper.isPrefix ? radius : Radius.zero,
                topEnd: wrapper.isPrefix ? Radius.zero : radius,
                bottomStart: wrapper.isPrefix ? radius : Radius.zero,
                bottomEnd: wrapper.isPrefix ? Radius.zero : radius,
              )
            : null,
        color: color,
      ),
      child: Padding(
        padding: padded
            ? const EdgeInsets.symmetric(
                horizontal: SDGANumbers.spacingLG,
                vertical: SDGANumbers.spacingXXS,
              )
            : EdgeInsets.zero,
        child: AnimatedDefaultTextStyle(
          duration: kThemeAnimationDuration,
          style: SDGATextStyles.textMediumRegular.copyWith(
            color: disabled
                ? colors.globals.textDefaultDisabled
                : colors.texts.secondaryParagraph,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: text != null ? Text(text!) : child,
          ),
        ),
      ),
    );
  }
}

class SDGAInputAffixWrapper extends InheritedWidget {
  const SDGAInputAffixWrapper({
    super.key,
    required super.child,
    required this.isPrefix,
    required this.disabled,
  });

  final bool isPrefix;
  final bool disabled;

  @override
  bool updateShouldNotify(covariant SDGAInputAffixWrapper oldWidget) {
    return isPrefix != oldWidget.isPrefix || disabled != oldWidget.disabled;
  }

  static SDGAInputAffixWrapper of(BuildContext context) => maybeOf(context)!;

  static SDGAInputAffixWrapper? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SDGAInputAffixWrapper>();
}
