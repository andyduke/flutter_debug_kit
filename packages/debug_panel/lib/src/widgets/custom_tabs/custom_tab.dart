part of 'custom_tabbar.dart';

enum CustomTabState {
  hovered,
  selected,
  disabled;

  static Set<CustomTabState> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CustomTabItemViewScope>()?.states ?? <CustomTabState>{};
  }
}

class CustomTabStateProperty<T> implements StateProperty<T, CustomTabState> {
  final T normal;
  final T? hovered;
  final T? selected;
  final T? disabled;

  const CustomTabStateProperty(
    this.normal, {
    this.hovered,
    this.selected,
    this.disabled,
  });

  @override
  T resolve(Set<CustomTabState> states) {
    if (states.contains(CustomTabState.disabled)) {
      return disabled ?? normal;
    }
    if (states.contains(CustomTabState.selected)) {
      return selected ?? normal;
    }
    if (states.contains(CustomTabState.hovered)) {
      return hovered ?? normal;
    }
    return normal;
  }

  static CustomTabStateProperty<T>? lerp<T>(
    CustomTabStateProperty<T>? a,
    CustomTabStateProperty<T>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    return StateProperty.lerp<CustomTabStateProperty<T>, T, CustomTabState>(a, b, t, lerpFunction);
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
