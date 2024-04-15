import 'package:cashbook/bloc/tag/tag_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTagPage extends StatefulWidget {
  const CreateTagPage({super.key, required this.heading});

  final String heading;

  @override
  State<CreateTagPage> createState() => _CreateTagPageState();
}

class _CreateTagPageState extends State<CreateTagPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Color selectedColor = Colors.blue;
  IconData selectedIcon = Icons.monetization_on_sharp;

  bool _validate() {
    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title cannot be empty");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    context.read<TagBloc>().stream.listen((state) {
      if (state is TagCreated) {
        Fluttertoast.showToast(msg: "Tag Created");
        Navigator.of(context).pop();
      } else if (state is TagCreateError) {
        Fluttertoast.showToast(msg: state.message);
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
                          "Create a tag for grouping your transactions."),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      TextField(
                        onTapOutside: (e) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: "Tag Title *",
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
                        height: height * 0.03,
                      ),
                      Row(
                        children: [
                          Text(
                            "Select a color for the tag",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .black),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Pick a color'),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                              onColorChanged: (Color value) {
                                                setState(() {
                                                  selectedColor = value;
                                                });
                                              },
                                              color: Colors.blue),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Done'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            },
                            child: Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                  color: selectedColor,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Select an icon for the tag",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .black),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              showIconPicker(context,
                                  iconColor: selectedColor,
                                  iconSize: 30,
                                  iconPackModes: const [
                                    IconPack.allMaterial
                                  ]).then((value) {
                                if (value != null) {
                                  setState(() {
                                    selectedIcon = value;
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .extension<AppColorsExtension>()!
                                      .primary,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                selectedIcon,
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .primaryLightTextColor,
                              ),
                            ),
                          ),
                        ],
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
                      if (_validate()) {
                        context.read<TagBloc>().add(CreateTagEvent(
                            title: titleController.text,
                            description: descriptionController.text,
                            color: selectedColor.value,
                            icon: serializeIcon(selectedIcon,
                                iconPack: IconPack.allMaterial)!["key"]));
                      }
                    },
                    child: Text(
                      "Create Tag",
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
