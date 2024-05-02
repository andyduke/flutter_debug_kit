import 'package:flutter/material.dart';

class SliverCenter extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const SliverCenter({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: padding,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
