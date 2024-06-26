import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/create/presentation/pages/add_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:intl/intl.dart';

class ShowExpense extends StatefulWidget {
  const ShowExpense({super.key, required this.expense});

  final Expense expense;

  @override
  State<ShowExpense> createState() => _ShowExpenseState();
}

class _ShowExpenseState extends State<ShowExpense> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.width;
    return AlertDialog(
      surfaceTintColor:
          Theme.of(context).extension<AppColorsExtension>()!.black,
      actions: [
        TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                backgroundColor: Theme.of(context)
                    .extension<AppColorsExtension>()!
                    .primary
                    .withAlpha(100)),
            onPressed: () {
              Navigator.of(context).pop();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddExpensePage(
                      heading: widget.expense.liability.target != null
                          ? "Edit Liability Payment"
                          : "Edit Expense",
                      entity: widget.expense)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: width * 0.035,
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .black
                      .withAlpha(100),
                ),
                const SizedBox(width: 5),
                Text(
                  "Edit Transaction",
                  style: TextStyle(
                      fontSize: width * 0.03,
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .black
                          .withAlpha(150)),
                ),
              ],
            ))
      ],
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FittedBox(
                  child: Text(widget.expense.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .black,
                          fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                Text(formatMoney(amount: widget.expense.amount, prefix: "- "),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .red,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.005),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryDark
                          .withAlpha(150),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    DateFormat('dd MMM yyyy h:m a').format(widget.expense.date),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.03,
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLightTextColor),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.005),
                  decoration: BoxDecoration(
                      color: widget.expense.tag.target != null
                          ? widget.expense.tag.target!.colorValue
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.expense.liability.target != null
                            ? deserializeIcon({
                                  "key":
                                      widget.expense.liability.target?.icon ??
                                          "hourglass_split",
                                  "pack": "material"
                                }, iconPack: IconPack.allMaterial) ??
                                BootstrapIcons.hourglass_split
                            : widget.expense.tag.target != null
                                ? deserializeIcon({
                                      "key": widget.expense.tag.target!.icon,
                                      "pack": "material"
                                    }, iconPack: IconPack.allMaterial) ??
                                    BootstrapIcons.hourglass_split
                                : BootstrapIcons.hourglass_split,
                        size: width * 0.03,
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .primaryLightTextColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.expense.liability.target != null
                            ? "Liability"
                            : widget.expense.tag.target != null
                                ? widget.expense.tag.target!.title
                                : "Uncategorized",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: width * 0.03,
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primaryLightTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryLightTextColor
                      .withAlpha(100),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                  widget.expense.description ?? "No description provided!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .black
                          .withAlpha(150))),
            ),
          ],
        ),
      ),
    );
  }
}
