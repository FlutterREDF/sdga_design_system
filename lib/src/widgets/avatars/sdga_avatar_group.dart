import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGAAvatarGroup extends StatelessWidget {
  final List<SDGAAvatar> avatars;
  final SDGAAvatarSizes size;
  final SDGAAvatarType type;
  final bool stacked;
  final bool square;
  final AlignmentGeometry alignment;

  const SDGAAvatarGroup({
    super.key,
    required this.avatars,
    required this.type,
    this.size = SDGAAvatarSizes.tiny,
    this.stacked = true,
    this.square = false,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.size,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.biggest.width;
          final width =
              stacked ? size.size * 0.8 : size.size + SDGANumbers.spacingSM;
          var totalShown =
              (totalWidth / width).floor().clamp(1, avatars.length);
          var extra = (totalWidth - ((totalShown - 1) * width + size.size));
          if (extra < 0 && totalShown > 1) {
            totalShown--;
            extra = (totalWidth - ((totalShown - 1) * width + size.size));
          }
          extra *= (alignment.resolve(Directionality.of(context)).x + 1) / 2;
          return Stack(
            children: [
              for (var i = 0; i < totalShown; i++) ...[
                if (i < totalShown - 1 || totalShown == avatars.length) ...[
                  PositionedDirectional(
                    start: extra + i * width,
                    child: avatars[i],
                  ),
                ] else ...[
                  PositionedDirectional(
                    start: extra + i * width,
                    child: SDGAAvatar.initials(
                      size: size,
                      square: square,
                      initials: '+${avatars.length - totalShown + 1}',
                    ),
                  ),
                ]
              ]
            ],
          );
        },
      ),
    );
  }
}
