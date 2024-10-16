import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class TooltipPage extends BaseComponentsPage {
  const TooltipPage({super.key});

  @override
  State<TooltipPage> createState() => _TooltipPageState();
}

class _TooltipPageState extends BaseComponentsPageState<TooltipPage> {
  final GlobalKey<SDGATooltipState> _key = GlobalKey();
  bool _showIcon = true;
  bool _showTitle = true;
  bool _showBeak = true;
  bool _inverted = true;

  @override
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingLG),
      child: Row(
        children: [
          _wrapWithTooltip(
            child: const SDGAFeedbackIcon(
              type: SDGAFeedbackIconType.confirmation,
              color: SDGAWidgetColor.neutral,
            ),
          ),
          const Spacer(),
          _wrapWithTooltip(
            key: _key,
            child: const SDGAFeedbackIcon(
              type: SDGAFeedbackIconType.confirmation,
              color: SDGAWidgetColor.neutral,
            ),
          ),
          const Spacer(),
          _wrapWithTooltip(
            child: const SDGAFeedbackIcon(
              type: SDGAFeedbackIconType.confirmation,
              color: SDGAWidgetColor.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapWithTooltip({Key? key, required Widget child}) {
    return SDGATooltip(
      key: key,
      inverted: _inverted,
      showBeak: _showBeak,
      triggerMode: TooltipTriggerMode.tap,
      semanticMessage:
          "Max width of tooltips is 240px - text will wrap automatically",
      title: _showTitle ? const Text("Tooltip title") : null,
      body: const Text(
          "Max width of tooltips is 240px - text will wrap automatically"),
      icon: _showIcon
          ? const SDGAFeedbackIcon.customSize(
              size: 18,
              type: SDGAFeedbackIconType.confirmation,
              color: SDGAWidgetColor.neutral,
              iconFillColor: SDGAColors.white,
            )
          : null,
      child: child,
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildShowTooltip(),
      _buildShowIconProperty(),
      _buildShowTitleProperty(),
      _buildShowBeakProperty(),
      _buildInvertedProperty(),
    ];
  }

  Widget _buildShowTooltip() {
    return SDGAListTile(
      title: const Text("Show Tooltip"),
      onTap: () {
        _key.currentState?.ensureTooltipVisible();
      },
    );
  }

  Widget _buildShowIconProperty() {
    return SDGASwitchListTile(
      value: _showIcon,
      title: const Text('Show Icon'),
      onChanged: (value) => setState(() => _showIcon = value),
    );
  }

  Widget _buildShowTitleProperty() {
    return SDGASwitchListTile(
      value: _showTitle,
      title: const Text('Show Title'),
      onChanged: (value) => setState(() => _showTitle = value),
    );
  }

  Widget _buildShowBeakProperty() {
    return SDGASwitchListTile(
      value: _showBeak,
      title: const Text('Show Beak (Small Arrow)'),
      onChanged: (value) => setState(() => _showBeak = value),
    );
  }

  Widget _buildInvertedProperty() {
    return SDGASwitchListTile(
      value: _inverted,
      title: const Text('Inverted'),
      onChanged: (value) => setState(() => _inverted = value),
    );
  }
}
