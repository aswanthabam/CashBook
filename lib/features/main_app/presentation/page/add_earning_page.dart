import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/presentation/widgets/add_entity/add_tag.dart';
import 'package:cashbook/features/main_app/presentation/widgets/bottom_button.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_input.dart';
import 'package:flutter/material.dart';

class AddEarningPage extends StatefulWidget {
  const AddEarningPage({
    super.key,
    required this.heading,
    required this.onSubmit,
  });

  final String heading;
  final bool Function() onSubmit;

  @override
  State<AddEarningPage> createState() => _AddEarningPageState();
}

class _AddEarningPageState extends State<AddEarningPage> {
  List<TagData> tags = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height + MediaQuery.of(context).padding.top,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoneyInput(
                    amountController: amountController,
                    titleController: titleController,
                  )
                ],
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
                          showDialog(
                              context: context,
                              builder: (context) => AddTag(onAddTag: (tags) {
                                    // TODO : IMPLEMENT ON TAG ADD
                                  },
                                  onCreateTag: () {
                                    // TODO : IMPLEMENT ON TAG CREATE
                                  }));
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
