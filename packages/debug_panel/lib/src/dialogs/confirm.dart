import 'package:flutter/material.dart';

Future<bool> showConfirmation({
  required BuildContext context,
  String? title,
  required Widget text,
  String? yesText,
  String? noText,
  Color? yesColor,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: (title != null) ? Text(title) : null,
      content: text,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yesText ?? 'Yes', style: TextStyle(color: yesColor)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(noText ?? 'No'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
