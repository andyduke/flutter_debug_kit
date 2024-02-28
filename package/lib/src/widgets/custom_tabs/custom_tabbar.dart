import 'dart:math' as math;
import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_panel/src/widgets/custom_tabs/default_custom_tab_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'custom_tab.dart';

typedef CustomTabBarTapCallback = void Function(int index, int prevIndex);

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const defaultTabBarHeight = 42.0;
  static const defaultIsScrollable = true;
  static const defaultDragStartBehavior = DragStartBehavior.start;

  final CustomTabController? controller;
  final List<Widget> tabs;
  final CustomTabBarTapCallback? onTap;
  final double height;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;

  const CustomTabBar({
    super.key,
    this.controller,
    required this.tabs,
    this.onTap,
    this.height = defaultTabBarHeight,
    this.isScrollable = defaultIsScrollable,
    this.padding,
    this.physics,
    this.dragStartBehavior = defaultDragStartBehavior,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize {
    double maxHeight = height;

    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }

    // for (final item in tabs) {
    //   final double? itemHeight = item.height;
    //   if (itemHeight != null) {
    //     maxHeight = math.max(itemHeight, maxHeight);
    //   }
    // }

    return Size.fromHeight(maxHeight);
  }

  // static Set<CustomTabState> statesOf(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<_CustomTabItemViewScope>()?.states ?? <CustomTabState>{};
  // }
}

class _CustomTabBarState extends State<CustomTabBar> {
  CustomTabController? _controller;

  final _scrollController = ScrollController();

  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();

    _updateTabKeys();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateTabController();
    // _scrollToCurrentTab();
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _updateTabController();

      // ???: Adjust scroll position

      _scrollToCurrentTab();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChange);
    _controller = null;

    _scrollController.dispose();

    super.dispose();
  }

  void _updateTabKeys() {
    _tabKeys = widget.tabs.map((tab) => GlobalKey()).toList();
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

    _controller?.removeListener(_handleTabChange);
    _controller = newController;
    _controller?.addListener(_handleTabChange);

    // Update tab keys
    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  void _ensureVisible(BuildContext context) {
    final ScrollableState? scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      final renderObject = context.findRenderObject();
      if (renderObject != null) {
        scrollable.position.ensureVisible(
          renderObject,
          alignment: 0.5,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _scrollToCurrentTab() {
    if (_controller != null) {
      final currentTabContext = _tabKeys[_controller!.index].currentContext;
      if (currentTabContext != null) {
        _ensureVisible(currentTabContext);
      }
    }
  }

  void _handleTabChange() {
    setState(() {});
    _scrollToCurrentTab();
  }

  void _handleTabTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);

    final prevIndex = _controller?.index ?? -1;
    _controller?.index = index;

    widget.onTap?.call(index, prevIndex);
  }

  Widget _buildTab(int index, Widget tab) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTabTap(index),
      child: _CustomTabItemView(
        key: _tabKeys[index],
        isSelected: (index == _controller?.index),
        child: tab,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = List<Widget>.generate(widget.tabs.length, (int index) => _buildTab(index, widget.tabs[index]));

    Widget tabBar = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tabs,
      ),
    );

    if (widget.isScrollable) {
      // The scrolling tabs should not show an overscroll indicator.
      tabBar = ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          overscroll: false,
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            // PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          padding: widget.padding,
          physics: widget.physics,
          child: tabBar,
        ),
      );
    } else if (widget.padding != null) {
      tabBar = Padding(
        padding: widget.padding!,
        child: tabBar,
      );
    }

    return Align(
      heightFactor: 1.0,
      alignment: Alignment.centerLeft, // TODO: COnfigurable
      child: tabBar,
    );
  }
}

// ---

class _CustomTabItemView extends StatefulWidget {
  final Widget child;
  final bool isSelected;

  const _CustomTabItemView({
    super.key,
    required this.child,
    required this.isSelected,
  });

  @override
  State<_CustomTabItemView> createState() => _CustomTabItemViewState();
}

class _CustomTabItemViewState extends State<_CustomTabItemView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // TODO: [1] Wrap all tabs with single CustomTabState extends InheritedModel<int>,
    //       aspect is a tab index.
    //       Use CustomTabState.of(context, index) inside Tab widget to track states changes.
    //       How to get Tab index?

    // TODO: [2] Wrap with InheritedNotifier and get rid of CustomTab!
    //       https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html
    //
    //       Create Notifier widget CustomTabState, wrap each tab
    //       with it and use it inside custom tab to refrect to
    //       state changes:
    //
    //       build(context) {
    //         final states = CustomTabState.of(context);
    //         ...
    //       }

    // TODO: [3] Wrap with CustomTabState:InheritedWidget(states)
    //           Subscribe to tabController, if changed and tabController.index == index -> setState();

    final states = {
      if (widget.isSelected) CustomTabState.selected,
      if (_isHovered) CustomTabState.hovered,
    };

    return MouseRegion(
      // cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      cursor: SystemMouseCursors.click,
      onEnter: (PointerEnterEvent event) => _onHoverChanged(enabled: true),
      onExit: (PointerExitEvent event) => _onHoverChanged(enabled: false),
      child: _CustomTabItemViewScope(
        states: states,
        child: widget.child,
      ),
    );
  }

  void _onHoverChanged({required bool enabled}) {
    setState(() {
      _isHovered = enabled;
    });
  }
}

class _CustomTabItemViewScope extends InheritedWidget {
  final Set<CustomTabState> states;

  const _CustomTabItemViewScope({
    required super.child,
    required this.states,
  });

  @override
  bool updateShouldNotify(covariant _CustomTabItemViewScope oldWidget) => (states != oldWidget.states);
}
