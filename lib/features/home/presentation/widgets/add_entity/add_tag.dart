import 'package:cashbook/bloc/tag/tag_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/home/presentation/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddTag extends StatefulWidget {
  const AddTag(
      {super.key, required this.onAddTag, required this.onCreateTag, this.tag});

  final Function(TagData?) onAddTag;
  final Function() onCreateTag;
  final TagData? tag;

  @override
  State<AddTag> createState() => _AddTagState();
}

class _AddTagState extends State<AddTag> {
  TagData? selectedTag;
  List<TagData> tags = [];

  @override
  void initState() {
    super.initState();

    TagBloc tagBloc = context.read<TagBloc>();
    tagBloc.add(GetTagsEvent());
    tagBloc.stream.listen((event) {
      if (event is TagDataLoaded) {
        tags = [];
        for (var tag in event.tags) {
          tag.isSelected =
              selectedTag != null ? selectedTag!.id == tag.id : false;
          tags.add(tag);
        }
        setState(() {});
      } else if (event is TagDataError) {
        Fluttertoast.showToast(msg: event.message);
      } else if (event is TagCreated) {
        tagBloc.add(GetTagsEvent());
      }
    });
    selectedTag = widget.tag;
  }

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
            color:
                Theme.of(context).extension<AppColorsExtension>()!.grayishWhite,
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
                style: TextStyle(fontSize: width * 0.03, color: Colors.grey),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Wrap(
                  alignment: WrapAlignment.center,
                  children: tags.map((tag) {
                    return Tag(
                        onPressed: () {
                          tag.isSelected = !tag.isSelected;
                          if (selectedTag != null) {
                            selectedTag?.isSelected = false;
                          }
                          if (tag.isSelected) {
                            selectedTag = tag;
                            widget.onAddTag(selectedTag);
                            // Navigator.of(context).pop();
                          } else {
                            selectedTag = null;
                          }
                          setState(() {});
                        },
                        tagData: tag,
                        highlightColor: Colors.grey,
                        icon: deserializeIcon(
                                {"key": tag.icon, "pack": "material"},
                                iconPack: IconPack.allMaterial) ??
                            Icons.error);
                  }).toList()),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: widget.onCreateTag,
                      child: Row(
                        children: [
                          Text(
                            "Create Tag",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .primaryDark),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.create_sharp,
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primaryDark,
                          ),
                        ],
                      )),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLight,
                      ),
                      onPressed: () {
                        widget.onAddTag(selectedTag);
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
              ),
            ],
          )),
    );
  }
}
