import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

enum _SDGAButtonType {
  button('Button'),
  destructiveButton('Destructive Button'),
  icon('Icon'),
  destructiveIcon('Destructive Icon'),
  menu('Menu'),
  fab('Fab'),
  close('Close');

  final String text;

  const _SDGAButtonType(this.text);
}

class ButtonsPage extends BaseComponentsPage {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends BaseComponentsPageState<ButtonsPage> {
  _SDGAButtonType _type = _SDGAButtonType.button;
  SDGAWidgetSize _size = SDGAWidgetSize.large;
  SDGACloseButtonSize _closeSize = SDGACloseButtonSize.large;
  SDGAButtonStyle _style = SDGAButtonStyle.primaryBrand;
  SDGAFabButtonStyle _fabStyle = SDGAFabButtonStyle.primaryBrand;
  SDGADestructiveButtonStyle _destructiveStyle =
      SDGADestructiveButtonStyle.primary;
  bool _disabled = false;
  bool _onColor = false;
  bool _trailingIcon = false;
  bool _leadingIcon = false;
  bool _showLabel = false;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  Color? get backgroundColor =>
      _onColor ? SDGAColorScheme.of(context).backgrounds.saFlag : null;

  @override
  Widget buildContent() {
    switch (_type) {
      case _SDGAButtonType.button:
        return SDGAButton(
          size: _size,
          style: _style,
          onColor: _onColor,
          leadingIcon: _leadingIcon ? const Icon(Icons.share) : null,
          trailingIcon: _trailingIcon ? const Icon(Icons.favorite) : null,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
          child: const Text('Button'),
        );
      case _SDGAButtonType.icon:
        return SDGAButton.icon(
          icon: const Icon(Icons.share),
          size: _size,
          style: _style,
          onColor: _onColor,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
        );
      case _SDGAButtonType.destructiveButton:
        return SDGAButton.destructive(
          size: _size,
          style: _destructiveStyle,
          onColor: _onColor,
          leadingIcon: _leadingIcon ? const Icon(Icons.share) : null,
          trailingIcon: _trailingIcon ? const Icon(Icons.favorite) : null,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
          child: const Text('Button'),
        );
      case _SDGAButtonType.destructiveIcon:
        return SDGAButton.destructiveIcon(
          icon: const Icon(Icons.share),
          size: _size,
          style: _destructiveStyle,
          onColor: _onColor,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
        );
      case _SDGAButtonType.menu:
        return SDGAButton.menu(
          size: _size,
          style: _style,
          leadingIcon: _leadingIcon ? const Icon(Icons.share) : null,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
          child: _showLabel ? const Text('Button') : null,
        );
      case _SDGAButtonType.close:
        return SDGAButton.close(
          size: _closeSize,
          onColor: _onColor,
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
        );
      case _SDGAButtonType.fab:
        return SDGAButton.fab(
          style: _fabStyle,
          onColor: _onColor,
          icon: const Icon(Icons.share),
          onPressed: _disabled ? null : () {},
          focusNode: focusNode,
          child: _showLabel ? const Text('Button') : null,
        );
    }
  }

  @override
  List<Widget> buildProperties() {
    final children = List<Widget>.from([
      buildFocusProperty(),
      _buildTypeProperty(),
      if (_type != _SDGAButtonType.fab && _type != _SDGAButtonType.close)
        _buildSizeProperty(),
    ]);
    switch (_type) {
      case _SDGAButtonType.button:
        children.addAll([
          _buildStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
          _buildLeadingIconProperty(),
          _buildTrailingIconProperty(),
        ]);
        break;
      case _SDGAButtonType.destructiveButton:
        children.addAll([
          _buildDestructiveStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
          _buildLeadingIconProperty(),
          _buildTrailingIconProperty(),
        ]);
        break;
      case _SDGAButtonType.icon:
        children.addAll([
          _buildStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
        ]);
        break;
      case _SDGAButtonType.destructiveIcon:
        children.addAll([
          _buildDestructiveStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
        ]);
        break;
      case _SDGAButtonType.menu:
        children.addAll([
          _buildStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
          _buildShowLabelProperty(),
          _buildLeadingIconProperty(),
        ]);
        break;
      case _SDGAButtonType.fab:
        children.addAll([
          _buildFabStyleProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
          _buildShowLabelProperty(),
        ]);
        break;
      case _SDGAButtonType.close:
        children.addAll([
          _buildCloseSizeProperty(),
          _buildDisabledProperty(),
          _buildOnColorProperty(),
        ]);
        break;
    }
    return children;
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildOnColorProperty() {
    return SDGASwitchListTile(
      value: _onColor,
      title: const Text('On Color'),
      onChanged: (value) => setState(() => _onColor = value),
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

  Widget _buildShowLabelProperty() {
    return SDGASwitchListTile(
      value: _showLabel,
      title: const Text('Show Label'),
      onChanged: (value) => setState(() => _showLabel = value),
    );
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.text,
      values: _SDGAButtonType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _type = item),
    );
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

  Widget _buildCloseSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _closeSize.name,
      values: SDGACloseButtonSize.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _closeSize = item),
    );
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGAButtonStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildDestructiveStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _destructiveStyle.name,
      values: SDGADestructiveButtonStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _destructiveStyle = item),
    );
  }

  Widget _buildFabStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _fabStyle.name,
      values: SDGAFabButtonStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _fabStyle = item),
    );
  }
}
