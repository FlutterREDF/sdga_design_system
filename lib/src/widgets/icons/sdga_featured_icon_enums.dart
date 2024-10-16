part of 'sdga_featured_icon.dart';

enum SDGAFeaturedIconStyle { dark, light, outline }

enum SDGAFeaturedIconSizes {
  small(32.0, 16.0),
  medium(40.0, 20.0),
  large(48.0, 24.0),
  extraLarge(56.0, 28.0);

  final double size;
  final double iconSize;

  const SDGAFeaturedIconSizes(this.size, this.iconSize);
}
