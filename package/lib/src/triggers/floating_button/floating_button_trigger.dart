import 'dart:async';

import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pref_storage/prefs.dart';
import 'package:debug_panel/src/triggers/floating_button/floating_button.dart';
import 'package:debug_panel/src/widgets/movable.dart';
import 'package:flutter/material.dart';

class DebugPanelFloatingButtonTrigger extends StatefulWidget {
  static const positionStorageKey = 'debug_panel_floating_button_position';

  // TODO: Initial position
  final DebugPanelController controller;
  final Widget child;
  final VoidCallback? onPressed;

  const DebugPanelFloatingButtonTrigger({
    super.key,
    required this.child,
    required this.controller,
    this.onPressed,
  });

  @override
  State<DebugPanelFloatingButtonTrigger> createState() => _DebugPanelFloatingButtonTriggerState();
}

class _DebugPanelFloatingButtonTriggerState extends State<DebugPanelFloatingButtonTrigger> {
  final ready = Completer();
  Offset? position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!ready.isCompleted) {
      _loadPosition();
    }
  }

  Future<void> _loadPosition() async {
    final prefStorage = DebugPanelPrefs.maybeOf(context);
    position = await prefStorage?.get<Offset>(DebugPanelFloatingButtonTrigger.positionStorageKey);
    ready.complete();
  }

  @override
  Widget build(BuildContext context) {
    final prefStorage = DebugPanelPrefs.maybeOf(context);
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
              (screenSize.width - DebugPanelFloatingButton.buttonSize - 16).clamp(screenInsets.left, double.maxFinite),
              (screenSize.height * 0.8) -
                  (DebugPanelFloatingButton.buttonSize / 2).clamp(screenInsets.top, double.maxFinite),
            );

        return Movable(
          enabled: widget.controller.buttonVisible,
          position: currentPosition,
          size: const Size.square(DebugPanelFloatingButton.buttonSize),
          bounds: Rect.fromLTWH(screenInsets.left, screenInsets.top, screenSize.width, screenSize.height),
          onMoveEnd: (position) {
            // print('Moved to: $position');
            prefStorage?.set<Offset>(DebugPanelFloatingButtonTrigger.positionStorageKey, position);
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
                child: DebugPanelFloatingButton(
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
