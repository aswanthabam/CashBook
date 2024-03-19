import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  Tag(
      {super.key,
      required this.onPressed,
      required this.name,
      required this.color,
      required this.highlightColor,
      this.textColor = Colors.white,
      this.isHighlighted = false});

  final String name;
  final Color color;
  final Color highlightColor;
  final Color textColor;
  bool isHighlighted = false;
  final Function() onPressed;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return IntrinsicWidth(
        child: Container(
      height: height * 0.04,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(width * 0.05),
      ),
      child: Center(
        child: Text(
          widget.name,
          style: TextStyle(
            color: widget.textColor,
            fontSize: width * 0.035,
          ),
        ),
      ),
    ));
  }
}
