import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_panel/src/widgets/custom_tabs/default_custom_tab_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class CustomTabBarView extends StatefulWidget {
  final CustomTabController? controller;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  const CustomTabBarView({
    super.key,
    this.controller,
    required this.children,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView> {
  CustomTabController? _controller;
  PageController? _pageController;
  late List<Widget> _childrenWithKey;
  int? _currentIndex;
  int _warpUnderwayCount = 0;
  int _scrollUnderwayCount = 0;

  final animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateTabController();
    _currentIndex = _controller!.index;

    // TODO(chunhtai): https://github.com/flutter/flutter/issues/134253
    _pageController?.dispose();
    _pageController = PageController(
      initialPage: _currentIndex!,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void didUpdateWidget(CustomTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _currentIndex = _controller!.index;
      _jumpToPage(_currentIndex!);
    }

    if (widget.viewportFraction != oldWidget.viewportFraction) {
      _pageController?.dispose();
      _pageController = PageController(
        initialPage: _currentIndex!,
        viewportFraction: widget.viewportFraction,
      );
    }

    // While a warp is under way, we stop updating the tab page contents.
    // This is tracked in https://github.com/flutter/flutter/issues/31269.
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0) {
      _updateChildren();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabControllerChange);
    _controller = null;
    _pageController?.dispose();

    super.dispose();
  }

  void _updateChildren() {
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  void _updateTabController() {
    final CustomTabController? newController = widget.controller ?? DefaultCustomTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No CustomTabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'CustomTabController using the "controller" property, or you must ensure that there '
          'is a DefaultCustomTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    _controller?.removeListener(_handleTabControllerChange);
    _controller = newController;
    _controller?.addListener(_handleTabControllerChange);
  }

  void _jumpToPage(int page) {
    _warpUnderwayCount += 1;
    _pageController!.jumpToPage(page);
    _warpUnderwayCount -= 1;
  }

  Future<void> _animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) async {
    _warpUnderwayCount += 1;
    await _pageController!.animateToPage(page, duration: duration, curve: curve);
    _warpUnderwayCount -= 1;
  }

  void _handleTabControllerChange() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      _warpToCurrentIndex();
    }
  }

  void _warpToCurrentIndex() {
    if (!mounted || _pageController!.page == _currentIndex!.toDouble()) {
      return;
    }

    final bool adjacentDestination = (_currentIndex! - _controller!.previousIndex).abs() == 1;
    if (adjacentDestination) {
      _warpToAdjacentTab(animationDuration);
    } else {
      _warpToNonAdjacentTab(animationDuration);
    }
  }

  Future<void> _warpToAdjacentTab(Duration duration) async {
    if (duration == Duration.zero) {
      _jumpToPage(_currentIndex!);
    } else {
      await _animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
    }
    if (mounted) {
      setState(() {
        _updateChildren();
      });
    }
    return Future<void>.value();
  }

  Future<void> _warpToNonAdjacentTab(Duration duration) async {
    final int previousIndex = _controller!.previousIndex;
    assert((_currentIndex! - previousIndex).abs() > 1);

    // initialPage defines which page is shown when starting the animation.
    // This page is adjacent to the destination page.
    final int initialPage = _currentIndex! > previousIndex ? _currentIndex! - 1 : _currentIndex! + 1;

    setState(() {
      // Needed for `RenderSliverMultiBoxAdaptor.move` and kept alive children.
      // For motivation, see https://github.com/flutter/flutter/pull/29188 and
      // https://github.com/flutter/flutter/issues/27010#issuecomment-486475152.
      _childrenWithKey = List<Widget>.of(_childrenWithKey, growable: false);
      final Widget temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });

    // Make a first jump to the adjacent page.
    _jumpToPage(initialPage);

    // Jump or animate to the destination page.
    if (duration == Duration.zero) {
      _jumpToPage(_currentIndex!);
    } else {
      await _animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
    }

    if (mounted) {
      setState(() {
        _updateChildren();
      });
    }
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0 || _scrollUnderwayCount > 0) {
      return false;
    }

    if (notification.depth != 0) {
      return false;
    }

    _scrollUnderwayCount += 1;
    final double page = _pageController!.page!;
    if (notification is ScrollUpdateNotification) {
      final bool pageChanged = (page - _controller!.index).abs() > 0.6;
      if (pageChanged) {
        _controller!.index = page.round();
        _currentIndex = _controller!.index;
      }
    } else if (notification is ScrollEndNotification) {
      _controller!.index = page.round();
      _currentIndex = _controller!.index;
    }
    _scrollUnderwayCount -= 1;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView(
        dragStartBehavior: widget.dragStartBehavior,
        clipBehavior: widget.clipBehavior,
        controller: _pageController,
        physics: widget.physics == null
            ? const PageScrollPhysics().applyTo(const ClampingScrollPhysics())
            : const PageScrollPhysics().applyTo(widget.physics),
        children: _childrenWithKey,
      ),
    );
  }
}
