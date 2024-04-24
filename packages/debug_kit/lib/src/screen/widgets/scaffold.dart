import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/screen/widgets/app_bar.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tab_controller.dart';
import 'package:flutter/foundation.dart';
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
  final nestedScrollKey = GlobalKey<NestedScrollViewState>(debugLabel: 'DebugKit:Scaffold:NestedScrollView');

  final scrollController = ScrollController(
    keepScrollOffset: false,
  );

  ScrollController get innerScrollController => nestedScrollKey.currentState?.innerController ?? scrollController;

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

  bool get isDesktop {
    final platform = Theme.of(context).platform;
    return kIsWeb ||
        (platform == TargetPlatform.linux) ||
        (platform == TargetPlatform.macOS) ||
        (platform == TargetPlatform.windows);
  }

  int get initialPageIndex => (widget.initialPageName == null)
      ? 0
      : widget.pages
          .foldIndexed(0, (index, previous, page) => (page.name == widget.initialPageName) ? index : previous);

  void _resetScrollPosition() {
    final offset = isDesktop ? 0.0 : DebugKitPanelAppBar.kToolbarHeight;
    if (scrollController.offset > offset) {
      scrollController.jumpTo(offset);
    }
  }

  void _scrollToTop(BuildContext context) {
    innerScrollController.animateTo(
      -(2 * DebugKitPanelAppBar.kToolbarHeight), // AppBar full height
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Widget _pageSwitchTransitionBuilder(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    final enterTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );
    final exitTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    );

    return SlideTransition(
      position: exitTween.animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: enterTween.animate(
          CurvedAnimation(
            parent: primaryAnimation,
            curve: Curves.easeIn,
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      // Hide scrollbars as they break animations and cause crashes due to issues with multiple subscribers.
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scaffold(
        body: NestedScrollView(
          key: nestedScrollKey,
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            /*
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: DebugKitPanelAppBar(
                floating: !isDesktop,
                pages: widget.pages,
                tabController: tabController,
                scrollController: scrollController,
                onClose: () => widget.controller.close(),
              ),
            ),
            */
            DebugKitPanelAppBar(
              floating: !isDesktop,
              pages: widget.pages,
              tabController: tabController,
              scrollController: scrollController,
              onClose: () => widget.controller.close(),
              onTop: () => _scrollToTop(context),
            ),
          ],
          body: ListenableBuilder(
            listenable: tabController,
            builder: (context, child) {
              return Scrollbar(
                thumbVisibility: isDesktop,
                interactive: isDesktop,
                controller: innerScrollController,
                child: PageTransitionSwitcher(
                  reverse: (tabController.previousIndex > tabController.index),
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: _pageSwitchTransitionBuilder,
                  child: SizedBox.expand(
                    key: ValueKey(tabController.index),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: widget.pages.elementAt(tabController.index).build(context, widget.controller),
                    ),
                  ),
                ),
              );
            },
          ),
          /*
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
          */
        ),
      ),
    );
  }
}

/*
class _DesktopPrimaryScrollController extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const _DesktopPrimaryScrollController({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    /*
    return CustomScrollView(
      // primary: false,
      // controller: controller,
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: PrimaryScrollController(
            controller: controller,
            child: child,
          ),
        ),
      ],
    );
    */

    // return child;

    /*
    return PrimaryScrollController(
      automaticallyInheritForPlatforms: const {
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.fuchsia,
      },
      controller: controller,
      child: child,
    );
    */

    return PrimaryScrollController.none(child: child);

    /*
    final platform = ScrollConfiguration.of(context).getPlatform(context);
    final isDesktop = kIsWeb ||
        (platform == TargetPlatform.windows) ||
        (platform == TargetPlatform.macOS) ||
        (platform == TargetPlatform.linux);

    return isDesktop
        ? PrimaryScrollController(
            controller: controller,
            automaticallyInheritForPlatforms: const {
              /*
              TargetPlatform.windows,
              TargetPlatform.macOS,
              TargetPlatform.linux,
              TargetPlatform.android,
              TargetPlatform.iOS,
              TargetPlatform.fuchsia,
              */
            },
            child: child,
          )
        : child;
    */
  }
}
*/
