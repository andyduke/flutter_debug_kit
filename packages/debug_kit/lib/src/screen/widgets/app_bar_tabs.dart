import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/theme/extensions/app_bar_tabs_theme.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class AppBarTabs extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTabs({
    super.key,
    required this.controller,
    required this.pages,
    this.onTopTap,
  });

  final CustomTabController controller;
  final Set<DebugKitPanelBasePage> pages;
  final VoidCallback? onTopTap;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false, scrollbars: false),
      child: CustomTabBar(
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

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
    final tabTheme = theme.extension<DebugKitPanelAppBarTabsTheme>()!;

    final foreColor = tabTheme.colors.resolve(states).foreground;

    return Container(
      height: height,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: ShapeDecoration(
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
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
