import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:flutter/material.dart';

abstract class DebugPanelPageBaseSection {
  final String name;
  final String title;
  final String? subtitle;
  final String? footnote;
  final bool? collapsed;

  Widget build(BuildContext context, DebugPanelController controller);

  DebugPanelPageBaseSection({
    required this.name,
    required this.title,
    this.subtitle,
    this.footnote,
    this.collapsed,
  });

  @override
  bool operator ==(covariant DebugPanelPageBaseSection other) =>
      (runtimeType == other.runtimeType) && (name == other.name);

  @override
  int get hashCode => name.hashCode;
}

typedef DebugPanelWidgetBuilder = Widget Function(BuildContext context, DebugPanelController controller);

class DebugPanelPageSection extends DebugPanelPageBaseSection {
  final DebugPanelWidgetBuilder builder;

  DebugPanelPageSection({
    required super.name,
    required super.title,
    super.subtitle,
    super.footnote,
    super.collapsed,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, DebugPanelController controller) => builder(context, controller);
}

class DebugPanelPage extends DebugPanelBasePage {
  final Set<DebugPanelPageBaseSection> sections;

  DebugPanelPage({
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
  Widget build(BuildContext context, DebugPanelController controller) {
    return SingleChildScrollView(
      child: Container(
        padding: DebugPanelBasePage.defaultPadding,
        child: Column(
          children: [
            // Sections
            for (var section in sections)
              _DebugPanelPageSectionView(
                section: section,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}

class _DebugPanelPageSectionView extends StatefulWidget {
  final DebugPanelPageBaseSection section;
  final DebugPanelController controller;

  const _DebugPanelPageSectionView({
    required this.section,
    required this.controller,
  });

  @override
  State<_DebugPanelPageSectionView> createState() => _DebugPanelPageSectionViewState();
}

class _DebugPanelPageSectionViewState extends State<_DebugPanelPageSectionView> {
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
