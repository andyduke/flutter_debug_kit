part of 'list_view_builders.dart';

typedef ListViewBaseBuilderListBuilder = Widget Function(
  BuildContext context,
  int itemCount,
  NullableIndexedWidgetBuilder listItemBuilder,
  IndexedWidgetBuilder? listSeparatorBuilder,
);

class ListViewBaseBuilder extends StatelessWidget {
  final ListViewBaseBuilderListBuilder listBuilder;
  final Widget? header;
  final Widget? footer;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? emptyViewBuilder;

  const ListViewBaseBuilder({
    super.key,
    required this.listBuilder,
    this.header,
    this.footer,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyViewBuilder,
  });

  Widget? _buildItem(BuildContext context, int index, int offset, int total) {
    if ((header != null) && (index == 0)) {
      return header!;
    }

    if ((footer != null) && (index == (total - 1))) {
      return footer!;
    }

    return itemBuilder(context, index + offset);
  }

  Widget _buildSeparator(BuildContext context, int index, int offset, int total) {
    if ((header != null) && (index == 0)) {
      return const SizedBox.shrink();
    }

    if ((footer != null) && (index >= (total - 2))) {
      return const SizedBox.shrink();
    }

    return separatorBuilder!(context, index + offset);
  }

  @override
  Widget build(BuildContext context) {
    final total = itemCount + ((header != null) ? 1 : 0) + ((footer != null) ? 1 : 0);
    final offset = (header != null) ? -1 : 0;

    if (itemCount == 0 && emptyViewBuilder != null) {
      final emptyTotal = 1 + ((header != null) ? 1 : 0) + ((footer != null) ? 1 : 0);

      return listBuilder(
        context,
        emptyTotal,
        (context, index) {
          if (index == 0 && header != null) {
            return header;
          } else if (index == (emptyTotal - 1) && footer != null) {
            return footer;
          }

          return emptyViewBuilder!(context);
        },
        null,
      );
    }

    return listBuilder(
      context,
      total,
      (context, index) => _buildItem(context, index, offset, total),
      (separatorBuilder != null) ? (context, index) => _buildSeparator(context, index, offset, total) : null,
    );
  }
}
