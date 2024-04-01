import 'package:debug_kit/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:flutter/material.dart';

typedef FilteredListViewBuilder<F extends FilterData> = Widget Function(
    BuildContext context, FilteredListController<F> controller);

class FilteredListView<F extends FilterData> extends StatelessWidget {
  final FilteredListController<F> controller;
  final FilteredListViewBuilder<F> filterBuilder;
  final FilteredListViewBuilder<F> builder;

  const FilteredListView({
    super.key,
    required this.controller,
    required this.filterBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) => filterBuilder(context, controller),
        ),

        // Body
        Expanded(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) => builder(context, controller),
          ),
        ),
      ],
    );
  }
}
