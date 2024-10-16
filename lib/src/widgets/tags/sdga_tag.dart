import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

part 'sdga_tag_enums.dart';

class SDGATag extends StatelessWidget {
  final SDGATagColor color;
  final SDGATagSize size;
  final SDGATagStatus status;
  final SDGATagStyle style;
  final _SDGATagType _type;
  final bool outline;
  final bool rounded;
  final Widget? label;
  final Widget? icon;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const SDGATag({
    super.key,
    this.color = SDGATagColor.neutral,
    this.size = SDGATagSize.medium,
    this.outline = false,
    this.rounded = false,
    required Widget this.label,
    this.leadingIcon,
    this.trailingIcon,
  })  : _type = _SDGATagType.tag,
        status = SDGATagStatus.neutral,
        style = SDGATagStyle.inverted,
        icon = null;

  const SDGATag.icon({
    super.key,
    this.color = SDGATagColor.neutral,
    this.size = SDGATagSize.medium,
    this.outline = false,
    this.rounded = false,
    required Widget this.icon,
  })  : _type = _SDGATagType.icon,
        status = SDGATagStatus.neutral,
        style = SDGATagStyle.inverted,
        label = null,
        leadingIcon = null,
        trailingIcon = null;

  const SDGATag.status({
    super.key,
    this.status = SDGATagStatus.neutral,
    this.size = SDGATagSize.medium,
    this.style = SDGATagStyle.inverted,
    required Widget this.label,
  })  : _type = _SDGATagType.status,
        color = SDGATagColor.neutral,
        outline = false,
        rounded = false,
        icon = null,
        leadingIcon = null,
        trailingIcon = null;

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final vertical = size == SDGATagSize.medium ? 4.0 : 3.0;
    final horizontal = size == SDGATagSize.medium ? 12.0 : 8.0;
    final iconPadding = size == SDGATagSize.medium ? 7.0 : 5.0;
    final borderColor = _getBorderColor(colors);
    BoxBorder? border;
    if (borderColor != null) {
      border = Border.all(color: borderColor);
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _type == _SDGATagType.icon ? iconPadding : vertical,
        horizontal: _type == _SDGATagType.icon ? iconPadding : horizontal,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(colors),
        borderRadius: BorderRadius.all(
          Radius.circular(
            rounded || _type == _SDGATagType.status
                ? SDGANumbers.radiusFull
                : SDGANumbers.radiusSmall,
          ),
        ),
        border: border,
      ),
      child: _buildThemeOverrides(context, child: _buildContent(colors)),
    );
  }

  Widget _buildThemeOverrides(BuildContext context, {required Widget child}) {
    final color = _getTextColor(SDGAColorScheme.of(context));
    return DefaultTextStyle(
      style: _style.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: _iconSize,
          color: color,
        ),
        child: child,
      ),
    );
  }

  Widget _buildDot(SDGAColorScheme colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getDotColor(colors),
        borderRadius: const BorderRadius.all(
          Radius.circular(SDGAConstants.radius9999),
        ),
      ),
      child: const SizedBox.square(dimension: 10),
    );
  }

  Widget _buildContent(SDGAColorScheme colors) {
    final child = label;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          if (trailingIcon != null || child != null || icon != null)
            const SizedBox(width: SDGANumbers.spacingMD),
        ],
        if (icon != null) ...[
          icon!,
          if (trailingIcon != null || child != null)
            const SizedBox(width: SDGANumbers.spacingMD),
        ],
        if (_type == _SDGATagType.status) ...[
          _buildDot(colors),
          const SizedBox(width: SDGANumbers.spacingMD),
        ],
        if (child != null) child,
        if (trailingIcon != null) ...[
          if (child != null) const SizedBox(width: SDGANumbers.spacingMD),
          trailingIcon!,
        ],
      ],
    );
  }

  Color? _getBackgroundColor(SDGAColorScheme colors) {
    if (_type == _SDGATagType.status) {
      if (style == SDGATagStyle.ghost) return null;
      final inverted = style == SDGATagStyle.inverted;
      switch (status) {
        case SDGATagStatus.neutral:
          return inverted
              ? colors.tags.backgroundNeutral
              : colors.tags.backgroundNeutralLight;
        case SDGATagStatus.error:
          return inverted
              ? colors.tags.backgroundError
              : colors.tags.backgroundErrorLight;
        case SDGATagStatus.success:
          return inverted
              ? colors.tags.backgroundSuccess
              : colors.tags.backgroundSuccessLight;
        case SDGATagStatus.warning:
          return inverted
              ? colors.tags.backgroundWarning
              : colors.tags.backgroundWarningLight;
        case SDGATagStatus.info:
          return inverted
              ? colors.tags.backgroundInfo
              : colors.tags.backgroundInfoLight;
      }
    } else {
      if (outline) return null;
      switch (color) {
        case SDGATagColor.neutral:
          return colors.tags.backgroundNeutralLight;
        case SDGATagColor.success:
          return colors.tags.backgroundSuccessLight;
        case SDGATagColor.error:
          return colors.tags.backgroundErrorLight;
        case SDGATagColor.warning:
          return colors.tags.backgroundWarningLight;
        case SDGATagColor.info:
          return colors.tags.backgroundInfoLight;
        case SDGATagColor.onColor:
          return colors.tags.backgroundOnColor;
      }
    }
  }

  Color _getDotColor(SDGAColorScheme colors) {
    if (style == SDGATagStyle.inverted) return colors.tags.dot;
    switch (status) {
      case SDGATagStatus.neutral:
        return colors.tags.backgroundNeutral;
      case SDGATagStatus.error:
        return colors.tags.iconError;
      case SDGATagStatus.success:
        return colors.tags.iconSuccess;
      case SDGATagStatus.warning:
        return colors.tags.iconWarning;
      case SDGATagStatus.info:
        return colors.tags.iconInfo;
    }
  }

  Color? _getBorderColor(SDGAColorScheme colors) {
    if (_type == _SDGATagType.status) return null;
    switch (color) {
      case SDGATagColor.neutral:
        return outline
            ? colors.tags.borderNeutral
            : colors.borders.neutralSecondary;
      case SDGATagColor.success:
        return outline
            ? colors.tags.borderSuccess
            : colors.tags.borderSuccessLight;
      case SDGATagColor.error:
        return outline ? colors.tags.borderError : colors.tags.borderErrorLight;
      case SDGATagColor.warning:
        return outline
            ? colors.tags.borderWarning
            : colors.tags.borderWarningLight;
      case SDGATagColor.info:
        return outline ? colors.tags.borderInfo : colors.tags.borderInfoLight;
      case SDGATagColor.onColor:
        return outline ? colors.tags.borderOnColor : null;
    }
  }

  Color? _getTextColor(SDGAColorScheme colors) {
    if (_type == _SDGATagType.status) {
      if (style == SDGATagStyle.inverted) {
        return colors.texts.onColorPrimary;
      } else if (style == SDGATagStyle.ghost) {
        return colors.tags.textNeutral;
      } else {
        switch (status) {
          case SDGATagStatus.neutral:
            return colors.tags.textNeutral;
          case SDGATagStatus.error:
            return colors.tags.textError;
          case SDGATagStatus.success:
            return colors.tags.textSuccess;
          case SDGATagStatus.warning:
            return colors.tags.textWarning;
          case SDGATagStatus.info:
            return colors.tags.textInfo;
        }
      }
    } else {
      switch (color) {
        case SDGATagColor.neutral:
          return colors.tags.textNeutral;
        case SDGATagColor.success:
          return colors.tags.textSuccess;
        case SDGATagColor.error:
          return colors.tags.textError;
        case SDGATagColor.warning:
          return colors.tags.textWarning;
        case SDGATagColor.info:
          return colors.tags.textInfo;
        case SDGATagColor.onColor:
          return colors.texts.onColorPrimary;
      }
    }
  }

  TextStyle get _style {
    switch (size) {
      case SDGATagSize.medium:
        return SDGATextStyles.textMediumMedium;
      case SDGATagSize.small:
        return SDGATextStyles.textExtraSmallMedium;
      case SDGATagSize.extraSmall:
        return SDGATextStyles.textExtraExtraSmallSemiBold;
    }
  }

  double get _iconSize {
    switch (size) {
      case SDGATagSize.medium:
        return 18;
      case SDGATagSize.small:
        return 14;
      case SDGATagSize.extraSmall:
        return 10;
    }
  }
}
