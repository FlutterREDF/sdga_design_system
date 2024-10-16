import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';
import 'package:sdga_icons/sdga_icons.dart';

enum _SDGACardType {
  normal('Default'),
  expandable('Expandable'),
  selectable('Selectable');

  final String text;

  const _SDGACardType(this.text);
}

class CardsPage extends BaseComponentsPage {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends BaseComponentsPageState<CardsPage> {
  _SDGACardType _type = _SDGACardType.normal;
  SDGACardEffect _effect = SDGACardEffect.shadow;
  bool _showIcon = false;
  bool _showTitle = true;
  bool _showDescription = true;
  bool _showImage = false;
  bool _showCustomChild = false;
  bool _showPrimaryButton = true;
  bool _showSecondaryButton = true;
  bool _selected = false;
  bool _expanded = false;
  bool _disabled = false;

  @override
  Key? get contentKey => ValueKey(_type);

  @override
  bool get wrapWithFill => false;

  @override
  Widget buildContent() {
    Widget? title = _showTitle ? const Text('Card Title') : null;
    Widget? description = _showDescription
        ? const Text('Some description about this card')
        : null;
    Widget? image =
        _showImage ? Image.asset('assets/flag.jpeg', fit: BoxFit.cover) : null;
    Widget? icon = _showIcon
        ? const SDGAFeaturedIcon(
            icon: SDGAIcon(SDGAIconsStroke.checkmarkCircle02),
            circular: true,
            size: SDGAFeaturedIconSizes.large,
            color: SDGAWidgetColor.success,
            style: SDGAFeaturedIconStyle.light,
          )
        : null;
    Widget? child = _showCustomChild || _type == _SDGACardType.expandable
        ? Column(
            children: [
              SizedBox(
                height: 24,
                child: ListView.separated(
                  padding: const EdgeInsetsDirectional.only(
                    start: SDGANumbers.spacingXL,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => SDGATag(
                    size: SDGATagSize.small,
                    label: Text('Label $index'),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: SDGANumbers.spacingMD),
                ),
              ),
              const SizedBox(height: SDGANumbers.spacing3XL),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDGANumbers.spacingXL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SDGARatingBar(
                      size: SDGAWidgetSize.small,
                      useBrandColors: false,
                      value: 3.5,
                    ),
                    const SizedBox(height: SDGANumbers.spacingXS),
                    Text(
                      '12 reviews',
                      style: SDGATextStyles.textExtraSmallRegular.copyWith(
                        color: SDGAColorScheme.of(context)
                            .links
                            .iconNeutralVisited,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : null;
    Widget result;
    switch (_type) {
      case _SDGACardType.normal:
        result = SDGACard(
          effect: _effect,
          icon: icon,
          image: image,
          title: title,
          enabled: !_disabled,
          description: description,
          padChildHorizontally: false,
          primaryAction: _showPrimaryButton
              ? SDGAButton(
                  style: SDGAButtonStyle.primaryBrand,
                  size: SDGAWidgetSize.large,
                  onPressed: () {},
                  child: const Text('Action'),
                )
              : null,
          secondaryAction: _showSecondaryButton
              ? SDGAButton(
                  style: SDGAButtonStyle.secondaryOutline,
                  size: SDGAWidgetSize.large,
                  onPressed: () {},
                  child: const Text('Action'),
                )
              : null,
          child: child,
        );
      case _SDGACardType.expandable:
        result = SDGACard.expandable(
          effect: _effect,
          icon: icon,
          image: image,
          title: title,
          description: description,
          padChildHorizontally: false,
          padExpandedChildHorizontally: false,
          expandedChild: child!,
          isExpanded: _expanded,
          onExpandedChanged:
              _disabled ? null : (value) => setState(() => _expanded = value),
        );

      case _SDGACardType.selectable:
        result = SDGACard.selectable(
          focusNode: focusNode,
          effect: _effect,
          icon: icon,
          image: image,
          title: title,
          description: description,
          padChildHorizontally: false,
          isSelected: _selected,
          onSelectionChanged:
              _disabled ? null : (value) => setState(() => _selected = value),
          child: child,
        );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(SDGANumbers.spacingXL),
        child: result,
      ),
    );
  }

  @override
  List<Widget> buildProperties() {
    return [
      _buildTypeProperty(),
      _buildEffectProperty(),
      if (_type == _SDGACardType.selectable) ...[
        buildFocusProperty(),
      ],
      _buildDisabledProperty(),
      _buildShowImageProperty(),
      _buildShowIconProperty(),
      _buildShowTitleProperty(),
      _buildShowDescriptionProperty(),
      if (_type == _SDGACardType.normal) ...[
        _buildShowChildProperty(),
        _buildShowPrimaryButtonProperty(),
        _buildShowSecondaryButtonProperty(),
      ],
      if (_type == _SDGACardType.selectable) ...[
        _buildShowChildProperty(),
        _buildSelectedProperty(),
      ],
      if (_type == _SDGACardType.expandable) ...[
        _buildExpandedProperty(),
      ],
    ];
  }

  Widget _buildTypeProperty() {
    return buildSelectionProperty(
      title: 'Type',
      value: _type.text,
      values: _SDGACardType.values,
      getText: (item) => item.text,
      onSelected: (item) => setState(() => _type = item),
    );
  }

  Widget _buildEffectProperty() {
    return buildSelectionProperty(
      title: 'Effect',
      value: _effect.name,
      values: SDGACardEffect.values,
      getText: (item) => item.name,
      onSelected: (item) => setState(() => _effect = item),
    );
  }

  Widget _buildDisabledProperty() {
    return SDGASwitchListTile(
      value: _disabled,
      title: const Text('Disabled'),
      onChanged: (value) => setState(() => _disabled = value),
    );
  }

  Widget _buildShowImageProperty() {
    return SDGASwitchListTile(
      value: _showImage,
      title: const Text('Show Image'),
      onChanged: (value) => setState(() => _showImage = value),
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

  Widget _buildShowDescriptionProperty() {
    return SDGASwitchListTile(
      value: _showDescription,
      title: const Text('Show Description'),
      onChanged: (value) => setState(() => _showDescription = value),
    );
  }

  Widget _buildShowChildProperty() {
    return SDGASwitchListTile(
      value: _showCustomChild,
      title: const Text('Show Custom Content'),
      onChanged: (value) => setState(() => _showCustomChild = value),
    );
  }

  Widget _buildShowPrimaryButtonProperty() {
    return SDGASwitchListTile(
      value: _showPrimaryButton,
      title: const Text('Show Primary Button'),
      onChanged: (value) => setState(() => _showPrimaryButton = value),
    );
  }

  Widget _buildShowSecondaryButtonProperty() {
    return SDGASwitchListTile(
      value: _showSecondaryButton,
      title: const Text('Show Secondary Button'),
      onChanged: (value) => setState(() => _showSecondaryButton = value),
    );
  }

  Widget _buildSelectedProperty() {
    return SDGASwitchListTile(
      value: _selected,
      title: const Text('Selected'),
      onChanged: (value) => setState(() => _selected = value),
    );
  }

  Widget _buildExpandedProperty() {
    return SDGASwitchListTile(
      value: _expanded,
      title: const Text('Expanded'),
      onChanged: (value) => setState(() => _expanded = value),
    );
  }
}
