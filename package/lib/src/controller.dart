import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DebugPanelController with ChangeNotifier {
  DebugPanelController({
    required bool buttonVisible,
  })  : _buttonVisible = buttonVisible,
        super();

  bool get opened => _opened;
  bool _opened = false;
  set opened(bool newValue) {
    if (newValue != _opened) {
      _opened = newValue;
      notifyListeners();
    }
  }

  void open() {
    opened = true;
  }

  void close() {
    opened = false;
  }

  bool get buttonVisible => _buttonVisible;
  bool _buttonVisible = true;
  set buttonVisible(bool newValue) {
    if (newValue != _buttonVisible) {
      _buttonVisible = newValue;
      notifyListeners();
    }
  }

  // ---

  /*
  @internal
  DebugPanel? get attachedPanel => _attachedPanel;
  DebugPanel? _attachedPanel;

  @internal
  set attachedPanel(DebugPanel? newValue) {
    if (newValue != null && _attachedPanel != null && newValue != _attachedPanel) {
      throw Exception('This DebugPanelController is already used in DebugPanel.');
    } else {
      _attachedPanel = newValue.attach(this);
    }
  }
  */

  /*
  // TODO: Remove attachPanel/detachPanel!

  DebugPanelState? _attachedPanel;

  @internal
  void attachPanel(DebugPanelState panel, DebugPanelBaseSettings settings) {
    if (_attachedPanel != null) {
      throw Exception('This DebugPanelController is already used in DebugPanel.');
    } else {
      _attachedPanel = panel;
      applySettings(settings);
    }
  }

  @internal
  void detachPanel() {
    _attachedPanel = null;
  }

  @internal
  void applySettings(DebugPanelBaseSettings settings) {
    _buttonVisible = settings.buttonVisible;
  }
  */

  // @internal
  // void addPage() {}

  @override
  bool operator ==(covariant DebugPanelController other) {
    return (opened == other.opened) && (buttonVisible == other.buttonVisible);
  }

  @override
  int get hashCode => Object.hash(opened, buttonVisible);

  // ---

  // static DebugPanelController? _primaryController;

  // static DebugPanelController of(BuildContext context) {
  //   final DebugPanelDefaultController? result =
  //       context.dependOnInheritedWidgetOfExactType<DebugPanelDefaultController>();
  //   return result?.controller ?? (_primaryController ??= DebugPanelController());
  // }

  static DebugPanelController? maybeOf(BuildContext context) {
    final DebugPanelDefaultController? result =
        context.dependOnInheritedWidgetOfExactType<DebugPanelDefaultController>();
    return result?.controller;
  }
}

class DebugPanelDefaultController extends InheritedWidget {
  final DebugPanelController? controller;

  const DebugPanelDefaultController({
    super.key,
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(covariant DebugPanelDefaultController oldWidget) => oldWidget.controller != controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<DebugPanelController>('controller', controller, ifNull: 'no controller', showName: false));
  }
}
