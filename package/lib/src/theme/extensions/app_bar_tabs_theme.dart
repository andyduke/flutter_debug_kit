import 'package:debug_panel/src/theme/utils/color_set.dart';
import 'package:debug_panel/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class DebugPanelAppBarTabsTheme extends ThemeExtension<DebugPanelAppBarTabsTheme> {
  final TextStyle textStyle;
  final CustomTabStateProperty<ColorSet> colors;
  // final Color tabForeColor;
  // final Color tabBackColor;
  // final Color selectedTabForeColor;
  // final Color selectedTabBackColor;
  // final Color hoveredTabForeColor;
  // final Color hoveredTabBackColor;

  DebugPanelAppBarTabsTheme({
    required this.textStyle,
    required this.colors,
    // required this.tabForeColor,
    // required this.tabBackColor,
    // required this.selectedTabForeColor,
    // required this.selectedTabBackColor,
    // required this.hoveredTabForeColor,
    // required this.hoveredTabBackColor,
  });

  @override
  DebugPanelAppBarTabsTheme copyWith({
    TextStyle? textStyle,
    CustomTabStateProperty<ColorSet>? colors,
    // Color? tabForeColor,
    // Color? tabBackColor,
    // Color? selectedTabForeColor,
    // Color? selectedTabBackColor,
    // Color? hoveredTabForeColor,
    // Color? hoveredTabBackColor,
  }) {
    return DebugPanelAppBarTabsTheme(
      textStyle: textStyle ?? this.textStyle,
      colors: colors ?? this.colors,
      // tabForeColor: tabForeColor ?? this.tabForeColor,
      // tabBackColor: tabBackColor ?? this.tabBackColor,
      // selectedTabForeColor: selectedTabForeColor ?? this.selectedTabForeColor,
      // selectedTabBackColor: selectedTabBackColor ?? this.selectedTabBackColor,
      // hoveredTabForeColor: hoveredTabForeColor ?? this.hoveredTabForeColor,
      // hoveredTabBackColor: hoveredTabBackColor ?? this.hoveredTabBackColor,
    );
  }

  @override
  DebugPanelAppBarTabsTheme lerp(ThemeExtension<DebugPanelAppBarTabsTheme>? other, double t) {
    if (other is! DebugPanelAppBarTabsTheme) {
      return this;
    }
    return DebugPanelAppBarTabsTheme(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      colors: CustomTabStateProperty.lerp<ColorSet>(colors, other.colors, t, (a, b, t) => ColorSet.lerp(a, b, t))!,
      // tabForeColor: Color.lerp(tabForeColor, other.tabForeColor, t)!,
      // tabBackColor: Color.lerp(tabBackColor, other.tabBackColor, t)!,
      // selectedTabForeColor: Color.lerp(selectedTabForeColor, other.selectedTabForeColor, t)!,
      // selectedTabBackColor: Color.lerp(selectedTabBackColor, other.selectedTabBackColor, t)!,
      // hoveredTabForeColor: Color.lerp(hoveredTabForeColor, other.hoveredTabForeColor, t)!,
      // hoveredTabBackColor: Color.lerp(hoveredTabBackColor, other.hoveredTabBackColor, t)!,
    );
  }

  @override
  String toString() => '''DebugPanelAppBarTabsTheme(
  textStyle: $textStyle,
  colors: $colors
)''';
  // tabForeColor: $tabForeColor, tabBackColor: $tabBackColor,
  // selectedTabForeColor: $selectedTabForeColor, selectedTabBackColor: $selectedTabBackColor,
  // hoveredTabForeColor: $hoveredTabForeColor, hoveredTabBackColor: $hoveredTabBackColor
}
