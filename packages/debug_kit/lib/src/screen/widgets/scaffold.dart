import 'package:collection/collection.dart';
import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/screen/widgets/app_bar.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tabbar_view.dart';
import 'package:flutter/material.dart';

class DebugKitPanelScaffold extends StatefulWidget {
  final DebugKitController controller;
  final String? initialPageName;
  final Set<DebugKitPanelBasePage> pages;

  const DebugKitPanelScaffold({
    super.key,
    required this.controller,
    this.initialPageName,
    required this.pages,
  });

  @override
  State<DebugKitPanelScaffold> createState() => _DebugKitPanelScaffoldState();
}

class _DebugKitPanelScaffoldState extends State<DebugKitPanelScaffold> {
  final scrollController = ScrollController();

  late final tabController = CustomTabController(
    initialIndex: initialPageIndex,
    length: widget.pages.length,
  )..addListener(_resetScrollPosition);

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  int get initialPageIndex => (widget.initialPageName == null)
      ? 0
      : widget.pages
          .foldIndexed(0, (index, previous, page) => (page.name == widget.initialPageName) ? index : previous);

  void _resetScrollPosition() {
    if (scrollController.offset > DebugKitPanelAppBar.kToolbarHeight) {
      scrollController.jumpTo(DebugKitPanelAppBar.kToolbarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          DebugKitPanelAppBar(
            pages: widget.pages,
            tabController: tabController,
            scrollController: scrollController,
            onClose: () => widget.controller.close(),
          ),
        ],
        body: CustomTabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            for (var page in widget.pages)
              _DesktopPrimaryScrollController(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: page.build(context, widget.controller),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DesktopPrimaryScrollController extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const _DesktopPrimaryScrollController({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final platform = ScrollConfiguration.of(context).getPlatform(context);
    final isDesktop = (platform == TargetPlatform.windows) ||
        (platform == TargetPlatform.macOS) ||
        (platform == TargetPlatform.linux);

    return isDesktop ? PrimaryScrollController(controller: controller, child: child) : child;
  }
}
