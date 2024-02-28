import 'dart:io';

import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/screen/widgets/scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugPanelScreen extends StatelessWidget {
  final DebugPanelController controller;
  final Set<DebugPanelBasePage> pages;

  const DebugPanelScreen({
    super.key,
    required this.controller,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.close();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      // TODO: DEBUG
      body: Column(
        children: [
          for (var page in pages) page.build(context),
        ],
      ),
    );
    */
    return DebugPanelScaffold(
      controller: controller,
      pages: pages,
    );
  }
}
