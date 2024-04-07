import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  Tag({
    super.key,
    required this.onPressed,
    required this.tagData,
    required this.highlightColor,
    required this.icon,
  });

  final Color highlightColor;
  final Function() onPressed;
  final TagData tagData;
  final IconData icon;

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
          color: widget.tagData.isSelected
              ? widget.highlightColor
              : widget.tagData.colorValue,
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
        child: Center(
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: width * 0.04,
              ),
              const SizedBox(width: 5),
              Text(
                widget.tagData.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.035,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
