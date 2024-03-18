import 'package:debug_panel/src/theme/theme_data.dart';
import 'package:flutter/material.dart';

class DebugPanelTheme extends StatelessWidget {
  final Widget child;

  const DebugPanelTheme({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Theme(
      data: (brightness == Brightness.light) ? DebugPanelThemeData.dark() : DebugPanelThemeData.light(),
      child: child,
    );
  }
}
