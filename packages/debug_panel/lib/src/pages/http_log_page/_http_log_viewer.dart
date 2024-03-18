part of 'http_log_page.dart';

enum _DebugPanelHttpLogLevel {
  info(100, 199, 'Information'),
  success(200, 299, 'Successful'),
  redirect(300, 399, 'Redirection'),
  clientError(400, 499, 'Client error'),
  serverError(500, 599, 'Server error');

  final int startCode;
  final int endCode;
  final String name;

  const _DebugPanelHttpLogLevel(this.startCode, this.endCode, this.name);

  bool contains(int? statusCode) {
    return (statusCode != null) && (statusCode >= startCode) && (statusCode <= endCode);
  }

  @override
  String toString() => name;
}

class _HttpLogViewer extends StatelessWidget {
  final DebugPanelHttpLogController controller;

  const _HttpLogViewer({
    required this.controller,
  });

  Iterable<DebugPanelHttpLogEntry> _filter(
      Iterable<DebugPanelHttpLogEntry> entries, String? search, _DebugPanelHttpLogLevel? filter) {
    final searchText = ((search == null) || (search.isEmpty)) ? null : search;

    if (searchText == null && (filter == null)) {
      return entries;
    }

    final result = entries.where((entry) {
      return ((searchText == null) ||
              (('${entry.request.url}'.containsInsensitive(searchText) ||
                  ('${entry.response?.statusCode}' == searchText)))) &&
          (filter == null || filter.contains(entry.response?.statusCode));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LogViewScaffold(
      filterValues:
          _DebugPanelHttpLogLevel.values.map((l) => LogViewFilterItem<_DebugPanelHttpLogLevel>(text: l.name, value: l)),
      onFilter: _filter,
      listListenable: controller,
      listGetter: () => controller.log.toList(growable: false).reversed,
      itemBuilder: (entry) => _HttpEntryTile(entry: entry),
      // toolbarActions: [
      //   // TODO: Clear button
      // ],
    );
  }
}

class _HttpEntryTile extends StatelessWidget {
  final DebugPanelHttpLogEntry entry;

  const _HttpEntryTile({
    required this.entry,
  });

  Widget _buildLeading(BuildContext context) {
    final result = (entry.response != null)
        ? _buildStatusIcon(context)
        : const SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          );

    return SizedBox.square(
      dimension: 32,
      child: Center(
        child: result,
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    final int statusCode = entry.response?.statusCode ?? 0;
    late Widget status;

    if (_DebugPanelHttpLogLevel.info.contains(statusCode)) {
      status = const _Dot(color: Colors.blue);
    } else if (_DebugPanelHttpLogLevel.success.contains(statusCode)) {
      status = const _Dot(color: Colors.green);
    } else if (_DebugPanelHttpLogLevel.redirect.contains(statusCode)) {
      status = const _Dot(color: Colors.cyan);
    } else if (_DebugPanelHttpLogLevel.clientError.contains(statusCode)) {
      status = const _Dot(color: Colors.purple);
    } else if (_DebugPanelHttpLogLevel.serverError.contains(statusCode)) {
      status = const _Dot(color: Colors.red);
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: entry,
      builder: (context, child) => ListTile(
        leading: _buildLeading(context),
        title: Text('${entry.request.method.toUpperCase()} ${entry.request.url}'), // TODO: Text.rich
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
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
      dimension: 8,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

/*
// TODO: Refactor - extract to LogViewScaffold
class _HttpLogViewer extends StatefulWidget {
  final DebugPanelHttpLogController controller;

  const _HttpLogViewer({
    required this.controller,
  });

  @override
  State<_HttpLogViewer> createState() => _HttpLogViewerState();
}

class _HttpLogFilterData extends FilterData {
  final _DebugPanelHttpLogLevel? level;

  _HttpLogFilterData({
    required this.level,
  });

  @override
  String toString() => '_HttpLogFilterData(${level ?? 'none'})';
}

class _HttpLogViewerState extends State<_HttpLogViewer> {
  final listController = FilteredListController<_HttpLogFilterData>();
  bool filterBar = false;

  final bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  Iterable<DebugPanelHttpLogEntry> _filter(
      Iterable<DebugPanelHttpLogEntry> entries, FilteredListController<_HttpLogFilterData> controller) {
    final search = ((controller.search == null) || (controller.search!.isEmpty)) ? null : controller.search;
    final filterLevel = controller.filter?.level;

    if (search == null && (filterLevel == null)) {
      return entries;
    }

    final result = entries.where((entry) {
      return ((search == null) ||
              (('${entry.request.url}'.containsInsensitive(search) || ('${entry.response?.statusCode}' == search)))) &&
          (filterLevel == null || filterLevel.contains(entry.response?.statusCode));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final logReversed = widget.controller.log.toList(growable: false).reversed;

        return FilteredListView<_HttpLogFilterData>(
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

                  /*
                  // TODO: Move to dropdown menu?
                  // Clear log button
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _clear,
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Remove all',
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                  */
                ],
              ),

              //
              if (isDesktop && filterBar) _HttpLogPageFilterBar(controller: controller),
            ],
          ),
          builder: (context, controller) {
            final filteredLog = _filter(logReversed, controller);

            return Stack(
              children: [
                KeyboardDismisser(
                  child: ListView.builder(
                    itemCount: filteredLog.length + ((!isDesktop && filterBar) ? 1 : 0),
                    itemBuilder: (context, index) {
                      if ((!isDesktop && filterBar) && index == 0) {
                        return _HttpLogPageFilterBar(controller: controller);
                      }

                      final record = filteredLog.elementAt(index - ((!isDesktop && filterBar) ? 1 : 0));

                      // TODO: _HttpEntryTile
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
*/
