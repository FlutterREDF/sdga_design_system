import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class LinkPage extends BaseComponentsPage {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends BaseComponentsPageState<LinkPage> {
  SDGALinkSize _size = SDGALinkSize.medium;
  SDGAWidgetStyle _style = SDGAWidgetStyle.brand;
  bool _showIcon = false;
  bool _inline = false;
  bool _visited = false;
  bool _disabled = false;

  @override
  Color? get backgroundColor => _style == SDGAWidgetStyle.onColor
      ? SDGAColorScheme.of(context).backgrounds.saFlag
      : null;

  @override
  Widget buildContent() {
    return SDGALink(
      size: _size,
      style: _style,
      icon: _showIcon ? const SDGAIcon(SDGAIconsStroke.link02) : null,
      inline: _inline,
      visited: _visited,
      onPressed: _disabled ? null : () {},
      focusNode: focusNode,
      child: const Text("Link"),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      buildFocusProperty(),
      _buildStyleProperty(),
      _buildSizeProperty(),
      _buildShowIconProperty(),
      _buildInlineProperty(),
      _buildVisitedProperty(),
      _buildDisabledProperty(),
    ];
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGAWidgetStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _size.name,
      values: SDGALinkSize.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _size = item),
    );
  }

  Widget _buildShowIconProperty() {
    return SDGASwitchListTile(
      value: _showIcon,
      title: const Text('Show Icon'),
      onChanged: (value) => setState(() => _showIcon = value),
    );
  }

  Widget _buildInlineProperty() {
    return SDGASwitchListTile(
      value: _inline,
      title: const Text('Inline'),
      onChanged: (value) => setState(() => _inline = value),
    );
  }

  Widget _buildVisitedProperty() {
    return SDGASwitchListTile(
      value: _visited,
      title: const Text('Visited'),
      onChanged: (value) => setState(() => _visited = value),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }
}
