import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/screen/widgets/app_bar_tabs.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:flutter/material.dart';

class DebugPanelAppBar extends StatelessWidget {
  static const kToolbarHeight = 44.0;

  // final TabController tabController;
  final CustomTabController tabController;
  final ScrollController scrollController;
  final Set<DebugPanelBasePage> pages;
  final VoidCallback? onClose;

  const DebugPanelAppBar({
    super.key,
    required this.tabController,
    required this.scrollController,
    required this.pages,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // Title
      title: const Padding(
        padding: EdgeInsets.only(top: 9),
        child: Text('Debug Panel'),
      ),
      actions: [
        if (onClose != null)
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ),
        const SizedBox(width: 8),
      ],
      toolbarHeight: kToolbarHeight,

      // Settings
      floating: true,
      pinned: true,
      snap: false,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,

      // Tabs
      bottom: AppBarTabs(
        controller: tabController,
        pages: pages,
        onTopTap: () {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }
}
