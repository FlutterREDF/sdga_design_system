import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class BannersPage extends BaseComponentsPage {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends BaseComponentsPageState<BannersPage> {
  SDGAAlertType _type = SDGAAlertType.success;
  bool _dismissible = false;
  bool _showIcon = true;
  bool _showTitle = true;
  bool _showLink = false;
  bool _showButton = true;

  @override
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(SDGANumbers.spacingXL),
      child: SDGABanner(
        type: _type,
        onDismissPressed: _dismissible ? () {} : null,
        showIcon: _showIcon,
        title: _showTitle ? "Banner" : null,
        content: "This is a banner message",
        buttonChild: _showButton ? const Text("Button") : null,
        linkChild: _showLink ? const Text("Learn More") : null,
        onButtonPressed: () {},
        onLinkPressed: () {},
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildShowIconProperty(),
      _buildShowTitleProperty(),
      _buildDismissibleProperty(),
      _buildShowLinkProperty(),
      _buildShowButtonProperty(),
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.name,
      values: SDGAAlertType.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildShowIconProperty() {
    return SDGASwitchListTile(
      value: _showIcon,
      title: const Text('Show Icon'),
      onChanged: (value) => setState(() => _showIcon = value),
    );
  }

  Widget _buildShowTitleProperty() {
    return SDGASwitchListTile(
      value: _showTitle,
      title: const Text('Show Title'),
      onChanged: (value) => setState(() => _showTitle = value),
    );
  }

  Widget _buildDismissibleProperty() {
    return SDGASwitchListTile(
      value: _dismissible,
      title: const Text('Dismissible'),
      onChanged: (value) => setState(() => _dismissible = value),
    );
  }

  Widget _buildShowLinkProperty() {
    return SDGASwitchListTile(
      value: _showLink,
      title: const Text('Show Link'),
      onChanged: (value) => setState(() => _showLink = value),
    );
  }

  Widget _buildShowButtonProperty() {
    return SDGASwitchListTile(
      value: _showButton,
      title: const Text('Show Button'),
      onChanged: (value) => setState(() => _showButton = value),
    );
  }
}
