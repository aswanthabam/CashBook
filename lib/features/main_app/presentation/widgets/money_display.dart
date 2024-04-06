import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class MoneyDisplay extends StatefulWidget {
  const MoneyDisplay({super.key, required this.text, required this.subText});
  final String subText;
  final String text;

  @override
  State<MoneyDisplay> createState() => _MoneyDisplayState();
}

class _MoneyDisplayState extends State<MoneyDisplay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text, style:  TextStyle(
          fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).extension<AppColorsExtension>()!.primary
        ),),
        Text(widget.subText, style:  TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).extension<AppColorsExtension>()!.primarySemiDark
        ),),
      ],
    ),);
  }
}