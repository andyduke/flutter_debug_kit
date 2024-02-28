import 'package:flutter/material.dart';

class DebugPanelAppBarTabsTheme extends ThemeExtension<DebugPanelAppBarTabsTheme> {
  final TextStyle textStyle;
  final Color tabForeColor;
  final Color tabBackColor;
  final Color selectedTabForeColor;
  final Color selectedTabBackColor;
  final Color hoveredTabForeColor;
  final Color hoveredTabBackColor;

  DebugPanelAppBarTabsTheme({
    required this.textStyle,
    required this.tabForeColor,
    required this.tabBackColor,
    required this.selectedTabForeColor,
    required this.selectedTabBackColor,
    required this.hoveredTabForeColor,
    required this.hoveredTabBackColor,
  });

  @override
  DebugPanelAppBarTabsTheme copyWith({
    TextStyle? textStyle,
    Color? tabForeColor,
    Color? tabBackColor,
    Color? selectedTabForeColor,
    Color? selectedTabBackColor,
    Color? hoveredTabForeColor,
    Color? hoveredTabBackColor,
  }) {
    return DebugPanelAppBarTabsTheme(
      textStyle: textStyle ?? this.textStyle,
      tabForeColor: tabForeColor ?? this.tabForeColor,
      tabBackColor: tabBackColor ?? this.tabBackColor,
      selectedTabForeColor: selectedTabForeColor ?? this.selectedTabForeColor,
      selectedTabBackColor: selectedTabBackColor ?? this.selectedTabBackColor,
      hoveredTabForeColor: hoveredTabForeColor ?? this.hoveredTabForeColor,
      hoveredTabBackColor: hoveredTabBackColor ?? this.hoveredTabBackColor,
    );
  }

  @override
  DebugPanelAppBarTabsTheme lerp(ThemeExtension<DebugPanelAppBarTabsTheme>? other, double t) {
    if (other is! DebugPanelAppBarTabsTheme) {
      return this;
    }
    return DebugPanelAppBarTabsTheme(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      tabForeColor: Color.lerp(tabForeColor, other.tabForeColor, t)!,
      tabBackColor: Color.lerp(tabBackColor, other.tabBackColor, t)!,
      selectedTabForeColor: Color.lerp(selectedTabForeColor, other.selectedTabForeColor, t)!,
      selectedTabBackColor: Color.lerp(selectedTabBackColor, other.selectedTabBackColor, t)!,
      hoveredTabForeColor: Color.lerp(hoveredTabForeColor, other.hoveredTabForeColor, t)!,
      hoveredTabBackColor: Color.lerp(hoveredTabBackColor, other.hoveredTabBackColor, t)!,
    );
  }

  @override
  String toString() => '''DebugPanelAppBarTabsTheme(
  textStyle: $textStyle,
  tabForeColor: $tabForeColor, tabBackColor: $tabBackColor,
  selectedTabForeColor: $selectedTabForeColor, selectedTabBackColor: $selectedTabBackColor,
  hoveredTabForeColor: $hoveredTabForeColor, hoveredTabBackColor: $hoveredTabBackColor
)''';
}
