import 'package:debug_panel/debug_panel.dart';
import 'package:flutter/widgets.dart';

class DebugPanelCustomize extends StatefulWidget {
  final dynamic pages;
  final dynamic items; // TODO: ???

  final Widget child;

  const DebugPanelCustomize({
    super.key,
    required this.child,
    this.pages,
    this.items,
  });

  @override
  State<DebugPanelCustomize> createState() => _DebugPanelCustomizeState();
}

class _DebugPanelCustomizeState extends State<DebugPanelCustomize> {
  DebugPanelController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cleanupCustomization();
    controller = DebugPanel.maybeOf(context);
    _customize();
  }

  void _customize() {
    if (controller != null) {
      // TODO: Add pages & items
    }
  }

  void _cleanupCustomization() {
    if (controller != null) {
      // TODO: Remove pages & items
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
