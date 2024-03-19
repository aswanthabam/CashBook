import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AddEntityPage extends StatefulWidget {
  const AddEntityPage({
    super.key,
    required this.heading,
    required this.onSubmit,
  });

  final String heading;
  final bool Function() onSubmit;

  @override
  State<AddEntityPage> createState() => _AddEntityPageState();
}

class _AddEntityPageState extends State<AddEntityPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height + MediaQuery.of(context).padding.top,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(100),
              Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(20),
              Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(20),
              Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(0),
              Theme.of(context).extension<AppColorsExtension>()!.transparent,
            ],
          ),
        ),
        child: Stack(
          children: [
            AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).extension<AppColorsExtension>()!.black,
              ),
              backgroundColor: Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(0),
              title: Text(widget.heading),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [MoneyInput()],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryDark
                          .withAlpha(150)),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.02),
                  child: Row(
                    children: [
                      BottomButton(
                        onPressed: () {
                          // TODO : IMPLEMENT ADD TAG
                        },
                        icon: BootstrapIcons.tag_fill,
                        text: "Tag",
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      BottomButton(
                        onPressed: () {
                          // TODO : IMPLEMENT ADD DESCRIPTION
                        },
                        icon: BootstrapIcons.plus_circle_dotted,
                        text: "Description",
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.035, vertical: height * 0.01),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .white,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // TODO : IMPLEMENT ADD EXPENSE
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .black,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

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
                                .primaryDark,
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
                        .primaryDark,
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
