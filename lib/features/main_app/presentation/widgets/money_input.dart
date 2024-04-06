import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class MoneyInput extends StatefulWidget {
  const MoneyInput({super.key});

  @override
  State<MoneyInput> createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height * 0.2,
      child: Column(
        children: [
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: height * 0.2,
                minWidth: width * 0.05,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.067),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).unfocus();
                  },
                  textAlign: TextAlign.center,
                  showCursor: false,
                  decoration: InputDecoration(
                    hintText: "0.0",
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: SizedBox(
                        height: height * 0.01,
                        child: Text(
                          "₹",
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                            applyHeightToLastDescent: true,
                            leadingDistribution:
                            TextLeadingDistribution.proportional,
                          ),
                          style: TextStyle(
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primaryTextColor,
                            fontSize: width * 0.1,
                          ),
                        ),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryLight,
                      fontSize: width * 0.1,
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryTextColor,
                    fontSize: width * 0.1,
                  ),
                ),
              ),
            ),
          ),
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // maxHeight: height * 0.06,
                minWidth: width * 0.3,
              ),
              child: SizedBox(
                height: height * 0.05,
                child: TextFormField(
                  cursorHeight: 0,
                  controller: controller2,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(
                    fontSize: width * 0.035,
                  ),
                  decoration: InputDecoration(
                    hintText: "Title",
                    filled: true,
                    fillColor: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLightTextColor
                        .withAlpha(100),
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .black,
                      fontSize: width * 0.035,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
