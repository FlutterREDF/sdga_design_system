import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

enum _AffixType {
  none('None'),
  textOnly('Text Solid'),
  textOnlySubtle('Text Subtle');

  final String text;

  const _AffixType(this.text);
}

class TextInputPage extends BaseComponentsPage {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends BaseComponentsPageState<TextInputPage> {
  SDGAInputDecorationStyle _style = SDGAInputDecorationStyle.filledDefault;
  _AffixType _prefixType = _AffixType.none;
  _AffixType _suffixType = _AffixType.none;
  bool _hasError = false;
  bool _readOnly = false;
  bool _disabled = false;
  bool _required = true;
  bool _multiline = false;
  bool _showLabel = true;
  bool _largeLabel = true;
  bool _semiBoldLabel = true;
  bool _showHint = true;
  bool _showHelp = true;
  bool _showPrefixIcon = false;
  bool _showSuffixIcon = false;

  @override
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(SDGANumbers.spacingXL),
      child: SDGATextField(
        focusNode: focusNode,
        maxLines: _multiline ? 4 : 1,
        enabled: !_disabled,
        readOnly: _readOnly,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: SDGAInputDecoration(
          style: _style,
          helperText: _showHelp ? 'Help Text' : null,
          errorText: _hasError ? 'Error Text' : null,
          hintText: _showHint ? "Enter Text" : null,
          prefix: _getPrefix(),
          suffix: _getSuffix(),
          prefixIcon: _showPrefixIcon && !_multiline
              ? const SDGAIcon(SDGAIconsStroke.search01)
              : null,
          suffixIcon: _showSuffixIcon && !_multiline
              ? const SDGAFeedbackIcon(
                  addRing: true,
                  size: SDGAWidgetSize.medium,
                )
              : null,
          label: _showLabel
              ? SDGALabel(
                  'Label',
                  required: _required,
                  semiBold: _semiBoldLabel,
                  size:
                      _largeLabel ? SDGALabelSize.large : SDGALabelSize.medium,
                )
              : null,
        ),
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildStyleProperty(),
      _buildMultilineProperty(),
      _buildReadOnlyProperty(),
      _buildDisabledProperty(),
      _buildShowLabelProperty(),
      if (_showLabel) ...[
        _buildLargeLabelProperty(),
        _buildSemiBoldLabelProperty(),
        _buildRequiredProperty(),
      ],
      _buildShowHintProperty(),
      _buildShowHelpProperty(),
      _buildHasErrorProperty(),
      if (!_multiline) ...[
        _buildPrefixTypeProperty(),
        _buildSuffixTypeProperty(),
        _buildShowPrefixIconProperty(),
        _buildShowSuffixIconProperty(),
      ],
    ];
  }

  Widget? _getPrefix() {
    if (_multiline) return null;
    switch (_prefixType) {
      case _AffixType.none:
        return null;
      case _AffixType.textOnly:
        return const SDGAInputAffix.text('Prefix');
      case _AffixType.textOnlySubtle:
        return const SDGAInputAffix.text('Prefix',
            style: SDGAInputAffixStyle.subtle);
    }
  }

  Widget? _getSuffix() {
    if (_multiline) return null;
    switch (_suffixType) {
      case _AffixType.none:
        return null;
      case _AffixType.textOnly:
        return const SDGAInputAffix.text('Suffix');
      case _AffixType.textOnlySubtle:
        return const SDGAInputAffix.text('Suffix',
            style: SDGAInputAffixStyle.subtle);
    }
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGAInputDecorationStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildHasErrorProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_hasError'),
      value: _hasError,
      title: const Text('Has Error'),
      onChanged: (value) => setState(() => _hasError = value),
    );
  }

  Widget _buildReadOnlyProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_readOnly'),
      value: _readOnly,
      title: const Text('Read Only'),
      onChanged: (value) => setState(() => _readOnly = value),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_disabled'),
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildMultilineProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_multiline'),
      value: _multiline,
      title: const Text('Multiline'),
      onChanged: (value) => setState(() => _multiline = value),
    );
  }

  Widget _buildShowLabelProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_showLabel'),
      value: _showLabel,
      title: const Text('Show Label'),
      onChanged: (value) => setState(() => _showLabel = value),
    );
  }

  Widget _buildRequiredProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_required'),
      value: _required,
      title: const Text('    Required'),
      onChanged: (value) => setState(() => _required = value),
    );
  }

  Widget _buildLargeLabelProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_largeLabel'),
      value: _largeLabel,
      title: const Text('    Large Label'),
      onChanged: (value) => setState(() => _largeLabel = value),
    );
  }

  Widget _buildSemiBoldLabelProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_semiBoldLabel'),
      value: _semiBoldLabel,
      title: const Text('    Semi-Bold Label'),
      onChanged: (value) => setState(() => _semiBoldLabel = value),
    );
  }

  Widget _buildShowHintProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_showHint'),
      value: _showHint,
      title: const Text('Show Hint'),
      onChanged: (value) => setState(() => _showHint = value),
    );
  }

  Widget _buildShowHelpProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_showHelp'),
      value: _showHelp,
      title: const Text('Show Help'),
      onChanged: (value) => setState(() => _showHelp = value),
    );
  }

  Widget _buildShowPrefixIconProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_showPrefixIcon'),
      value: _showPrefixIcon,
      title: const Text('Show Prefix Icon'),
      onChanged: (value) => setState(() => _showPrefixIcon = value),
    );
  }

  Widget _buildShowSuffixIconProperty() {
    return SDGASwitchListTile(
      key: const ValueKey('_showSuffixIcon'),
      value: _showSuffixIcon,
      title: const Text('Show Suffix Icon'),
      onChanged: (value) => setState(() => _showSuffixIcon = value),
    );
  }

  Widget _buildPrefixTypeProperty() {
    return buildSelectionProperty(
      title: 'Prefix Type',
      value: _prefixType.text,
      values: _AffixType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _prefixType = item),
    );
  }

  Widget _buildSuffixTypeProperty() {
    return buildSelectionProperty(
      title: 'Suffix Type',
      value: _suffixType.text,
      values: _AffixType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _suffixType = item),
    );
  }
}
