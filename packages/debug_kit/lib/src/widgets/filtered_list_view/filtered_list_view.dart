import 'package:debug_kit/src/widgets/filtered_list_view/controllers/filtered_list_controller.dart';
import 'package:debug_kit/src/widgets/filtered_list_view/models/filter_data.dart';
import 'package:flutter/material.dart';

typedef FilteredListViewBuilder<F extends FilterData, T> = Widget Function(
  BuildContext context,
  FilteredListController<F, T> controller,
);

typedef FilteredListDataReloader = Future<void> Function();

typedef FilteredListDataBuilder<F extends FilterData, T> = Widget Function(
  BuildContext context,
  FilteredListController<F, T> controller,
  List<T> data,
);

typedef FilteredListErrorBuilder<F extends FilterData, T> = Widget Function(
  BuildContext context,
  FilteredListController<F, T> controller,
  Object error,
  StackTrace? stackTrace,
);

typedef FilteredListEmptyBuilder<F extends FilterData, T> = Widget Function(
  BuildContext context,
  FilteredListController<F, T> controller,
);

class FilteredListView<F extends FilterData, T> extends StatefulWidget {
  final FilteredListController<F, T> controller;
  final FilteredListViewBuilder<F, T>? filterBuilder;
  final FilteredListDataBuilder<F, T> builder;
  final WidgetBuilder? waitingBuilder;
  final FilteredListErrorBuilder? errorBuilder;
  final FilteredListEmptyBuilder<F, T>? emptyBuilder;
  final bool highLatencyFetch;
  final bool checkEmpty;

  const FilteredListView({
    super.key,
    required this.controller,
    this.filterBuilder,
    required this.builder,
    this.waitingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.highLatencyFetch = false,
    this.checkEmpty = true,
  });

  @override
  State<FilteredListView<F, T>> createState() => _FilteredListViewState<F, T>();
}

class _FilteredListViewState<F extends FilterData, T> extends State<FilteredListView<F, T>> {
  late FilteredListController<F, T> controller = widget.controller;

  @override
  void initState() {
    super.initState();

    controller.addListener(_updated);
  }

  @override
  void didUpdateWidget(covariant FilteredListView<F, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      controller.removeListener(_updated);
      controller = widget.controller;
      controller.addListener(_updated);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updated);

    super.dispose();
  }

  void _updated() {
    setState(() {});
  }

  Widget _buildEmpty(
    BuildContext context,
    FilteredListController<F, T> controller,
  ) {
    return Center(
      child: Text(
        'No data',
        style: TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }

  Widget _buildData(BuildContext context, List<T> data) {
    if (widget.checkEmpty && data.isEmpty) {
      return (widget.emptyBuilder ?? _buildEmpty).call(context, widget.controller);
    } else {
      return widget.builder(context, widget.controller, data);
    }
  }

  Widget _buildError(BuildContext context, Object error, StackTrace? stackTrace) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(
        context,
        controller,
        error,
        stackTrace,
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Text(
          '$error\n\n$stackTrace',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildWaiting(BuildContext context) {
    if (widget.waitingBuilder != null) {
      return widget.waitingBuilder!(context);
    }

    return const Center(
      child: SizedBox.square(
        dimension: 32,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reloading = widget.controller.reloading;
    final body = FutureBuilder<List<T>>(
      key: ValueKey(widget.controller),
      future: widget.controller.fetch(),
      builder: (context, snapshot) {
        // print('$snapshot');

        return switch (snapshot) {
          AsyncSnapshot(data: List<T> data, hasData: true)
              when (reloading || (!widget.highLatencyFetch || (snapshot.connectionState == ConnectionState.done))) =>
            _buildData(context, data),
          AsyncSnapshot(error: Object error, stackTrace: StackTrace? stackTrace, hasError: true)
              when (reloading || (!widget.highLatencyFetch || (snapshot.connectionState == ConnectionState.done))) =>
            _buildError(context, error, stackTrace),
          _ => _buildWaiting(context),
        };
      },
    );

    if (widget.filterBuilder == null) {
      return body;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter bar
        if (widget.filterBuilder != null) widget.filterBuilder!(context, widget.controller),

        // Body
        Expanded(
          child: body,
        ),
      ],
    );
  }
}
