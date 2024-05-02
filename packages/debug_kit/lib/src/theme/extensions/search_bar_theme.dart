import 'package:flutter/material.dart';

class DebugKitSearchBarTheme extends ThemeExtension<DebugKitSearchBarTheme> {
  /// Padding around the entire search bar
  final EdgeInsets padding;

  /// Padding around the search row
  final EdgeInsets searchBarPadding;

  /// Padding around the search field
  final EdgeInsets searchFieldPadding;

  /// Search field text style
  final TextStyle searchFieldTextStyle;

  // /// Search field decoration
  // final InputDecorationTheme searchFieldDecoration;

  /// Style for buttons (reset, filters) inside search field
  final ButtonStyle searchFieldButtonStyle;

  /// Indentation of the divider (divider) of buttons inside the search field (between the reset button and the filters button)
  final EdgeInsets searchFieldDividerPadding;

  /// Padding around the filter row
  final EdgeInsets filterBarPadding;

  /// Style for filter chips
  final ChipThemeData filterBarChipStyle;

  /// Padding for filter chips
  final EdgeInsets filterBarChipPadding;

  /// Padding for the filter chip separator (separates the "All" chip from the rest)
  final EdgeInsets filterBarDividerPadding;

  DebugKitSearchBarTheme({
    required this.padding,
    required this.searchBarPadding,
    required this.searchFieldPadding,
    required this.searchFieldTextStyle,
    // required this.searchFieldDecoration,
    required this.searchFieldButtonStyle,
    required this.searchFieldDividerPadding,
    required this.filterBarPadding,
    required this.filterBarChipStyle,
    required this.filterBarChipPadding,
    required this.filterBarDividerPadding,
  });

  @override
  DebugKitSearchBarTheme copyWith({
    EdgeInsets? padding,
    EdgeInsets? searchBarPadding,
    EdgeInsets? searchFieldPadding,
    TextStyle? searchFieldTextStyle,
    // InputDecorationTheme? searchFieldDecoration,
    ButtonStyle? searchFieldButtonStyle,
    EdgeInsets? searchFieldDividerPadding,
    EdgeInsets? filterBarPadding,
    ChipThemeData? filterBarChipStyle,
    EdgeInsets? filterBarChipPadding,
    EdgeInsets? filterBarDividerPadding,
  }) {
    return DebugKitSearchBarTheme(
      padding: padding ?? this.padding,
      searchBarPadding: searchBarPadding ?? this.searchBarPadding,
      searchFieldPadding: searchFieldPadding ?? this.searchFieldPadding,
      searchFieldTextStyle: searchFieldTextStyle ?? this.searchFieldTextStyle,
      // searchFieldDecoration: searchFieldDecoration ?? this.searchFieldDecoration,
      searchFieldButtonStyle: searchFieldButtonStyle ?? this.searchFieldButtonStyle,
      searchFieldDividerPadding: searchFieldDividerPadding ?? this.searchFieldDividerPadding,
      filterBarPadding: filterBarPadding ?? this.padding,
      filterBarChipStyle: filterBarChipStyle ?? this.filterBarChipStyle,
      filterBarChipPadding: filterBarChipPadding ?? this.filterBarChipPadding,
      filterBarDividerPadding: filterBarDividerPadding ?? this.filterBarDividerPadding,
    );
  }

  @override
  DebugKitSearchBarTheme lerp(ThemeExtension<DebugKitSearchBarTheme>? other, double t) {
    if (other is! DebugKitSearchBarTheme) {
      return this;
    }
    return DebugKitSearchBarTheme(
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      searchBarPadding: EdgeInsets.lerp(searchBarPadding, other.searchBarPadding, t)!,
      searchFieldPadding: EdgeInsets.lerp(searchFieldPadding, other.searchFieldPadding, t)!,
      searchFieldTextStyle: TextStyle.lerp(searchFieldTextStyle, other.searchFieldTextStyle, t)!,
      // searchFieldDecoration: InputDecorationTheme.lerp(searchFieldDecoration, other.searchFieldDecoration, t)!,
      searchFieldButtonStyle: ButtonStyle.lerp(searchFieldButtonStyle, other.searchFieldButtonStyle, t)!,
      searchFieldDividerPadding: EdgeInsets.lerp(searchFieldDividerPadding, other.searchFieldDividerPadding, t)!,
      filterBarPadding: EdgeInsets.lerp(filterBarPadding, other.filterBarPadding, t)!,
      filterBarChipStyle: ChipThemeData.lerp(filterBarChipStyle, other.filterBarChipStyle, t)!,
      filterBarChipPadding: EdgeInsets.lerp(filterBarChipPadding, other.filterBarChipPadding, t)!,
      filterBarDividerPadding: EdgeInsets.lerp(filterBarDividerPadding, other.filterBarDividerPadding, t)!,
    );
  }

  @override
  String toString() => '''DebugKitSearchBarTheme(
  padding: $padding
  searchBarPadding: $searchBarPadding
  searchFieldPadding: $searchFieldPadding
  searchFieldTextStyle: $searchFieldTextStyle
  searchFieldButtonStyle: $searchFieldButtonStyle
  searchFieldDividerPadding: $searchFieldDividerPadding
  filterBarPadding: $filterBarPadding
  filterBarChipStyle: $filterBarChipStyle
  filterBarChipPadding: $filterBarChipPadding
  filterBarDividerPadding: $filterBarDividerPadding
)''';
}
