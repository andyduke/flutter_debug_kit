import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:flutter/material.dart';

abstract class DebugKitPanelPageBaseSection {
  final String name;
  final String title;
  final String? subtitle;
  final String? footnote;
  final bool? collapsed;

  Widget build(BuildContext context, DebugKitController controller);

  DebugKitPanelPageBaseSection({
    required this.name,
    required this.title,
    this.subtitle,
    this.footnote,
    this.collapsed,
  });

  @override
  bool operator ==(covariant DebugKitPanelPageBaseSection other) =>
      (runtimeType == other.runtimeType) && (name == other.name);

  @override
  int get hashCode => name.hashCode;
}

typedef DebugKitPanelWidgetBuilder = Widget Function(BuildContext context, DebugKitController controller);

class DebugKitPanelPageSection extends DebugKitPanelPageBaseSection {
  final DebugKitPanelWidgetBuilder builder;

  DebugKitPanelPageSection({
    required super.name,
    required super.title,
    super.subtitle,
    super.footnote,
    super.collapsed,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, DebugKitController controller) => builder(context, controller);
}

class DebugKitPanelPage extends DebugKitPanelBasePage {
  final Set<DebugKitPanelPageBaseSection> sections;

  DebugKitPanelPage({
    required this.name,
    required this.title,
    this.icon,
    this.sections = const {},
  });

  @override
  final String name;

  @override
  final String title;

  @override
  final IconData? icon;

  @override
  Widget build(BuildContext context, DebugKitController controller) {
    return SingleChildScrollView(
      child: Container(
        padding: DebugKitPanelBasePage.defaultPadding,
        child: Column(
          children: [
            // Sections
            for (var section in sections)
              _DebugKitPanelPageSectionView(
                section: section,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}

class _DebugKitPanelPageSectionView extends StatefulWidget {
  final DebugKitPanelPageBaseSection section;
  final DebugKitController controller;

  const _DebugKitPanelPageSectionView({
    required this.section,
    required this.controller,
  });

  @override
  State<_DebugKitPanelPageSectionView> createState() => _DebugKitPanelPageSectionViewState();
}

class _DebugKitPanelPageSectionViewState extends State<_DebugKitPanelPageSectionView> {
  late bool _isCollapsed = widget.section.collapsed ?? false;
  final _bodyKey = const ValueKey('sectionBody');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          GestureDetector(
            onTap: () {
              if (widget.section.collapsed != null) {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              }
            },
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: (widget.section.collapsed != null) ? SystemMouseCursors.click : MouseCursor.defer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(widget.section.title, style: theme.textTheme.titleMedium),
                  ),

                  //
                  if (widget.section.collapsed != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 2),
                      child: Icon(
                        _isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        size: 24,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Body
          if (!_isCollapsed)
            KeyedSubtree(
              key: _bodyKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subtitle
                    if (widget.section.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(widget.section.subtitle!, style: theme.textTheme.bodySmall),
                      ),

                    // Section body
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: widget.section.build(context, widget.controller),
                    ),

                    // Footnote
                    if (widget.section.footnote != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(widget.section.footnote!, style: theme.textTheme.bodySmall),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
