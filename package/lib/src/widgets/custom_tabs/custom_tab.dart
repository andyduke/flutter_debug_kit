part of 'custom_tabbar.dart';

enum CustomTabState {
  hovered,
  selected,
  disabled;

  static Set<CustomTabState> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CustomTabItemViewScope>()?.states ?? <CustomTabState>{};
  }
}

/*
abstract interface class CustomTab {
  final Key? key;

  abstract final double? height;

  const CustomTab({
    this.key,
  });

  Widget build(BuildContext context, Set<CustomTabState> states);
}
*/
