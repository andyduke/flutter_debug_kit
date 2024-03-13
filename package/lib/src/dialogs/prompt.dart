import 'package:flutter/material.dart';

Future<String?> showPrompt({
  required BuildContext context,
  String? title,
  Widget? intro,
  required String prompt,
  String? defaultValue,
  Widget? footnote,
}) async {
  return showDialog<String?>(
    context: context,
    builder: (context) => PromptDialog(
      title: title,
      intro: intro,
      prompt: prompt,
      defaultValue: defaultValue,
      footnote: footnote,
    ),
  );
}

class PromptDialog extends StatefulWidget {
  final String? title;
  final Widget? intro;
  final String prompt;
  final String? defaultValue;
  final Widget? footnote;

  const PromptDialog({
    super.key,
    this.title,
    this.intro,
    required this.prompt,
    this.defaultValue,
    this.footnote,
  });

  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  late final textController = TextEditingController(text: widget.defaultValue);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: (widget.title != null) ? Text(widget.title!) : null,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.intro != null) widget.intro!,

            //
            Text(widget.prompt),
            TextField(
              controller: textController,
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(textController.text),
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
