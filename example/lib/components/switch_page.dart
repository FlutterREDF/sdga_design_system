import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SwitchPage extends BaseComponentsPage {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends BaseComponentsPageState<SwitchPage> {
  SDGAAlertType _alertType = SDGAAlertType.error;
  bool _disabled = false;
  bool _selected = false;
  bool _showLabel = false;
  bool _showHelperText = false;
  bool _showAlertMessage = false;
  bool _trailSwitch = false;

  @override
  Widget buildContent() {
    if (_showLabel) {
      return Padding(
        padding: const EdgeInsets.all(SDGAConstants.spacing2),
        child: SDGASwitch.layout(
          focusNode: focusNode,
          value: _selected,
          label: "Switch Label",
          helperText: _showHelperText
              ? 'When a selection needs a further detailed explanation, it goes here.'
              : null,
          alertMessage: _showAlertMessage ? 'Error/Warning message' : null,
          alertType: _alertType,
          trailSwitch: _trailSwitch,
          onChanged: _disabled
              ? null
              : (value) {
                  setState(() => _selected = value);
                },
        ),
      );
    } else {
      return SDGASwitch(
        focusNode: focusNode,
        value: _selected,
        onChanged: _disabled
            ? null
            : (value) {
                setState(() => _selected = value);
              },
      );
    }
  }

  @override
  List<Widget> buildProperties() {
    return [
      buildFocusProperty(),
      _buildSelectedProperty(),
      _buildDisabledProperty(),
      _buildShowLabelProperty(),
      if (_showLabel) ...[
        _buildAlertTypeProperty(),
        _buildShowHelperTextProperty(),
        _buildShowAlertMessageProperty(),
        _buildTrailSwitchProperty(),
      ],
    ];
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
      onChanged: (value) {
        setState(() => _showLabel = value);
        FocusManager.instance.primaryFocus?.unfocus();
      },
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

  Widget _buildTrailSwitchProperty() {
    return SDGASwitchListTile(
      value: _trailSwitch,
      title: const Text('Trail Switch'),
      onChanged: (value) => setState(() => _trailSwitch = value),
    );
  }
}
