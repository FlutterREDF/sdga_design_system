part of 'home_page.dart';

class HomeDrawerOptionsWrapper extends InheritedWidget {
  const HomeDrawerOptionsWrapper({
    super.key,
    required super.child,
    required this.options,
  });

  final HomeDrawerOptions options;

  @override
  bool updateShouldNotify(covariant HomeDrawerOptionsWrapper oldWidget) {
    return false;
  }

  static HomeDrawerOptionsWrapper of(BuildContext context) => maybeOf(context)!;

  static HomeDrawerOptionsWrapper? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeDrawerOptionsWrapper>();
}

class HomeDrawerOptions {
  HomeDrawerOptions();
  final List<VoidCallback> _listeners = [];

  bool _onColor = false;
  bool get onColor => _onColor;
  set onColor(bool value) {
    _onColor = value;
    notifyListeners();
  }

  bool _overlay = false;
  bool get overlay => _overlay;
  set overlay(bool value) {
    _overlay = value;
    notifyListeners();
  }

  bool _showHeader = true;
  bool get showHeader => _showHeader;
  set showHeader(bool value) {
    _showHeader = value;
    notifyListeners();
  }

  bool _showIcons = true;
  bool get showIcons => _showIcons;
  set showIcons(bool value) {
    _showIcons = value;
    notifyListeners();
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    if (_listeners.isNotEmpty) {
      for (var listener in _listeners) {
        listener.call();
      }
    }
  }
}
