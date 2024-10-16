import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class AvatarsPage extends BaseComponentsPage {
  const AvatarsPage({super.key});

  @override
  State<AvatarsPage> createState() => _AvatarsPageState();
}

class _AvatarsPageState extends BaseComponentsPageState<AvatarsPage> {
  SDGAAvatarType _type = SDGAAvatarType.initials;
  SDGAAvatarSizes _size = SDGAAvatarSizes.medium;
  bool _square = false;
  bool _group = false;
  bool _groupStacked = false;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  Widget buildContent() {
    if (_group) {
      return SDGAAvatarGroup(
        type: _type,
        size: _size,
        square: _square,
        stacked: _groupStacked,
        avatars: List.generate(10, (index) => _buildAvatar()),
        alignment: Alignment.center,
      );
    } else {
      return _buildAvatar();
    }
  }

  SDGAAvatar _buildAvatar() {
    return SDGAAvatar(
      type: _type,
      size: _size,
      icon: const Icon(Icons.person_outline),
      initials: "OG",
      square: _square,
      image: Image.asset(
        'assets/sample_image.png',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildSizeProperty(),
      _buildSquareProperty(),
      _buildGroupProperty(),
      if (_group) ...[
        _buildStackedGroupProperty(),
      ],
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.name,
      values: SDGAAvatarType.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _size.name,
      values: SDGAAvatarSizes.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _size = item),
    );
  }

  Widget _buildSquareProperty() {
    return SDGASwitchListTile(
      value: _square,
      title: const Text('Square'),
      onChanged: (value) => setState(() => _square = value),
    );
  }

  Widget _buildGroupProperty() {
    return SDGASwitchListTile(
      value: _group,
      title: const Text('Group'),
      onChanged: (value) => setState(() => _group = value),
    );
  }

  Widget _buildStackedGroupProperty() {
    return SDGASwitchListTile(
      value: _groupStacked,
      title: const Text('Stacked Group'),
      onChanged: (value) => setState(() => _groupStacked = value),
    );
  }
}
