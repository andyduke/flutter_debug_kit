import 'package:debug_panel/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Opens/closes Debug Panel using keyboard keys, default Alt-F12.
class DebugPanelShortcutTrigger extends StatelessWidget {
  static final defaultActivator = LogicalKeySet(
    LogicalKeyboardKey.f12,
    LogicalKeyboardKey.alt,
  );

  final List<ShortcutActivator> activators;
  final DebugPanelController controller;
  final Widget child;

  const DebugPanelShortcutTrigger({
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
