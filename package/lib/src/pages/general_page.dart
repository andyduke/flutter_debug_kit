import 'package:debug_panel/src/pages/page.dart';
import 'package:flutter/material.dart';

class DebugPanelGeneralPage extends DebugPanelPage {
  DebugPanelGeneralPage({
    super.sections = const {},
  }) : super(
          name: 'general',
          title: 'General',
          icon: Icons.info_outline,
        );

  @override
  Set<DebugPanelPageBaseSection> get sections => {
        DebugPanelPageSection(
          name: 'package_info',
          title: 'Application info',
          builder: (context) {
            // TODO: Package name & version
            return const Text('app info');
          },
        ),

        // Inherited sections
        ...super.sections,
      };
}
