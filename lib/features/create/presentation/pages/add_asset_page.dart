import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/create/presentation/bloc/assets/assets_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key, required this.heading});

  final String heading;

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController worthController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? icon;
  int color = 0xff0000ff;

  @override
  void initState() {
    super.initState();
    AssetsBloc bloc = context.read<AssetsBloc>();
    bloc.stream.listen((event) {
      if (event is AssetCreated) {
        Fluttertoast.showToast(msg: "Successfully added asset!");
        Navigator.of(context).pop();
      } else if (event is AssetsCreationError) {
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
        child: Column(
          children: [
            SizedBox(
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
                                "Add an asset by adding the title or name of asset and worth of the asset."),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextField(
                              onTapOutside: (e) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintText: "Asset Title *",
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
                                  hintText: "Worth of Asset *",
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
                            context.read<AssetsBloc>().add(
                                  CreateAssetEvent(
                                      title: titleController.text,
                                      worth: double.parse(worthController.text),
                                      description: descriptionController.text,
                                      date: DateTime.now(),
                                      icon: icon,
                                      color: color),
                                );
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
          ],
        ),
      ),
    );
  }
}
