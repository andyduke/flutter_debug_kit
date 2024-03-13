import 'package:flutter/material.dart';

class FloatingBottomBar extends StatelessWidget {
  static const kFloatingBarHeight = 48.0;
  static const kFloatingBarOffset = 16.0;

  final bool highlighted;
  final List<Widget> children;

  const FloatingBottomBar({
    super.key,
    required this.highlighted,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextStyle.merge(
      style: TextStyle(
          color: highlighted ? theme.colorScheme.onTertiaryContainer : theme.colorScheme.onSecondaryContainer),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                highlighted ? theme.colorScheme.onTertiaryContainer : theme.colorScheme.onSecondaryContainer,
          ),
        ),
        child: AnimatedContainer(
          constraints: const BoxConstraints(
            maxHeight: kFloatingBarHeight,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 32) + const EdgeInsets.only(bottom: kFloatingBarOffset),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: highlighted ? theme.colorScheme.tertiaryContainer : theme.colorScheme.secondaryContainer,
            shadows: [
              BoxShadow(
                offset: const Offset(0, -1),
                color: Colors.black.withOpacity(0.15),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
