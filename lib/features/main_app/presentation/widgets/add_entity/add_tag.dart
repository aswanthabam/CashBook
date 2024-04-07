import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/presentation/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/tag/tag_bloc.dart';

class AddTag extends StatefulWidget {
  const AddTag(
      {super.key,
      required this.onAddTag,
      required this.onCreateTag,
      this.tags});

  final Function(List<TagData>) onAddTag;
  final Function() onCreateTag;
  final List<TagData>? tags;

  @override
  State<AddTag> createState() => _AddTagState();
}

class _AddTagState extends State<AddTag> {
  List<TagData> selectedTags = [];
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
          tag.isSelected = selectedTags.any((t) => t.id == tag.id);
          tags.add(tag);
        }
        setState(() {});
      } else if (event is TagDataError) {
        Fluttertoast.showToast(msg: event.message);
      } else if (event is TagCreated) {
        tagBloc.add(GetTagsEvent());
      }
    });
    selectedTags = widget.tags ?? [];
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
                  children: tags.map((tag) {
                    return Tag(
                        onPressed: () {
                          tag.isSelected = !tag.isSelected;
                          if (tag.isSelected) {
                            selectedTags.add(tag);
                          } else {
                            int index = selectedTags
                                .indexWhere((element) => element.id == tag.id);
                            selectedTags.removeAt(index);
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
                        widget.onAddTag(selectedTags);
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
