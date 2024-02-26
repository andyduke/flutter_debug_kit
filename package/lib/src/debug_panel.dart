import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/overlay.dart';
import 'package:debug_panel/src/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class DebugPanel extends StatefulWidget {
  final DebugPanelController? controller;
  final DebugPanelBaseSettings settings;
  final Widget? child;

  const DebugPanel({
    super.key,
    this.controller,
    this.settings = const DebugPanelSettings(),
    required this.child,
  });

  @override
  State<DebugPanel> createState() => DebugPanelState();

  static DebugPanelController? maybeOf(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_InheritedDebugPanel>();
    return inherited?.controller;
  }
}

@internal
class DebugPanelState extends State<DebugPanel> {
  /*
  DebugPanelController get controller =>
      _controller ??= ((widget.controller ?? DebugPanelController.of(context))..attachPanel(this, widget.settings));
  DebugPanelController? _controller;

  // TODO: Get rid of attaching the panel to the controller.

  @override
  void dispose() {
    _controller?.detachPanel();

    super.dispose();
  }
  */

  DebugPanelController get controller =>
      _controller ??= widget.controller ?? DebugPanelController(buttonVisible: widget.settings.buttonVisible);
  DebugPanelController? _controller;

  @override
  void didUpdateWidget(covariant DebugPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller = null;
    }

    /*
    if (oldWidget.settings != widget.settings) {
      controller.applySettings(widget.settings);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDebugPanel(
      controller: controller,
      child: DebugPanelOverlay(
        builder: widget.settings.buildOverlay,
        // TODO: Wrap with floating button
        child: widget.child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _InheritedDebugPanel extends InheritedWidget {
  final DebugPanelController controller;

  const _InheritedDebugPanel({
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(covariant _InheritedDebugPanel oldWidget) => oldWidget.controller != controller;
}
