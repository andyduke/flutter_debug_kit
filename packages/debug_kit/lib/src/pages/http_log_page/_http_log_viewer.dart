part of 'http_log_page.dart';

enum _DebugKitHttpLogLevel {
  // info(100, 199, 'Information'),
  // success(200, 299, 'Successful'),
  // redirect(300, 399, 'Redirection'),
  // clientError(400, 499, 'Client error'),
  // serverError(500, 599, 'Server error');

  pending(false, 'Pending'),
  success(true, 'Success', 0, 299),
  redirect(true, 'Redirection', 300, 399),
  error(true, 'Error', 400, 599);

  final bool finished;
  final String name;
  final int? startCode;
  final int? endCode;

  const _DebugKitHttpLogLevel(this.finished, this.name, [this.startCode, this.endCode])
      : assert(!finished || (finished && startCode != null && endCode != null));

  bool contains(int? statusCode) {
    return finished && (statusCode != null) && (statusCode >= startCode!) && (statusCode <= endCode!);
  }

  bool get isPending => !finished;

  @override
  String toString() => name;
}

class _HttpLogViewer extends StatelessWidget {
  final DebugKitHttpLogController controller;

  const _HttpLogViewer({
    required this.controller,
  });

  List<DebugKitHttpLogEntry> _filter(
    List<DebugKitHttpLogEntry> entries,
    String? search,
    _DebugKitHttpLogLevel? filter,
  ) {
    final searchText = ((search == null) || (search.isEmpty)) ? null : search;

    if (searchText == null && (filter == null)) {
      return entries;
    }

    final result = entries.where((entry) {
      return ((searchText == null) ||
              (('${entry.request.url}'.containsInsensitive(searchText) ||
                  ('${entry.response?.statusCode}' == searchText)))) &&
          (filter == null ||
              (filter.isPending && entry.response == null) ||
              filter.contains(entry.response?.statusCode));
    });

    return result.toList();
  }

  Future<void> _clear() async {
    // TODO: Confirm dialog
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /*
    return LogViewScaffold(
      filterValues:
          _DebugKitHttpLogLevel.values.map((l) => LogViewFilterItem<_DebugKitHttpLogLevel>(text: l.name, value: l)),
      onFilter: _filter,
      listListenable: controller,
      listGetter: () => controller.log.toList(growable: false).reversed,
      itemBuilder: (entry) => _HttpEntryTile(entry: entry),
      // toolbarActions: [
      //   // TODO: Clear button
      // ],
    );
    */

    return FilteredListScaffold<_DebugKitHttpLogLevel, DebugKitHttpLogEntry>(
      filterValues: _DebugKitHttpLogLevel.values,
      filterBuilder: (f) => _HttpEntryFilterView(f),
      onFilter: _filter,
      toolbarActions: [
        IconButton(
          onPressed: _clear,
          icon: const Icon(Icons.delete_sweep),
          tooltip: 'Remove all',
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
        ),
      ],
      listTitle: 'Last requests',
      listGetter: () => controller.log.toList(growable: false).reversed.toList(),
      listListenable: controller,
      itemBuilder: (context, entry) => _HttpEntryTile(entry: entry),
    );
  }
}

class _HttpEntryFilterView extends StatelessWidget {
  final _DebugKitHttpLogLevel? value;

  const _HttpEntryFilterView(this.value);

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color ?? Theme.of(context).colorScheme.primary;

    return (value == null)
        ? const Text('All')
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  size: 16,
                  color: color,
                ),
                child: switch (value!) {
                  _DebugKitHttpLogLevel.pending => const Icon(Icons.timer_outlined),
                  _DebugKitHttpLogLevel.success => const Icon(Icons.check),
                  _DebugKitHttpLogLevel.redirect => const Icon(Icons.keyboard_double_arrow_right_rounded),
                  _DebugKitHttpLogLevel.error => const Icon(Icons.error_outline),
                },
              ),
              const SizedBox(width: 6),
              Text(value!.name),
            ],
          );
  }
}

class _HttpEntryTile extends StatelessWidget {
  final DebugKitHttpLogEntry entry;

  const _HttpEntryTile({
    required this.entry,
  });

  Widget _buildStatusIcon(BuildContext context) {
    final int statusCode = entry.response?.statusCode ?? 0;
    late Widget status;

    /*
    if (_DebugKitHttpLogLevel.info.contains(statusCode)) {
      status = const _Dot(color: Colors.blue);
    } else if (_DebugKitHttpLogLevel.success.contains(statusCode)) {
      status = _Dot(color: Colors.teal.shade300);
    } else if (_DebugKitHttpLogLevel.redirect.contains(statusCode)) {
      status = const _Dot(color: Colors.cyan);
    } else if (_DebugKitHttpLogLevel.clientError.contains(statusCode)) {
      status = const _Dot(color: Colors.purple);
    } else if (_DebugKitHttpLogLevel.serverError.contains(statusCode)) {
      status = const _Dot(color: Colors.pink);
    }
    */

    if (_DebugKitHttpLogLevel.success.contains(statusCode)) {
      status = _Dot(color: Colors.teal.shade300);
    } else if (_DebugKitHttpLogLevel.redirect.contains(statusCode)) {
      status = const _Dot(color: Colors.amber);
    } else if (_DebugKitHttpLogLevel.error.contains(statusCode)) {
      status = _Dot(color: Theme.of(context).colorScheme.error); // TODO: Custom theme
    }

    return status;
  }

  Widget _buildMetaRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Status icon
        !entry.isFinished
            ? const SizedBox.square(dimension: 12, child: CircularProgressIndicator(strokeWidth: 2))
            : _buildStatusIcon(context),
        const SizedBox(width: 10),

        // Status code
        if (entry.isFinished) Text('${entry.status}  •  '),

        // HTTP Method
        Text(entry.request.method.toUpperCase()),

        // Time
        if (entry.isFinished)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                '${entry.elapsedTime.format()} • ${entry.request.timestamp.format(context)}',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: entry,
      builder: (context, child) => DebugKitListTile(
        supertitle: _buildMetaRow(context),
        title: Text(entry.request.summary, maxLines: 3, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 10,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
