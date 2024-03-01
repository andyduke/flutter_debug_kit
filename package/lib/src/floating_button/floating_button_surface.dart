import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/floating_button/floating_button.dart';
import 'package:debug_panel/src/widgets/movable.dart';
import 'package:flutter/material.dart';

class DebugPanelFloatingButtonSurface extends StatefulWidget {
  final DebugPanelController controller;
  final Widget child;

  const DebugPanelFloatingButtonSurface({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<DebugPanelFloatingButtonSurface> createState() => _DebugPanelFloatingButtonSurfaceState();
}

class _DebugPanelFloatingButtonSurfaceState extends State<DebugPanelFloatingButtonSurface> {
  final _overlayKey = GlobalKey(debugLabel: 'DebugPanel.FloatingButon.Overlay');

  bool _ready = false;
  double _top = 0;
  double _left = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_ready) {
      _top = (MediaQuery.of(context).size.height * 0.75) - (DebugPanelFloatingButton.buttonSize * 1.2);
      _left = MediaQuery.of(context).size.width - (DebugPanelFloatingButton.buttonSize * 1.2);
      _ready = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     widget.child,

    //     // Floating button
    //     Positioned(
    //       top: _top,
    //       left: _left,
    //       child: Offstage(
    //         offstage: !widget.controller.buttonVisible,

    //         // TODO: Draggable
    //         child: DebugPanelFloatingButton(
    //           onPressed: () {
    //             widget.controller.open();
    //           },
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    final screenInsets = widget.controller.buttonVisible ? MediaQuery.viewPaddingOf(context) : EdgeInsets.zero;
    final screenSize =
        screenInsets.deflateSize(widget.controller.buttonVisible ? MediaQuery.sizeOf(context) : Size.zero);

    return Movable(
      enabled: widget.controller.buttonVisible,
      position: Offset(
        (screenSize.width - DebugPanelFloatingButton.buttonSize - 16).clamp(20, double.maxFinite),
        (screenSize.height * 0.8) - (DebugPanelFloatingButton.buttonSize / 2).clamp(20, double.maxFinite),
      ),
      size: const Size(DebugPanelFloatingButton.buttonSize, DebugPanelFloatingButton.buttonSize), // TODO: DEBUG
      bounds: Rect.fromLTWH(screenInsets.left, screenInsets.top, screenSize.width, screenSize.height),
      onMoveEnd: (position) {
        // TODO: Save movable position
        print('Moved to: $position');
      },
      // onPressed: () {
      //   widget.controller.open();
      // },
      movable: Offstage(
        offstage: !widget.controller.buttonVisible,
        child: DebugPanelFloatingButton(
          onPressed: () {
            widget.controller.open();
          },
        ),
      ),
      child: widget.child,
    );
  }
}
