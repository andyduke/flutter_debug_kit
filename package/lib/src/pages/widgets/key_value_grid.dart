import 'package:flutter/material.dart';

class KeyValueGrid extends StatelessWidget {
  final Map<String, dynamic> entries;
  final ValueChanged<String>? onDelete;

  const KeyValueGrid({
    super.key,
    required this.entries,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTileTheme(
      data: ListTileThemeData(
        titleAlignment: ListTileTitleAlignment.top,
        titleTextStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 17, color: theme.colorScheme.onSurface),
        subtitleTextStyle:
            theme.textTheme.bodyMedium?.copyWith(fontSize: 15, color: theme.colorScheme.onSurfaceVariant),
        iconColor: theme.colorScheme.secondary,
      ),
      child: ListView.separated(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final key = entries.keys.elementAt(index);
          return _KeyValueTile(
            name: key,
            value: entries[key],
            onDelete: () {
              onDelete?.call(key);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class _KeyValueTile extends StatelessWidget {
  final String name;
  final Object? value;
  final VoidCallback? onDelete;

  const _KeyValueTile({
    required this.name,
    required this.value,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      // TODO: onTap: () => Edit value
      contentPadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 6),
      leading: const Padding(
        padding: EdgeInsets.only(top: 3.0),
        child: Icon(Icons.article),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 20),
          Text(
            '$value',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ],
      ),
      subtitle: Text('${value.runtimeType}'),
      trailing: IconButton(
        onPressed: onDelete,
        icon: Icon(Icons.delete, color: theme.colorScheme.error),
        tooltip: 'Remove entry',
      ),
    );
  }
}

/*
class KeyValueGrid extends StatelessWidget {
  final Map<String, dynamic> entries;
  final ValueChanged<String>? onDelete;

  const KeyValueGrid({
    super.key,
    required this.entries,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Key'),
        ),
        DataColumn(
          label: Text('Value'),
        ),
        DataColumn(
          label: Text('Type'),
        ),
      ],
      source: _KeyValueDataSource(entries: entries),
    );
  }
}

class _KeyValueDataSource extends DataTableSource {
  final Map<String, dynamic> entries;

  _KeyValueDataSource({
    required this.entries,
  });

  @override
  int get rowCount => entries.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    final key = entries.keys.elementAt(index);
    final value = entries[key];

    return DataRow(
      cells: <DataCell>[
        DataCell(Text(key)),
        DataCell(Text('$value')),
        DataCell(Text('${value.runtimeType}')),
      ],
    );
  }
}
*/
