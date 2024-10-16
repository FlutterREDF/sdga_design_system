import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGASwitchListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a switch.
  ///
  /// The switch tile itself does not maintain any state. Instead, when the
  /// state of the switch changes, the widget calls the [onChanged] callback.
  /// Most widgets that use a switch will listen for the [onChanged] callback
  /// and rebuild the switch tile with a new [value] to update the visual
  /// appearance of the switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onChanged] is called when the user toggles the switch on or off.
  const SDGASwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.title,
    this.subtitle,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
  });

  /// Whether this switch is checked.
  final bool value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch tile with the
  /// new value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// {@tool snippet}
  /// ```dart
  /// SDGASwitchListTile(
  ///   value: _isSelected,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _isSelected = newValue;
  ///     });
  ///   },
  ///   title: const Text('Selection'),
  /// )
  /// ```
  /// {@end-tool}
  final ValueChanged<bool>? onChanged;

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
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        trailing: ExcludeFocus(
          child: SDGASwitch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }
}
