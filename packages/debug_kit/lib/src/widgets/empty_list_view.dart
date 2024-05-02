import 'package:flutter/widgets.dart';

class EmptyListView extends StatelessWidget {
  final Widget? header;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const EmptyListView({
    super.key,
    this.header,
    required this.keyboardDismissBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: keyboardDismissBehavior,
      slivers: [
        if (header != null)
          SliverToBoxAdapter(
            child: header!,
          ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('No entries'),
            ),
          ),
        ),
      ],
    );
  }
}
