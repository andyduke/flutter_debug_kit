import 'package:debug_panel/src/controller.dart';
import 'package:flutter/widgets.dart';

abstract class DebugPanelBasePage {
  static const defaultPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 16);

  abstract final String name;
  abstract final String title;
  abstract final IconData? icon;

  Widget build(BuildContext context, DebugPanelController controller);

  @override
  bool operator ==(covariant DebugPanelBasePage other) => (name == other.name);

  @override
  int get hashCode => name.hashCode;
}
