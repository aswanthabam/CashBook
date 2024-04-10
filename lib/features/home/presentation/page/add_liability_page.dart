import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AddLiabilityPage extends StatefulWidget {
  const AddLiabilityPage({
    super.key,
    required this.heading,
    required this.onSubmit,
  });

  final String heading;
  final bool Function() onSubmit;

  @override
  State<AddLiabilityPage> createState() => _AddLiabilityPageState();
}

class _AddLiabilityPageState extends State<AddLiabilityPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height + MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  iconTheme: IconThemeData(
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .black,
                  ),
                  backgroundColor: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .red
                      .withAlpha(0),
                  title: Text(widget.heading),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "Add a liability by giving a name for the liability and amount."),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      TextField(
                        onTapOutside: (e) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: "Liability Title *",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .extension<AppColorsExtension>()!
                                        .primary))),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextField(
                        onTapOutside: (e) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixIcon:
                                const Icon(BootstrapIcons.currency_rupee),
                            hintText: "Amount *",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .extension<AppColorsExtension>()!
                                        .primary))),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextField(
                        onTapOutside: (e) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: descriptionController,
                        autocorrect: true,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: "Description",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .extension<AppColorsExtension>()!
                                        .primary))),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                width: width,
                height: height * 0.05 + width * 0.1,
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primary,
                    ),
                    onPressed: () {
                      // TODO : IMPLEMENT ADD LIABILITY
                    },
                    child: Text(
                      "Add Liability",
                      style: TextStyle(
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .primaryLightTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
