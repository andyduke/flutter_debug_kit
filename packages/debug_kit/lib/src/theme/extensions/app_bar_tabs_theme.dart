import 'package:debug_kit/src/theme/utils/color_set.dart';
import 'package:debug_kit/src/widgets/custom_tabs/custom_tabbar.dart';
import 'package:flutter/material.dart';

class DebugKitPanelAppBarTabsTheme extends ThemeExtension<DebugKitPanelAppBarTabsTheme> {
  final TextStyle textStyle;
  final CustomTabStateProperty<ColorSet> colors;

  DebugKitPanelAppBarTabsTheme({
    required this.textStyle,
    required this.colors,
  });

  @override
  DebugKitPanelAppBarTabsTheme copyWith({
    TextStyle? textStyle,
    CustomTabStateProperty<ColorSet>? colors,
  }) {
    return DebugKitPanelAppBarTabsTheme(
      textStyle: textStyle ?? this.textStyle,
      colors: colors ?? this.colors,
    );
  }

  @override
  DebugKitPanelAppBarTabsTheme lerp(ThemeExtension<DebugKitPanelAppBarTabsTheme>? other, double t) {
    if (other is! DebugKitPanelAppBarTabsTheme) {
      return this;
    }
    return DebugKitPanelAppBarTabsTheme(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      colors: CustomTabStateProperty.lerp<ColorSet>(colors, other.colors, t, (a, b, t) => ColorSet.lerp(a, b, t))!,
    );
  }

  @override
  String toString() => '''DebugKitPanelAppBarTabsTheme(
  textStyle: $textStyle,
  colors: $colors
)''';
}
