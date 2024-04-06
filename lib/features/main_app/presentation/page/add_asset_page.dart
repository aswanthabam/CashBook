import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({
    super.key,
    required this.heading,
    required this.onSubmit,
  });

  final String heading;
  final bool Function() onSubmit;

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController worthController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
                      // TODO : IMPLEMENT ADD ASSET
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