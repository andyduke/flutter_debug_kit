import 'package:flutter/widgets.dart';

class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTapDown: (details) {
        var f = FocusScope.of(context);
        if (!f.hasPrimaryFocus) {
          f.unfocus();
        }
      },
      child: child,
    );
  }
}
