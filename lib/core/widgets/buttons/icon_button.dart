import 'package:flutter/cupertino.dart';

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
          !alignRight && icon != null ? Icon(icon) : const SizedBox(),
          Text(message),
          alignRight && icon != null ? Icon(icon) : const SizedBox()
        ],
      ),
    );
  }
}
