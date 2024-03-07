import 'package:debug_panel/debug_panel.dart';
import 'package:debug_panel/src/widgets/standalone_navigator.dart';
import 'package:flutter/material.dart';

/*
class DebugPanelOverlay extends StatefulWidget {
  // final GlobalKey<NavigatorState> navigatorKey;
  final DebugPanelController controller;
  final Widget child;
  final WidgetBuilder builder;

  const DebugPanelOverlay({
    super.key,
    // required this.navigatorKey,
    required this.controller,
    required this.child,
    required this.builder,
  });

  @override
  State<DebugPanelOverlay> createState() => _DebugPanelOverlayState();
}

class _DebugPanelOverlayState extends State<DebugPanelOverlay> {
  static const kAnimationDuration = Duration(milliseconds: 250);

  final debugNavigatorKey = GlobalKey<NavigatorState>();

  bool get visible => widget.controller.opened;

  Widget _buildBody({required Key key}) {
    return StandaloneNavigator(
      key: key,
      navigatorKey: debugNavigatorKey,
      onCanClose: () => widget.controller.opened,
      onClose: () => widget.controller.close(),
      child: widget.builder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Backdrop
        Positioned.fill(
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) => _FadeSwitcher(
              duration: kAnimationDuration,
              child: visible
                  ? const _Backdrop(key: ValueKey('DebugPanel.Backdrop'))
                  : const SizedBox.shrink(key: ValueKey('DebugPanel.Backdrop.Dummy')),
            ),
          ),
        ),

        // Body
        Positioned.fill(
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) => _SlideSwitcher(
              duration: kAnimationDuration,
              child: visible
                  ? _buildBody(key: const ValueKey('DebugPanel.Overlay.Body'))
                  : const SizedBox.shrink(key: ValueKey('DebugPanel.Overlay.Dummy')),
            ),
          ),
        ),
      ],
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: const SizedBox.expand(),
    );
  }
}

class _FadeSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const _FadeSwitcher({
    super.key,
    required this.child,
    this.duration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: child,
    );
  }
}

class _SlideSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const _SlideSwitcher({
    super.key,
    required this.child,
    this.duration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
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
      // child: body,
      child: child,
    );
  }
}
*/