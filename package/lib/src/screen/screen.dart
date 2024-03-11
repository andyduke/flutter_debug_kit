import 'package:debug_panel/src/controller.dart';
import 'package:debug_panel/src/pages/base_page.dart';
import 'package:debug_panel/src/screen/widgets/scaffold.dart';
import 'package:debug_panel/src/theme/theme.dart';
import 'package:debug_panel/src/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyleForBrightness(Theme.of(context).brightness),
      child: DebugPanelTheme(
        child: DebugPanelScaffold(
          controller: controller,
          pages: pages,
        ),
      ),
    );
  }

  static SystemUiOverlayStyle systemOverlayStyleForBrightness(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final SystemUiOverlayStyle style = isDark
        ? SystemUiOverlayStyle(
            statusBarColor: DebugPanelThemeData.lightPalette.appBarBackground,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: DebugPanelThemeData.lightScheme.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            statusBarColor: DebugPanelThemeData.darkPalette.appBarBackground,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: DebugPanelThemeData.darkScheme.background,
            systemNavigationBarIconBrightness: Brightness.light,
          );

    return style;
  }
}
