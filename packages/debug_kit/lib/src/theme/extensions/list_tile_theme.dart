import 'dart:ui';
import 'package:flutter/material.dart';

class DebugKitListTileTheme extends ThemeExtension<DebugKitListTileTheme> {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextStyle supertitleTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final double titleSpacing;

  DebugKitListTileTheme({
    required this.margin,
    required this.padding,
    required this.supertitleTextStyle,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.titleSpacing,
  });

  @override
  DebugKitListTileTheme copyWith({
    EdgeInsets? margin,
    EdgeInsets? padding,
    TextStyle? supertitleTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    double? titleSpacing,
  }) {
    return DebugKitListTileTheme(
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      supertitleTextStyle: supertitleTextStyle ?? this.supertitleTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
    );
  }

  @override
  DebugKitListTileTheme lerp(ThemeExtension<DebugKitListTileTheme>? other, double t) {
    if (other is! DebugKitListTileTheme) {
      return this;
    }
    return DebugKitListTileTheme(
      margin: EdgeInsets.lerp(margin, other.margin, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      supertitleTextStyle: TextStyle.lerp(supertitleTextStyle, other.supertitleTextStyle, t)!,
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t)!,
      subtitleTextStyle: TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t)!,
      titleSpacing: lerpDouble(titleSpacing, other.titleSpacing, t)!,
    );
  }

  @override
  String toString() => '''DebugKitListTileTheme(
  margin: $margin,
  padding: $padding
  supertitleTextStyle: $supertitleTextStyle
  titleTextStyle: $titleTextStyle
  subtitleTextStyle: $subtitleTextStyle
  titleSpacing: $titleSpacing
)''';
}
