import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AddDescription extends StatefulWidget {
  AddDescription({super.key, this.descriptionController});

  TextEditingController? descriptionController;

  @override
  State<AddDescription> createState() => _AddDescriptionState();
}

class _AddDescriptionState extends State<AddDescription> {
  @override
  void initState() {
    super.initState();
    widget.descriptionController ??= TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .black,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Add a description for the transaction",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.descriptionController,
              autofocus: true,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter description",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withAlpha(200)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryLight,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.done,
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .primaryLightTextColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Done",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .extension<AppColorsExtension>()!
                                  .primaryLightTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
