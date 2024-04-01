import 'dart:async';
import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pref_storage/prefs.dart';
import 'package:debug_kit/src/triggers/floating_button/floating_button.dart';
import 'package:debug_kit/src/triggers/trigger.dart';
import 'package:debug_kit/src/widgets/movable.dart';
import 'package:flutter/material.dart';

class DebugKitFloatingButtonTrigger extends StatefulWidget {
  static const name = 'debug_kit_floating_button';

  static DebugKitTrigger setup() {
    return DebugKitTrigger(
      name: name,
      builder: (context, controller, child) => DebugKitFloatingButtonTrigger(
        controller: controller,
        child: child,
      ),
    );
  }

  static const positionStorageKey = 'debug_kit_floating_button_position';

  // TODO: Initial position
  final DebugKitController controller;
  final Widget child;
  final VoidCallback? onPressed;

  const DebugKitFloatingButtonTrigger({
    super.key,
    required this.child,
    required this.controller,
    this.onPressed,
  });

  @override
  State<DebugKitFloatingButtonTrigger> createState() => _DebugKitFloatingButtonTriggerState();
}

class _DebugKitFloatingButtonTriggerState extends State<DebugKitFloatingButtonTrigger> {
  final ready = Completer();
  bool loading = false;
  Offset? position;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant DebugKitFloatingButtonTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);

    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loading && !ready.isCompleted) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    loading = true;

    final prefStorage = DebugKitPrefs.maybeOf(context);
    position = await prefStorage?.get<Offset>(DebugKitFloatingButtonTrigger.positionStorageKey);

    // TODO: Load button visibility from Shared prefs

    ready.complete();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final prefStorage = DebugKitPrefs.maybeOf(context);
    final screenInsets = widget.controller.buttonVisible ? MediaQuery.viewPaddingOf(context) : EdgeInsets.zero;
    final screenSize =
        screenInsets.deflateSize(widget.controller.buttonVisible ? MediaQuery.sizeOf(context) : Size.zero);

    return FutureBuilder(
      future: ready.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final currentPosition = position ??
            Offset(
              (screenSize.width - DebugKitFloatingButton.buttonSize - 16).clamp(screenInsets.left, double.maxFinite),
              (screenSize.height * 0.8) -
                  (DebugKitFloatingButton.buttonSize / 2).clamp(screenInsets.top, double.maxFinite),
            );

        return Movable(
          enabled: widget.controller.buttonVisible,
          position: currentPosition,
          size: const Size.square(DebugKitFloatingButton.buttonSize),
          bounds: Rect.fromLTWH(screenInsets.left, screenInsets.top, screenSize.width, screenSize.height),
          onMoveEnd: (position) {
            // print('Moved to: $position');
            prefStorage?.set<Offset>(DebugKitFloatingButtonTrigger.positionStorageKey, position);
          },
          // onPressed: () {
          //   widget.controller.open();
          // },
          movable: Offstage(
            offstage: !widget.controller.buttonVisible,
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, child) => Visibility(
                visible: !widget.controller.opened,
                child: DebugKitFloatingButton(
                  onPressed: widget.onPressed ?? () => widget.controller.open(),
                ),
              ),
            ),
          ),
          child: widget.child,
          /*
        // TODO: DEBUG
        child: Stack(
          children: [
            child,
            Positioned(
              top: 100,
              left: 100,
              child: Material(
                type: MaterialType.canvas,
                child: Container(
                  width: 200,
                  color: Colors.amber,
                  padding: const EdgeInsets.all(12),
                  child: Text('''
      Screen insets: $screenInsets\n
      Screen size: $screenSize\n
      Position: $position\n
      Viewport bounds: ${Rect.fromLTWH(screenInsets.left, screenInsets.top, screenSize.width, screenSize.height)}
      '''),
                ),
              ),
            ),
          ],
        ),
        */
        );
      },
    );
  }
}
