import 'package:debug_panel/debug_panel.dart';
import 'package:flutter/material.dart';

class DebugPanelOverlay extends StatefulWidget {
  final DebugPanelController controller;
  final Widget child;
  final WidgetBuilder builder;

  const DebugPanelOverlay({
    super.key,
    required this.controller,
    required this.child,
    required this.builder,
  });

  @override
  State<DebugPanelOverlay> createState() => _DebugPanelOverlayState();
}

class _DebugPanelOverlayState extends State<DebugPanelOverlay> {
  static const kAnimationDuration = Duration(milliseconds: 250);

  late DebugPanelController controller = widget.controller;

  bool get visible => controller.opened;

  Widget get body => visible ? _buildBody() : const SizedBox.shrink(key: ValueKey('DebugPanelOverlay: Dummy'));

  @override
  void initState() {
    super.initState();

    controller.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant DebugPanelOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      controller.removeListener(_update);
      controller = widget.controller;
      controller.addListener(_update);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_update);

    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  Widget _buildBody() {
    return KeyedSubtree(
      key: const ValueKey('DebugPanelOverlay: View'),
      child: widget.builder(context),
    );

    /*
    return Container(
      key: const ValueKey('DebugPanelOverlay: View'),
      color: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          // const Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                controller.close();
              },
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Scaffold(
              body: widget.builder(context),
            ),
          ),
        ],
      ),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Backdrop
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              duration: kAnimationDuration,
              curve: visible ? Curves.easeIn : Curves.easeInBack,
              opacity: !visible ? 0 : 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),

        // Body
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedSwitcher(
              duration: kAnimationDuration,
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  key: ValueKey<Key?>(child.key),
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: body,
            ),
          ),
        ),
      ],
    );
  }
}
