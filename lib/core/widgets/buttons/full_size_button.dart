import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class FullSizeButton extends StatefulWidget {
  const FullSizeButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.leftIcon,
      required this.rightIcon,
      this.iconColor,
      this.textColor,
      this.borderColor,
      this.padding,
      this.height});

  final IconData rightIcon;
  final IconData leftIcon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? height;
  final Function() onPressed;

  @override
  State<FullSizeButton> createState() => _FullSizeButtonState();
}

class _FullSizeButtonState extends State<FullSizeButton> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(width * 0.05),
        child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: width,
              height: widget.height ?? height * 0.09,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.borderColor ??
                      Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .black
                          .withAlpha(100),
                  width: 1.4,
                ),
                color: Theme.of(context)
                    .extension<AppColorsExtension>()!
                    .transparent,
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              padding: widget.padding ?? EdgeInsets.all(width * 0.05),
              child: Row(
                children: [
                  Icon(
                    widget.leftIcon,
                    color: widget.iconColor ??
                        Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLight,
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                        color: widget.textColor ??
                            Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .black),
                  ),
                  const Spacer(),
                  Icon(
                    widget.rightIcon,
                    color: widget.iconColor ??
                        Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLight,
                  ),
                ],
              ),
            )));
  }
}
