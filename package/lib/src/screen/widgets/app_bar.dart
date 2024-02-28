import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/screen/widgets/app_bar_tabs.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class DebugPanelAppBar extends StatelessWidget {
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
    final theme = Theme.of(context);

    return SliverAppBar(
      // Title
      // title: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Container(
      //       decoration: BoxDecoration(
      //         color: theme.colorScheme.background,
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //       padding: const EdgeInsets.all(8),
      //       child: const Text('D'),
      //     ),
      //     const SizedBox(width: 8),
      //     const Text('Debug Panel'),
      //   ],
      // ),
      // centerTitle: false,
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
      toolbarHeight: 44.0,

      // Settings
      floating: true,
      pinned: true,
      //stretch: true,
      snap: false,
      // backgroundColor: Colors.teal,
      scrolledUnderElevation: 0,

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
      /*
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // labelPadding: EdgeInsets.zero,
        tabs: [
          for (var page in pages)
            _Tab(
              icon: page.icon,
              text: page.title,
            ),
        ],
        labelColor: theme.colorScheme.onPrimary,
        // unselectedLabelColor: Colors.black,
        // indicatorSize: TabBarIndicatorSize.label,
        indicatorSize: TabBarIndicatorSize.tab,

        // TODO: Custom decoration with vertical inner spacing
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25,
          ),
          color: theme.colorScheme.primary,
        ),
        onTap: (value) {
          if (!tabController.indexIsChanging && (tabController.index == value)) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        },
      ),
      */
      /*
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: kToolbarHeight),
          // decoration: const BoxDecoration(
          //   color: Colors.teal,
          // ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            },
            child: const Text('Pages tabs'),
          ),
        ),
      ),
      */
    );
  }
}

/*
class _Tab extends StatelessWidget implements PreferredSizeWidget {
  static const double _kTabHeight = 46.0;
  // static const double _kTabHeight = 34.0;

  final String text;
  final IconData? icon;

  const _Tab({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final label = Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon),
          ),

        //
        Text(text),
      ],
    );

    return SizedBox(
      height: _kTabHeight,
      child: Center(
        widthFactor: 1.0,
        child: label,
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(_kTabHeight);
  }
}
*/
