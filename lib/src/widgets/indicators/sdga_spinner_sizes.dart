part of 'sdga_spinner.dart';

enum SDGASpinnerSizes {
  /// The smallest size available, suitable for areas with limited space or for a subtle indication of loading.
  tiny(20.0, 2.0),

  /// A bit larger than Tiny, providing a clearer visual cue.
  extraSmall(24.0, 2.0),

  /// A common size for loading indicators that balances visibility with discretion.
  small(28.0, 2.0),

  /// A standard size that's easily noticeable without dominating the interface.
  medium(32.0, 3.0),

  /// A more prominent indicator for situations where the loading process is a significant aspect of the user experience.
  large(36.0, 3.0),

  /// Even more conspicuous, suitable for main areas of focus where users expect to wait.
  extraLarge(40.0, 3.0),

  /// The largest option, likely to be used for significant loading processes or as a central visual element during longer waits.
  huge(44.0, 4.0);

  final double size;
  final double strokeWidth;

  const SDGASpinnerSizes(this.size, this.strokeWidth);
}
