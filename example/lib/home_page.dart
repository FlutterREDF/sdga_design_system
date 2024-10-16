import 'package:example/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

part 'home_drawer.dart';
part 'home_drawer_options.dart';

enum _Pages {
  accordions('Accordions', true),
  avatars('Avatars', true),
  banners('Banners', true),
  buttons('Buttons', true),
  cards('Cards', true),
  checkboxes('Checkboxes', true),
  contentSwitchers('Content Switchers', true),
  datePicker('Date picker'),
  drawer('Drawer', true),
  dropdown('Dropdown'),
  fileUpload('File Upload', true),
  inlineAlert('Inline Alert', true),
  link('Link', true),
  list('List', true),
  menu('Menu', true),
  modals('Modals', true),
  notificationToast('Notification Toast', true),
  pagination('Pagination', true),
  stepper('Stepper', true),
  radio('Radio', true),
  rating('Rating', true),
  spinners('Spinners', true),
  switchPage('Switch', true),
  tabs('Tabs', true),
  tags('Tags', true),
  textInput('Text input', true),
  tooltip('Tooltip', true);

  final String text;
  final bool done;

  const _Pages(this.text, [this.done = false]);
}

class HomePage extends StatefulWidget {
  final void Function() toggleTheme;

  const HomePage({
    super.key,
    required this.toggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeDrawerOptions _options = HomeDrawerOptions();
  _Pages _currentPage = _Pages.buttons;

  @override
  Widget build(BuildContext context) {
    final colors = SDGAColorScheme.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return HomeDrawerOptionsWrapper(
      options: _options,
      child: Scaffold(
        backgroundColor: colors.backgrounds.white,
        drawerScrimColor: SDGAColors.blackAlpha.alpha30,
        drawer: _HomeDrawer(
          options: _options,
          currentPage: _currentPage,
          onPageSelected: (context, page) {
            Scaffold.of(context).closeDrawer();
            setState(() {
              _currentPage = page;
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: colors.backgrounds.white,
          title: Text(
            _currentPage.text,
            style: SDGATextStyles.textSmallSemiBold
                .copyWith(color: colors.texts.defaultColor),
          ),
          elevation: 1,
          scrolledUnderElevation: 1,
          surfaceTintColor: colors.backgrounds.white,
          shadowColor: colors.borders.neutralSecondary,
          leading: Builder(builder: (context) {
            return Center(
              child: SDGATooltip(
                inverted: true,
                triggerMode: TooltipTriggerMode.tap,
                semanticMessage: "Open Drawer",
                body: const Text("Open Drawer"),
                child: SDGAButton.icon(
                  style: SDGAButtonStyle.secondary,
                  icon: const SDGAIcon(SDGAIconsStroke.menu02),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            );
          }),
          centerTitle: true,
          actions: [
            SDGATooltip(
              inverted: true,
              triggerMode: TooltipTriggerMode.tap,
              semanticMessage: "Toggle Theme",
              body: const Text("Toggle Theme"),
              child: SDGAButton.icon(
                style: SDGAButtonStyle.secondary,
                icon: SDGAIcon(
                    isLight ? SDGAIconsSolid.moon02 : SDGAIconsSolid.sun02),
                onPressed: widget.toggleTheme,
              ),
            ),
            const SizedBox(width: SDGANumbers.spacingMD),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: _getPage(),
        ),
      ),
    );
  }

  /// -  **Actions**: [SDGAButton], [SDGALink].
  /// -  **Content Display**: [SDGAAccordionList], [SDGACard], [SDGAListTile], [SDGACheckboxListTile], [SDGARadioListTile], [SDGASwitchListTile].
  /// -  **Data Display**: [SDGAAvatar], [SDGAContentSwitcher].
  /// -  **Feedback**: [SDGAModal], [SDGANotificationToast], [SDGARatingBar], [SDGATooltip].
  /// -  **Forms**: [SDGACheckbox], [SDGARadio], [SDGASwitch], [SDGAFileInput], [SDGATextField].
  /// -  **Navigational**: [SDGADrawer], [SDGAMenu], [SDGAPagination], [SDGATabBar].
  /// -  **Loading Indicators**: [SDGASpinner].
  /// -  **Search and Other Elements**: [SDGATag], [SDGABanner], [SDGAInlineAlert].
  Widget _getPage() {
    switch (_currentPage) {
      case _Pages.accordions:
        return const AccordionsPage();
      case _Pages.avatars:
        return const AvatarsPage();
      case _Pages.banners:
        return const BannersPage();
      case _Pages.buttons:
        return const ButtonsPage();
      case _Pages.cards:
        return const CardsPage();
      case _Pages.checkboxes:
        return const CheckboxesPage();
      case _Pages.contentSwitchers:
        return const ContentSwitchersPage();
      case _Pages.drawer:
        return const DrawerPage();
      case _Pages.fileUpload:
        return const FileUploadPage();
      case _Pages.inlineAlert:
        return const InlineAlertPage();
      case _Pages.link:
        return const LinkPage();
      case _Pages.list:
        return const ListPage();
      case _Pages.menu:
        return const MenuPage();
      case _Pages.modals:
        return const ModalsPage();
      case _Pages.notificationToast:
        return const NotificationToastPage();
      case _Pages.pagination:
        return const PaginationPage();
      case _Pages.stepper:
        return const StepperPage();
      case _Pages.radio:
        return const RadioPage();
      case _Pages.rating:
        return const RatingPage();
      case _Pages.spinners:
        return const SpinnersPage();
      case _Pages.switchPage:
        return const SwitchPage();
      case _Pages.tabs:
        return const TabsPage();
      case _Pages.tags:
        return const TagsPage();
      case _Pages.textInput:
        return const TextInputPage();
      case _Pages.tooltip:
        return const TooltipPage();
      case _Pages.datePicker:
      case _Pages.dropdown:
        return const Padding(
          padding: EdgeInsets.all(SDGANumbers.spacingLG),
          child: Center(child: SDGAPlaceholder(message: 'Work in progress')),
        );
    }
  }
}
