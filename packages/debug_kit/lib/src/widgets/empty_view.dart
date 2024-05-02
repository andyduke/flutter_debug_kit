import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;

  const EmptyView({
    super.key,
    this.padding,
    required this.child,
  });

  EmptyView.text(
    String text, {
    super.key,
    this.padding,
  }) : child = Text(text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(18.0), // TODO: Extract to theme
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 17, color: Theme.of(context).disabledColor), // TODO: Extract to theme
        child: child,
      ),
    );
  }
}
