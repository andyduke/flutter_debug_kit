import 'package:flutter/material.dart';

class DebugPanelDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final bool isExpanded;
  final DropdownButtonBuilder? selectedItemBuilder;
  final double? itemHeight;

  const DebugPanelDropdownButton({
    super.key,
    this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded = true,
    this.selectedItemBuilder,
    this.itemHeight = kMinInteractiveDimension,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.colorScheme.surfaceVariant,
      ),
      child: Theme(
        data: theme.copyWith(
          focusColor: (theme.brightness == Brightness.dark)
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.primaryContainer,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            itemHeight: itemHeight,
            isExpanded: isExpanded,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            borderRadius: BorderRadius.circular(5),
            icon: const Icon(Icons.expand_more),
            focusColor: theme.colorScheme.primary,
            dropdownColor: theme.colorScheme.surfaceVariant,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedItemBuilder: selectedItemBuilder,

            //
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
