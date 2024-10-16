import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

class MenuPage extends BaseComponentsPage {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends BaseComponentsPageState<MenuPage> {
  bool _firstSelected = false;
  bool _secondSelected = false;
  bool _thirdSelected = false;

  @override
  bool get noProperties => true;

  @override
  Widget buildContent() {
    return SDGAMenu(
      buildItems: (context, controller) {
        return [
          const SDGAMenuItem.groupTitle(Text('GROUP LABEL')),
          SDGAMenuItem(
            onTap: () {
              controller.close();
            },
            label: const Text('Item Label'),
            leading: const SDGAIcon(SDGAIconsStroke.file01),
            trailing: SDGAButton.icon(
              icon: const SDGAIcon(SDGAIconsStroke.edit02),
              style: SDGAButtonStyle.subtle,
              size: SDGAWidgetSize.small,
              onPressed: () {},
            ),
          ),
          SDGAMenuItem(
            onTap: () {},
            label: const Text('Item Label'),
            leading: const SDGAIcon(SDGAIconsStroke.file01),
          ),
          const SDGAMenuItem(
            label: Text('Item Label'),
            leading: SDGAIcon(SDGAIconsStroke.file01),
          ),
          const SDGAMenuItem.divider(),
          const SDGAMenuItem.groupTitle(Text('GROUP LABEL')),
          SDGAMenuItem(
            onTap: () => setState(() => _firstSelected = !_firstSelected),
            label: const Text('Item Label'),
            leading: const SDGAIcon(SDGAIconsStroke.file01),
            trailing: SDGASwitch(
              value: _firstSelected,
              onChanged: (value) => setState(() => _firstSelected = value),
            ),
          ),
          SDGAMenuItem(
            onTap: () => setState(() => _secondSelected = !_secondSelected),
            label: const Text('Item Label'),
            leading: const SDGAIcon(SDGAIconsStroke.file01),
            trailing: SDGASwitch(
              value: _secondSelected,
              onChanged: (value) => setState(() => _secondSelected = value),
            ),
          ),
          SDGAMenuItem(
            onTap: () => setState(() => _thirdSelected = !_thirdSelected),
            label: const Text('Item Label'),
            leading: const SDGAIcon(SDGAIconsStroke.file01),
            trailing: SDGASwitch(
              value: _thirdSelected,
              onChanged: (value) => setState(() => _thirdSelected = value),
            ),
          ),
          const SDGAMenuItem.divider(),
          const SDGAMenuItem.groupTitle(Text('GROUP LABEL')),
          _buildTagItem(SDGATagColor.neutral),
          _buildTagItem(SDGATagColor.info),
          _buildTagItem(SDGATagColor.success),
          _buildTagItem(SDGATagColor.warning),
          _buildTagItem(SDGATagColor.error),
        ];
      },
      builder: (context, controller, child) {
        return SDGAButton.icon(
          style: Theme.of(context).brightness == Brightness.light
              ? SDGAButtonStyle.primaryNeutral
              : SDGAButtonStyle.secondary,
          icon: const SDGAIcon(SDGAIconsStroke.moreHorizontalCircle01),
          onPressed: () => controller.open(),
        );
      },
    );
  }

  SDGAMenuItem _buildTagItem(SDGATagColor color) => SDGAMenuItem(
        onTap: () {},
        label: const Text('Item Label'),
        leading: const SDGAIcon(SDGAIconsStroke.file01),
        trailing: SDGATag(
          label: const Text('Label'),
          size: SDGATagSize.small,
          color: color,
        ),
      );
}
