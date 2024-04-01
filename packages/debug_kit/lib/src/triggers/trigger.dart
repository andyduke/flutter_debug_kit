import 'package:debug_kit/src/controller.dart';
import 'package:flutter/widgets.dart';

typedef DebugKitTriggerBuilder = Widget Function(BuildContext context, DebugKitController controller, Widget child);

class DebugKitTrigger {
  final String name;
  final DebugKitTriggerBuilder builder;

  DebugKitTrigger({
    required this.name,
    required this.builder,
  });

  @override
  bool operator ==(covariant DebugKitTrigger other) => (name == other.name);

  @override
  int get hashCode => name.hashCode;
}
