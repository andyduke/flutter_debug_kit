import 'package:flutter/material.dart';

class DebugPanelOverlay extends StatelessWidget {
  final Widget child;
  final WidgetBuilder builder;

  const DebugPanelOverlay({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        //
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 1,
                  child: Scaffold(
                    body: builder(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
