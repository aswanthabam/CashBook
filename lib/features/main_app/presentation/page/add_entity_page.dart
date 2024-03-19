import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/presentation/widgets/bottom_button.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_input.dart';
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


