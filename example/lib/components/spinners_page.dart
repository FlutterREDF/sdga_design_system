import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SpinnersPage extends BaseComponentsPage {
  const SpinnersPage({super.key});

  @override
  State<SpinnersPage> createState() => _SpinnersPageState();
}

class _SpinnersPageState extends BaseComponentsPageState<SpinnersPage> {
  SDGAWidgetStyle _type = SDGAWidgetStyle.brand;
  SDGASpinnerSizes _size = SDGASpinnerSizes.large;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  Color? get backgroundColor => _type == SDGAWidgetStyle.onColor
      ? SDGAColorScheme.of(context).backgrounds.saFlag
      : null;

  @override
  Widget buildContent() {
    return SDGASpinner(
      style: _type,
      size: _size,
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildSizeProperty(),
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.name,
      values: SDGAWidgetStyle.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildSizeProperty() {
    return buildSelectionProperty(
      title: 'Size',
      value: _size.name,
      values: SDGASpinnerSizes.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _size = item),
    );
  }
}
