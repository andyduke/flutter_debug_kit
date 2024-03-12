import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pref_storage/pref_storage.dart';
import 'package:debug_panel/src/pref_storage/prefs.dart';
import 'package:debug_panel/src/triggers/floating_button/floating_button_trigger.dart';
import 'package:debug_panel/src/screen/screen.dart';
import 'package:debug_panel/src/screen_route.dart';
import 'package:debug_panel/src/settings.dart';
import 'package:debug_panel/src/triggers/glyph/glyph_trigger.dart';
import 'package:debug_panel/src/triggers/shortcut_trigger.dart';
import 'package:debug_panel/src/triggers/trigger.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// TODO: Add triggers:
//   - DebugPanelShakeTrigger - show debug panel on shake
//   - DebugPanelTwoFingersTrigger - show panel with two fingers hold

class DebugPanel extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final DebugPanelController? controller;
  final DebugPanelBaseSettings settings;
  final Widget? child;
  final DebugPanelTrigger trigger;
  final bool enabled;

  const DebugPanel({
    super.key,
    required this.navigatorKey,
    this.controller,
    this.settings = const DebugPanelSettings(),
    required this.child,
    this.trigger = _defaultTriggers,
    this.enabled = true,
  });

  static Widget _defaultTriggers(BuildContext context, DebugPanelController controller, Widget child) {
    return DebugPanelGlyphTrigger(
      controller: controller,
      child: DebugPanelShortcutTrigger(
        controller: controller,
        child: DebugPanelFloatingButtonTrigger(
          controller: controller,
          child: child,
        ),
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

  final _prefs = DebugPanelPrefStorage();

  bool _screenVisible = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(_toggleScreen);
    controller.enabled = widget.enabled;
  }

  @override
  void didUpdateWidget(covariant DebugPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      controller.removeListener(_toggleScreen);
      _controller = null;
      controller.addListener(_toggleScreen);
    }

    if (oldWidget.enabled != widget.enabled) {
      controller.enabled = widget.enabled;
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
    if (controller.enabled) {
      if (controller.opened && !_screenVisible) {
        _openScreen();
      } else if (!controller.opened && _screenVisible) {
        _closeScreen();
      }
    }
  }

  Future<void> _openScreen() async {
    if (!controller.enabled) return;

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
    if (!controller.enabled) return;

    widget.navigatorKey.currentState?.popUntil(ModalRoute.withName(_screenRouteName));
    widget.navigatorKey.currentState?.pop();
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.child ?? const SizedBox.shrink();
    final overlay = controller.enabled
        ? DebugPanelPrefs(
            storage: _prefs,
            child: widget.trigger(context, controller, body),
          )
        : body;

    if (widget.controller == null && controller.enabled) {
      return DebugPanelDefaultController(
        controller: controller,
        child: overlay,
      );
    } else {
      return overlay;
    }
  }
}
