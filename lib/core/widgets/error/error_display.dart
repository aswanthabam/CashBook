import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ErrorDisplay extends StatefulWidget {
  const ErrorDisplay(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      this.mainColor = Colors.grey});

  final String title;
  final String description;
  final IconData icon;
  final Color mainColor;

  @override
  State<ErrorDisplay> createState() => _ErrorDisplayState();
}

class _ErrorDisplayState extends State<ErrorDisplay> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppColorsExtension>()!.white,
          borderRadius: BorderRadius.circular(width * 0.05),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 1))
          ],
        ),
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            Icon(
              widget.icon,
              size: width * 0.1,
              color: widget.mainColor,
            ),
            SizedBox(
              height: width * 0.05,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: widget.mainColor),
            ),
            SizedBox(
              height: width * 0.05,
            ),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ));
  }
}
