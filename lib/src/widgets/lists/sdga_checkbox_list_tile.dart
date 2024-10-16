import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

class SDGACheckboxListTile extends StatelessWidget {
  /// Creates a combination of a list tile and a checkbox.
  ///
  /// The checkbox tile itself does not maintain any state. Instead, when the
  /// state of the checkbox changes, the widget calls the [onChanged] callback.
  /// Most widgets that use a checkbox will listen for the [onChanged] callback
  /// and rebuild the checkbox tile with a new [value] to update the visual
  /// appearance of the checkbox.
  ///
  /// The following arguments are required:
  ///
  /// * [value], which determines whether the checkbox is checked. The [value]
  ///   can only be null if [tristate] is true.
  /// * [onChanged], which is called when the value of the checkbox should
  ///   change. It can be set to null to disable the checkbox.
  const SDGACheckboxListTile({
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
    this.tristate = false,
    this.checkboxSemanticLabel,
    this.style = SDGAToggleableStyle.brand,
  });

  /// Whether this checkbox is checked.
  final bool? value;

  /// Called when the value of the checkbox should change.
  ///
  /// The checkbox passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the checkbox tile with the
  /// new value.
  ///
  /// If null, the checkbox will be displayed as disabled.
  ///
  /// {@tool snippet}
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// SDGACheckboxListTile(
  ///   value: _throwShotAway,
  ///   onChanged: (bool? newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },
  ///   title: const Text('Throw away your shot'),
  /// )
  /// ```
  /// {@end-tool}
  final ValueChanged<bool?>? onChanged;

  /// If true the checkbox's [value] can be true, false, or null.
  ///
  /// Checkbox displays a dash when its value is null.
  ///
  /// When a tri-state checkbox ([tristate] is true) is tapped, its [onChanged]
  /// callback will be applied to true if the current value is false, to null if
  /// value is true, and to false if value is null (i.e. it cycles through false
  /// => true => null => false when tapped).
  ///
  /// If tristate is false (the default), [value] must not be null.
  final bool tristate;

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

  /// {@macro flutter.material.checkbox.semanticLabel}
  final String? checkboxSemanticLabel;

  /// The style for this radio button, whether to use brand colors or neutral colors
  ///
  /// The default is [SDGAToggleableStyle.brand]
  final SDGAToggleableStyle style;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
    }
  }

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
        onTap: onChanged != null ? _handleValueChange : null,
        trailing: ExcludeFocus(
          child: SDGACheckbox(
            style: style,
            value: value,
            onChanged: onChanged,
            tristate: tristate,
            semanticLabel: checkboxSemanticLabel,
          ),
        ),
      ),
    );
  }
}
