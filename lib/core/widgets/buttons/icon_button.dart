import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget(
      {super.key,
      required this.onPressed,
      required this.message,
      this.icon,
      this.alignRight = false});

  final VoidCallback onPressed;
  final String message;
  final IconData? icon;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          !alignRight && icon != null
              ? Icon(
                  icon,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black,
                )
              : const SizedBox(),
          Text(message),
          alignRight && icon != null
              ? Icon(
                  icon,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
