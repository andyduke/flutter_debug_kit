import 'package:debug_kit/src/widgets/empty_view.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/filtered_list_view.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:debug_kit/src/widgets/list_view_builders/list_view_builders.dart';
import 'package:debug_kit/src/widgets/search_bar.dart';
import 'package:debug_kit/src/widgets/sliver_center.dart';
import 'package:debug_kit/src/widgets/waiting.dart';
import 'package:flutter/material.dart';

typedef FilteredListScaffoldItemBuilder<E> = Widget Function(BuildContext context, E entry);
typedef FilteredListScaffoldFilterCallback<F, E> = List<E> Function(List<E> entries, String? search, F? filter);

class FilteredListScaffoldFilterData<F> extends FilterData {
  final F value;

  FilteredListScaffoldFilterData(this.value);

  @override
  bool operator ==(covariant FilteredListScaffoldFilterData<F> other) => value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class FilteredListScaffold<F, E> extends StatefulWidget {
  final Widget? leading;
  final List<Widget> toolbarActions;
  final String? listTitle;
  final ValueGetter<List<E>> listGetter;
  final Listenable? listListenable;
  final FilteredListScaffoldItemBuilder<E> itemBuilder;
  final List<F>? filterValues;
  final DebugKitSearchBarFilterBuilder<F>? filterBuilder;
  final FilteredListScaffoldFilterCallback<F, E>? onFilter;

  const FilteredListScaffold({
    super.key,
    this.leading,
    this.toolbarActions = const [],
    this.listTitle,
    required this.listGetter,
    this.listListenable,
    required this.itemBuilder,
    this.filterValues,
    this.filterBuilder,
    this.onFilter,
  }) : assert((filterValues == null && onFilter == null && filterBuilder == null) ||
            (filterValues != null && onFilter != null && filterBuilder != null));

  @override
  State<FilteredListScaffold<F, E>> createState() => _FilteredListScaffoldState<F, E>();
}

class _FilteredListScaffoldState<F, E> extends State<FilteredListScaffold<F, E>> {
  final scrollController = ScrollController(keepScrollOffset: false);

  late final TextEditingController searchFieldController = TextEditingController(text: '')..addListener(_applySearch);

  late final controller = FilteredListController<FilteredListScaffoldFilterData<F>, E>(
    onFetch: (controller) async {
      List<E> list = widget.listGetter();
      if (widget.onFilter != null) {
        list = widget.onFilter!(list, controller.search, controller.filter?.value);
      }
      return list;
    },
  );

  void _applySearch() {
    controller.apply(search: searchFieldController.text);
  }

  void _applyFilter(F? newValue) {
    if (newValue != null) {
      controller.apply(filter: FilteredListScaffoldFilterData(newValue));
    } else {
      controller.reset(filter: true);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.listListenable?.addListener(_updateList);
  }

  @override
  void didUpdateWidget(covariant FilteredListScaffold<F, E> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.listListenable != oldWidget.listListenable) {
      oldWidget.listListenable?.removeListener(_updateList);
      widget.listListenable?.addListener(_updateList);
    }
  }

  @override
  void dispose() {
    widget.listListenable?.removeListener(_updateList);
    searchFieldController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  void _updateList() {
    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: scrollController,
      slivers: [
        // Search & filter bar
        if (widget.filterValues != null && widget.onFilter != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DebugKitSearchBar<F>(
                searchFieldController: searchFieldController,
                filter: widget.filterValues!,
                filterBuilder: widget.filterBuilder,
                onFilter: _applyFilter,
                trailing: widget.toolbarActions,
              ),
            ),
          ),

        // List
        FilteredListView(
          controller: controller,
          builder: (context, controller, list) {
            return SliverListViewBuilder(
              header: (widget.listTitle != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16) + const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${widget.listTitle!.toUpperCase()}  •  ${list.length}',

                        // TODO: Extract to theme
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : null,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final entry = list[index];
                return widget.itemBuilder(context, entry);
              },
            );

            /*
            return SliverList.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final entry = list[index];
                return widget.itemBuilder(context, entry);
              },
            );
            */
          },
          emptyBuilder: (context, controller) => SliverCenter(
            child: EmptyView.text('No entries'),
          ),
          waitingBuilder: (context) => const SliverCenter(
            child: Waiting(),
          ),
          errorBuilder: (context, controller, error, stackTrace) => SliverCenter(
            child: Text('$error\n\n$stackTrace'), // TODO: Error display
          ),
        ),
      ],
    );
  }
}
