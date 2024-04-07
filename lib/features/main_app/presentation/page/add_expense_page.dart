import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/page/create_tag_page.dart';
import 'package:cashbook/features/main_app/presentation/widgets/add_entity/add_tag.dart';
import 'package:cashbook/features/main_app/presentation/widgets/bottom_button.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key, required this.heading, this.entity});

  final String heading;
  final Expense? entity;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  List<TagData> tags = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ExpenseBloc bloc = context.read<ExpenseBloc>();
    bloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Successfully added expense");
      } else if (event is ExpenseAddError) {
        Fluttertoast.showToast(msg: "Failed to add expense");
      } else if (event is ExpenseEdited) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Successfully Edited expense");
      } else if (event is ExpenseAddError) {
        Fluttertoast.showToast(msg: "Failed to edit expense");
      }
    });
    if (widget.entity != null) {
      amountController.text = NumberFormat.decimalPattern()
          .format(widget.entity!.amount)
          .replaceAll(',', '');
      titleController.text = widget.entity!.title;
      tags = widget.entity!.tags;
    }
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
            AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).extension<AppColorsExtension>()!.black,
              ),
              backgroundColor: Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .red
                  .withAlpha(0),
              title: Text(widget.heading),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoneyInput(
                    amountController: amountController,
                    titleController: titleController,
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryDark
                          .withAlpha(150)),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.02),
                  child: Row(
                    children: [
                      BottomButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddTag(
                                  tags: tags,
                                  onAddTag: (selectedTags) {
                                    setState(() {
                                      tags = selectedTags;
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
                        icon: BootstrapIcons.tag_fill,
                        text: "Tag",
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      BottomButton(
                        onPressed: () {
                          // TODO : IMPLEMENT ADD DESCRIPTION
                        },
                        icon: BootstrapIcons.plus_circle_dotted,
                        text: "Description",
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.035, vertical: height * 0.01),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .white,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (widget.entity == null) {
                            context.read<ExpenseBloc>().add(AddExpenseEvent(
                                amount: double.parse(amountController.text),
                                title: titleController.text,
                                description: "Unimplemented",
                                date: DateTime.now(),
                                // TODO : IMPLEMENT CUSTOM TIMEING
                                tags: tags));
                          } else {
                            context.read<ExpenseBloc>().add(EditExpenseEvent(
                                title: titleController.text,
                                amount: double.parse(amountController.text),
                                description: "Unimplemented",
                                date: widget.entity!.date,
                                tags: tags,
                                // TODO : IMPLEMENT CUSTOM TIMEING
                                id: widget.entity!.id));
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .black,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
