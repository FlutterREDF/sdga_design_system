import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class RatingPage extends BaseComponentsPage {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends BaseComponentsPageState<RatingPage> {
  SDGAWidgetSize _size = SDGAWidgetSize.large;
  bool _allowFractions = true;
  bool _useBrandColors = false;
  bool _intractable = true;
  double _rating = 3.5;

  @override
  Widget buildContent() {
    return SDGARatingBar(
      focusNode: focusNode,
      size: _size,
      value: _rating,
      allowFractions: _allowFractions,
      useBrandColors: _useBrandColors,
      onChanged:
          _intractable ? (rating) => setState(() => _rating = rating) : null,
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      buildFocusProperty(),
      _buildSizeProperty(),
      _buildAllowFractionsProperty(),
      _buildUseBrandColorsProperty(),
      _buildIntractableProperty(),
    ];
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

  Widget _buildAllowFractionsProperty() {
    return SDGASwitchListTile(
      value: _allowFractions,
      title: const Text('Allow Fractions'),
      onChanged: (value) => setState(() => _allowFractions = value),
    );
  }

  Widget _buildUseBrandColorsProperty() {
    return SDGASwitchListTile(
      value: _useBrandColors,
      title: const Text('Use Brand Colors'),
      onChanged: (value) => setState(() => _useBrandColors = value),
    );
  }

  Widget _buildIntractableProperty() {
    return SDGASwitchListTile(
      value: _intractable,
      title: const Text('Intractable'),
      onChanged: (value) => setState(() => _intractable = value),
    );
  }
}
