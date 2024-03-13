import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/screen/widgets/app_bar.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tabbar_view.dart';
import 'package:flutter/material.dart';

class DebugPanelScaffold extends StatefulWidget {
  final DebugPanelController controller;
  final Set<DebugPanelBasePage> pages;

  const DebugPanelScaffold({
    super.key,
    required this.controller,
    required this.pages,
  });

  @override
  State<DebugPanelScaffold> createState() => _DebugPanelScaffoldState();
}

class _DebugPanelScaffoldState extends State<DebugPanelScaffold> {
  final scrollController = ScrollController();

  late final tabController = CustomTabController(
    length: widget.pages.length,
  )..addListener(_resetScrollPosition);

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  void _resetScrollPosition() {
    if (scrollController.offset > DebugPanelAppBar.kToolbarHeight) {
      scrollController.jumpTo(DebugPanelAppBar.kToolbarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          DebugPanelAppBar(
            pages: widget.pages,
            tabController: tabController,
            scrollController: scrollController,
            onClose: () => widget.controller.close(),
          ),
        ],
        body: CustomTabBarView(
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
