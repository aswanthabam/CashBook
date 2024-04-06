import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class HistoryDisplayer extends StatefulWidget {
  const HistoryDisplayer(
      {super.key, required this.expenses, required this.historyCount});

  final List<Expense> expenses;
  final int historyCount;

  @override
  State<HistoryDisplayer> createState() => _HistoryDisplayerState();
}

class _HistoryDisplayerState extends State<HistoryDisplayer> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: height * 0.02),
        itemCount: widget.expenses.length > widget.historyCount
            ? widget.historyCount
            : widget.expenses.length,
        itemBuilder: (context, index) {
          TagData? tag = widget
                  .expenses[widget.expenses.length - index - 1].tags.isNotEmpty
              ? widget.expenses[widget.expenses.length - index - 1].tags[0]
              : null;
          return ListTile(
            shape: const Border(top: BorderSide(color: Colors.grey, width: 1)),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tag != null
                      ? deserializeIcon({"key": tag.icon, "pack": "material"},
                              iconPack: IconPack.allMaterial) ??
                          BootstrapIcons.hourglass_split
                      : BootstrapIcons.hourglass_split,
                  color: tag != null ? Color(tag.color) : Colors.blue,
                ),
                const SizedBox(
                  height: 3,
                )
              ],
            ),
            horizontalTitleGap: 25,
            title: Text(
              widget.expenses[widget.expenses.length - index - 1].title,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black),
            ),
            subtitle: Row(
              children: [
                Text(
                    "${formatDate(widget.expenses[widget.expenses.length - index - 1].date)}",
                    style: const TextStyle(fontSize: 12)),
                Text(
                  "  ⦿  ${tag != null ? tag.title : 'Uncategorized'}",
                  style: TextStyle(
                      color: tag != null ? Color(tag.color) : Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            trailing: Text(
              widget.expenses[widget.expenses.length - index - 1].amount
                  .toString(),
              style: const TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          );
        });
    ;
  }
}
