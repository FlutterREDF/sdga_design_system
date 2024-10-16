import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class ContentSwitchersPage extends BaseComponentsPage {
  const ContentSwitchersPage({super.key});

  @override
  State<ContentSwitchersPage> createState() => _ContentSwitchersPageState();
}

class _ContentSwitchersPageState
    extends BaseComponentsPageState<ContentSwitchersPage> {
  int _selectedItem = 1;
  bool _scrollable = false;
  bool _onColor = false;
  bool _disabled = false;

  @override
  Color? get backgroundColor =>
      _onColor ? SDGAColorScheme.of(context).backgrounds.saFlag : null;

  @override
  Widget buildContent() {
    return Padding(
      padding: _scrollable
          ? EdgeInsets.zero
          : const EdgeInsets.all(SDGANumbers.spacingXL),
      child: SDGAContentSwitcher<int>(
        items: List.generate(_scrollable ? 10 : 4, (i) => i + 1),
        getText: (item) => 'Item $item',
        selectedItem: _selectedItem,
        scrollable: _scrollable,
        onColor: _onColor,
        padding: const EdgeInsets.all(SDGANumbers.spacingXL),
        onChanged:
            _disabled ? null : (item) => setState(() => _selectedItem = item),
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildScrollableProperty(),
      _buildOnColorProperty(),
      _buildDisabledProperty(),
    ];
  }

  Widget _buildScrollableProperty() {
    return SDGASwitchListTile(
      value: _scrollable,
      title: const Text('Scrollable'),
      onChanged: (value) => setState(() => _scrollable = value),
    );
  }

  Widget _buildOnColorProperty() {
    return SDGASwitchListTile(
      value: _onColor,
      title: const Text('On Color'),
      onChanged: (value) => setState(() => _onColor = value),
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
