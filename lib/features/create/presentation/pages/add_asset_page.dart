import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/create/presentation/bloc/assets/assets_bloc.dart';
import 'package:cashbook/features/create/presentation/pages/create_tag_page.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_tag.dart';
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
  TagData? tag;

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
                                    ? deserializeIcon(
                                        {"key": tag!.icon, "pack": "material"},
                                        iconPack: IconPack.allMaterial)
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
                                  "Add a tag for classifying your assets.",
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
                      context.read<AssetsBloc>().add(CreateAssetEvent(
                          title: titleController.text,
                          worth: double.parse(worthController.text),
                          description: descriptionController.text,
                          date: DateTime.now(),
                          tag: tag));
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
    );
  }
}
