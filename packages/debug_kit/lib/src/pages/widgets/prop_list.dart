import 'package:flutter/material.dart';

class DebugKitPanelProperty {
  final String label;
  final String value;
  final TextSpan? extra;

  DebugKitPanelProperty({
    required this.label,
    required this.value,
    this.extra,
  });
}

class DebugKitPanelPropList extends StatelessWidget {
  final List<DebugKitPanelProperty> properties;

  const DebugKitPanelPropList({
    super.key,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var property in properties) _TextRow(label: property.label, value: property.value, extra: property.extra),
      ].fold(
        [],
        (previousValue, element) => [
          ...previousValue,
          previousValue.isNotEmpty ? const SizedBox(height: 10) : const SizedBox.shrink(),
          element,
        ],
      ),
    );
  }
}

class _TextRow extends StatelessWidget {
  final String label;
  final String value;
  final TextSpan? extra;

  const _TextRow({
    required this.label,
    required this.value,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label\n',
        children: [
          TextSpan(
            text: value,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            children: [
              if (extra != null) extra!,
            ],
          ),
        ],
      ),
    );
  }
}
