import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class InlineAlertPage extends BaseComponentsPage {
  const InlineAlertPage({super.key});

  @override
  State<InlineAlertPage> createState() => _InlineAlertPageState();
}

class _InlineAlertPageState extends BaseComponentsPageState<InlineAlertPage> {
  SDGAAlertType _type = SDGAAlertType.success;
  bool _dismissible = false;
  bool _showHelperText = true;
  bool _showActions = true;
  bool _coloredBackground = true;

  @override
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(SDGANumbers.spacingXL),
      child: SDGAInlineAlert(
        type: _type,
        coloredBackground: _coloredBackground,
        title: const Text('Alert message title'),
        icon: const SDGAIcon(SDGAIconsStroke.helpCircle),
        onDismissPressed: _dismissible ? () {} : null,
        helperText: _showHelperText
            ? const Text('When the alert needs a further detailed explanation')
            : null,
        actions: _showActions
            ? [
                SDGAButton(
                  style: SDGAButtonStyle.subtle,
                  size: SDGAWidgetSize.small,
                  child: const Text('Button'),
                  onPressed: () {},
                ),
                SDGAButton(
                  style: SDGAButtonStyle.subtle,
                  size: SDGAWidgetSize.small,
                  child: const Text('Button'),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildColoredBackgroundProperty(),
      _buildDismissibleProperty(),
      _buildShowHelperTextProperty(),
      _buildShowActionsProperty(),
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

  Widget _buildColoredBackgroundProperty() {
    return SDGASwitchListTile(
      value: _coloredBackground,
      title: const Text('Colored Background'),
      onChanged: (value) => setState(() => _coloredBackground = value),
    );
  }

  Widget _buildDismissibleProperty() {
    return SDGASwitchListTile(
      value: _dismissible,
      title: const Text('Dismissible'),
      onChanged: (value) => setState(() => _dismissible = value),
    );
  }

  Widget _buildShowHelperTextProperty() {
    return SDGASwitchListTile(
      value: _showHelperText,
      title: const Text('Show Helper Text'),
      onChanged: (value) => setState(() => _showHelperText = value),
    );
  }

  Widget _buildShowActionsProperty() {
    return SDGASwitchListTile(
      value: _showActions,
      title: const Text('Show Actions'),
      onChanged: (value) => setState(() => _showActions = value),
    );
  }
}
