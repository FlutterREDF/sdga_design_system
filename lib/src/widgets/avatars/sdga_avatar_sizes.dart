part of 'sdga_avatar.dart';

enum SDGAAvatarSizes {
  /// Suitable for small spaces, like table cells
  tiny(24.0, 16.0),

  /// Suitable for small components
  extraSmall(32.0, 24.0),

  /// Standard size for profile panels
  small(40.0, 32.0),

  /// Standard size for cards
  medium(48.0, 32.0),

  /// Used sparingly to highlight users
  large(64.0, 40.0),

  /// For spacious areas, ensure balance
  extraLarge(80.0, 56.0),

  /// For spacious areas, ensure balance
  huge(120.0, 80.0);

  final double size;
  final double iconSize;

  const SDGAAvatarSizes(this.size, this.iconSize);
}
