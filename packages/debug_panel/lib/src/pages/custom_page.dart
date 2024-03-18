import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:flutter/material.dart';

class DebugPanelCustomPage extends DebugPanelBasePage {
  @override
  final String name;

  @override
  final String title;

  @override
  final IconData? icon;

  final WidgetBuilder builder;

  DebugPanelCustomPage({
    required this.name,
    required this.title,
    this.icon,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, DebugPanelController controller) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(title, style: theme.textTheme.titleMedium),
        ),

        builder(context),
      ],
    );
  }
}
