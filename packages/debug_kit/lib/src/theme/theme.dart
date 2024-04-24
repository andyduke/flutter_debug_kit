import 'package:debug_kit/src/theme/theme_data.dart';
import 'package:debug_kit/src/utils/scroll_behavior.dart';
import 'package:flutter/material.dart';

class DebugKitTheme extends StatelessWidget {
  final Widget child;

  const DebugKitTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Theme(
      data: (brightness == Brightness.light) ? DebugKitThemeData.dark() : DebugKitThemeData.light(),
      child: ScrollConfiguration(
        behavior: DebugKitScrollBehavior(),
        child: child,
      ),
      // child: child,
    );
  }
}
