part of 'http_log_page.dart';

enum _DebugKitHttpLogLevel {
  info(100, 199, 'Information'),
  success(200, 299, 'Successful'),
  redirect(300, 399, 'Redirection'),
  clientError(400, 499, 'Client error'),
  serverError(500, 599, 'Server error');

  final int startCode;
  final int endCode;
  final String name;

  const _DebugKitHttpLogLevel(this.startCode, this.endCode, this.name);

  bool contains(int? statusCode) {
    return (statusCode != null) && (statusCode >= startCode) && (statusCode <= endCode);
  }

  @override
  String toString() => name;
}

class _HttpLogViewer extends StatelessWidget {
  final DebugKitHttpLogController controller;

  const _HttpLogViewer({
    required this.controller,
  });

  Iterable<DebugKitHttpLogEntry> _filter(
      Iterable<DebugKitHttpLogEntry> entries, String? search, _DebugKitHttpLogLevel? filter) {
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
          _DebugKitHttpLogLevel.values.map((l) => LogViewFilterItem<_DebugKitHttpLogLevel>(text: l.name, value: l)),
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
  final DebugKitHttpLogEntry entry;

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

    if (_DebugKitHttpLogLevel.info.contains(statusCode)) {
      status = const _Dot(color: Colors.blue);
    } else if (_DebugKitHttpLogLevel.success.contains(statusCode)) {
      status = const _Dot(color: Colors.green);
    } else if (_DebugKitHttpLogLevel.redirect.contains(statusCode)) {
      status = const _Dot(color: Colors.cyan);
    } else if (_DebugKitHttpLogLevel.clientError.contains(statusCode)) {
      status = const _Dot(color: Colors.purple);
    } else if (_DebugKitHttpLogLevel.serverError.contains(statusCode)) {
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
