import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:flutter/material.dart';

class DebugKitPanelCustomPage extends DebugKitPanelBasePage {
  @override
  final String name;

  @override
  final String title;

  @override
  final IconData? icon;

  final WidgetBuilder builder;

  DebugKitPanelCustomPage({
    required this.name,
    required this.title,
    this.icon,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, DebugKitController controller) {
    /*
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Padding(
          padding: DebugKitPanelBasePage.defaultPadding,
          child: Text(title, style: theme.textTheme.titleMedium),
        ),

        Expanded(
          child: builder(context),
        ),
      ],
    );
    */

    return builder(context);
  }
}
