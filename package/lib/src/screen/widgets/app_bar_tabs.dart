import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/theme/extensions/app_bar_tabs_theme.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class AppBarTabs extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTabs({
    super.key,
    required this.controller,
    required this.pages,
    this.onTopTap,
  });

  final CustomTabController controller;
  final Set<DebugPanelBasePage> pages;
  final VoidCallback? onTopTap;

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final tabTheme = theme.extension<DebugPanelAppBarTabsTheme>()!;

    return CustomTabBar(
      controller: controller,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      tabs: [
        for (var page in pages)
          AppBarTab(
            icon: page.icon,
            text: page.title,
          ),
      ],
      onTap: (int index, int prevIndex) {
        if (prevIndex == index) {
          onTopTap?.call();
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

/*
class AppBarTabs extends CustomTabBar {
  AppBarTabs({
    super.key,
    required super.controller,
    required Set<DebugPanelPage> pages,
  }) : super(
          isScrollable: true,
          tabs: _buildTabs(pages),
        );

  static List<Widget> _buildTabs(Set<DebugPanelPage> pages) {
    return [
      for (var page in pages)
        AppBarTab(
          icon: page.icon,
          text: page.title,
        ),
    ];
  }
}
*/

/*
class AppBarTabBar extends StatelessWidget {
  const AppBarTabBar({
    super.key,
    required this.tabController,
    required this.pages,
  });

  final CustomTabController tabController;
  final Set<DebugPanelPage> pages;

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      controller: tabController,
      isScrollable: true,
      tabs: [
        for (var page in pages)
          AppBarTab(
            icon: page.icon,
            text: page.title,
          ),
      ],
    );
  }
}
*/

class AppBarTab extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double? height;

  const AppBarTab({
    super.key,
    required this.text,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final states = CustomTabState.of(context);
    final theme = Theme.of(context);
    final tabTheme = theme.extension<DebugPanelAppBarTabsTheme>()!;

    // final foreColor = switch (states) {
    //   Set<CustomTabState>() when states.contains(CustomTabState.selected) => tabTheme.selectedTabForeColor,
    //   Set<CustomTabState>() when states.contains(CustomTabState.hovered) => tabTheme.hoveredTabForeColor,
    //   _ => tabTheme.tabForeColor,
    // };

    final foreColor = tabTheme.colors.resolve(states).foreground;

    return Container(
      height: height,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: ShapeDecoration(
          // color: switch (states) {
          //   Set<CustomTabState>() when states.contains(CustomTabState.selected) => tabTheme.selectedTabBackColor,
          //   Set<CustomTabState>() when states.contains(CustomTabState.hovered) => tabTheme.hoveredTabBackColor,
          //   _ => tabTheme.tabBackColor,
          // },
          color: tabTheme.colors.resolve(states).background,
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: foreColor, size: 20),
            const SizedBox(width: 4),
            Text(
              text,
              style: tabTheme.textStyle.apply(color: foreColor),
            ),
            if (icon != null) const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
