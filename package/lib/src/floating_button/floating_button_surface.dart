import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/floating_button/floating_button.dart';
import 'package:debug_panel/src/widgets/movable.dart';
import 'package:flutter/material.dart';

class DebugPanelFloatingButtonSurface extends StatelessWidget {
  final DebugPanelController controller;
  final Widget child;
  final VoidCallback onPressed;

  const DebugPanelFloatingButtonSurface({
    super.key,
    required this.child,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenInsets = controller.buttonVisible ? MediaQuery.viewPaddingOf(context) : EdgeInsets.zero;
    final screenSize = screenInsets.deflateSize(controller.buttonVisible ? MediaQuery.sizeOf(context) : Size.zero);
    final position = Offset(
      (screenSize.width - DebugPanelFloatingButton.buttonSize - 16).clamp(20, double.maxFinite),
      (screenSize.height * 0.8) - (DebugPanelFloatingButton.buttonSize / 2).clamp(20, double.maxFinite),
    );

    return Movable(
      enabled: controller.buttonVisible,
      position: position,
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
        offstage: !controller.buttonVisible,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) => Visibility(
            visible: !controller.opened,
            child: DebugPanelFloatingButton(
              onPressed: onPressed,
            ),
          ),
        ),
      ),
      child: child,
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
  }
}
