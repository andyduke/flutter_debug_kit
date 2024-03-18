import 'package:debug_panel/src/pages/shared_prefs_page/edit_storage_entry_form.dart';
import 'package:flutter/material.dart';

class EditStorageEntryDialog extends StatefulWidget {
  static Future<Object?> show({
    required BuildContext context,
    String? title,
    required String name,
    Object? value,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => EditStorageEntryDialog(
        title: title,
        name: name,
        value: value,
      ),
    );
  }

  // ---

  final String? title;
  final String name;
  final Object? value;

  const EditStorageEntryDialog({
    super.key,
    this.title,
    required this.name,
    this.value,
  });

  @override
  State<EditStorageEntryDialog> createState() => _EditStorageEntryDialogState();
}

class _EditStorageEntryDialogState extends State<EditStorageEntryDialog> {
  late final valueController = EditStorageEntryFormController(widget.value);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: (widget.title != null) ? Text(widget.title!) : null,
      content: SingleChildScrollView(
        child: EditStorageEntryForm(
          name: widget.name,
          controller: valueController,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(valueController.value),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }
}
