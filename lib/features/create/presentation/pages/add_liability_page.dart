import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddLiabilityPage extends StatefulWidget {
  const AddLiabilityPage({super.key, required this.heading});

  final String heading;

  @override
  State<AddLiabilityPage> createState() => _AddLiabilityPageState();
}

class _AddLiabilityPageState extends State<AddLiabilityPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController worthController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  int color = 0xff0000ff;
  String? icon;
  DateTime startDate = DateTime.now();
  DateTime? endDate;

  bool _validate() {
    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a title for the liability.");
      return false;
    }
    if (worthController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the amount of the liability.");
      return false;
    }
    try {
      double.parse(worthController.text);
    } catch (e) {
      Fluttertoast.showToast(msg: "Please enter a valid amount.");
      return false;
    }
    if (endDate != null && startDate.isAfter(endDate!)) {
      Fluttertoast.showToast(
          msg: "The start date cannot be after the end date.");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    LiabilityBloc bloc = context.read<LiabilityBloc>();
    bloc.stream.listen((event) {
      if (event is LiabilityCreated) {
        Fluttertoast.showToast(msg: "Successfully added liability!");
        Navigator.of(context).pop();
      } else if (event is LiabilityCreationError) {
        Fluttertoast.showToast(msg: event.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
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
                              controller: worthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  suffixIcon:
                                      const Icon(BootstrapIcons.currency_rupee),
                                  hintText: "Liability Amount *",
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
                            SizedBox(
                              height: height * 0.025,
                            ),
                            const Text(
                                "Select the date when the liability started and the expected date of completion."),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width / 2 - 30,
                                  height: height * 0.05,
                                  child: TextField(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1999),
                                              lastDate: DateTime.now(),
                                              currentDate: startDate)
                                          .then((value) {
                                        if (value != null) {
                                          if (value != startDate) {
                                            setState(() {
                                              startDate = value;
                                              startDateController.text = value
                                                  .toIso8601String()
                                                  .split("T")[0];
                                            });
                                          }
                                        }
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    onTapOutside: (e) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    controller: startDateController,
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                        hintText: "Start Date",
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .extension<
                                                    AppColorsExtension>()!
                                                .black),
                                        contentPadding:
                                            EdgeInsets.all(height * 0.025),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        prefixIcon:
                                            const Icon(Icons.calendar_today)),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 2 - 30,
                                  height: height * 0.05,
                                  child: TextField(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1999),
                                              lastDate: DateTime.now(),
                                              currentDate: endDate)
                                          .then((value) {
                                        if (value != null) {
                                          if (endDate != value) {
                                            value = value.copyWith(
                                                hour: 23,
                                                minute: 59,
                                                second: 59,
                                                millisecond: 999);
                                            setState(() {
                                              endDate = value!;
                                              endDateController.text = value
                                                  .toIso8601String()
                                                  .split("T")[0];
                                            });
                                          }
                                        }
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    onTapOutside: (e) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    controller: endDateController,
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                        hintText: "End Date",
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .extension<
                                                    AppColorsExtension>()!
                                                .black),
                                        contentPadding:
                                            EdgeInsets.all(height * 0.025),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        prefixIcon:
                                            const Icon(Icons.calendar_today)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            const FittedBox(
                              child: Text(
                                  "If this liability has an interest rate add it, else leave it as 0."),
                            ),
                            TextField(
                              controller: interestController,
                              keyboardType: TextInputType.number,
                              onTapOutside: (e) {
                                if (interestController.text == "0") {
                                  interestController.text = "";
                                }
                                FocusScope.of(context).unfocus();
                              },
                              onTap: () {
                                interestController.text = "0";
                              },
                              decoration: InputDecoration(
                                  hintText: "Interest Rate",
                                  suffixText: "%",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .extension<AppColorsExtension>()!
                                              .primary))),
                            ),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            GestureDetector(
                              onTap: () {
                                showColorPickerDialog(context, Color(color))
                                    .then((value) {
                                  if (value.value != color) {
                                    setState(() {
                                      color = value.value;
                                    });
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.1,
                                    height: width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Color(color),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Set a color",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Set a color for your asset for better visibility.",
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            GestureDetector(
                              onTap: () {
                                showIconPicker(context,
                                    iconColor: Color(color),
                                    iconSize: 30,
                                    iconPackModes: const [
                                      IconPack.allMaterial
                                    ]).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      icon = serializeIcon(value,
                                          iconPack:
                                              IconPack.allMaterial)!["key"];
                                    });
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.1,
                                    height: width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Color(color),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Icon(icon != null
                                          ? deserializeIcon(
                                              {"key": icon, "pack": "material"},
                                              iconPack: IconPack.allMaterial)
                                          : Icons.business_sharp),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add an Icon",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Add an icon for your asset for better visibility.",
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: (height * 0.05 + width * 0.1))
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                width: width,
                height: height * 0.05 + width * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: EdgeInsets.all(width * 0.05),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primary,
                    ),
                    onPressed: () {
                      if (_validate()) {
                        context.read<LiabilityBloc>().add(CreateLiabilityEvent(
                            title: titleController.text,
                            amount: double.parse(worthController.text),
                            description: descriptionController.text,
                            date: startDate,
                            icon: icon,
                            color: color,
                            remaining: double.parse(worthController.text),
                            interest: double.parse(interestController.text),
                            endDate: endDate));
                      }
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
