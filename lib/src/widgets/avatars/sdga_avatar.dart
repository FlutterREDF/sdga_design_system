import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_avatar_sizes.dart';
part 'sdga_avatar_type.dart';

class SDGAAvatar extends StatelessWidget {
  final bool square;
  final SDGAAvatarSizes size;
  final SDGAAvatarType type;
  final String? initials;
  final Widget? initialsWidget;
  final Widget? icon;
  final Widget? image;

  const SDGAAvatar({
    super.key,
    required this.type,
    this.size = SDGAAvatarSizes.tiny,
    this.square = false,
    this.initials,
    this.initialsWidget,
    this.icon,
    this.image,
  })  : assert(
            type != SDGAAvatarType.initials ||
                initials != null ||
                initialsWidget != null,
            'You must provide an [initials] or [initialsWidget]'),
        assert(type != SDGAAvatarType.icon || icon != null,
            'You must provide an [icon] when the [type] is icon'),
        assert(type != SDGAAvatarType.image || image != null,
            'You must provide an [image] when the [type] is image');

  const SDGAAvatar.icon({
    super.key,
    this.size = SDGAAvatarSizes.tiny,
    this.square = false,
    required Widget this.icon,
  })  : type = SDGAAvatarType.icon,
        image = null,
        initials = null,
        initialsWidget = null;

  const SDGAAvatar.image({
    super.key,
    this.size = SDGAAvatarSizes.tiny,
    this.square = false,
    required Widget this.image,
  })  : type = SDGAAvatarType.image,
        icon = null,
        initials = null,
        initialsWidget = null;

  const SDGAAvatar.initials({
    super.key,
    this.size = SDGAAvatarSizes.tiny,
    this.square = false,
    this.initials,
    this.initialsWidget,
  })  : type = SDGAAvatarType.initials,
        icon = null,
        image = null;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    return Container(
      width: size.size,
      height: size.size,
      padding: EdgeInsets.all(_borderWidth),
      decoration: BoxDecoration(
        color: type == SDGAAvatarType.image
            ? colors.backgrounds.white
            : colors.buttons.backgroundNeutralDefault,
        border: Border.all(color: colors.borders.white, width: _borderWidth),
        borderRadius: BorderRadius.all(
          Radius.circular(
            square ? SDGAConstants.radius8 : SDGAConstants.radius9999,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            square ? SDGAConstants.radius8 : SDGAConstants.radius9999,
          ),
        ),
        child: _buildContent(context, colors),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SDGAColorScheme colors) {
    switch (type) {
      case SDGAAvatarType.initials:
        final child =
            initials != null ? Text(initials!) : initialsWidget ?? icon;
        return DefaultTextStyle(
          style: _style.copyWith(color: colors.texts.defaultColor),
          child: Center(child: child),
        );
      case SDGAAvatarType.icon:
        return IconTheme.merge(
          data: IconThemeData(
            size: size.iconSize,
            color: colors.icons.defaultColor,
          ),
          child: Center(child: icon),
        );
      case SDGAAvatarType.image:
        return Center(child: image);
    }
  }

  TextStyle get _style {
    switch (size) {
      case SDGAAvatarSizes.tiny:
        return SDGATextStyles.textExtraExtraSmallBold;
      case SDGAAvatarSizes.extraSmall:
        return SDGATextStyles.textExtraSmallSemiBold;
      case SDGAAvatarSizes.small:
        return SDGATextStyles.textSmallSemiBold;
      case SDGAAvatarSizes.medium:
        return SDGATextStyles.textMediumMedium;
      case SDGAAvatarSizes.large:
        return SDGATextStyles.textLargeMedium;
      case SDGAAvatarSizes.extraLarge:
        return SDGATextStyles.displaySmallRegular;
      case SDGAAvatarSizes.huge:
        return SDGATextStyles.displayMediumRegular;
    }
  }

  double get _borderWidth {
    switch (size) {
      case SDGAAvatarSizes.tiny:
      case SDGAAvatarSizes.extraSmall:
      case SDGAAvatarSizes.small:
      case SDGAAvatarSizes.medium:
      case SDGAAvatarSizes.large:
      case SDGAAvatarSizes.extraLarge:
        return 2;
      case SDGAAvatarSizes.huge:
        return 4;
    }
  }
}
