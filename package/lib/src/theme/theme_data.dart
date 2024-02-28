import 'dart:io';

import 'package:debug_panel/src/theme/extensions/app_bar_tabs_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugPanelPalette {
  final Color accentColor;
  final Color accentLightColor;

  const DebugPanelPalette({
    required this.accentColor,
    required this.accentLightColor,
  });
}

abstract class DebugPanelThemeData {
  static const darkPalette = DebugPanelPalette(
    accentColor: Color(0xFF538E95),
    accentLightColor: Color(0xFFA1C7CC),
  );

  static const lightPalette = DebugPanelPalette(
    accentColor: Color(0xFF538E95),
    accentLightColor: Color(0xFFA1C7CC),
  );

  static final darkScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: darkPalette.accentColor,
    background: const Color(0xFF272F2F),
  );

  static final lightScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: lightPalette.accentColor,
    background: const Color(0xFFF3F1F0),
  );

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: darkScheme,
      useMaterial3: true,

      // AppBar theme
      appBarTheme: AppBarTheme(
        // backgroundColor: const Color(0xFF17151C),
        backgroundColor: const Color(0xFF000000),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: darkScheme.primary),
        centerTitle: false,
        actionsIconTheme: IconThemeData(
          color: darkScheme.primary,
        ),
      ),

      // Tabs theme
      // tabBarTheme: const TabBarTheme(
      //   tabAlignment: TabAlignment.start,
      // ),

      // Text styles
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Color(0xFFB0BAC2)),
      ),

      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux)
            ? MaterialStateProperty.all(true)
            : null,
      ),

      // Extensions
      extensions: [
        DebugPanelAppBarTabsTheme(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabForeColor: darkScheme.primary,
          tabBackColor: Colors.transparent,
          selectedTabForeColor: darkScheme.onPrimary,
          selectedTabBackColor: darkScheme.primary,
          hoveredTabForeColor: darkScheme.onPrimaryContainer,
          hoveredTabBackColor: darkScheme.primaryContainer,
        ),
      ],
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: lightScheme,
      useMaterial3: true,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: lightScheme.primary),
        centerTitle: false,
        actionsIconTheme: IconThemeData(
          color: lightScheme.primary,
        ),
      ),

      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux)
            ? MaterialStateProperty.all(true)
            : null,
      ),

      // Extensions
      extensions: [
        DebugPanelAppBarTabsTheme(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabForeColor: lightScheme.primary,
          tabBackColor: Colors.transparent,
          selectedTabForeColor: lightScheme.onPrimary,
          selectedTabBackColor: lightScheme.primary,
          hoveredTabForeColor: lightScheme.onPrimary,
          hoveredTabBackColor: lightScheme.primary.withOpacity(0.5),
        ),
      ],
    );
  }
}
