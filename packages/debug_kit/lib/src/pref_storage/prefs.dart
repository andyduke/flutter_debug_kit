import 'package:debug_kit/src/pref_storage/pref_storage.dart';
import 'package:flutter/widgets.dart';

class DebugKitPrefs extends InheritedWidget {
  final DebugKitPrefStorage storage;

  const DebugKitPrefs({
    super.key,
    required this.storage,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DebugKitPrefs oldWidget) => false;

  static DebugKitPrefStorage? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DebugKitPrefs>()?.storage;
  }
}
