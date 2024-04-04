import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class DebugKitController with ChangeNotifier {
  DebugKitController({
    required bool buttonVisible,
  })  : _buttonVisible = buttonVisible,
        super();

  bool get opened => _opened;
  bool _opened = false;
  set opened(bool newValue) {
    if (newValue != _opened && enabled) {
      _opened = newValue;
      notifyListeners();
    }
  }

  // TODO: Add "DebugKitPanelBasePage? selectedPage" getter/setter

  // TODO: Add optional "page" parameter (switch to specified page after open)
  void open() {
    opened = true;
  }

  void close() {
    opened = false;
  }

  void toggle() {
    opened = !opened;
  }

  bool get buttonVisible => _buttonVisible;
  bool _buttonVisible = true;
  set buttonVisible(bool newValue) {
    if (newValue != _buttonVisible && enabled) {
      _buttonVisible = newValue;
      notifyListeners();
    }
  }

  @internal
  bool get enabled => _enabled;
  bool _enabled = true;
  @internal
  set enabled(bool newValue) {
    if (newValue != _enabled) {
      _enabled = newValue;
      notifyListeners();
    }
  }

  @override
  bool operator ==(covariant DebugKitController other) {
    return (opened == other.opened) && (buttonVisible == other.buttonVisible);
  }

  @override
  int get hashCode => Object.hash(opened, buttonVisible);

  // ---

  static DebugKitController? maybeOf(BuildContext context) {
    final DebugKitDefaultController? result = context.dependOnInheritedWidgetOfExactType<DebugKitDefaultController>();
    return result?.controller;
  }
}

class DebugKitDefaultController extends InheritedWidget {
  final DebugKitController? controller;

  const DebugKitDefaultController({
    super.key,
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(covariant DebugKitDefaultController oldWidget) => oldWidget.controller != controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DebugKitController>('controller', controller, ifNull: 'no controller', showName: false),
    );
  }
}
