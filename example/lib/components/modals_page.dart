import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class ModalsPage extends BaseComponentsPage {
  const ModalsPage({super.key});

  @override
  State<ModalsPage> createState() => _ModalsPageState();
}

class _ModalsPageState extends BaseComponentsPageState<ModalsPage> {
  bool _showActions = true;
  bool _stackedActions = true;
  bool _showCloseButton = true;
  bool _showHeaderLeadingAction = true;
  bool _showHeaderTrailingAction = true;
  bool _dismissible = true;
  bool _snap = true;

  @override
  Widget buildContent() {
    // return _getModal();
    return SDGAButton(
      style: Theme.of(context).brightness == Brightness.light
          ? SDGAButtonStyle.primaryNeutral
          : SDGAButtonStyle.secondary,
      leadingIcon: const SDGAIcon(SDGAIconsStroke.sidebarBottom),
      child: const Text('Open Modal'),
      onPressed: () => showModalBottomSheet(
        isDismissible: _dismissible,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => SDGADraggableScrollable(
          snap: _snap,
          shouldCloseOnMinExtent: _dismissible,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              child: _getModal(),
            );
          },
        ),
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildDismissibleProperty(),
      _buildSnapProperty(),
      _buildShowActionsProperty(),
      _buildStackedActionsProperty(),
      _buildShowHeaderLeadingActionProperty(),
      _buildShowHeaderTrailingActionProperty(),
      if (!_showHeaderTrailingAction) _buildShowCloseButtonProperty(),
    ];
  }

  Widget _getModal() {
    return SDGAModal(
      actionsDirection: _stackedActions ? Axis.vertical : Axis.horizontal,
      showCloseButton: _showCloseButton,
      headerLeadingAction: _showHeaderLeadingAction
          ? SDGAButton(
              style: SDGAButtonStyle.subtle,
              size: SDGAWidgetSize.small,
              onPressed: () {},
              child: const Text('Button'),
            )
          : null,
      headerTrailingAction: _showHeaderTrailingAction
          ? SDGAButton(
              style: SDGAButtonStyle.subtle,
              size: SDGAWidgetSize.small,
              onPressed: () {},
              child: const Text('Button'),
            )
          : null,
      actions: _showActions
          ? _stackedActions
              ? [
                  _buildButton(SDGAButtonStyle.primaryNeutral),
                  _buildButton(SDGAButtonStyle.secondaryOutline),
                  _buildButton(SDGAButtonStyle.subtle),
                ]
              : [
                  _buildButton(SDGAButtonStyle.secondaryOutline),
                  _buildButton(SDGAButtonStyle.primaryNeutral),
                ]
          : null,
      title: const Text('Modal Title'),
      child: const SDGAPlaceholder(),
    );
  }

  Widget _buildDismissibleProperty() {
    return SDGASwitchListTile(
      value: _dismissible,
      title: const Text('Dismissible'),
      onChanged: (value) => setState(() => _dismissible = value),
    );
  }

  Widget _buildSnapProperty() {
    return SDGASwitchListTile(
      value: _snap,
      title: const Text('Snap'),
      onChanged: (value) => setState(() => _snap = value),
    );
  }

  Widget _buildShowActionsProperty() {
    return SDGASwitchListTile(
      value: _showActions,
      title: const Text('Show Actions'),
      onChanged: (value) => setState(() => _showActions = value),
    );
  }

  Widget _buildStackedActionsProperty() {
    return SDGASwitchListTile(
      value: _stackedActions,
      title: const Text('Stack Actions'),
      onChanged: (value) => setState(() => _stackedActions = value),
    );
  }

  Widget _buildShowHeaderLeadingActionProperty() {
    return SDGASwitchListTile(
      value: _showHeaderLeadingAction,
      title: const Text('Show Header Leading Action'),
      onChanged: (value) => setState(() => _showHeaderLeadingAction = value),
    );
  }

  Widget _buildShowHeaderTrailingActionProperty() {
    return SDGASwitchListTile(
      value: _showHeaderTrailingAction,
      title: const Text('Show Header Trailing Action'),
      onChanged: (value) => setState(() => _showHeaderTrailingAction = value),
    );
  }

  Widget _buildShowCloseButtonProperty() {
    return SDGASwitchListTile(
      value: _showCloseButton,
      title: const Text('Show Close Button'),
      onChanged: (value) => setState(() => _showCloseButton = value),
    );
  }

  Widget _buildButton(SDGAButtonStyle style) => SDGAButton(
        style: style,
        size: SDGAWidgetSize.medium,
        onPressed: () {},
        child: const Text('Button'),
      );
}
