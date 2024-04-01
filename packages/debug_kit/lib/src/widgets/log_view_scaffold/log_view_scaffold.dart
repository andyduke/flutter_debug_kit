import 'dart:io';
import 'package:debug_kit/src/widgets/filter_bar.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/filtered_list_view.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:debug_kit/src/widgets/keyboard_dismisser.dart';
import 'package:debug_kit/src/widgets/search_field.dart';
import 'package:debug_kit/src/widgets/toolbar.dart';
import 'package:flutter/material.dart';

typedef LogViewScaffoldFilterCallback<F, E> = Iterable<E> Function(Iterable<E> entries, String? search, F? filter);
typedef LogVieScaffoldListEntriesCallback<E> = Iterable<E> Function();

typedef LogViewScaffoldItemBuilder<E> = Widget Function(E entry);

class LogViewFilterItem<F> {
  // TODO: Icon
  final String text;
  final F value;

  LogViewFilterItem({
    required this.text,
    required this.value,
  });
}

class LogViewScaffold<F, E> extends StatefulWidget {
  final Iterable<LogViewFilterItem<F>> filterValues;
  final LogViewScaffoldFilterCallback<F, E> onFilter;
  final Listenable listListenable;
  final LogVieScaffoldListEntriesCallback<E> listGetter;
  final List<Widget> toolbarActions;
  final LogViewScaffoldItemBuilder<E> itemBuilder;

  const LogViewScaffold({
    super.key,
    this.filterValues = const [],
    required this.onFilter,
    required this.listListenable,
    required this.listGetter,
    this.toolbarActions = const [],
    required this.itemBuilder,
  });

  @override
  State<LogViewScaffold<F, E>> createState() => _LogViewScaffoldState<F, E>();
}

class _LogViewScaffoldFilterData<F> extends FilterData {
  final F? value;

  _LogViewScaffoldFilterData(this.value);
}

class _LogViewScaffoldState<F, E> extends State<LogViewScaffold<F, E>> {
  final listController = FilteredListController<_LogViewScaffoldFilterData<F>>();
  bool filterBar = false;

  final bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.listListenable,
      builder: (context, child) {
        final logReversed = widget.listGetter();

        return FilteredListView<_LogViewScaffoldFilterData<F>>(
          controller: listController,
          filterBuilder: (context, controller) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Toolbar(
                leading: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SearchField(
                        onChange: (value) => controller.apply(search: value),
                      ),
                    ),
                  ),
                ],
                trailing: [
                  // Toggle filter bar button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        filterBar = !filterBar;
                      });

                      if (!filterBar) {
                        controller.reset(search: false);
                      }
                    },
                    icon: const Icon(Icons.filter_alt),
                    tooltip: 'Toggle filters',
                    style: TextButton.styleFrom(
                      foregroundColor: filterBar ? theme.colorScheme.primary : null,
                    ),
                  ),

                  ...widget.toolbarActions,
                ],
              ),

              //
              if (isDesktop && filterBar)
                _LogViewFilterBar<F>(
                  value: controller.filter?.value,
                  values: widget.filterValues,
                  onFilter: (value) => controller.apply(filter: _LogViewScaffoldFilterData(value)),
                ),
            ],
          ),
          builder: (context, controller) {
            final filteredLog = widget.onFilter(logReversed, controller.search, controller.filter?.value);

            return Stack(
              children: [
                KeyboardDismisser(
                  child: ListView.builder(
                    itemCount: filteredLog.length + ((!isDesktop && filterBar) ? 1 : 0),
                    itemBuilder: (context, index) {
                      if ((!isDesktop && filterBar) && index == 0) {
                        return _LogViewFilterBar<F>(
                          value: controller.filter?.value,
                          values: widget.filterValues,
                          onFilter: (value) => controller.apply(filter: _LogViewScaffoldFilterData(value)),
                        );
                      }

                      final record = filteredLog.elementAt(index - ((!isDesktop && filterBar) ? 1 : 0));
                      return widget.itemBuilder(record);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---

typedef _LogViewFilterBarApply<F> = void Function(F? value);

class _LogViewFilterBar<F> extends StatelessWidget {
  final F? value;
  final Iterable<LogViewFilterItem<F>> values;
  final _LogViewFilterBarApply<F> onFilter;

  const _LogViewFilterBar({
    super.key,
    required this.value,
    required this.values,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      // padding: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterBar<F?>(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: value,
            items: {
              FilterBarItem(
                child: const Text('All'),
                value: null,
              ),
              for (var l in values)
                FilterBarItem(
                  // TODO: Icon
                  child: Text(l.text),
                  value: l.value,
                ),
            },
            onChange: (value) {
              onFilter(value);
            },
          ),

          // Bottom divider
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Divider(height: 1),
          ),
        ],
      ),
    );
  }
}
