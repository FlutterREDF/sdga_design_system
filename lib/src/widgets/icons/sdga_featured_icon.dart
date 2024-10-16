import 'package:flutter/widgets.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_featured_icon_enums.dart';

class SDGAFeaturedIcon extends StatelessWidget {
  final SDGAFeaturedIconSizes size;
  final SDGAFeaturedIconStyle style;
  final SDGAWidgetColor color;
  final bool circular;
  final Widget icon;

  const SDGAFeaturedIcon({
    super.key,
    this.size = SDGAFeaturedIconSizes.large,
    this.style = SDGAFeaturedIconStyle.dark,
    this.color = SDGAWidgetColor.success,
    this.circular = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);

    return Container(
      width: size.size,
      height: size.size,
      decoration: BoxDecoration(
        color: _getBackgroundColor(colors),
        border: style == SDGAFeaturedIconStyle.outline
            ? Border.all(color: color.getBorderColor(colors))
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(
            circular ? SDGANumbers.radiusFull : SDGANumbers.radiusMedium,
          ),
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          size: size.iconSize,
          color: style != SDGAFeaturedIconStyle.dark
              ? color.getIconColor(colors)
              : colors.icons.onColor,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Color? _getBackgroundColor(SDGAColorScheme colors) {
    switch (style) {
      case SDGAFeaturedIconStyle.dark:
        return color.getColor(colors);
      case SDGAFeaturedIconStyle.light:
        return color.getLightColor(colors);
      case SDGAFeaturedIconStyle.outline:
        return null;
    }
  }
}
