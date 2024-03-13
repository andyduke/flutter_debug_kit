import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditStorageEntryFormController with ChangeNotifier {
  EditStorageEntryFormController([Object? value]) : _value = value;

  Object? get value => _value;
  Object? _value;
  set value(Object? newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}

class EditStorageEntryForm extends StatefulWidget {
  final EditStorageEntryFormController controller;
  final String name;

  const EditStorageEntryForm({
    super.key,
    required this.controller,
    required this.name,
  });

  @override
  State<EditStorageEntryForm> createState() => _EditStorageEntryFormState();
}

class _EditStorageEntryFormState extends State<EditStorageEntryForm> {
  late final textController = TextEditingController(text: '$value');

  Object? get value => widget.controller.value;
  set value(Object? newValue) {
    widget.controller.value = newValue;

    switch (value.runtimeType) {
      case String:
      case int:
      case double:
        textController.text = '$value';
        break;
    }
  }

  Widget _buildValueEditor() {
    switch (value.runtimeType) {
      case String:
        return TextField(
          controller: textController,
          autofocus: true,
          onChanged: (newValue) => setState(() {
            widget.controller.value = newValue;
          }),
        );

      case int:
        return TextField(
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'\-?[0-9]'))],
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          controller: textController,
          autofocus: true,
          onChanged: (newValue) => setState(() {
            widget.controller.value = int.tryParse(newValue) ?? value;
          }),
        );

      case double:
        return TextField(
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*\.?\d*)'))],
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          controller: textController,
          autofocus: true,
          onChanged: (newValue) => setState(() {
            widget.controller.value = double.tryParse(newValue) ?? value;
          }),
        );

      case bool:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: Switch.adaptive(
              value: value as bool,
              onChanged: (newValue) => setState(() {
                widget.controller.value = newValue;
              }),
            ),
          ),
        );

      // TODO: StringList editor

      default:
        return Text('Unknown type: ${value.runtimeType}');
    }
  }

  Widget _buildLayout() {
    final theme = Theme.of(context);

    if (value is bool) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(widget.name, style: TextStyle(color: theme.colorScheme.primary))),
          const SizedBox(width: 10),
          _buildValueEditor(),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.name, style: TextStyle(color: theme.colorScheme.primary)),
          const SizedBox(height: 10),
          _buildValueEditor(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 240,
      ),
      child: _buildLayout(),
    );
  }
}
