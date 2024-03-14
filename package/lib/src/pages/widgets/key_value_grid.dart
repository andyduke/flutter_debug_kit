import 'package:flutter/material.dart';

class KeyValueGrid extends StatelessWidget {
  final Map<String, dynamic> entries;
  final ValueChanged<String>? onEdit;
  final ValueChanged<String>? onDelete;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const KeyValueGrid({
    super.key,
    required this.entries,
    this.onEdit,
    this.onDelete,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      keyboardDismissBehavior: keyboardDismissBehavior,
      padding: EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final key = entries.keys.elementAt(index);
        return _KeyValueTile(
          name: key,
          value: entries[key],
          onEdit: () {
            onEdit?.call(key);
          },
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
        child: Divider(height: 1),
      ),
    );
  }
}

class _KeyValueTile extends StatelessWidget {
  final String name;
  final Object? value;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final TextStyle? primaryTextStyle;
  final TextStyle? secondaryTextStyle;

  const _KeyValueTile({
    required this.name,
    required this.value,
    this.onEdit,
    this.onDelete,
    this.primaryTextStyle,
    this.secondaryTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 6),
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
                      style:
                          (primaryTextStyle ?? const TextStyle()).merge(const TextStyle(fontWeight: FontWeight.w500))),

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
      ),
    );
  }
}
