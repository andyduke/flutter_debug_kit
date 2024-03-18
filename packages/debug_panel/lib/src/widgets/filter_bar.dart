import 'package:flutter/material.dart';

class FilterBarItem<T> {
  final Widget child;
  final T value;

  FilterBarItem({
    required this.child,
    required this.value,
  });

  @override
  bool operator ==(covariant FilterBarItem<T> other) => value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class FilterBar<T> extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Set<FilterBarItem<T>> items;
  final T? value;
  final ValueChanged<T> onChange;

  const FilterBar({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.items,
    this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: SizedBox(
        height: 42,
        child: ListView.builder(
          padding: padding,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);

            return Padding(
              padding: EdgeInsets.only(left: (index > 0) ? 20 : 0),
              child: _FilterBarButton(
                onPressed: () => onChange(item.value),
                selected: value == item.value,
                child: item.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterBarButton extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onPressed;

  const _FilterBarButton({
    required this.child,
    this.selected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: theme.colorScheme.secondaryContainer,
            width: 2.0,
          ),
          color: selected ? theme.colorScheme.secondaryContainer : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DefaultTextStyle.merge(
          style:
              TextStyle(fontWeight: FontWeight.w500, color: selected ? theme.colorScheme.onSecondaryContainer : null),
          child: child,
        ),
      ),
    );
  }
}
