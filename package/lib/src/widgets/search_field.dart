import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChange;

  const SearchField({
    super.key,
    this.value,
    required this.onChange,
  });

  @override
  State<SearchField> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  late final textController = TextEditingController(text: widget.value);
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: textController,
      onChanged: (value) => widget.onChange(value.trim()),
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: MaterialLocalizations.of(context).searchFieldLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        filled: true,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () {
              textController.text = '';
              focusNode.unfocus();
              widget.onChange('');
            },
            icon: const Icon(Icons.clear, size: 24),
          ),
        ),
      ),
    );
  }
}
