import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/triggers/trigger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Opens/closes Debug Panel using keyboard keys, default Alt-F12.
class DebugKitShortcutTrigger extends StatelessWidget {
  static const name = 'debug_kit_shortcut';

  static DebugKitTrigger setup({List<ShortcutActivator> activators = const []}) {
    return DebugKitTrigger(
      name: name,
      builder: (context, controller, child) => DebugKitShortcutTrigger(
        activators: activators,
        controller: controller,
        child: child,
      ),
    );
  }

  static final defaultActivator = LogicalKeySet(
    LogicalKeyboardKey.f12,
    LogicalKeyboardKey.alt,
  );

  final List<ShortcutActivator> activators;
  final DebugKitController controller;
  final Widget child;

  const DebugKitShortcutTrigger({
    super.key,
    this.activators = const [],
    required this.controller,
    required this.child,
  });

  void _toggle() {
    controller.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        for (var v in activators.isEmpty ? [defaultActivator] : activators) v: _toggle
      },
      child: child,
    );
  }
}
