import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  final List<Widget> leading;
  final List<Widget> trailing;
  final bool divider;

  const Toolbar({
    super.key,
    required this.leading,
    required this.trailing,
    this.divider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: divider
            ? Border(bottom: BorderSide(width: 2, color: theme.dividerTheme.color ?? theme.dividerColor))
            : null,
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: (divider ? const EdgeInsets.symmetric(vertical: 6) : const EdgeInsets.only(top: 12, bottom: 2)),
      child: Row(
        children: [
          ...leading,
          const SizedBox(width: 16),
          ...trailing,
        ],
      ),
    );
  }
}
