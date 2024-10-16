import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

enum _SDGAListType {
  tile('Normal List Tile'),
  switchTile('Switch List Tile'),
  radioTile('Radio List Tile'),
  checkboxTile('Checkbox List Tile'),
  ;

  final String text;

  const _SDGAListType(this.text);
}

class ListPage extends BaseComponentsPage {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends BaseComponentsPageState<ListPage> {
  _SDGAListType _type = _SDGAListType.tile;
  SDGAToggleableStyle _style = SDGAToggleableStyle.brand;
  bool _disabled = false;
  bool _trailingIcon = false;
  bool _leadingIcon = false;
  bool _showDescription = false;
  bool _selected = false;
  bool _intermediate = false;
  bool? _checked = false;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  Widget buildContent() {
    Widget child;
    switch (_type) {
      case _SDGAListType.tile:
        child = SDGAListTile(
          title: const Text("Title"),
          focusNode: focusNode,
          enabled: !_disabled,
          onTap: () {},
          subtitle:
              _showDescription ? const Text("Description goes here") : null,
          leading: _leadingIcon
              ? const SDGAIcon(SDGAIconsStroke.settingsError01)
              : null,
          trailing: _trailingIcon
              ? const SDGAIcon(SDGAIconsStroke.arrowRight01)
              : null,
        );
        break;
      case _SDGAListType.radioTile:
        child = SDGARadioListTile<bool>(
          title: const Text("Title"),
          focusNode: focusNode,
          value: true,
          groupValue: _selected,
          toggleable: true,
          style: _style,
          subtitle:
              _showDescription ? const Text("Description goes here") : null,
          leading: _leadingIcon
              ? const SDGAIcon(SDGAIconsStroke.settingsError01)
              : null,
          onChanged: _disabled
              ? null
              : (value) {
                  setState(() => _selected = value ?? false);
                },
        );
        break;
      case _SDGAListType.checkboxTile:
        child = SDGACheckboxListTile(
          title: const Text("Title"),
          focusNode: focusNode,
          value: _checked,
          tristate: _intermediate,
          style: _style,
          subtitle:
              _showDescription ? const Text("Description goes here") : null,
          leading: _leadingIcon
              ? const SDGAIcon(SDGAIconsStroke.settingsError01)
              : null,
          onChanged: _disabled ? null : _onChange,
        );
        break;
      case _SDGAListType.switchTile:
        child = SDGASwitchListTile(
          title: const Text("Title"),
          focusNode: focusNode,
          value: _selected,
          subtitle:
              _showDescription ? const Text("Description goes here") : null,
          leading: _leadingIcon
              ? const SDGAIcon(SDGAIconsStroke.settingsError01)
              : null,
          onChanged: _disabled
              ? null
              : (value) {
                  setState(() => _selected = value);
                },
        );
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingLG),
      child: child,
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      buildFocusProperty(),
      _buildTypeProperty(),
      if (_type != _SDGAListType.tile && _type != _SDGAListType.switchTile) ...[
        _buildStyleProperty(),
      ],
      _buildDisabledProperty(),
      _buildShowDescriptionProperty(),
      _buildLeadingIconProperty(),
      if (_type == _SDGAListType.tile) ...[
        _buildTrailingIconProperty(),
      ] else if (_type == _SDGAListType.checkboxTile) ...[
        _buildCheckedProperty(),
        _buildIntermediateProperty(),
      ] else ...[
        _buildSelectedProperty(),
      ],
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.text,
      values: _SDGAListType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildShowDescriptionProperty() {
    return SDGASwitchListTile(
      value: _showDescription,
      title: const Text('Show Description'),
      onChanged: (value) => setState(() => _showDescription = value),
    );
  }

  Widget _buildLeadingIconProperty() {
    return SDGASwitchListTile(
      value: _leadingIcon,
      title: const Text('Leading Icon'),
      onChanged: (value) => setState(() => _leadingIcon = value),
    );
  }

  Widget _buildTrailingIconProperty() {
    return SDGASwitchListTile(
      value: _trailingIcon,
      title: const Text('Trailing Icon'),
      onChanged: (value) => setState(() => _trailingIcon = value),
    );
  }

  Widget _buildSelectedProperty() {
    return SDGASwitchListTile(
      value: _selected,
      title: const Text('Selected'),
      onChanged: (value) => setState(() => _selected = value),
    );
  }

  Widget _buildCheckedProperty() {
    return SDGASwitchListTile(
      value: _checked ?? false,
      title: const Text('Checked'),
      onChanged: (value) => setState(() {
        _checked = value;
        _intermediate = false;
      }),
    );
  }

  Widget _buildIntermediateProperty() {
    return SDGASwitchListTile(
      value: _intermediate,
      title: const Text('Intermediate'),
      onChanged: (value) => setState(() {
        _intermediate = value;
        if (_intermediate) {
          _checked = null;
        } else {
          _checked = false;
        }
      }),
    );
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

  void _onChange(bool? value) {
    setState(() {
      _intermediate = value == null;
      _checked = value ?? false;
    });
  }
}
