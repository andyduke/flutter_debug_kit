import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pref_storage/pref_storage.dart';
import 'package:debug_kit/src/pref_storage/prefs.dart';
import 'package:debug_kit/src/screen/screen.dart';
import 'package:debug_kit/src/screen_route.dart';
import 'package:debug_kit/src/settings.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// TODO: Add triggers:
//   - DebugKitShakeTrigger - show debug panel on shake
//   - DebugKitTwoFingersTrigger - show panel with two fingers hold

class DebugKit extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final DebugKitController? controller;
  final DebugKitBaseSettings settings;
  final Widget? child;
  final bool enabled;

  const DebugKit({
    super.key,
    required this.navigatorKey,
    this.controller,
    this.settings = const DebugKitSettings(),
    required this.child,
    this.enabled = true,
  });

  @override
  State<DebugKit> createState() => DebugKitState();
}

@internal
class DebugKitState extends State<DebugKit> {
  static const _screenRouteName = '/debug_kit_panel_screen';

  DebugKitController get controller =>
      _controller ??= (widget.controller ?? DebugKitController(buttonVisible: widget.settings.buttonVisible));
  DebugKitController? _controller;

  final _prefs = DebugKitPrefStorage();

  bool _screenVisible = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(_toggleScreen);
    controller.enabled = widget.enabled;
  }

  @override
  void didUpdateWidget(covariant DebugKit oldWidget) {
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
        DebugKitPanelScreenRoute(
          settings: const RouteSettings(name: _screenRouteName),
          builder: (context) => DebugKitPanelScreen(
            controller: controller,
            initialPageName: controller.initialPageName,
            pages: widget.settings.pages,
          ),
        ),
      );

      controller.initialPageName = null;
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

  Widget _buildTriggers(Widget child) {
    Widget result = child;

    for (var trigger in widget.settings.triggers) {
      result = trigger.builder(context, controller, result);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.child ?? const SizedBox.shrink();
    final overlay = controller.enabled
        ? DebugKitPrefs(
            storage: _prefs,
            child: _buildTriggers(body),
          )
        : body;

    if (widget.controller == null && controller.enabled) {
      return DebugKitDefaultController(
        controller: controller,
        child: overlay,
      );
    } else {
      return overlay;
    }
  }
}
