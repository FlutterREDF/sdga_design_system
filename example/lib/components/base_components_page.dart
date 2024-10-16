import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

import 'split_view.dart';

class BaseComponentsPage extends StatefulWidget {
  const BaseComponentsPage({super.key});

  @override
  State<BaseComponentsPage> createState() => BaseComponentsPageState();
}

class BaseComponentsPageState<T extends BaseComponentsPage> extends State<T> {
  final FocusNode focusNode = FocusNode();

  List<Widget> buildProperties() => throw Exception('Not implemented');

  Widget buildContent() => throw Exception('Not implemented');

  Color? get backgroundColor => null;

  Key? get contentKey => null;

  bool get wrapWithFill => true;

  bool get noProperties => false;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void focus() {
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = CustomScrollView(
      slivers: [
        if (wrapWithFill)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: backgroundColor,
              child: Center(
                key: contentKey,
                child: buildContent(),
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Container(
              color: backgroundColor,
              child: Center(
                key: contentKey,
                child: buildContent(),
              ),
            ),
          ),
      ],
    );

    if (noProperties) {
      return child;
    }
    return SplitView(
      gripColor: SDGAColorScheme.of(context).buttons.backgroundNeutralDefault,
      gripColorActive:
          SDGAColorScheme.of(context).buttons.backgroundNeutralPressed,
      gripSize: 14,
      indicator: Transform.translate(
        offset: const Offset(0, -9),
        child: const Icon(Icons.more_horiz, size: 32),
      ),
      children: [
        child,
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDGANumbers.spacingLG,
                vertical: SDGANumbers.spacingMD,
              ),
              sliver: SliverList.list(
                children: buildProperties(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<K?> showPicker<K>({
    required String title,
    required List<K> values,
    required String Function(K item) getText,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: SDGAColorScheme.of(context).backgrounds.body,
          title: Text(title),
          children: values
              .map(
                (value) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, value);
                  },
                  child: Text(getText(value)),
                ),
              )
              .toList(),
        );
      },
    );
    return result;
  }

  Widget buildFocusProperty() {
    return SDGAListTile(
      title: const Text("Request Focus"),
      onTap: focus,
    );
  }

  Widget buildSelectionProperty<K>({
    required String title,
    required String value,
    required List<K> values,
    required String Function(K item) getText,
    required void Function(K item) onSelected,
  }) {
    return SDGAListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const SDGAIcon(SDGAIconsStroke.arrowDown01),
      onTap: () async {
        final result = await showPicker(
          title: 'Select $title',
          values: values,
          getText: getText,
        );
        if (mounted && result != null) {
          onSelected(result);
        }
      },
    );
  }
}
