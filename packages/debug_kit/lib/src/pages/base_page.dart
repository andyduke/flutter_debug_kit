import 'package:debug_kit/src/controller.dart';
import 'package:flutter/widgets.dart';

abstract class DebugKitPanelBasePage {
  static const defaultPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 16);

  abstract final String name;
  abstract final String title;
  abstract final IconData? icon;

  Widget build(BuildContext context, DebugKitController controller);

  @override
  bool operator ==(covariant DebugKitPanelBasePage other) => (name == other.name);

  @override
  int get hashCode => name.hashCode;
}
