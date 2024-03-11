import 'package:debug_panel/src/pages/base_page.dart';
import 'package:flutter/material.dart';

abstract class DebugPanelPageBaseSection {
  abstract final String name;
  abstract final String title;
  abstract final String? note;
  abstract final bool? collapsed;
  abstract final WidgetBuilder builder;
}

class DebugPanelPageSection extends DebugPanelPageBaseSection {
  @override
  final String name;

  @override
  final String title;

  @override
  final String? note;

  @override
  final bool? collapsed;

  @override
  final WidgetBuilder builder;

  DebugPanelPageSection({
    required this.name,
    required this.title,
    this.note,
    this.collapsed,
    required this.builder,
  });

  @override
  bool operator ==(covariant DebugPanelPageBaseSection other) =>
      (runtimeType == other.runtimeType) && (name == other.name);

  @override
  int get hashCode => name.hashCode;
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: DebugPanelBasePage.defaultPadding,
        child: Column(
          children: [
            // Sections
            for (var section in sections) _DebugPanelPageSectionView(section: section),
          ],
        ),
      ),
    );
  }
}

class _DebugPanelPageSectionView extends StatefulWidget {
  final DebugPanelPageBaseSection section;

  const _DebugPanelPageSectionView({
    required this.section,
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
      padding: const EdgeInsets.only(bottom: 16),
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
              cursor: SystemMouseCursors.click,
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
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.section.builder(context),

                    // Note
                    if (widget.section.note != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(widget.section.note!, style: theme.textTheme.bodySmall),
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
