import 'package:flutter/material.dart';

class DebugPanelFloatingButton extends StatelessWidget {
  static const double buttonSize = 48.0;

  final VoidCallback onPressed;

  const DebugPanelFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        fixedSize: const Size(buttonSize, buttonSize),
      ),
      child: const Center(child: Icon(Icons.bug_report)),
    );
  }
}
