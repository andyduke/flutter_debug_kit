import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/triggers/floating_button/floating_button_trigger.dart';
import 'package:debug_panel/src/screen/screen.dart';
import 'package:debug_panel/src/screen_route.dart';
import 'package:debug_panel/src/settings.dart';
import 'package:debug_panel/src/triggers/shortcut_trigger.dart';
import 'package:debug_panel/src/triggers/trigger.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DebugPanel extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final DebugPanelController? controller;
  final DebugPanelBaseSettings settings;
  final Widget? child;
  final DebugPanelTrigger trigger;

  // TODO: Add triggers builder (default (context, child) => DebugPanelFloatingButtonTrigger(child: child))
  //       DebugPanelShortcutTrigger(shortcut: (Alt-F12)) - show debug panel with keyboard shortcut
  //       DebugPanelShakeTrigger - show debug panel on shake
  //       DebugPanelTwoFingersTrigger - show panel with two fingers hold

  const DebugPanel({
    super.key,
    required this.navigatorKey,
    this.controller,
    this.settings = const DebugPanelSettings(),
    required this.child,
    this.trigger = _defaultTriggers,
  });

  static Widget _defaultTriggers(BuildContext context, DebugPanelController controller, Widget child) {
    return DebugPanelShortcutTrigger(
      controller: controller,
      child: DebugPanelFloatingButtonTrigger(
        controller: controller,
        child: child,
      ),
    );
  }

  @override
  State<DebugPanel> createState() => DebugPanelState();
}

@internal
class DebugPanelState extends State<DebugPanel> {
  static const _screenRouteName = '/debug_panel_screen';

  DebugPanelController get controller =>
      _controller ??= widget.controller ?? DebugPanelController(buttonVisible: widget.settings.buttonVisible);
  DebugPanelController? _controller;

  bool _screenVisible = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(_toggleScreen);
  }

  @override
  void didUpdateWidget(covariant DebugPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      controller.removeListener(_toggleScreen);
      _controller = null;
      controller.addListener(_toggleScreen);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_toggleScreen);

    if (widget.controller == null) {
      _controller?.dispose();
    }

    super.dispose();
  }

  void _toggleScreen() async {
    if (controller.opened && !_screenVisible) {
      _openScreen();
    } else if (!controller.opened && _screenVisible) {
      _closeScreen();
    }
  }

  Future<void> _openScreen() async {
    _screenVisible = true;
    try {
      await widget.navigatorKey.currentState?.push(
        // MaterialPageRoute(
        //   fullscreenDialog: true,
        //   barrierDismissible: true,
        //   settings: const RouteSettings(name: _screenRouteName),
        //   builder: (context) => DebugPanelScreen(controller: controller, pages: widget.settings.pages),
        // ),
        DebugPanelScreenRoute(
          settings: const RouteSettings(name: _screenRouteName),
          builder: (context) => DebugPanelScreen(controller: controller, pages: widget.settings.pages),
        ),
      );
    } finally {
      _screenVisible = false;
    }

    controller.close();
  }

  void _closeScreen() {
    widget.navigatorKey.currentState?.popUntil(ModalRoute.withName(_screenRouteName));
    widget.navigatorKey.currentState?.pop();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = widget.trigger(context, controller, widget.child ?? const SizedBox.shrink());

    if (widget.controller == null) {
      return DebugPanelDefaultController(
        controller: controller,
        child: overlay,
      );
    } else {
      return overlay;
    }
  }
}
