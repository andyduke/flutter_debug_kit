import 'dart:math' as math;
import 'package:debug_kit/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:flutter/material.dart';

class DefaultCustomTabController extends StatefulWidget {
  final int length;
  final int initialIndex;
  final Widget child;

  const DefaultCustomTabController({
    super.key,
    required this.length,
    this.initialIndex = 0,
    required this.child,
  })  : assert(length >= 0),
        assert(length == 0 || (initialIndex >= 0 && initialIndex < length));

  @override
  State<DefaultCustomTabController> createState() => _DefaultCustomTabControllerState();

  static CustomTabController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CustomTabControllerScope>()?.controller;
  }

  static CustomTabController of(BuildContext context) {
    final CustomTabController? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        throw FlutterError(
          'DefaultCustomTabController.of() was called with a context that does not '
          'contain a DefaultCustomTabController widget.\n'
          'No DefaultCustomTabController widget ancestor could be found starting from '
          'the context that was passed to DefaultCustomTabController.of(). This can '
          'happen because you are using a widget that looks for a DefaultCustomTabController '
          'ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }
}

class _DefaultCustomTabControllerState extends State<DefaultCustomTabController> {
  late CustomTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomTabController(
      length: widget.length,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DefaultCustomTabController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.length != widget.length) {
      // If the length is shortened while the last tab is selected, we should
      // automatically update the index of the controller to be the new last tab.
      int? newIndex;
      int previousIndex = _controller.previousIndex;

      if (_controller.index >= widget.length) {
        newIndex = math.max(0, widget.length - 1);
        previousIndex = _controller.index;
      }

      _controller = _controller.copyWith(
        length: widget.length,
        index: newIndex,
        previousIndex: previousIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CustomTabControllerScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _CustomTabControllerScope extends InheritedWidget {
  const _CustomTabControllerScope({
    required this.controller,
    required super.child,
  });

  final CustomTabController controller;

  @override
  bool updateShouldNotify(_CustomTabControllerScope old) {
    return controller != old.controller;
  }
}
