part of 'home_page.dart';

class _HomeDrawer extends StatefulWidget {
  const _HomeDrawer({
    required this.options,
    required this.currentPage,
    required this.onPageSelected,
  });

  final HomeDrawerOptions options;

  final _Pages currentPage;

  final void Function(BuildContext context, _Pages page) onPageSelected;

  @override
  State<_HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<_HomeDrawer> {
  void _onOptionsUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    widget.options.addListener(_onOptionsUpdated);
    super.initState();
  }

  @override
  void dispose() {
    widget.options.removeListener(_onOptionsUpdated);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _HomeDrawer oldWidget) {
    if (oldWidget.options != widget.options) {
      oldWidget.options.removeListener(_onOptionsUpdated);
      widget.options.addListener(_onOptionsUpdated);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SDGADrawer(
      onColor: widget.options.onColor,
      overlay: widget.options.overlay,
      header: widget.options.showHeader ? _buildHeader() : null,
      items: [
        _getExpandable(
          label: 'Actions',
          icon: SDGAIconsStroke.mouse13,
          pages: [
            _getSubItem(_Pages.buttons),
            _getSubItem(_Pages.link),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Content Display',
          icon: SDGAIconsStroke.listView,
          pages: [
            _getSubItem(_Pages.accordions),
            _getSubItem(_Pages.cards),
            _getSubItem(_Pages.list),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Data Display',
          icon: SDGAIconsStroke.presentation01,
          pages: [
            _getSubItem(_Pages.avatars),
            _getSubItem(_Pages.contentSwitchers),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Feedback',
          icon: SDGAIconsStroke.notification01,
          pages: [
            _getSubItem(_Pages.modals),
            _getSubItem(_Pages.notificationToast),
            _getSubItem(_Pages.rating),
            _getSubItem(_Pages.tooltip),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Forms and Inputs',
          icon: SDGAIconsStroke.typeCursor,
          pages: [
            _getSubItem(_Pages.checkboxes),
            _getSubItem(_Pages.radio),
            _getSubItem(_Pages.switchPage),
            _getSubItem(_Pages.fileUpload),
            _getSubItem(_Pages.dropdown),
            _getSubItem(_Pages.datePicker),
            _getSubItem(_Pages.textInput),
            _getSubItem(_Pages.stepper),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Loading',
          icon: SDGAIconsStroke.loading01,
          pages: [
            _getSubItem(_Pages.spinners),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Navigational',
          icon: SDGAIconsStroke.navigation03,
          pages: [
            _getSubItem(_Pages.drawer),
            _getSubItem(_Pages.menu),
            _getSubItem(_Pages.pagination),
            _getSubItem(_Pages.tabs),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Search',
          icon: SDGAIconsStroke.searching,
          pages: [
            _getSubItem(_Pages.tags),
          ],
        ),
        const SDGADrawerItem.divider(),
        _getExpandable(
          label: 'Other',
          icon: SDGAIconsStroke.moreHorizontalCircle01,
          pages: [
            _getSubItem(_Pages.banners),
            _getSubItem(_Pages.inlineAlert),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SDGADrawerHeader(
      onColor: widget.options.onColor,
      title: const Text('Username', maxLines: 1),
      description: const Text(
        'user@example.com',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: SDGAAvatar(
        type: SDGAAvatarType.initials,
        initials: 'OG',
        size: SDGAAvatarSizes.small,
      ),
      trailing: const SDGATag.status(
        label: Text('Status'),
        size: SDGATagSize.extraSmall,
        status: SDGATagStatus.warning,
        style: SDGATagStyle.subtle,
      ),
      onClosePressed: (context) {
        Scaffold.of(context).closeDrawer();
      },
    );
  }

  SDGADrawerItem _getExpandable({
    required String label,
    required IconData icon,
    required List<SDGADrawerSubItem> pages,
  }) =>
      SDGADrawerItem.expandable(
        initiallyExpanded: true,
        label: label,
        leading: widget.options.showIcons ? SDGAIcon(icon) : null,
        items: pages,
      );

  SDGADrawerSubItem _getSubItem(_Pages page) => SDGADrawerSubItem(
        label: page.text,
        selected: widget.currentPage == page,
        trailing: page == _Pages.tags
            ? const SDGATag(
                label: Text('+99'),
                size: SDGATagSize.extraSmall,
                color: SDGATagColor.neutral,
                rounded: true,
              )
            : null,
        onTap: page.done ? () => widget.onPageSelected(context, page) : null,
      );
}
