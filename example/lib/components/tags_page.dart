import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

enum _SDGATagType {
  tag('Tag'),
  icon('Icon'),
  status('Status');

  final String text;

  const _SDGATagType(this.text);
}

class TagsPage extends BaseComponentsPage {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends BaseComponentsPageState<TagsPage> {
  _SDGATagType _type = _SDGATagType.tag;
  SDGATagColor _color = SDGATagColor.neutral;
  SDGATagSize _size = SDGATagSize.medium;
  SDGATagStatus _status = SDGATagStatus.neutral;
  SDGATagStyle _style = SDGATagStyle.inverted;
  bool _rounded = false;
  bool _outline = false;
  bool _trailingIcon = false;
  bool _leadingIcon = false;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  Color? get backgroundColor =>
      _type != _SDGATagType.status && _color == SDGATagColor.onColor
          ? SDGAColorScheme.of(context).backgrounds.saFlag
          : null;

  @override
  Widget buildContent() {
    switch (_type) {
      case _SDGATagType.tag:
        return SDGATag(
          label: const Text('Tag'),
          color: _color,
          size: _size,
          outline: _outline,
          rounded: _rounded,
          leadingIcon: _leadingIcon ? const Icon(Icons.share) : null,
          trailingIcon: _trailingIcon ? const Icon(Icons.favorite) : null,
        );
      case _SDGATagType.icon:
        return SDGATag.icon(
          icon: const Icon(Icons.favorite),
          color: _color,
          size: _size,
          outline: _outline,
          rounded: _rounded,
        );
      case _SDGATagType.status:
        return SDGATag.status(
          label: const Text('Status'),
          size: _size,
          status: _status,
          style: _style,
        );
    }
  }

  @override
  List<Widget> buildProperties() {
    final children = List<Widget>.from([
      _buildTypeProperty(),
      _buildSizeProperty(),
    ]);
    switch (_type) {
      case _SDGATagType.tag:
        children.addAll([
          _buildColorProperty(),
          _buildRoundedProperty(),
          _buildOutlineProperty(),
          _buildLeadingIconProperty(),
          _buildTrailingIconProperty(),
        ]);
        break;
      case _SDGATagType.icon:
        children.addAll([
          _buildColorProperty(),
          _buildRoundedProperty(),
          _buildOutlineProperty(),
        ]);
        break;
      case _SDGATagType.status:
        children.addAll([
          _buildStyleProperty(),
          _buildStatusProperty(),
        ]);
        break;
    }
    return children;
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.text,
      values: _SDGATagType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _size.name,
      values: SDGATagSize.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _size = item),
    );
  }

  Widget _buildColorProperty() {
    return buildSelectionProperty(
      title: 'Color',
      value: _color.name,
      values: SDGATagColor.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _color = item),
    );
  }

  Widget _buildStatusProperty() {
    return buildSelectionProperty(
      title: 'Status',
      value: _status.name,
      values: SDGATagStatus.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _status = item),
    );
  }

  Widget _buildStyleProperty() {
    return buildSelectionProperty(
      title: 'Style',
      value: _style.name,
      values: SDGATagStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _style = item),
    );
  }

  Widget _buildRoundedProperty() {
    return SDGASwitchListTile(
      value: _rounded,
      title: const Text('Rounded'),
      onChanged: (value) => setState(() => _rounded = value),
    );
  }

  Widget _buildOutlineProperty() {
    return SDGASwitchListTile(
      value: _outline,
      title: const Text('Outline'),
      onChanged: (value) => setState(() => _outline = value),
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
}
