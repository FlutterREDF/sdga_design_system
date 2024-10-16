import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sdga_design_system/src/src.dart';

// The default duration for hint fade in/out transitions.
const Duration _kHintFadeTransitionDuration = Duration(milliseconds: 20);
const Duration _kTransitionDuration = Duration(milliseconds: 150);
const Curve _kTransitionCurve = Curves.fastOutSlowIn;
const EdgeInsets _contentPadding =
    EdgeInsets.symmetric(horizontal: SDGANumbers.spacingXL);
const double _iconSize = 20.0;
const double _gap = SDGANumbers.spacingMD;
const double _minInputHeight = 40.0 - _gap * 2;

typedef _ChildBaselineGetter = double Function(
    RenderBox child, BoxConstraints constraints);

// Identifies the children of a _RenderDecorationElement.
enum _DecorationSlot {
  input,
  label,
  hint,
  prefix,
  suffix,
  prefixIcon,
  suffixIcon,
  helperError,
  counter,
  container,
}

/// Defines the visual style variants for the input decoration.
enum SDGAInputDecorationStyle {
  /// The default style of the filled input with a standard background and stroke.
  filledDefault,

  /// A lighter style of the filled input with no stroke and a light background.
  filledLighter,

  /// A darker style of the filled input with no stroke and a darker background.
  filledDarker,
}

/// The labels, icons, and styles used to an input field.
///
/// The [SDGATextField] and [SDGAInputDecorator] classes use [SDGAInputDecoration] objects
/// to describe their decoration. (In fact, this class is merely the
/// configuration of an [SDGAInputDecorator], which does all the heavy lifting.)
///
/// See also:
///
///  * [SDGATextField], which is a text input widget that uses an
///    [SDGAInputDecoration].
///  * [SDGAInputDecorator], which is a widget that draws an [SDGAInputDecoration]
///    around an input child widget.
@immutable
class SDGAInputDecoration {
  /// Creates a bundle of the labels, icons, and styles used to
  /// decorate an input field.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// Similarly, only one of [suffix] and [suffixText] can be specified.
  const SDGAInputDecoration({
    this.style = SDGAInputDecorationStyle.filledDefault,
    this.label,
    this.labelText,
    this.helper,
    this.helperText,
    this.helperMaxLines,
    this.hintText,
    this.hintTextDirection,
    this.hintMaxLines,
    this.hintFadeDuration,
    this.error,
    this.errorText,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefix,
    this.prefixText,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.counter,
    this.counterText,
    this.enabled = true,
    this.semanticCounterText,
  })  : assert(!(label != null && labelText != null),
            'Declaring both label and labelText is not supported.'),
        assert(!(helper != null && helperText != null),
            'Declaring both helper and helperText is not supported.'),
        assert(!(prefix != null && prefixText != null),
            'Declaring both prefix and prefixText is not supported.'),
        assert(!(suffix != null && suffixText != null),
            'Declaring both suffix and suffixText is not supported.'),
        assert(!(error != null && errorText != null),
            'Declaring both error and errorText is not supported.');

  /// Defines the visual style variant for the input decoration.
  final SDGAInputDecorationStyle style;

  /// Optional widget that describes the input field.
  ///
  /// Typically a [SDGALabel] widget.
  ///
  /// {@macro sdga.text_style}
  ///
  /// Only one of [label] and [labelText] can be specified.
  final Widget? label;

  /// Optional text that describes the input field.
  ///
  /// If a more elaborate label is required, consider using [label] instead.
  /// Only one of [label] and [labelText] can be specified.
  final String? labelText;

  /// Optional widget that appears below the [SDGAInputDecorator.child].
  ///
  /// Preferably a [SDGAInputHelper] widget.
  ///
  /// If non-null, the [helper] is displayed below the [SDGAInputDecorator.child], in
  /// the same location as [error]. If a non-null [error] or [errorText] value is
  /// specified then the [helper] is not shown.
  ///
  /// Only one of [helper] and [helperText] can be specified.
  final Widget? helper;

  /// Text that provides context about the [SDGAInputDecorator.child]'s value, such
  /// as how the value will be used.
  ///
  /// If non-null, the text is displayed below the [SDGAInputDecorator.child], in
  /// the same location as [errorText]. If a non-null [errorText] value is
  /// specified then the helper text is not shown.
  ///
  /// If a more elaborate helper text is required, consider using [helper] instead.
  ///
  /// Only one of [helper] and [helperText] can be specified.
  final String? helperText;

  /// The maximum number of lines the [helperText] can occupy.
  ///
  /// Defaults to null, which means that the [helperText] is not limited.
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the helper.
  ///
  /// See also:
  ///
  ///  * [errorMaxLines], the equivalent but for the [errorText].
  final int? helperMaxLines;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [SDGAInputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [SDGAInputDecorator.child])
  /// when the input [isEmpty].
  final String? hintText;

  /// The direction to use for the [hintText].
  ///
  /// If null, defaults to a value derived from [Directionality] for the
  /// input field and the current context.
  final TextDirection? hintTextDirection;

  /// The maximum number of lines the [hintText] can occupy.
  ///
  /// Defaults to the value of [TextField.maxLines] attribute.
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the hint text. [TextOverflow.ellipsis] is
  /// used to handle the overflow when it is limited to single line.
  final int? hintMaxLines;

  /// The duration of the [hintText] fade in and fade out animations.
  ///
  /// If null, defaults to 20ms.
  final Duration? hintFadeDuration;

  /// Optional widget that appears below the [SDGAInputDecorator.child] and the border.
  ///
  /// Preferably a [SDGAInputHelper] widget.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is not shown.
  ///
  /// Only one of [error] and [errorText] can be specified.
  final Widget? error;

  /// Text that appears below the [SDGAInputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is
  /// not shown.
  ///
  /// In a [SDGATextFormField], this is overridden by the value returned from
  /// [SDGATextFormField.validator], if that is not null.
  ///
  /// If a more elaborate error is required, consider using [error] instead.
  ///
  /// Only one of [error] and [errorText] can be specified.
  final String? errorText;

  /// The maximum number of lines the [errorText] can occupy.
  ///
  /// Defaults to null, which means that the [errorText] is not limited.
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the error.
  ///
  /// See also:
  ///
  ///  * [helperMaxLines], the equivalent but for the [helperText].
  final int? errorMaxLines;

  /// An icon that appears after the [prefix] or [prefixText] and before
  /// the editable part of the text field, within the decoration's container.
  ///
  /// The size and color of the prefix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The prefix icon alignment can be changed using [Align] with a fixed `widthFactor` and
  /// `heightFactor`.
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [prefix] and [prefixText], which are other ways to show content
  ///    before the text field (but after the icon).
  ///  * [suffixIcon], which is the same but on the trailing edge.
  ///  * [Align] A widget that aligns its child within itself and optionally
  ///    sizes itself based on the child's size.
  final Widget? prefixIcon;

  /// Optional widget to place on the start of the decoration's container.
  ///
  /// Preferably a [SDGAInputAffix] widget.
  ///
  /// This can be used, for example, to add some padding to text that would
  /// otherwise be specified using [prefixText], or to add a custom widget in
  /// front of the input.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefix] appears before the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffix], the equivalent but on the trailing edge.
  final Widget? prefix;

  /// Optional text prefix to place on the start of the decoration's container.
  ///
  /// This text is passed to a [SDGAInputAffix.text] widget.
  ///
  /// If a more elaborate prefix is required, consider using [prefix] instead.
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefixText] appears before the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffixText], the equivalent but on the trailing edge.
  final String? prefixText;

  /// An icon that appears after the editable part of the text field and
  /// before the [suffix] or [suffixText], within the decoration's container.
  ///
  /// The size and color of the suffix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The suffix icon alignment can be changed using [Align] with a fixed `widthFactor` and
  /// `heightFactor`.
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [suffix] and [suffixText], which are other ways to show content
  ///    after the text field (but before the icon).
  ///  * [prefixIcon], which is the same but on the leading edge.
  ///  * [Align] A widget that aligns its child within itself and optionally
  ///    sizes itself based on the child's size.
  final Widget? suffixIcon;

  /// Optional widget to place on the end of the decoration's container.
  ///
  /// Preferably a [SDGAInputAffix] widget.
  ///
  /// This can be used, for example, to add some padding to the text that would
  /// otherwise be specified using [suffixText], or to add a custom widget after
  /// the input.
  ///
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffix] appears after the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefix], the equivalent but on the leading edge.
  final Widget? suffix;

  /// Optional text suffix to place on the end of the decoration's container.
  ///
  /// This text is passed to a [SDGAInputAffix.text] widget.
  ///
  /// If a more elaborate suffix is required, consider using [suffix] instead.
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffixText] appears after the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefixText], the equivalent but on the leading edge.
  final String? suffixText;

  /// Optional text to place below the line as a character count.
  ///
  /// The semantic label can be replaced by providing a [semanticCounterText].
  ///
  /// If null or an empty string and [counter] isn't specified, then nothing
  /// will appear in the counter's location.
  final String? counterText;

  /// Optional custom counter widget to go in the place otherwise occupied by
  /// [counterText]. If this property is non null, then [counterText] is
  /// ignored.
  final Widget? counter;

  /// Whether the input is enabled or not.
  ///
  /// This property is true by default.
  final bool enabled;

  /// A semantic label for the [counterText].
  ///
  /// Defaults to null.
  ///
  /// If provided, this replaces the semantic label of the [counterText].
  final String? semanticCounterText;

  /// Creates a copy of this input decoration with the given fields replaced
  /// by the new values.
  SDGAInputDecoration copyWith({
    SDGAInputDecorationStyle? style,
    Widget? label,
    String? labelText,
    Widget? helper,
    String? helperText,
    int? helperMaxLines,
    String? hintText,
    TextDirection? hintTextDirection,
    Duration? hintFadeDuration,
    int? hintMaxLines,
    Widget? error,
    String? errorText,
    int? errorMaxLines,
    Widget? prefixIcon,
    Widget? prefix,
    String? prefixText,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    Widget? counter,
    String? counterText,
    bool? enabled,
    String? semanticCounterText,
  }) {
    return SDGAInputDecoration(
      style: style ?? this.style,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      helper: helper ?? this.helper,
      helperText: helperText ?? this.helperText,
      helperMaxLines: helperMaxLines ?? this.helperMaxLines,
      hintText: hintText ?? this.hintText,
      hintTextDirection: hintTextDirection ?? this.hintTextDirection,
      hintMaxLines: hintMaxLines ?? this.hintMaxLines,
      hintFadeDuration: hintFadeDuration ?? this.hintFadeDuration,
      error: error ?? this.error,
      errorText: errorText ?? this.errorText,
      errorMaxLines: errorMaxLines ?? this.errorMaxLines,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefix: prefix ?? this.prefix,
      prefixText: prefixText ?? this.prefixText,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      suffix: suffix ?? this.suffix,
      suffixText: suffixText ?? this.suffixText,
      counter: counter ?? this.counter,
      counterText: counterText ?? this.counterText,
      enabled: enabled ?? this.enabled,
      semanticCounterText: semanticCounterText ?? this.semanticCounterText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SDGAInputDecoration &&
        other.style == style &&
        other.label == label &&
        other.labelText == labelText &&
        other.helper == helper &&
        other.helperText == helperText &&
        other.helperMaxLines == helperMaxLines &&
        other.hintText == hintText &&
        other.hintTextDirection == hintTextDirection &&
        other.hintMaxLines == hintMaxLines &&
        other.hintFadeDuration == hintFadeDuration &&
        other.error == error &&
        other.errorText == errorText &&
        other.errorMaxLines == errorMaxLines &&
        other.prefixIcon == prefixIcon &&
        other.prefix == prefix &&
        other.prefixText == prefixText &&
        other.suffixIcon == suffixIcon &&
        other.suffix == suffix &&
        other.suffixText == suffixText &&
        other.counter == counter &&
        other.counterText == counterText &&
        other.enabled == enabled &&
        other.semanticCounterText == semanticCounterText;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      style,
      label,
      labelText,
      helper,
      helperText,
      helperMaxLines,
      hintText,
      hintTextDirection,
      hintMaxLines,
      hintFadeDuration,
      error,
      errorText,
      errorMaxLines,
      prefixIcon,
      prefix,
      prefixText,
      suffixIcon,
      suffix,
      suffixText,
      counter,
      counterText,
      enabled,
      semanticCounterText,
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() {
    final List<String> description = <String>[
      'style: $style',
      if (label != null) 'label: $label',
      if (labelText != null) 'labelText: "$labelText"',
      if (helper != null) 'helper: "$helper"',
      if (helperText != null) 'helperText: "$helperText"',
      if (helperMaxLines != null) 'helperMaxLines: "$helperMaxLines"',
      if (hintText != null) 'hintText: "$hintText"',
      if (hintMaxLines != null) 'hintMaxLines: "$hintMaxLines"',
      if (hintFadeDuration != null) 'hintFadeDuration: "$hintFadeDuration"',
      if (error != null) 'error: "$error"',
      if (errorText != null) 'errorText: "$errorText"',
      if (errorMaxLines != null) 'errorMaxLines: "$errorMaxLines"',
      if (prefixIcon != null) 'prefixIcon: $prefixIcon',
      if (prefix != null) 'prefix: $prefix',
      if (prefixText != null) 'prefixText: $prefixText',
      if (suffixIcon != null) 'suffixIcon: $suffixIcon',
      if (suffix != null) 'suffix: $suffix',
      if (suffixText != null) 'suffixText: $suffixText',
      if (counter != null) 'counter: $counter',
      if (counterText != null) 'counterText: $counterText',
      if (!enabled) 'enabled: false',
      if (semanticCounterText != null)
        'semanticCounterText: $semanticCounterText',
    ];
    return 'InputDecoration(${description.join(', ')})';
  }
}

class SDGAInputDecoratorWrapper extends InheritedWidget {
  const SDGAInputDecoratorWrapper({
    super.key,
    required super.child,
    required this.disabled,
    required this.error,
    this.maxLines,
  });

  final bool disabled;
  final bool error;
  final int? maxLines;

  @override
  bool updateShouldNotify(covariant SDGAInputDecoratorWrapper oldWidget) {
    return disabled != oldWidget.disabled ||
        error != oldWidget.error ||
        maxLines != oldWidget.maxLines;
  }

  static SDGAInputDecoratorWrapper of(BuildContext context) =>
      maybeOf(context)!;

  static SDGAInputDecoratorWrapper? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SDGAInputDecoratorWrapper>();
}

/// Defines the appearance of an input field.
///
/// [SDGAInputDecorator] displays the visual elements of a text field
/// around its input [child]. The visual elements themselves are defined
/// by an [SDGAInputDecoration] object and their layout and appearance depend
/// on the based parameters.
///
/// [SDGATextField] uses this widget to decorate its [EditableText] child.
///
/// [SDGAInputDecorator] can be used to create widgets that look and behave like a
/// [SDGATextField] but support other kinds of input.
///
/// See also:
///
///  * [SDGATextField], which uses an [SDGAInputDecorator] to display a border,
///    labels, and icons, around its [EditableText] child.
class SDGAInputDecorator extends StatefulWidget {
  /// Creates a widget that displays a border, labels, and icons,
  /// for an input field.
  const SDGAInputDecorator({
    super.key,
    required this.decoration,
    this.textAlign,
    this.textAlignVertical,
    this.isFocused = false,
    this.isHovering = false,
    this.expands = false,
    this.isEmpty = false,
    this.statesController,
    this.child,
    this.container,
  });

  /// The text and styles to use when decorating the child.
  final SDGAInputDecoration decoration;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign? textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;

  /// Whether the input field has focus.
  ///
  /// Defaults to false.
  final bool isFocused;

  /// Whether the input field is being hovered over by a mouse pointer.
  ///
  /// Defaults to false.
  final bool isHovering;

  /// If true, the height of the input field will be as large as possible.
  ///
  /// If wrapped in a widget that constrains its child's height, like Expanded
  /// or SizedBox, the input field will only be affected if [expands] is set to
  /// true.
  ///
  /// See [SDGATextField.minLines] and [SDGATextField.maxLines] for related ways to
  /// affect the height of an input. When [expands] is true, both must be null
  /// in order to avoid ambiguity in determining the height.
  ///
  /// Defaults to false.
  final bool expands;

  /// Whether the input field is empty.
  ///
  /// Determines whether to display the hint text.
  ///
  /// Defaults to false.
  final bool isEmpty;

  // TODO
  // /// The [ScrollController] to use when vertically scrolling the input.
  // ///
  // /// This is used to customize the position of the scrollbar. It's preferred
  // /// to hide the scrollbar using [ScrollBehavior.scrollbars] in the [child] widget
  // ///
  // /// If this is not null, we will use it draw a scrollbar before the suffix
  // final ScrollController? scrollController;

  /// The widget below this widget in the tree.
  ///
  /// Typically an [EditableText] or [InkWell].
  final Widget? child;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// The widget to be placed as a container for the input that goes behind
  /// [child] and other widgets, and between the [SDGAInputDecoration.label] and
  /// [SDGAInputDecoration.helper] widgets
  final Widget? container;

  @override
  State<SDGAInputDecorator> createState() => _SDGAInputDecoratorState();
}

class _SDGAInputDecoratorState extends State<SDGAInputDecorator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakingLabelController;
  static const SemanticsTag _kPrefixSemanticsTag =
      SemanticsTag('_SDGAInputDecoratorState.prefix');
  static const SemanticsTag _kSuffixSemanticsTag =
      SemanticsTag('_SDGAInputDecoratorState.suffix');

  bool _isPressed = false;
  TextAlign? get _textAlign => widget.textAlign;
  bool get _isFocused => widget.isFocused;
  bool get _isEnabled => widget.decoration.enabled;
  bool get _hasError =>
      widget.decoration.errorText != null || widget.decoration.error != null;
  bool get _isHovering => widget.isHovering && widget.decoration.enabled;
  bool get _isEmpty => widget.isEmpty;

  Set<WidgetState> get _widgetState {
    return <WidgetState>{
      if (!_isEnabled) WidgetState.disabled,
      if (_isPressed && !_isFocused) WidgetState.pressed,
      if (_isFocused) WidgetState.focused,
      if (_isHovering) WidgetState.hovered,
      if (_hasError) WidgetState.error,
    };
  }

  @override
  void initState() {
    super.initState();
    _shakingLabelController = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakingLabelController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SDGAInputDecorator old) {
    super.didUpdateWidget(old);
    final String? errorText = widget.decoration.errorText;
    final String? oldErrorText = old.decoration.errorText;

    if (errorText != null && errorText != oldErrorText) {
      _shakingLabelController.forward(from: 0);
    }
  }

  void _handlePressed(bool pressed) {
    if (pressed != _isPressed) {
      setState(() {
        _isPressed = pressed;
      });
      widget.statesController?.update(WidgetState.pressed, _isPressed);
    }
  }

  Color? _getFillColor(SDGAColorScheme colors) {
    if (_widgetState.contains(WidgetState.disabled)) return null;
    final Color defaultColor;
    switch (widget.decoration.style) {
      case SDGAInputDecorationStyle.filledDefault:
        defaultColor = colors.forms.fieldBackgroundDefault;
        break;
      case SDGAInputDecorationStyle.filledLighter:
        defaultColor = colors.forms.fieldBackgroundLighter;
        break;
      case SDGAInputDecorationStyle.filledDarker:
        defaultColor = colors.forms.fieldBackgroundDarker;
        break;
    }
    return SDGAUtils.resolveWidgetStateUnordered(
      _widgetState,
      fallback: defaultColor,
      pressed: colors.forms.fieldBackgroundPressed,
      focused: colors.forms.fieldBackgroundDefault,
    );
  }

  Color _getIconColor(SDGAColorScheme colors) {
    return SDGAUtils.resolveWidgetStateUnordered(
      _widgetState,
      fallback: colors.icons.defaultColor,
      error: colors.globals.iconDefaultDisabled,
    );
  }

  TextStyle _getLabelStyle(SDGAColorScheme colors) {
    return SDGATextStyles.textMediumRegular.copyWith(
      height: 1,
      color: SDGAUtils.resolveWidgetStateUnordered(
        _widgetState,
        fallback: colors.forms.fieldTextLabel,
        disabled: colors.globals.textDefaultDisabled,
      ),
    );
  }

  TextStyle _getHintStyle(SDGAColorScheme colors) {
    return SDGATextStyles.textMediumRegular.copyWith(
      color: SDGAUtils.resolveWidgetStateUnordered(
        _widgetState,
        fallback: colors.forms.fieldTextPlaceholder,
        disabled: colors.globals.textDefaultDisabled,
      ),
    );
  }

  TextStyle _getCounterStyle(SDGAColorScheme colors) {
    return SDGATextStyles.textSmallRegular.copyWith(
      color: SDGAUtils.resolveWidgetStateUnordered(
        _widgetState,
        fallback: colors.texts.primaryParagraph,
        disabled: colors.globals.textDefaultDisabled,
      ),
    );
  }

  TextStyle _getAffixStyle(SDGAColorScheme colors) {
    return SDGATextStyles.textMediumRegular.copyWith(
      color: SDGAUtils.resolveWidgetStateUnordered(
        _widgetState,
        fallback: colors.texts.secondaryParagraph,
        disabled: colors.globals.textDefaultDisabled,
      ),
    );
  }

  Border? _getDefaultBorder(SDGAColorScheme colors) {
    if (widget.decoration.style != SDGAInputDecorationStyle.filledDefault &&
        _widgetState.isEmpty) {
      return null;
    }
    final Color color = _widgetState.contains(WidgetState.error)
        ? colors.forms.fieldBorderError
        : SDGAUtils.resolveWidgetStateUnordered(
            _widgetState,
            fallback: colors.forms.fieldBorderDefault,
            error: colors.forms.fieldBorderError,
            hovered: colors.forms.fieldBorderHovered,
            focused: colors.forms.fieldBorderPressed,
            pressed: colors.forms.fieldBorderPressed,
            disabled: colors.borders.disabled,
          );
    return Border.fromBorderSide(BorderSide(color: color));
  }

  @override
  Widget build(BuildContext context) {
    final SDGAColorScheme colors = SDGAColorScheme.of(context);
    final TextStyle affixStyle = _getAffixStyle(colors);
    final TextStyle labelStyle = _getLabelStyle(colors);
    final TextStyle hintStyle = _getHintStyle(colors);
    final TextBaseline textBaseline =
        labelStyle.textBaseline ?? TextBaseline.alphabetic;
    final SDGAInputDecoration decoration = widget.decoration;
    final Border? border = _getDefaultBorder(colors);

    Widget? input = widget.child;
    Widget? hint;
    Widget? label;
    Widget? prefix;
    Widget? suffix;
    Widget? prefixIcon;
    Widget? suffixIcon;
    Widget? counter;

    if (decoration.hintText != null) {
      hint = AnimatedOpacity(
        opacity: _isEmpty ? 1.0 : 0.0,
        duration: decoration.hintFadeDuration ?? _kHintFadeTransitionDuration,
        curve: _kTransitionCurve,
        child: Text(
          decoration.hintText!,
          style: hintStyle,
          textDirection: decoration.hintTextDirection,
          textAlign: _textAlign,
          maxLines: decoration.hintMaxLines,
          overflow:
              decoration.hintMaxLines == null ? null : TextOverflow.ellipsis,
        ),
      );
    }
    if (decoration.labelText != null || decoration.label != null) {
      label = SDGAInputDecoratorWrapper(
        disabled: _widgetState.contains(WidgetState.disabled),
        error: _widgetState.contains(WidgetState.error),
        child: _Shaker(
          animation: _shakingLabelController.view,
          child: AnimatedDefaultTextStyle(
            duration: _kTransitionDuration,
            curve: _kTransitionCurve,
            style: labelStyle,
            child: decoration.label ??
                Text(
                  decoration.labelText!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: _textAlign,
                ),
          ),
        ),
      );
    }
    if (decoration.prefix != null || decoration.prefixText != null) {
      prefix = SDGAInputAffixWrapper(
        isPrefix: true,
        disabled: _widgetState.contains(WidgetState.disabled),
        child: _AffixText(
          text: decoration.prefixText,
          style: affixStyle,
          semanticsTag: _kPrefixSemanticsTag,
          child: decoration.prefix,
        ),
      );
    }
    if (decoration.suffix != null || decoration.suffixText != null) {
      suffix = SDGAInputAffixWrapper(
        isPrefix: false,
        disabled: _widgetState.contains(WidgetState.disabled),
        child: _AffixText(
          text: decoration.suffixText,
          style: affixStyle,
          semanticsTag: _kSuffixSemanticsTag,
          child: decoration.suffix,
        ),
      );
    }
    if (decoration.prefixIcon != null) {
      prefixIcon = _buildIcon(decoration.prefixIcon!, colors);
    }
    if (decoration.suffixIcon != null) {
      suffixIcon = _buildIcon(decoration.suffixIcon!, colors);
    }

    if (decoration.counter != null) {
      counter = decoration.counter;
    } else if (decoration.counterText != null && decoration.counterText != '') {
      counter = Semantics(
        container: true,
        liveRegion: _isFocused,
        child: Text(
          decoration.counterText!,
          style: _getCounterStyle(colors),
          overflow: TextOverflow.ellipsis,
          semanticsLabel: decoration.semanticCounterText,
        ),
      );
    }

    final Widget helperError = _HelperError(
      disabled: _widgetState.contains(WidgetState.disabled),
      helper: decoration.helper,
      helperText: decoration.helperText,
      helperMaxLines: decoration.helperMaxLines,
      error: decoration.error,
      errorText: decoration.errorText,
      errorMaxLines: decoration.errorMaxLines,
    );

    final TextDirection textDirection = Directionality.of(context);

    Widget decorator = SDGAAnimatedWidget<_AnimatedDecoration?>(
      duration: _kTransitionDuration,
      lerp: _AnimatedDecoration.lerp,
      value: _AnimatedDecoration(
        border: border,
        bottomBorder: _isPressed ? 0.5 : (_isFocused ? 1 : 0),
      ),
      builder: (context, data, child) {
        return _Decorator(
          decoration: _Decoration(
            border: data?.border ?? border,
            fillColor: _getFillColor(colors),
            bottomBorder: data?.bottomBorder ?? 0,
            input: input,
            label: label,
            hint: hint,
            prefix: prefix,
            suffix: suffix,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            helperError: helperError,
            counter: counter,
            container: widget.container != null
                ? Listener(
                    onPointerDown: (_) => _handlePressed(true),
                    onPointerUp: (_) => _handlePressed(false),
                    child: widget.container,
                  )
                : null,
          ),
          textDirection: textDirection,
          textBaseline: textBaseline,
          textAlignVertical: widget.textAlignVertical,
          isFocused: _isFocused,
          expands: widget.expands,
        );
      },
    );

    if (widget.container == null) {
      decorator = Listener(
        onPointerDown: (_) => _handlePressed(true),
        onPointerUp: (_) => _handlePressed(false),
        child: decorator,
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minInputHeight),
      child: SDGAInputDecoratorWrapper(
        disabled: _widgetState.contains(WidgetState.disabled),
        error: _widgetState.contains(WidgetState.error),
        child: decorator,
      ),
    );
  }

  Widget _buildIcon(Widget icon, SDGAColorScheme colors) {
    return Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: IconTheme.merge(
          data: IconThemeData(
            color: _getIconColor(colors),
            size: _iconSize,
          ),
          child: Semantics(child: icon),
        ),
      ),
    );
  }
}

class _AffixText extends StatelessWidget {
  const _AffixText({
    this.text,
    this.style,
    this.child,
    required this.semanticsTag,
  });

  final String? text;
  final TextStyle? style;
  final Widget? child;
  final SemanticsTag semanticsTag;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      child: Semantics(
        tagForChildren: semanticsTag,
        child: child ?? (text == null ? null : SDGAInputAffix.text(text!)),
      ),
    );
  }
}

// Used to "shake" the label to the left and right
// when the errorText first appears.
class _Shaker extends AnimatedWidget {
  const _Shaker({
    required Animation<double> animation,
    this.child,
  }) : super(listenable: animation);

  final Widget? child;

  Animation<double> get animation => listenable as Animation<double>;

  double get translateX {
    const double shakeDelta = 4.0;
    final double t = animation.value;

    double result;
    if (t <= 0.25) {
      result = -t;
    } else if (t < 0.75) {
      result = t - 0.5;
    } else {
      result = (1.0 - t) * 4.0;
    }

    return shakeDelta * result;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}

// Display the helper and error text. When the error text appears
// it fades and the helper text fades out. The error text also
// slides upwards a little when it first appears.
class _HelperError extends StatefulWidget {
  const _HelperError({
    this.helper,
    this.helperText,
    this.helperMaxLines,
    this.error,
    this.errorText,
    this.errorMaxLines,
    this.disabled = false,
  });

  final Widget? helper;
  final String? helperText;
  final int? helperMaxLines;
  final Widget? error;
  final String? errorText;
  final int? errorMaxLines;
  final bool disabled;

  @override
  _HelperErrorState createState() => _HelperErrorState();
}

class _HelperErrorState extends State<_HelperError>
    with SingleTickerProviderStateMixin {
  // If the height of this widget and the counter are zero ("empty") at
  // layout time, no space is allocated for the subtext.
  static const Widget empty = SizedBox.shrink();

  late AnimationController _controller;
  Widget? _helper;
  Widget? _error;

  bool get _hasHelper => widget.helperText != null || widget.helper != null;
  bool get _hasError => widget.errorText != null || widget.error != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
    if (_hasError) {
      _error = _buildError();
      _controller.value = 1.0;
    } else if (_hasHelper) {
      _helper = _buildHelper();
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The _controller's value has changed.
    });
  }

  @override
  void didUpdateWidget(_HelperError old) {
    super.didUpdateWidget(old);

    final Widget? newError = widget.error;
    final String? newErrorText = widget.errorText;
    final Widget? newHelper = widget.helper;
    final String? newHelperText = widget.helperText;
    final Widget? oldError = old.error;
    final String? oldErrorText = old.errorText;
    final Widget? oldHelper = old.helper;
    final String? oldHelperText = old.helperText;

    final bool errorStateChanged = (newError != null) != (oldError != null);
    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);
    final bool helperStateChanged = (newHelper != null) != (oldHelper != null);
    final bool helperTextStateChanged = newErrorText == null &&
        (newHelperText != null) != (oldHelperText != null);

    if (errorStateChanged ||
        errorTextStateChanged ||
        helperStateChanged ||
        helperTextStateChanged) {
      if (newError != null || newErrorText != null) {
        _error = _buildError();
        _controller.forward();
      } else if (newHelper != null || newHelperText != null) {
        _helper = _buildHelper();
        _controller.reverse();
      } else {
        _controller.reverse();
      }
    }
  }

  Widget _buildHelper() {
    assert(widget.helper != null || widget.helperText != null);
    return SDGAInputDecoratorWrapper(
      error: false,
      disabled: widget.disabled,
      maxLines: widget.helperMaxLines,
      child: Semantics(
        container: true,
        child: FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
          child: widget.helper ?? SDGAInputHelper(widget.helperText!),
        ),
      ),
    );
  }

  Widget _buildError() {
    assert(widget.error != null || widget.errorText != null);
    return SDGAInputDecoratorWrapper(
      error: true,
      disabled: widget.disabled,
      maxLines: widget.errorMaxLines,
      child: Semantics(
        container: true,
        child: FadeTransition(
          opacity: _controller,
          child: FractionalTranslation(
            translation: Tween<Offset>(
              begin: const Offset(0.0, -0.25),
              end: Offset.zero,
            ).evaluate(_controller.view),
            child: widget.error ?? SDGAInputHelper(widget.errorText!),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isDismissed) {
      _error = null;
      if (_hasHelper) {
        return _helper = _buildHelper();
      } else {
        _helper = null;
        return empty;
      }
    }

    if (_controller.isCompleted) {
      _helper = null;
      if (_hasError) {
        return _error = _buildError();
      } else {
        _error = null;
        return empty;
      }
    }

    if (_helper == null && _hasError) {
      return _buildError();
    }

    if (_error == null && _hasHelper) {
      return _buildHelper();
    }

    if (_hasError) {
      return Stack(
        children: <Widget>[
          FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
            child: _helper,
          ),
          _buildError(),
        ],
      );
    }

    if (_hasHelper) {
      return Stack(
        children: <Widget>[
          _buildHelper(),
          FadeTransition(
            opacity: _controller,
            child: _error,
          ),
        ],
      );
    }

    return empty;
  }
}

class _Decorator
    extends SlottedMultiChildRenderObjectWidget<_DecorationSlot, RenderBox> {
  const _Decorator({
    required this.textAlignVertical,
    required this.decoration,
    required this.textDirection,
    required this.textBaseline,
    required this.isFocused,
    required this.expands,
  });

  final _Decoration decoration;
  final TextDirection textDirection;
  final TextBaseline textBaseline;
  final TextAlignVertical? textAlignVertical;
  final bool isFocused;
  final bool expands;

  @override
  Iterable<_DecorationSlot> get slots => _DecorationSlot.values;

  @override
  Widget? childForSlot(_DecorationSlot slot) {
    switch (slot) {
      case _DecorationSlot.container:
        return decoration.container;
      case _DecorationSlot.input:
        return decoration.input;
      case _DecorationSlot.label:
        return decoration.label;
      case _DecorationSlot.hint:
        return decoration.hint;
      case _DecorationSlot.prefix:
        return decoration.prefix;
      case _DecorationSlot.suffix:
        return decoration.suffix;
      case _DecorationSlot.prefixIcon:
        return decoration.prefixIcon;
      case _DecorationSlot.suffixIcon:
        return decoration.suffixIcon;
      case _DecorationSlot.helperError:
        return decoration.helperError;
      case _DecorationSlot.counter:
        return decoration.counter;
    }
  }

  @override
  _RenderDecoration createRenderObject(BuildContext context) {
    return _RenderDecoration(
      decoration: decoration,
      textDirection: textDirection,
      textAlignVertical: textAlignVertical,
      isFocused: isFocused,
      expands: expands,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDecoration renderObject) {
    renderObject
      ..decoration = decoration
      ..expands = expands
      ..isFocused = isFocused
      ..textAlignVertical = textAlignVertical
      ..textDirection = textDirection;
  }
}

// The workhorse: layout and paint a _Decorator widget's _Decoration.
class _RenderDecoration extends RenderBox
    with SlottedContainerRenderObjectMixin<_DecorationSlot, RenderBox> {
  _RenderDecoration({
    required _Decoration decoration,
    required TextDirection textDirection,
    required bool isFocused,
    required bool expands,
    TextAlignVertical? textAlignVertical,
  })  : _decoration = decoration,
        _textDirection = textDirection,
        _textAlignVertical = textAlignVertical,
        _isFocused = isFocused,
        _expands = expands;

  RRect _containerRRect = RRect.zero;

  RenderBox? get container => childForSlot(_DecorationSlot.container);
  RenderBox? get input => childForSlot(_DecorationSlot.input);
  RenderBox? get label => childForSlot(_DecorationSlot.label);
  RenderBox? get hint => childForSlot(_DecorationSlot.hint);
  RenderBox? get prefix => childForSlot(_DecorationSlot.prefix);
  RenderBox? get suffix => childForSlot(_DecorationSlot.suffix);
  RenderBox? get prefixIcon => childForSlot(_DecorationSlot.prefixIcon);
  RenderBox? get suffixIcon => childForSlot(_DecorationSlot.suffixIcon);
  RenderBox get helperError => childForSlot(_DecorationSlot.helperError)!;
  RenderBox? get counter => childForSlot(_DecorationSlot.counter);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    final RenderBox? helperError = childForSlot(_DecorationSlot.helperError);
    return <RenderBox>[
      if (container != null) container!,
      if (input != null) input!,
      if (prefixIcon != null) prefixIcon!,
      if (suffixIcon != null) suffixIcon!,
      if (prefix != null) prefix!,
      if (suffix != null) suffix!,
      if (label != null) label!,
      if (hint != null) hint!,
      if (helperError != null) helperError,
      if (counter != null) counter!,
    ];
  }

  _Decoration get decoration => _decoration;
  _Decoration _decoration;
  set decoration(_Decoration value) {
    if (_decoration == value) {
      return;
    }
    _decoration = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextAlignVertical get textAlignVertical =>
      _textAlignVertical ?? TextAlignVertical.center;
  TextAlignVertical? _textAlignVertical;
  set textAlignVertical(TextAlignVertical? value) {
    if (_textAlignVertical == value) {
      return;
    }
    // No need to relayout if the effective value is still the same.
    if (textAlignVertical.y == (value?.y ?? TextAlignVertical.center.y)) {
      _textAlignVertical = value;
      return;
    }
    _textAlignVertical = value;
    markNeedsLayout();
  }

  bool get isFocused => _isFocused;
  bool _isFocused;
  set isFocused(bool value) {
    if (_isFocused == value) {
      return;
    }
    _isFocused = value;
    markNeedsSemanticsUpdate();
  }

  bool get expands => _expands;
  bool _expands = false;
  set expands(bool value) {
    if (_expands == value) {
      return;
    }
    _expands = value;
    markNeedsLayout();
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (prefix != null) {
      visitor(prefix!);
    }
    if (prefixIcon != null) {
      visitor(prefixIcon!);
    }

    if (label != null) {
      visitor(label!);
    }
    if (hint != null) {
      if (isFocused) {
        visitor(hint!);
      } else if (label == null) {
        visitor(hint!);
      }
    }

    if (input != null) {
      visitor(input!);
    }
    if (suffixIcon != null) {
      visitor(suffixIcon!);
    }
    if (suffix != null) {
      visitor(suffix!);
    }
    visitor(helperError);
    if (counter != null) {
      visitor(counter!);
    }
  }

  static double _minWidth(RenderBox? box, double height) =>
      box?.getMinIntrinsicWidth(height) ?? 0.0;
  static double _maxWidth(RenderBox? box, double height) =>
      box?.getMaxIntrinsicWidth(height) ?? 0.0;
  static double _minHeight(RenderBox? box, double width) =>
      box?.getMinIntrinsicHeight(width) ?? 0.0;
  static double _getBaseline(RenderBox box, BoxConstraints boxConstraints) {
    return ChildLayoutHelper.getBaseline(
            box, boxConstraints, TextBaseline.alphabetic) ??
        box.size.height;
  }

  static double _getDryBaseline(RenderBox box, BoxConstraints boxConstraints) {
    return ChildLayoutHelper.getDryBaseline(
            box, boxConstraints, TextBaseline.alphabetic) ??
        ChildLayoutHelper.dryLayoutChild(box, boxConstraints).height;
  }

  static BoxParentData _boxParentData(RenderBox box) =>
      box.parentData! as BoxParentData;

  // EdgeInsets get contentPadding => decoration.contentPadding;

  _SubtextSize? _computeSubtextSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
    required _ChildBaselineGetter getBaseline,
  }) {
    final RenderBox? counter = this.counter;
    Size counterSize;
    final double counterAscent;
    if (counter != null) {
      counterSize = layoutChild(counter, constraints);
      counterAscent = getBaseline(counter, constraints);
    } else {
      counterSize = Size.zero;
      counterAscent = 0.0;
    }

    final BoxConstraints helperErrorConstraints =
        constraints.deflate(EdgeInsets.only(left: counterSize.width));
    final double helperErrorHeight =
        layoutChild(helperError, helperErrorConstraints).height;

    if (helperErrorHeight == 0.0 && counterSize.height == 0.0) {
      return null;
    }

    final double ascent = math.max(
            counterAscent, getBaseline(helperError, helperErrorConstraints)) +
        _gap;
    final double bottomHeight =
        math.max(counterAscent, helperErrorHeight) + _gap;
    final double subtextHeight =
        math.max(counterSize.height, helperErrorHeight) + _gap;
    return _SubtextSize(
        ascent: ascent,
        bottomHeight: bottomHeight,
        subtextHeight: subtextHeight);
  }

  // Returns a value used by performLayout to position all of the renderers.
  // This method applies layout to all of the renderers except the container.
  // For convenience, the container is laid out in performLayout().
  _RenderDecorationLayout _layout(
    BoxConstraints constraints, {
    required ChildLayouter layoutChild,
    required _ChildBaselineGetter getBaseline,
  }) {
    assert(
      constraints.maxWidth < double.infinity,
      'An InputDecorator, which is typically created by a TextField, cannot '
      'have an unbounded width.\n'
      'This happens when the parent widget does not provide a finite width '
      'constraint. For example, if the InputDecorator is contained by a Row, '
      'then its width must be constrained. An Expanded widget or a SizedBox '
      'can be used to constrain the width of the InputDecorator or the '
      'TextField that contains it.',
    );

    final BoxConstraints boxConstraints = constraints.loosen();

    // Layout all the widgets used by InputDecorator
    final BoxConstraints containerConstraints = boxConstraints;
    BoxConstraints contentConstraints = containerConstraints
        .deflate(const EdgeInsets.symmetric(horizontal: SDGANumbers.spacingXL));

    // The helper or error text can occupy the full width less the space
    // occupied by the icon and counter.
    final _SubtextSize? subtextSize = _computeSubtextSizes(
      constraints: contentConstraints,
      layoutChild: layoutChild,
      getBaseline: getBaseline,
    );

    final RenderBox? prefixIcon = this.prefixIcon;
    final RenderBox? suffixIcon = this.suffixIcon;
    final Size prefixIconSize = prefixIcon == null
        ? Size.zero
        : layoutChild(prefixIcon, containerConstraints);
    final Size suffixIconSize = suffixIcon == null
        ? Size.zero
        : layoutChild(suffixIcon, containerConstraints);

    final double bottomHeight =
        subtextSize != null ? subtextSize.bottomHeight + _gap : 0.0;
    final RenderBox? label = this.label;
    final double topHeight;
    if (label != null) {
      final BoxConstraints labelConstraints =
          boxConstraints.copyWith(maxWidth: constraints.maxWidth);
      layoutChild(label, labelConstraints);

      topHeight = label.size.height + _gap;
    } else {
      topHeight = 0.0;
    }

    contentConstraints = contentConstraints
        .deflate(EdgeInsets.only(top: topHeight + bottomHeight));
    final RenderBox? prefix = this.prefix;
    final RenderBox? suffix = this.suffix;
    Size prefixSize =
        prefix == null ? Size.zero : layoutChild(prefix, contentConstraints);
    Size suffixSize =
        suffix == null ? Size.zero : layoutChild(suffix, contentConstraints);

    final EdgeInsetsDirectional accessoryHorizontalInsets =
        EdgeInsetsDirectional.only(
      start: prefixSize.width +
          _contentPadding.left +
          (prefixIcon == null ? 0 : prefixIconSize.width + _gap),
      end: suffixSize.width +
          _contentPadding.right +
          (suffixIcon == null ? 0 : suffixIconSize.width + _gap),
    );

    final double inputWidth = math.max(
        0.0, constraints.maxWidth - accessoryHorizontalInsets.horizontal);
    final BoxConstraints inputConstraints = boxConstraints
        .deflate(EdgeInsets.only(top: topHeight + bottomHeight + _gap * 2))
        .tighten(width: inputWidth)
        .copyWith(minHeight: _minInputHeight);

    final RenderBox? input = this.input;
    final RenderBox? hint = this.hint;
    final Size inputSize =
        input == null ? Size.zero : layoutChild(input, inputConstraints);
    final Size hintSize = hint == null
        ? Size.zero
        : layoutChild(hint, boxConstraints.tighten(width: inputWidth));
    final double inputBaseline =
        input == null ? 0.0 : getBaseline(input, inputConstraints);
    final double hintBaseline = hint == null
        ? 0.0
        : getBaseline(hint, boxConstraints.tighten(width: inputWidth));

    // The field can be occupied by a hint or by the input itself
    final double maxContainerHeight =
        math.max(0.0, boxConstraints.maxHeight - topHeight - bottomHeight);
    final double inputHeight = math.max(hintSize.height, inputSize.height);
    final double affixHeight = expands
        ? maxContainerHeight
        : math.min(
            math.max(inputHeight + _gap * 2,
                math.max(prefixSize.height, suffixSize.height)),
            maxContainerHeight);
    final fixedContentConstraints = contentConstraints.copyWith(
      minHeight: affixHeight,
      maxHeight: maxContainerHeight,
    );
    if (prefix != null) {
      prefixSize = layoutChild(prefix, fixedContentConstraints);
    }
    if (suffix != null) {
      suffixSize = layoutChild(suffix, fixedContentConstraints);
    }

    final double containerHeight = expands
        ? maxContainerHeight
        : math.min(math.max(affixHeight, inputHeight), maxContainerHeight);
    final double inputInternalBaseline = math.max(inputBaseline, hintBaseline);

    if (container != null) {
      layoutChild(
        container!,
        BoxConstraints.tight(Size(
          constraints.maxWidth,
          containerHeight,
        )),
      );
    }

    // if (scrollbars != null) {
    //   layoutChild(
    //     scrollbars!,
    //     BoxConstraints.tight(Size(
    //       constraints.maxWidth - prefixSize.width - suffixSize.width,
    //       containerHeight,
    //     )),
    //   );
    // }

    return _RenderDecorationLayout(
      inputConstraints: inputConstraints,
      containerHeight: containerHeight,
      baseline: inputInternalBaseline,
      subtextSize: subtextSize,
      size: Size(
          constraints.maxWidth, containerHeight + topHeight + bottomHeight),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return (prefixIcon != null ? 0.0 : _contentPadding.left) +
        _minWidth(prefixIcon, height) +
        _minWidth(prefix, height) +
        math.max(_minWidth(input, height), _minWidth(hint, height)) +
        _minWidth(suffix, height) +
        _minWidth(suffixIcon, height) +
        (suffixIcon != null ? 0.0 : _contentPadding.right);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return (prefixIcon != null ? 0.0 : _contentPadding.left) +
        _maxWidth(prefixIcon, height) +
        _maxWidth(prefix, height) +
        math.max(_maxWidth(input, height), _maxWidth(hint, height)) +
        _maxWidth(suffix, height) +
        _maxWidth(suffixIcon, height) +
        (suffixIcon != null ? 0.0 : _contentPadding.right);
  }

  double _lineHeight(double width, List<RenderBox?> boxes) {
    double height = 0.0;
    for (final RenderBox? box in boxes) {
      if (box == null) {
        continue;
      }
      height = math.max(_minHeight(box, width), height);
    }
    return height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double prefixIconHeight = _minHeight(prefixIcon, width);
    final double prefixIconWidth = _minWidth(prefixIcon, prefixIconHeight);

    final double suffixIconHeight = _minHeight(suffixIcon, width);
    final double suffixIconWidth = _minWidth(suffixIcon, suffixIconHeight);

    width = math.max(width - _contentPadding.horizontal, 0.0);

    final double counterHeight = _minHeight(counter, width);
    final double counterWidth = _minWidth(counter, counterHeight);

    final double helperErrorAvailableWidth =
        math.max(width - counterWidth, 0.0);
    final double helperErrorHeight =
        _minHeight(helperError, helperErrorAvailableWidth);
    double subtextHeight = math.max(counterHeight, helperErrorHeight);
    if (subtextHeight > 0.0) {
      subtextHeight += _gap;
    }

    final double prefixHeight = _minHeight(prefix, width);
    final double prefixWidth = _minWidth(prefix, prefixHeight);

    final double suffixHeight = _minHeight(suffix, width);
    final double suffixWidth = _minWidth(suffix, suffixHeight);

    final double availableInputWidth = math.max(
        width - prefixWidth - suffixWidth - prefixIconWidth - suffixIconWidth,
        0.0);
    final double inputHeight =
        _lineHeight(availableInputWidth, <RenderBox?>[input, hint]);
    final double inputMaxHeight =
        <double>[inputHeight, prefixHeight, suffixHeight].reduce(math.max);

    final double contentHeight = inputMaxHeight;
    final double containerHeight = <double>[
      contentHeight,
      prefixIconHeight,
      suffixIconHeight
    ].reduce(math.max);

    return math.max(containerHeight, 40.0) + subtextHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return getMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    final RenderBox? input = this.input;
    if (input == null) {
      return 0.0;
    }
    return _boxParentData(input).offset.dy +
        (input.getDistanceToActualBaseline(baseline) ?? input.size.height);
  }

  @override
  double? computeDryBaseline(
      covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? input = this.input;
    if (input == null) {
      return 0.0;
    }
    final _RenderDecorationLayout layout = _layout(
      constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      getBaseline: _getDryBaseline,
    );
    switch (baseline) {
      case TextBaseline.alphabetic:
        return 0.0 + layout.baseline;
      case TextBaseline.ideographic:
        return (input.getDryBaseline(
                    layout.inputConstraints, TextBaseline.ideographic) ??
                input.getDryLayout(layout.inputConstraints).height) -
            (input.getDryBaseline(
                    layout.inputConstraints, TextBaseline.alphabetic) ??
                input.getDryLayout(layout.inputConstraints).height) +
            layout.baseline;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final _RenderDecorationLayout layout = _layout(
      constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      getBaseline: _getDryBaseline,
    );
    return constraints.constrain(layout.size);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final _RenderDecorationLayout layout = _layout(
      constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
      getBaseline: _getBaseline,
    );
    size = constraints.constrain(layout.size);
    assert(size.width == constraints.constrainWidth(layout.size.width));
    assert(size.height == constraints.constrainHeight(layout.size.height));
    // Map textAlignVertical from -1:1 to 0:1 so that it can be used to scale
    // the baseline from its minimum to maximum values.
    final double textAlignVerticalFactor = (textAlignVertical.y + 1.0) / 2.0;
    final double overallWidth = layout.size.width;
    final double top = (label?.size.height ?? 0) + (label != null ? _gap : 0);
    final double height = layout.containerHeight;
    double centerLayout(RenderBox box, double x) {
      _boxParentData(box).offset =
          Offset(x, top + (height - box.size.height) / 2.0);
      return box.size.width;
    }

    double verticalAlignedLayout(RenderBox box, double x) {
      _boxParentData(box).offset = Offset(
        x,
        lerpDouble(
          top + _gap,
          top + height - box.size.height - _gap,
          textAlignVerticalFactor,
        )!,
      );
      return box.size.width;
    }

    final double subtextBaseline =
        (layout.subtextSize?.ascent ?? 0.0) + layout.containerHeight;
    final RenderBox? counter = this.counter;
    final double helperErrorBaseline =
        helperError.getDistanceToBaseline(TextBaseline.alphabetic)!;
    final double counterBaseline =
        counter?.getDistanceToBaseline(TextBaseline.alphabetic)! ?? 0.0;

    double start, end;
    switch (textDirection) {
      case TextDirection.ltr:
        start = 0;
        end = overallWidth;
        _boxParentData(helperError).offset =
            Offset(start, top + subtextBaseline - helperErrorBaseline);
        if (counter != null) {
          _boxParentData(counter).offset = Offset(end - counter.size.width,
              top + subtextBaseline - counterBaseline);
        }
        break;
      case TextDirection.rtl:
        start = overallWidth;
        end = 0;
        _boxParentData(helperError).offset = Offset(
            start - helperError.size.width,
            top + subtextBaseline - helperErrorBaseline);
        if (counter != null) {
          _boxParentData(counter).offset =
              Offset(end, top + subtextBaseline - counterBaseline);
        }
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (label != null) {
            _boxParentData(label!).offset =
                Offset(overallWidth - label!.size.width, 0);
          }

          if (prefix != null) {
            start -= centerLayout(prefix!, start - prefix!.size.width);
          }
          if (prefixIcon != null) {
            start -= _contentPadding.left;
            start -= centerLayout(prefixIcon!, start - prefixIcon!.size.width);
          }
          if (input != null || hint != null) {
            start -= prefixIcon != null ? _gap : _contentPadding.left;
          }
          if (input != null) {
            verticalAlignedLayout(input!, start - input!.size.width);
          }
          if (hint != null) {
            verticalAlignedLayout(hint!, start - hint!.size.width);
          }
          if (suffix != null) {
            end += centerLayout(suffix!, end);
          }
          if (suffixIcon != null) {
            end += _contentPadding.right;
            end += centerLayout(suffixIcon!, end);
          }

          break;
        }
      case TextDirection.ltr:
        {
          if (label != null) {
            _boxParentData(label!).offset = Offset.zero;
          }
          if (prefix != null) {
            start += centerLayout(prefix!, start);
          }
          if (prefixIcon != null) {
            start += _contentPadding.left;
            start += centerLayout(prefixIcon!, start);
          }
          if (input != null || hint != null) {
            start += prefixIcon != null ? _gap : _contentPadding.left;
          }
          if (input != null) {
            verticalAlignedLayout(input!, start);
          }
          if (hint != null) {
            verticalAlignedLayout(hint!, start);
          }
          if (suffix != null) {
            end -= centerLayout(suffix!, end - suffix!.size.width);
          }
          if (suffixIcon != null) {
            end -= _contentPadding.right;
            end -= centerLayout(suffixIcon!, end - suffixIcon!.size.width);
          }
          break;
        }
    }
    final double topOffset =
        (label?.size.height ?? 0) + (label != null ? _gap : 0);
    final Rect containerRect =
        Offset(0, topOffset) & Size(size.width, layout.containerHeight);

    _containerRRect = RRect.fromRectAndRadius(
      containerRect,
      const Radius.circular(SDGANumbers.radiusSmall),
    );
    if (container != null) {
      _boxParentData(container!).offset =
          Offset(_containerRRect.left, _containerRRect.top);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        context.paintChild(child, _boxParentData(child).offset + offset);
      }
    }

    RRect containerRRect = _containerRRect.shift(offset);

    if (decoration.fillColor != null) {
      context.canvas.drawRRect(
        containerRRect,
        Paint()..color = decoration.fillColor!,
      );
    }

    doPaint(container);
    doPaint(label);
    doPaint(prefix);
    doPaint(suffix);
    doPaint(prefixIcon);
    doPaint(suffixIcon);
    doPaint(hint);
    doPaint(input);
    doPaint(helperError);
    doPaint(counter);
    final Border? border = decoration.border;
    if (border != null) {
      if (decoration.bottomBorder > 0) {
        final double value =
            (containerRRect.width * (1 - decoration.bottomBorder) / 2);

        context.pushClipRRect(
          false,
          Offset.zero,
          containerRRect.outerRect,
          containerRRect,
          (context, offset) {
            context.canvas.drawLine(
              Offset(
                containerRRect.left + value,
                containerRRect.bottom - 2,
              ),
              Offset(
                containerRRect.right - value,
                containerRRect.bottom - 2,
              ),
              Paint()
                ..color = border.bottom.color
                ..strokeWidth = 2,
            );
          },
        );
      }

      border.paint(
        context.canvas,
        containerRRect.outerRect,
        borderRadius: const BorderRadius.all(
          Radius.circular(SDGANumbers.radiusSmall),
        ),
      );
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    // if (decoration.onlyHtiTestContainer) {
    //   return false;
    //   print(position);

    //   return _containerRRect.contains(position);
    // } else {
    // }
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      // if (child == input && decoration.onlyHtiTestContainer) {
      //   if (_containerRRect.contains(position)) return true;
      //   continue;
      // }
      final Offset offset = _boxParentData(child).offset;
      final bool isHit = result.addWithPaintOffset(
        offset: offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }
    return false;
  }

  ChildSemanticsConfigurationsResult _childSemanticsConfigurationDelegate(
      List<SemanticsConfiguration> childConfigs) {
    final ChildSemanticsConfigurationsResultBuilder builder =
        ChildSemanticsConfigurationsResultBuilder();
    List<SemanticsConfiguration>? prefixMergeGroup;
    List<SemanticsConfiguration>? suffixMergeGroup;
    for (final SemanticsConfiguration childConfig in childConfigs) {
      if (childConfig
          .tagsChildrenWith(_SDGAInputDecoratorState._kPrefixSemanticsTag)) {
        prefixMergeGroup ??= <SemanticsConfiguration>[];
        prefixMergeGroup.add(childConfig);
      } else if (childConfig
          .tagsChildrenWith(_SDGAInputDecoratorState._kSuffixSemanticsTag)) {
        suffixMergeGroup ??= <SemanticsConfiguration>[];
        suffixMergeGroup.add(childConfig);
      } else {
        builder.markAsMergeUp(childConfig);
      }
    }
    if (prefixMergeGroup != null) {
      builder.markAsSiblingMergeGroup(prefixMergeGroup);
    }
    if (suffixMergeGroup != null) {
      builder.markAsSiblingMergeGroup(suffixMergeGroup);
    }
    return builder.build();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.childConfigurationsDelegate = _childSemanticsConfigurationDelegate;
  }
}

// A container for the layout values computed by _RenderDecoration._layout.
// These values are used by _RenderDecoration.performLayout to position
// all of the renderer children of a _RenderDecoration.
class _RenderDecorationLayout {
  const _RenderDecorationLayout({
    required this.inputConstraints,
    required this.baseline,
    required this.containerHeight,
    required this.subtextSize,
    required this.size,
  });

  final BoxConstraints inputConstraints;
  final double baseline;
  final double containerHeight;
  final _SubtextSize? subtextSize;
  final Size size;
}

// An analog of SDGAInputDecoration for the _Decorator widget.
class _Decoration {
  const _Decoration({
    required this.border,
    this.fillColor,
    this.container,
    this.input,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.helperError,
    this.counter,
    required this.bottomBorder,
    // this.onlyHtiTestContainer = false,
  });

  final Border? border;
  final Color? fillColor;
  final Widget? container;
  final Widget? input;
  final Widget? label;
  final Widget? hint;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? helperError;
  final Widget? counter;
  final double bottomBorder;
  // final bool onlyHtiTestContainer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _Decoration &&
        other.border == border &&
        other.fillColor == fillColor &&
        other.input == input &&
        other.label == label &&
        other.hint == hint &&
        other.prefix == prefix &&
        other.suffix == suffix &&
        other.prefixIcon == prefixIcon &&
        other.suffixIcon == suffixIcon &&
        other.helperError == helperError &&
        other.counter == counter &&
        other.bottomBorder == bottomBorder;
  }

  @override
  int get hashCode => Object.hash(
        border,
        fillColor,
        input,
        label,
        hint,
        prefix,
        suffix,
        prefixIcon,
        suffixIcon,
        helperError,
        counter,
        bottomBorder,
      );
}

class _AnimatedDecoration {
  const _AnimatedDecoration({
    required this.border,
    required this.bottomBorder,
  });

  final Border? border;
  final double bottomBorder;

  _AnimatedDecoration scale(double t) {
    return _AnimatedDecoration(
      border: border?.scale(t),
      bottomBorder: math.max(0.0, bottomBorder * t),
    );
  }

  static _AnimatedDecoration? lerp(
      _AnimatedDecoration? a, _AnimatedDecoration? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return _AnimatedDecoration(
      border: Border.lerp(a.border, b.border, t),
      bottomBorder: lerpDouble(a.bottomBorder, b.bottomBorder, t)!,
    );
  }
}

class _SubtextSize {
  const _SubtextSize({
    required this.ascent,
    required this.bottomHeight,
    required this.subtextHeight,
  });

  final double ascent;
  final double bottomHeight;
  final double subtextHeight;
}
