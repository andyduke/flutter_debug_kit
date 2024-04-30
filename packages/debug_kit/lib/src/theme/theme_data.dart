import 'package:debug_kit/src/theme/extensions/app_bar_tabs_theme.dart';
import 'package:debug_kit/src/theme/utils/color_set.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class DebugKitPalette {
  final Color appBarBackground;
  final Color accentColor;
  final Color accentLightColor;

  const DebugKitPalette({
    required this.appBarBackground,
    required this.accentColor,
    required this.accentLightColor,
  });
}

abstract class DebugKitThemeData {
  static const darkPalette = DebugKitPalette(
    appBarBackground: Color(0xFF000000),
    accentColor: Color(0xFF538E95),
    accentLightColor: Color(0xFFA1C7CC),
  );

  static const lightPalette = DebugKitPalette(
    appBarBackground: Color(0xFFFFFFFF),
    accentColor: Color(0xFF538E95),
    accentLightColor: Color(0xFFA1C7CC),
  );

  static final darkScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: darkPalette.accentColor,
    background: const Color(0xFF272F2F),
    secondary: const Color(0xFF56CCF2),
    secondaryContainer: const Color(0xFF3B7384),
    onSecondary: Colors.white,
    onSecondaryContainer: Colors.white,
    tertiary: const Color(0xFF4F92FF),
    tertiaryContainer: const Color(0xFF1B4EA3),
    onTertiary: Colors.white,
    onTertiaryContainer: const Color(0xFFD8E7FF),
  );

  static final lightScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: lightPalette.accentColor,
    background: const Color(0xFFF3F1F0),
    secondary: const Color(0xFF56CCF2),
    secondaryContainer: const Color(0xFF3E5F68),
    onSecondary: Colors.white,
    onSecondaryContainer: Colors.white,
    tertiary: const Color(0xFF5E9CFF),
    tertiaryContainer: const Color(0xFF205BBA),
    onTertiary: Colors.white,
    onTertiaryContainer: const Color(0xFFD8E7FF),
    // surfaceVariant: const Color(0xFFD8E7FF),
    // onSurfaceVariant: Colors.black,
  );

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: darkScheme,
      useMaterial3: true,

      // TODO: DEBUG
      // visualDensity: VisualDensity.standard,

      focusColor: darkScheme.secondaryContainer,

      // AppBar theme
      appBarTheme: AppBarTheme(
        // backgroundColor: const Color(0xFF17151C),
        backgroundColor: darkPalette.appBarBackground,
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

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0),
        displayMedium: TextStyle(fontSize: 45.0),
        displaySmall: TextStyle(fontSize: 36.0),
        headlineLarge: TextStyle(fontSize: 36.0),
        headlineMedium: TextStyle(fontSize: 32.0),
        headlineSmall: TextStyle(fontSize: 26.8),
        titleLarge: TextStyle(fontSize: 26.0),
        titleMedium: TextStyle(fontSize: 21.0),
        titleSmall: TextStyle(fontSize: 16.8),
        labelLarge: TextStyle(fontSize: 16.8),
        labelMedium: TextStyle(fontSize: 14.4),
        labelSmall: TextStyle(fontSize: 13.2),
        bodyLarge: TextStyle(fontSize: 18.5),
        bodyMedium: TextStyle(fontSize: 16.5),
        bodySmall: TextStyle(fontSize: 14.5, color: Color(0xFFB0BAC2)),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: darkScheme.onSurfaceVariant.withOpacity(0.2),
        thickness: 1.0,
        space: 9,
      ),

      // Text field theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        isDense: true,
      ),

      // Cursor theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: darkScheme.primary,
        selectionColor: darkScheme.primary.withOpacity(0.7),
        selectionHandleColor: darkScheme.primary,
      ),

      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateColor.resolveWith((states) => switch (states) {
              Set() when states.contains(MaterialState.dragged) => darkScheme.onSurface.withOpacity(0.75),
              Set() when states.contains(MaterialState.hovered) => darkScheme.onSurface.withOpacity(0.65),
              _ => darkScheme.onSurface.withOpacity(0.3),
            }),
      ),

      // Extensions
      extensions: [
        DebugKitPanelAppBarTabsTheme(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          colors: CustomTabStateProperty<ColorSet>(
            ColorSet(foreground: darkScheme.primary, background: Colors.transparent),
            selected: ColorSet(foreground: darkScheme.onPrimary, background: darkScheme.primary),
            hovered: ColorSet(foreground: darkScheme.onPrimaryContainer, background: darkScheme.primaryContainer),
          ),
          // tabForeColor: darkScheme.primary,
          // tabBackColor: Colors.transparent,
          // selectedTabForeColor: darkScheme.onPrimary,
          // selectedTabBackColor: darkScheme.primary,
          // hoveredTabForeColor: darkScheme.onPrimaryContainer,
          // hoveredTabBackColor: darkScheme.primaryContainer,
        ),
      ],
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: lightScheme,
      useMaterial3: true,

      focusColor: lightScheme.surfaceVariant,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: lightPalette.appBarBackground,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: lightScheme.primary),
        centerTitle: false,
        actionsIconTheme: IconThemeData(
          color: lightScheme.primary,
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0),
        displayMedium: TextStyle(fontSize: 45.0),
        displaySmall: TextStyle(fontSize: 36.0),
        headlineLarge: TextStyle(fontSize: 36.0),
        headlineMedium: TextStyle(fontSize: 32.0),
        headlineSmall: TextStyle(fontSize: 26.8),
        titleLarge: TextStyle(fontSize: 26.0),
        titleMedium: TextStyle(fontSize: 21.0),
        titleSmall: TextStyle(fontSize: 16.8),
        labelLarge: TextStyle(fontSize: 16.8),
        labelMedium: TextStyle(fontSize: 14.4),
        labelSmall: TextStyle(fontSize: 13.2),
        bodyLarge: TextStyle(fontSize: 18.5),
        bodyMedium: TextStyle(fontSize: 16.5),
        bodySmall: TextStyle(fontSize: 14.5, color: Color(0xFF737271)),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: lightScheme.onSurfaceVariant.withOpacity(0.2),
        thickness: 1.0,
        space: 9,
      ),

      // Scrollbar theme
      // scrollbarTheme: ScrollbarThemeData(
      // ),

      // Text field theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        isDense: true,
      ),

      // Cursor theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: lightScheme.primary,
        selectionColor: lightScheme.primary.withOpacity(0.35),
        selectionHandleColor: lightScheme.primary,
      ),

      // Extensions
      extensions: [
        DebugKitPanelAppBarTabsTheme(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          colors: CustomTabStateProperty<ColorSet>(
            ColorSet(foreground: lightScheme.primary, background: Colors.transparent),
            selected: ColorSet(foreground: lightScheme.onPrimary, background: lightScheme.primary),
            hovered: ColorSet(foreground: lightScheme.onPrimary, background: lightScheme.primary.withOpacity(0.62)),
          ),
          // tabForeColor: lightScheme.primary,
          // tabBackColor: Colors.transparent,
          // selectedTabForeColor: lightScheme.onPrimary,
          // selectedTabBackColor: lightScheme.primary,
          // hoveredTabForeColor: lightScheme.onPrimary,
          // hoveredTabBackColor: lightScheme.primary.withOpacity(0.5),
        ),
      ],
    );
  }
}
