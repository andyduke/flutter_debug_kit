import 'package:debug_kit/src/controller.dart';
import 'package:debug_kit/src/pages/base_page.dart';
import 'package:debug_kit/src/screen/widgets/scaffold.dart';
import 'package:debug_kit/src/theme/theme.dart';
import 'package:debug_kit/src/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugKitPanelScreen extends StatelessWidget {
  final DebugKitController controller;
  final Set<DebugKitPanelBasePage> pages;

  const DebugKitPanelScreen({
    super.key,
    required this.controller,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyleForBrightness(Theme.of(context).brightness),
      child: DebugKitTheme(
        child: DebugKitPanelScaffold(
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
            statusBarColor: DebugKitThemeData.lightPalette.appBarBackground,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: DebugKitThemeData.lightScheme.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            statusBarColor: DebugKitThemeData.darkPalette.appBarBackground,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: DebugKitThemeData.darkScheme.background,
            systemNavigationBarIconBrightness: Brightness.light,
          );

    return style;
  }
}
