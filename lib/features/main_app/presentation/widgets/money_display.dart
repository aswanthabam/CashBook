import 'package:cashbook/core/theme/app_palatte.dart';
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
        Text(widget.text, style: const TextStyle(
          fontSize: 40,
          color: AppPalatte.primary
        ),),
        Text(widget.subText, style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppPalatte.primarySemiDark
        ),),
      ],
    ),);
  }
}