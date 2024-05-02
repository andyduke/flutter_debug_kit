import 'package:flutter/material.dart';

enum WaitingSize {
  tiny(size: 12, storkeWidth: 2),
  small(size: 20, storkeWidth: 2),
  large(size: 36, storkeWidth: 3);

  final double size;
  final double storkeWidth;

  const WaitingSize({
    required this.size,
    required this.storkeWidth,
  });
}

class Waiting extends StatelessWidget {
  final bool primary;
  final WaitingSize size;
  final EdgeInsets? padding;

  const Waiting({
    super.key,
    this.primary = true,
    this.size = WaitingSize.large,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox.square(
        dimension: size.size,
        child: CircularProgressIndicator(
          strokeWidth: size.storkeWidth,
          color: primary ? theme.colorScheme.primary : theme.disabledColor,
        ),
      ),
    );
  }
}
