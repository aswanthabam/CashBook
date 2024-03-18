import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({super.key, required this.text, required this.controller});

  final String text;
  final TextEditingController controller;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height * 0.09,
      padding: EdgeInsets.all(width * 0.03),
      child: TextFormField(
        onTapOutside: (PointerDownEvent event) {
          FocusScope.of(context).unfocus();
        },
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).extension<AppColorsExtension>()!.primaryLight,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorLight,
              width: 10,
            ),
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
          labelText: widget.text,
        ),
      ),
    );
  }
}
