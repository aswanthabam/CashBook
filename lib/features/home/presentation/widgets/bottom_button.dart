import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
        required this.onPressed,
        required this.icon,
        required this.text});

  final Function() onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.01),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .extension<AppColorsExtension>()!
                .black
                .withAlpha(150),
            borderRadius: BorderRadius.circular(width * 0.05),
          ),
          child: Row(
            children: [
              SizedBox(
                width: width * 0.05,
                height: width * 0.05,
                child: Icon(
                  icon,
                  size: width * 0.05,
                  color:
                  Theme.of(context).extension<AppColorsExtension>()!.white,
                ),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Text(
                text,
                style: TextStyle(
                  color:
                  Theme.of(context).extension<AppColorsExtension>()!.white,
                  fontSize: width * 0.035,
                ),
              ),
            ],
          )),
    );
  }
}
