import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class AccordionsPage extends BaseComponentsPage {
  const AccordionsPage({super.key});

  @override
  State<AccordionsPage> createState() => _AccordionsPageState();
}

class _AccordionsPageState extends BaseComponentsPageState<AccordionsPage> {
  SDGAWidgetSize _size = SDGAWidgetSize.large;
  SDGAAccordionIconAffinity _affinity = SDGAAccordionIconAffinity.trailing;
  bool _flush = false;

  @override
  bool get wrapWithFill => false;

  @override
  Widget buildContent() {
    const String content =
        'The accordion component delivers large amounts of content in a small space through progressive disclosure. The user gets key details about the underlying content and can choose to expand that content within the constraints of the accordion.';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SDGAAccordionList(
        size: _size,
        initialOpenAccordionValue: 1,
        iconAffinity: _affinity,
        flushPadding: _flush,
        children: const [
          SDGAAccordion(
            value: 1,
            title: Text('Accordion 1', maxLines: 1),
            body: Text(content),
          ),
          SDGAAccordion(
            value: 2,
            title: Text('Accordion 2', maxLines: 1),
            body: Text(content),
          ),
          SDGAAccordion(
            value: 3,
            title: Text('Accordion 3', maxLines: 1),
            body: Text(content),
          ),
          SDGAAccordion(
            value: 4,
            title: Text('Accordion 4', maxLines: 1),
            body: Text(content),
            disabled: true,
          ),
          SDGAAccordion(
            value: 5,
            title: Text('Accordion 5', maxLines: 1),
            body: Text(content),
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildSizeProperty(),
      _buildAffinityProperty(),
      _buildFlushProperty(),
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

  Widget _buildAffinityProperty() {
    return buildSelectionProperty(
      title: 'Icon Affinity',
      value: _affinity.name,
      values: SDGAAccordionIconAffinity.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _affinity = item),
    );
  }

  Widget _buildFlushProperty() {
    return SDGASwitchListTile(
      value: _flush,
      title: const Text('Flush', maxLines: 1),
      onChanged: (value) => setState(() => _flush = value),
    );
  }
}
