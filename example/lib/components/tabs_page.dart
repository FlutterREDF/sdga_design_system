import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

const List<String> _titles = [
  "First Tab",
  "Second Tab",
  "Third Tab",
  "Forth Tab",
  "Fifth Tab",
];

class TabsPage extends BaseComponentsPage {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends BaseComponentsPageState<TabsPage> {
  SDGAWidgetSize _size = SDGAWidgetSize.large;
  Axis _axis = Axis.horizontal;
  bool _showDivider = true;
  bool _showIcons = true;
  bool _disabled = false;
  int _selectedItem = 0;

  @override
  Widget buildContent() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SDGATabBar(
        size: _size,
        direction: _axis,
        showBottomDivider: _showDivider,
        tabs: List.generate(
          _titles.length,
          (index) {
            return SDGATab(
              title: Text(_titles[index]),
              selected: _selectedItem == index,
              icon: _showIcons ? const SDGAIcon(SDGAIconsStroke.home06) : null,
              onPressed: _disabled
                  ? null
                  : () => setState(() => _selectedItem = index),
            );
          },
        ),
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildDirectionProperty(),
      _buildSizeProperty(),
      _buildShowIconsProperty(),
      _buildShowDividerProperty(),
      _buildDisabledProperty(),
    ];
  }

  Widget _buildSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _size.name,
      values: SDGAWidgetSize.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _size = item),
    );
  }

  Widget _buildDirectionProperty() {
    return buildSelectionProperty(
      title: 'Direction',
      value: _axis.name,
      values: Axis.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _axis = item),
    );
  }

  Widget _buildShowIconsProperty() {
    return SDGASwitchListTile(
      value: _showIcons,
      title: const Text('Show Icons'),
      onChanged: (value) => setState(() => _showIcons = value),
    );
  }

  Widget _buildShowDividerProperty() {
    return SDGASwitchListTile(
      value: _showDivider,
      title: const Text('Show Divider'),
      onChanged: (value) => setState(() => _showDivider = value),
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
