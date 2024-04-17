import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:cashbook/features/create/presentation/pages/create_tag_page.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_tag.dart';
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
  TagData? tag;
  DateTime startDate = DateTime.now();
  DateTime? endDate;

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
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: height,
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
                                            .extension<AppColorsExtension>()!
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
                                            .extension<AppColorsExtension>()!
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
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AddTag(
                                    tag: tag,
                                    onAddTag: (selectedTag) {
                                      setState(() {
                                        tag = selectedTag;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    onCreateTag: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateTagPage(
                                                      heading:
                                                          "Create new Tag")));
                                    }));
                          },
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Icon(tag != null
                                      ? deserializeIcon({
                                          "key": tag!.icon,
                                          "pack": "material"
                                        }, iconPack: IconPack.allMaterial)
                                      : Icons.bookmark),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add a Tag",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "Add a tag for classifying your liabilities.",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
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
                        context.read<LiabilityBloc>().add(CreateLiabilityEvent(
                            title: titleController.text,
                            amount: double.parse(worthController.text),
                            description: descriptionController.text,
                            date: startDate,
                            tag: tag,
                            remaining: double.parse(worthController.text),
                            interest: 0,
                            endDate: endDate));
                      },
                      child: Text(
                        "Add Asset",
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
      ),
    );
  }
}
