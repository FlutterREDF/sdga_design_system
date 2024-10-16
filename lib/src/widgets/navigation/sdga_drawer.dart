import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sdga_design_system/src/src.dart';

part 'sdga_drawer_item.dart';

const double _kWidth = 320.0;
/// A customizable drawer widget for displaying a list of items with an optional header.
///
/// The [SDGADrawer] is a stateless widget that renders a drawer with a header (optional)
/// and a list of [SDGADrawerItem] widgets. It provides various options to customize the
/// appearance and behavior of the drawer.
///
/// {@tool sample}
///
/// ```dart
/// SDGADrawer(
///   header: const SDGADrawerHeader(
///     title: Text('Username', maxLines: 1),
///     description: Text(
///       'user@example.com',
///       overflow: TextOverflow.ellipsis,
///       maxLines: 1,
///     ),
///   ),
///   items: [
///     SDGADrawerItem(
///       label: 'Home',
///       leading: Icon(Icons.home),
///       onTap: () {
///         // Handle drawer item tap
///       },
///     ),
///     SDGADrawerItem(
///       label: 'Settings',
///       leading: Icon(Icons.settings),
///       onTap: () {
///         // Handle drawer item tap
///       },
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
class SDGADrawer extends StatelessWidget {
  /// Creates an [SDGADrawer] widget.
  const SDGADrawer({
    super.key,
    this.header,
    required this.items,
    this.onColor = false,
    this.overlay = false,
    this.width,
    this.semanticLabel,
  });

  /// The header widget of this drawer that is placed above the items.
  ///
  /// Typically a [SDGADrawerHeader] widget.
  final Widget? header;

  /// The list of drawer items to be displayed in the drawer.
  final List<SDGADrawerItem> items;

  /// Indicates whether the button is on a darker background.
  final bool onColor;

  /// Determines whether the drawer should be displayed as an overlay on top
  /// of the main content with a blur applied.
  final bool overlay;

  /// The width of the drawer.
  ///
  /// If this is null, then it falls back to the default (320.0).
  final double? width;

  /// The semantic label of the drawer used by accessibility frameworks to
  /// announce screen transitions when the drawer is opened and closed.
  ///
  /// If this label is not provided, it will default to
  /// [MaterialLocalizations.drawerLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this
  ///    value is used.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    String? label = semanticLabel;
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label = semanticLabel ?? MaterialLocalizations.of(context).drawerLabel;
    }

    Widget child = SingleChildScrollView(
      padding: EdgeInsets.only(
        top: SDGANumbers.spacingXL,
        left: SDGANumbers.spacingXL,
        right: SDGANumbers.spacingXL,
        bottom: max(
            SDGANumbers.spacing8XL, MediaQuery.viewInsetsOf(context).bottom),
      ),
      child: _SDGADrawerOptions(
        onColor: onColor,
        child: Column(children: items),
      ),
    );
    if (header != null) {
      child = Column(
        children: [
          header!,
          Expanded(child: child),
        ],
      );
    }
    child = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: overlay
            ? onColor
                ? SDGAShadows.shadow2XL
                : SDGAShadows.shadowDrawer
            : null,
        color: onColor
            ? SDGAColors.primary.shade800
            : overlay
                ? colors.alphas.white80
                : colors.backgrounds.menu,
      ),
      child: child,
    );
    if (overlay && !onColor) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
          child: child,
        ),
      );
    }

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: width ?? _kWidth),
        child: child,
      ),
    );
  }
}

class _SDGADrawerOptions extends InheritedWidget {
  const _SDGADrawerOptions({
    required super.child,
    required this.onColor,
  });

  final bool onColor;

  @override
  bool updateShouldNotify(covariant _SDGADrawerOptions oldWidget) {
    return false;
  }

  static _SDGADrawerOptions? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SDGADrawerOptions>();
}
