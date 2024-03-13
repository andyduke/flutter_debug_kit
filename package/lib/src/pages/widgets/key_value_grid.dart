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

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final key = entries.keys.elementAt(index);
        return _KeyValueTile(
          name: key,
          value: entries[key],
          onDelete: () {
            onDelete?.call(key);
          },
          primaryTextStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 17, color: theme.colorScheme.onSurface),
          secondaryTextStyle:
              theme.textTheme.bodyMedium?.copyWith(fontSize: 15, color: theme.colorScheme.onSurfaceVariant),
        );
      },
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(),
      ),
    );
  }
}

class _KeyValueTile extends StatelessWidget {
  final String name;
  final Object? value;
  final VoidCallback? onDelete;
  final TextStyle? primaryTextStyle;
  final TextStyle? secondaryTextStyle;

  const _KeyValueTile({
    required this.name,
    required this.value,
    this.onDelete,
    this.primaryTextStyle,
    this.secondaryTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6, bottom: 6, right: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Entry name & type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Entry name
                Text(name,
                    style: (primaryTextStyle ?? const TextStyle()).merge(const TextStyle(fontWeight: FontWeight.w500))),

                // Entry type
                Text('${value.runtimeType}', style: secondaryTextStyle),
              ],
            ),
          ),

          // Entry value
          const SizedBox(width: 20),
          Text(
            '$value',
            style: (primaryTextStyle ?? const TextStyle()).merge(TextStyle(color: theme.colorScheme.primary)),
          ),

          // Remove button
          const SizedBox(width: 4),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete, color: theme.colorScheme.error),
            tooltip: 'Remove entry',
          ),
        ],
      ),
    );
  }
}
