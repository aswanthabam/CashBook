import 'package:flutter/material.dart';

class NamedCheckBox extends StatefulWidget {
  NamedCheckBox({super.key, required this.values, required this.onChange});
  List<String> values;
  Function(int) onChange;
  @override
  State<NamedCheckBox> createState() => _NamedCheckBoxState();
}

class _NamedCheckBoxState extends State<NamedCheckBox> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.values.length * 100,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: widget.values
            .map<Widget>((value) => Expanded(
                child: GestureDetector(
                    onTap: () {
                      if (widget.values.indexOf(value) != selected) {
                        setState(() {
                          selected = widget.values.indexOf(value);
                        });
                        widget.onChange(selected);
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.values.indexOf(value) == selected
                                ? Colors.green.shade500
                                : Colors.transparent,
                            borderRadius: widget.values.indexOf(value) == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))
                                : (widget.values.indexOf(value) ==
                                        widget.values.length - 1
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                    : BorderRadius.circular(0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(value),
                          ],
                        )))))
            .toList(),
      ),
    );
  }
}
