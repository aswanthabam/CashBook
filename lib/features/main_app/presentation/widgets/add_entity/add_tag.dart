import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/presentation/widgets/tag.dart';
import 'package:flutter/material.dart';

class AddTag extends StatefulWidget {
  const AddTag(
      {super.key,
      required this.onAddTag,
      required this.onCreateTag,
      required this.tags});

  final Function(TagData) onAddTag;
  final Function() onCreateTag;
  final List<TagData> tags;

  @override
  State<AddTag> createState() => _AddTagState();
}

class _AddTagState extends State<AddTag> {
  List<TagData> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
          height: height * 0.45,
          width: width,
          padding: EdgeInsets.all(width * 0.05),
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppColorsExtension>()!.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                "Select a Tag",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Select a tag for the transaction. If you can't find a tag, you can add a new one.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: width * 0.03, color: Colors.grey.shade900),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Wrap(
                  alignment: WrapAlignment.center,
                  children: widget.tags
                      .map((tag) => Tag(
                          onPressed: () {
                            tag.isSelected = true;
                            selectedTags.add(tag);
                            setState(() {});
                          },
                          tagData: tag,
                          highlightColor: Colors.grey))
                      .toList()),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        // TODO : CREATE NEW TAG
                      },
                      child: Text(
                        "Create New Tag",
                        style: TextStyle(
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primaryDark),
                      )),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLight,
                      ),
                      onPressed: () {
                        // TODO : IMPLEMENT ADD TAG
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primaryLightTextColor,
                          ),
                          Text(
                            "Add Tag",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .primaryLightTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
