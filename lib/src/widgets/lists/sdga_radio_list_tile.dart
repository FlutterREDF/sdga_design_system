import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGARadioListTile<T> extends StatelessWidget {
  /// Creates a combination of a list tile and a radio button.
  ///
  /// The radio tile itself does not maintain any state. Instead, when the radio
  /// button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio tile with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const SDGARadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.leading,
    this.title,
    this.subtitle,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.style = SDGAToggleableStyle.brand,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio tile with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGARadioListTile<SingingCharacter>(
  ///   title: const Text('Lafayette'),
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter? newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// Set to true if this radio button is allowed to be returned to an
  /// indeterminate state by selecting it again when selected.
  ///
  /// To indicate returning to an indeterminate state, [onChanged] will be
  /// called with null.
  ///
  /// If true, [onChanged] can be called with [value] when selected while
  /// [groupValue] != [value], or with null when selected again while
  /// [groupValue] == [value].
  ///
  /// If false, [onChanged] will be called with [value] when it is selected
  /// while [groupValue] != [value], and only by selecting another radio button
  /// in the group (i.e. changing the value of [groupValue]) can this radio
  /// button be unselected.
  ///
  /// The default is false.
  final bool toggleable;

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// You can use [Text.maxLines] to enforce the number of lines.
  final Widget? subtitle;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.ListTile.enableFeedback}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// The style for this radio button, whether to use brand colors or neutral colors
  ///
  /// The default is [SDGAToggleableStyle.brand]
  final SDGAToggleableStyle style;

  /// Whether this radio button is checked.
  ///
  /// To control this value, set [value] and [groupValue] appropriately.
  bool get checked => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: SDGAListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        enableFeedback: enableFeedback,
        enabled: onChanged != null,
        onTap: onChanged != null
            ? () {
                if (toggleable && checked) {
                  onChanged!(null);
                  return;
                }
                if (!checked) {
                  onChanged!(value);
                }
              }
            : null,
        trailing: ExcludeFocus(
          child: SDGARadio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            style: style,
            toggleable: toggleable,
          ),
        ),
      ),
    );
  }
}
