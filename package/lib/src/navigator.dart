import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/platform/cupertino.dart';
import 'package:debug_panel/src/platform/material.dart';
import 'package:flutter/material.dart';

@Deprecated('Legacy')
class DebugPanelNavigator extends StatefulWidget {
  final DebugPanelController controller;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const DebugPanelNavigator({
    super.key,
    required this.controller,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<DebugPanelNavigator> createState() => _DebugPanelNavigatorState();
}

class _DebugPanelNavigatorState extends State<DebugPanelNavigator> {
  HeroController? _heroController;
  BackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Create a HeroController based on the app type.
    if (_heroController == null) {
      if (isMaterialApp(context)) {
        _heroController = createMaterialHeroController();
      } else if (isCupertinoApp(context)) {
        _heroController = createCupertinoHeroController();
      } else {
        _heroController = HeroController();
      }
    }

    if (_backButtonDispatcher == null) {
      BackButtonDispatcher? parentDispatcher = Router.maybeOf(context)?.backButtonDispatcher;
      _backButtonDispatcher = parentDispatcher?.createChildBackButtonDispatcher() ?? RootBackButtonDispatcher();
      _backButtonDispatcher!.takePriority();
      _backButtonDispatcher!.addCallback(_dispatchBackButton);
    }
  }

  @override
  void dispose() {
    _backButtonDispatcher?.removeCallback(_dispatchBackButton);

    super.dispose();
  }

  Future<bool> _dispatchBackButton() async {
    if (widget.controller.opened) {
      bool? handled = await widget.navigatorKey.currentState?.maybePop();
      if (!(handled ?? true)) {
        widget.controller.close();
      }
      return true;
    }

    return false;
  }

  bool _handlePopPage(Route<Object?> route, Object? result) {
    if (route.willHandlePopInternally) {
      final bool popped = route.didPop(result);
      assert(!popped);
      return popped;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add PageStorage
    // TODO: Add ScaffoldMessenger

    return HeroControllerScope(
      controller: _heroController!,
      child: Navigator(
        key: widget.navigatorKey,
        pages: [
          MaterialPage(child: widget.child),
        ],
        onPopPage: _handlePopPage,
      ),
    );
  }
}
