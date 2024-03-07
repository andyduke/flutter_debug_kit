import 'package:debug_panel/src/platform/cupertino.dart';
import 'package:debug_panel/src/platform/material.dart';
import 'package:flutter/material.dart';

@Deprecated('Unused')
class StandaloneNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
  final bool Function()? onCanClose;
  final VoidCallback? onClose;

  const StandaloneNavigator({
    super.key,
    required this.navigatorKey,
    required this.child,
    this.onCanClose,
    this.onClose,
  }) : assert(onClose == null || onCanClose != null);

  @override
  State<StandaloneNavigator> createState() => _StandaloneNavigatorState();
}

class _StandaloneNavigatorState extends State<StandaloneNavigator> {
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
    if (widget.onCanClose?.call() ?? false) {
      bool? handled = await widget.navigatorKey.currentState?.maybePop();
      if (!(handled ?? true)) {
        widget.onClose?.call();
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
    // TODO: Add Overlay

    return HeroControllerScope(
      controller: _heroController!,
      child: Navigator(
        key: widget.navigatorKey,
        pages: [
          MaterialPage(
            child: widget.child,
          ),
        ],
        onPopPage: _handlePopPage,
      ),
    );
  }
}
