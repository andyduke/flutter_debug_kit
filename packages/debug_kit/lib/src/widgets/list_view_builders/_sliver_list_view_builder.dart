part of 'list_view_builders.dart';

class SliverListViewBuilder extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? emptyViewBuilder;

  const SliverListViewBuilder({
    super.key,
    this.header,
    this.footer,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyViewBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListViewBaseBuilder(
      header: header,
      footer: footer,
      listBuilder: (context, itemCount, listItemBuilder, listSeparatorBuilder) {
        if (listSeparatorBuilder == null) {
          return SliverList.builder(
            itemCount: itemCount,
            itemBuilder: listItemBuilder,
          );
        } else {
          return SliverList.separated(
            itemCount: itemCount,
            itemBuilder: listItemBuilder,
            separatorBuilder: listSeparatorBuilder,
          );
        }
      },
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      emptyViewBuilder: (emptyViewBuilder != null)
          ? (context) => SliverToBoxAdapter(
                child: emptyViewBuilder!(context),
              )
          : null,
    );
  }
}
