import 'package:flutter/widgets.dart';

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    super.key,
    required this.keyboardDismissBehavior,
  });

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: keyboardDismissBehavior,
      slivers: const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text('No entries'),
          ),
        ),
      ],
    );
  }
}
