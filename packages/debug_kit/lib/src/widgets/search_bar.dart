import 'package:collection/collection.dart';
import 'package:debug_kit/src/theme/extensions/search_bar_theme.dart';
import 'package:flutter/material.dart';

/*
abstract interface class DebugKitSearchBarFilterItem<F> {
  // TODO: Icon
  abstract final String text;
  abstract final F value;
}
*/

typedef DebugKitSearchBarFilterBuilder<F> = Widget Function(F? value);

class DebugKitSearchBar<F> extends StatefulWidget {
  final TextEditingController searchFieldController;
  final List<F> filter;
  final DebugKitSearchBarFilterBuilder<F>? filterBuilder;
  final Widget? leading;
  final List<Widget> trailing;
  final ValueChanged<F?>? onFilter;

  const DebugKitSearchBar({
    super.key,
    required this.searchFieldController,
    this.filter = const [],
    this.filterBuilder,
    this.leading,
    this.trailing = const [],
    this.onFilter,
  }) : assert((filter.length == 0 && filterBuilder == null) || (filter.length > 0 && filterBuilder != null));

  @override
  State<DebugKitSearchBar<F>> createState() => _DebugKitSearchBarState<F>();
}

class _DebugKitSearchBarState<F> extends State<DebugKitSearchBar<F>> {
  int filterSelected = 0;

  void _applyFilter(F? newValue, int index) {
    if (widget.onFilter != null) {
      setState(() {
        filterSelected = index;
      });

      widget.onFilter!(newValue);
    }
  }

  bool get filterVisible => _filterVisible;
  bool _filterVisible = false;
  set filterVisible(bool newValue) {
    if (filterVisible != newValue) {
      _filterVisible = newValue;

      // Reset filter on filter bar hiding
      if (!filterVisible) {
        _applyFilter(null, 0);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barTheme = theme.extension<DebugKitSearchBarTheme>()!;

    return Padding(
      padding: barTheme.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          Padding(
            padding: barTheme.searchBarPadding,
            child: SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading
                  if (widget.leading != null) ...[
                    widget.leading!,
                    SizedBox(width: barTheme.searchFieldPadding.left),
                  ],

                  // Search field
                  Expanded(
                    child: TextField(
                      controller: widget.searchFieldController,
                      style: barTheme.searchFieldTextStyle,
                      decoration: InputDecoration(
                        hintText: MaterialLocalizations.of(context).searchFieldLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        filled: true,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListenableBuilder(
                                listenable: widget.searchFieldController,
                                builder: (context, child) {
                                  return Visibility(
                                    visible: widget.searchFieldController.text.isNotEmpty,
                                    child: child!,
                                  );
                                },
                                child: IconButton(
                                  onPressed: () {
                                    widget.searchFieldController.clear();
                                  },
                                  style: barTheme.searchFieldButtonStyle,
                                  icon: const Icon(Icons.clear, size: 24),
                                ),
                              ),

                              // Filter button
                              if (widget.filter.isNotEmpty) ...[
                                Padding(
                                  padding: barTheme.searchFieldDividerPadding,
                                  child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(border: Border(left: BorderSide(color: theme.dividerColor))),
                                    child: const SizedBox(width: 0, height: 24),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    filterVisible = !filterVisible;
                                  },
                                  style: barTheme.searchFieldButtonStyle,
                                  icon: const Icon(Icons.filter_alt, size: 24),
                                  color: !filterVisible ? null : theme.colorScheme.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // onChanged: (newValue) => setState(() {
                      //   widget.searchFieldController.text = newValue;
                      // }),
                    ),
                  ),

                  // Trailing
                  if (widget.trailing.isNotEmpty) ...[
                    SizedBox(width: barTheme.searchFieldPadding.right),
                    ...widget.trailing,
                  ],
                ],
              ),
            ),
          ),

          // Filter bar
          if (widget.filter.isNotEmpty && filterVisible)
            Padding(
              padding: EdgeInsets.only(top: barTheme.filterBarPadding.top, bottom: barTheme.filterBarPadding.bottom),
              child: ChipTheme(
                data: barTheme.filterBarChipStyle,
                child: SizedBox(
                  height: 43,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        EdgeInsets.only(left: barTheme.filterBarPadding.left, right: barTheme.filterBarPadding.right),
                    children: [
                      // "All" chip
                      FilterChip(
                          label: widget.filterBuilder!(null),
                          selected: filterSelected == 0,
                          onSelected: (_) => _applyFilter(null, 0)),

                      // Divider
                      Padding(
                        padding: barTheme.filterBarDividerPadding,
                        child: VerticalDivider(color: theme.dividerColor.withOpacity(0.7), indent: 12, endIndent: 12),
                      ),

                      // Filter chips
                      ...widget.filter.mapIndexed(
                        (i, f) => Padding(
                          padding: barTheme.filterBarChipPadding,
                          child: FilterChip(
                            label: widget.filterBuilder!(f),
                            selected: filterSelected == (i + 1),
                            onSelected: (_) => _applyFilter(f, i + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
