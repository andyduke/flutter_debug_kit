part of 'list_view_builders.dart';

class ListViewBuilder extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? emptyViewBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const ListViewBuilder({
    super.key,
    this.header,
    this.footer,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyViewBuilder,
    this.controller,
    this.padding,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    return ListViewBaseBuilder(
      header: header,
      footer: footer,
      listBuilder: (context, itemCount, listItemBuilder, listSeparatorBuilder) {
        if (listSeparatorBuilder == null) {
          return ListView.builder(
            itemCount: itemCount,
            itemBuilder: listItemBuilder,
            controller: controller,
            padding: padding,
            restorationId: restorationId,
            keyboardDismissBehavior: keyboardDismissBehavior,
          );
        } else {
          return ListView.separated(
            itemCount: itemCount,
            itemBuilder: listItemBuilder,
            separatorBuilder: listSeparatorBuilder,
            controller: controller,
            padding: padding,
            restorationId: restorationId,
            keyboardDismissBehavior: keyboardDismissBehavior,
          );
        }
      },
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      emptyViewBuilder: emptyViewBuilder,
    );
  }
}
