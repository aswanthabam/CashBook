import 'package:cashbook/features/main_app/domain/models/tag_data.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  Tag(
      {super.key,
      required this.onPressed,
      required this.tagData,
      required this.highlightColor});

  final Color highlightColor;
  final Function() onPressed;
  final TagData tagData;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onPressed,
      child: IntrinsicWidth(
          child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.005),
        height: height * 0.04,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        decoration: BoxDecoration(
          color: widget.tagData.isSelected ? widget.highlightColor : widget.tagData.color,
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
        child: Center(
          child: Text(
            widget.tagData.name,
            style: TextStyle(
              color: widget.tagData.textColor,
              fontSize: width * 0.035,
            ),
          ),
        ),
      )),
    );
  }
}
