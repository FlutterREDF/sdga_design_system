import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class PaginationPage extends BaseComponentsPage {
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends BaseComponentsPageState<PaginationPage> {
  SDGAWidgetSize _size = SDGAWidgetSize.small;
  bool _disabled = false;
  int _currentPage = 1;

  @override
  Widget buildContent() {
    return SDGAPagination(
      currentPage: _currentPage,
      totalPageCount: 99,
      size: _size,
      onPageChange:
          _disabled ? null : (page) => setState(() => _currentPage = page),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildSizeProperty(),
      _buildDisabledProperty(),
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

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }
}
