import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class RadioPage extends BaseComponentsPage {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends BaseComponentsPageState<RadioPage> {
  SDGAToggleableStyle _style = SDGAToggleableStyle.brand;
  SDGAAlertType _alertType = SDGAAlertType.error;
  bool _disabled = false;
  bool _readonly = false;
  bool _selected = false;
  bool _showLabel = false;
  bool _showHelperText = false;
  bool _showAlertMessage = false;

  @override
  Widget buildContent() {
    if (_showLabel) {
      return Padding(
        padding: const EdgeInsets.all(SDGAConstants.spacing2),
        child: SDGARadio<bool>.layout(
          value: true,
          style: _style,
          readonly: _readonly,
          groupValue: _selected,
          focusNode: focusNode,
          label: "Radio Label",
          helperText: _showHelperText
              ? 'When a selection needs a further detailed explanation, it goes here.'
              : null,
          alertMessage: _showAlertMessage ? 'Error/Warning message' : null,
          alertType: _alertType,
          onChanged: _disabled ? null : (_) {},
        ),
      );
    } else {
      return SDGARadio<bool>(
        value: true,
        style: _style,
        readonly: _readonly,
        groupValue: _selected,
        focusNode: focusNode,
        onChanged: _disabled ? null : (_) {},
      );
    }
  }

  @override
  List<Widget> buildProperties() {
    return [
      buildFocusProperty(),
      _buildStyleProperty(),
      _buildSelectedProperty(),
      _buildReadOnlyProperty(),
      _buildDisabledProperty(),
      _buildShowLabelProperty(),
      if (_showLabel) ...[
        _buildAlertTypeProperty(),
        _buildShowHelperTextProperty(),
        _buildShowAlertMessageProperty(),
      ],
    ];
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGAToggleableStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildAlertTypeProperty() {
    return buildSelectionProperty(
      title: 'Alert Type',
      value: _alertType.name,
      values: SDGAAlertType.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _alertType = item),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildReadOnlyProperty() {
    return SDGASwitchListTile(
      value: _readonly,
      title: const Text('Readonly'),
      onChanged: (value) => setState(() => _readonly = value),
    );
  }

  Widget _buildSelectedProperty() {
    return SDGASwitchListTile(
      value: _selected,
      title: const Text('Selected'),
      onChanged: (value) => setState(() => _selected = value),
    );
  }

  Widget _buildShowLabelProperty() {
    return SDGASwitchListTile(
      value: _showLabel,
      title: const Text('Show Label'),
      onChanged: (value) => setState(() => _showLabel = value),
    );
  }

  Widget _buildShowHelperTextProperty() {
    return SDGASwitchListTile(
      value: _showHelperText,
      title: const Text('Show Helper Text'),
      onChanged: (value) => setState(() => _showHelperText = value),
    );
  }

  Widget _buildShowAlertMessageProperty() {
    return SDGASwitchListTile(
      value: _showAlertMessage,
      title: const Text('Show Alert Message'),
      onChanged: (value) => setState(() => _showAlertMessage = value),
    );
  }
}
