import 'package:debug_panel/src/pref_storage/pref_storage.dart';
import 'package:flutter/widgets.dart';

class DebugPanelPrefs extends InheritedWidget {
  final DebugPanelPrefStorage storage;

  const DebugPanelPrefs({
    super.key,
    required this.storage,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DebugPanelPrefs oldWidget) => false;

  static DebugPanelPrefStorage? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DebugPanelPrefs>()?.storage;
  }
}
