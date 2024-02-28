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

class _DebugPanelScaffoldState extends State<DebugPanelScaffold> /* with SingleTickerProviderStateMixin */ {
  final scrollController = ScrollController();
  // late final tabController = TabController(
  //   vsync: this,
  //   length: widget.pages.length,
  // );

  late final tabController = CustomTabController(
    length: widget.pages.length,
  );

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();

    super.dispose();
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
              Container(
                width: double.infinity,
                alignment: Alignment.topLeft,
                child: page.build(context),
              ),
          ],
        ),
        /* TODO: DEBUG
        body: TabBarView(
          controller: tabController,
          children: [
            for (var page in widget.pages)
              Container(
                alignment: Alignment.center,
                child: Text('$page'),
              ),
          ],
        ),
        */
      ),
    );
  }
}
