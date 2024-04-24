import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/screen/widgets/app_bar_tabs.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:flutter/material.dart';

class DebugKitPanelAppBar extends StatelessWidget {
  static const kToolbarHeight = 44.0;

  final bool floating;
  // final TabController tabController;
  final CustomTabController tabController;
  final ScrollController scrollController;
  final Set<DebugKitPanelBasePage> pages;
  final VoidCallback? onClose;
  final VoidCallback? onTop;

  const DebugKitPanelAppBar({
    super.key,
    this.floating = true,
    required this.tabController,
    required this.scrollController,
    required this.pages,
    this.onClose,
    this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // Title
      title: const Padding(
        padding: EdgeInsets.only(top: 9),
        child: Text('DebugKit Panel'),
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
      floating: floating,
      pinned: true,
      snap: false,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,

      // Tabs
      bottom: AppBarTabs(
        controller: tabController,
        pages: pages,
        onTopTap: () {
          onTop?.call();
        },
      ),
    );
  }
}
