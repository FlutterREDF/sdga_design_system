import 'package:example/example.dart';
import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class DrawerPage extends BaseComponentsPage {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends BaseComponentsPageState<DrawerPage> {
  @override
  Widget buildContent() {
    return SDGAButton(
      style: Theme.of(context).brightness == Brightness.light
          ? SDGAButtonStyle.primaryNeutral
          : SDGAButtonStyle.secondary,
      leadingIcon: const SDGAIcon(SDGAIconsStroke.menu02),
      child: const Text('Open Drawer'),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }

  @override
  List<Widget> buildProperties() {
    final HomeDrawerOptions options = context
        .dependOnInheritedWidgetOfExactType<HomeDrawerOptionsWrapper>()!
        .options;
    return [
      _buildShowHeaderProperty(options),
      _buildShowIconsProperty(options),
      _buildOnColorProperty(options),
      _buildOverlayProperty(options),
    ];
  }

  Widget _buildShowHeaderProperty(HomeDrawerOptions options) {
    return SDGASwitchListTile(
      value: options.showHeader,
      title: const Text('Show Header'),
      onChanged: (value) => setState(() => options.showHeader = value),
    );
  }

  Widget _buildShowIconsProperty(HomeDrawerOptions options) {
    return SDGASwitchListTile(
      value: options.showIcons,
      title: const Text('Show Icons'),
      onChanged: (value) => setState(() => options.showIcons = value),
    );
  }

  Widget _buildOnColorProperty(HomeDrawerOptions options) {
    return SDGASwitchListTile(
      value: options.onColor,
      title: const Text('Use Brand Colors'),
      onChanged: (value) => setState(() => options.onColor = value),
    );
  }

  Widget _buildOverlayProperty(HomeDrawerOptions options) {
    return SDGASwitchListTile(
      value: options.overlay,
      title: const Text('Overlay'),
      onChanged: (value) => setState(() => options.overlay = value),
    );
  }

  // Widget _buildTypeProperty() {
  //   return buildSelectionProperty(
  //     title: 'Type',
  //     value: _type.text,
  //     values: SDGAAvatarType.values,
  //     getText: (item) => item.text,
  //     onSelected: (item) => setState(() => _type = item),
  //   );
  // }
}
