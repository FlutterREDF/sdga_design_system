import 'package:flutter/widgets.dart';

class SDGAUtils {
  static T resolveWidgetStateUnordered<T>(
    Set<WidgetState> states, {
    required T fallback,
    T? pressed,
    T? disabled,
    T? hovered,
    T? focused,
    T? error,
    T? scrolledUnder,
    T? dragged,
    T? selected,
  }) {
    if (pressed != null && states.contains(WidgetState.pressed)) {
      return pressed;
    } else if (disabled != null && states.contains(WidgetState.disabled)) {
      return disabled;
    } else if (hovered != null && states.contains(WidgetState.hovered)) {
      return hovered;
    } else if (focused != null && states.contains(WidgetState.focused)) {
      return focused;
    } else if (error != null && states.contains(WidgetState.error)) {
      return error;
    } else if (scrolledUnder != null &&
        states.contains(WidgetState.scrolledUnder)) {
      return scrolledUnder;
    } else if (dragged != null && states.contains(WidgetState.dragged)) {
      return dragged;
    } else if (selected != null && states.contains(WidgetState.selected)) {
      return selected;
    } else {
      return fallback;
    }
  }
}

class SaltedKey<S, V> extends LocalKey {
  const SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SaltedKey<S, V> &&
        other.salt == salt &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}
