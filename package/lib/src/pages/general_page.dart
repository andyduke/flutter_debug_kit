import 'package:debug_panel/src/pages/base_page.dart';
import 'package:flutter/material.dart';

abstract class DebugPanelGeneralPageBaseSection {
  abstract final String title;
  abstract final String? note;
  abstract final bool collapsed;
  abstract final WidgetBuilder builder;
}

class DebugPanelGeneralPageSection extends DebugPanelGeneralPageBaseSection {
  static const defaultCollapsed = false;

  @override
  final String title;

  @override
  final String? note;

  @override
  final bool collapsed;

  @override
  final WidgetBuilder builder;

  DebugPanelGeneralPageSection({
    required this.title,
    required this.note,
    this.collapsed = defaultCollapsed,
    required this.builder,
  });
}

// TODO: Refactor - composite from DebugPanelPage
class DebugPanelGeneralPage extends DebugPanelBasePage {
  final List<DebugPanelGeneralPageBaseSection> sections;

  DebugPanelGeneralPage({
    this.sections = const [],
  });

  @override
  String get name => 'general';

  @override
  String get title => 'General';

  @override
  IconData? get icon => Icons.info_outline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text('General info', style: theme.textTheme.titleMedium),
        ),

        // App version section
        // TODO: AppVersionSection

        // Sections
        for (var section in sections) DebugPanelGeneralPageSectionView(section: section),
      ],
    );
  }
}

class DebugPanelGeneralPageSectionView extends StatelessWidget {
  final DebugPanelGeneralPageBaseSection section;

  const DebugPanelGeneralPageSectionView({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Wrap with Expanded if collapsible
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(section.title, style: theme.textTheme.labelLarge),
        ),

        // Body
        section.builder(context),

        // TODO: Note
      ],
    );
  }
}
