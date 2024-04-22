import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/bloc/expense/expense_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:cashbook/features/create/presentation/pages/create_tag_page.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_description.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_tag.dart';
import 'package:cashbook/features/home/presentation/widgets/bottom_button.dart';
import 'package:cashbook/features/home/presentation/widgets/money_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage(
      {super.key, required this.heading, this.entity, this.liability});

  final String heading;
  final Expense? entity;
  final Liability? liability;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TagData? tag;
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _validate() {
    if (amountController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Amount cannot be empty");
      return false;
    }
    if (double.tryParse(amountController.text) == null) {
      Fluttertoast.showToast(msg: "Amount must be a number");
      return false;
    }
    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title cannot be empty");
      return false;
    }
    if (titleController.text.length < 3) {
      Fluttertoast.showToast(msg: "Title must be least 3 characters long");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.liability != null) {
      titleController.text = "${widget.liability!.title} Payment";
    }
    ExpenseBloc bloc = context.read<ExpenseBloc>();

    LiabilityBloc liabilityBloc = context.read<LiabilityBloc>();
    liabilityBloc.stream.listen((event) {
      if (event is LiabilityPaid) {
        Fluttertoast.showToast(msg: "Successfully paid liability");
        // Navigator.of(context).pop();
      } else if (event is LiabilityPayError) {
        Fluttertoast.showToast(msg: event.message);
      } else if (event is LiabilityPaymentEdited) {
        Fluttertoast.showToast(msg: "Successfully edited liability payment");
        // Navigator.of(context).pop();
      } else if (event is LiabilityPaymentEditError) {
        Fluttertoast.showToast(msg: "Failed to edit liability payment");
      }
    });

    bloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        if (widget.liability != null) {
          liabilityBloc.add(PayLiabilityEvent(
              liability: widget.liability!, expense: event.expense));
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Successfully added expense");
        }
      } else if (event is ExpenseAddError) {
        Fluttertoast.showToast(msg: "Failed to add expense");
      } else if (event is ExpenseEdited) {
        if (widget.entity != null && widget.entity!.liability.target != null) {
          liabilityBloc.add(EditLiabilityPaymentEvent(
              liability: widget.entity!.liability.target!,
              expense: widget.entity!,
              neAmount: event.expense.amount));
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Successfully Edited expense");
        }
      } else if (event is ExpenseEditedError) {
        Fluttertoast.showToast(msg: "Failed to edit expense");
      }
    });
    if (widget.entity != null) {
      amountController.text = NumberFormat.decimalPattern()
          .format(widget.entity!.amount)
          .replaceAll(',', '');
      titleController.text = widget.entity!.title;
      tag = widget.entity!.tag.target;
      descriptionController.text = widget.entity!.description ?? "";
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
                      horizontal: width * 0.03, vertical: height * 0.01),
                  child: Row(
                    children: [
                      (widget.liability == null
                          ? Row(children: [
                              BottomButton(
                                onPressed: () {
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
                                icon: BootstrapIcons.tag_fill,
                                text: "Tag",
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              BottomButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AddDescription(
                                            descriptionController:
                                                descriptionController,
                                          ));
                                },
                                icon: BootstrapIcons.plus_circle_dotted,
                                text: "Description",
                              ),
                            ])
                          : const SizedBox()),
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
                          if (!_validate()) {
                            return;
                          }
                          if (widget.liability != null) {
                            print(
                                "LIABILITY::::::::::::::::::::::::::::::::::::::::::::::::::");
                            print(widget.liability!.id);
                            context.read<ExpenseBloc>().add(AddExpenseEvent(
                                amount: double.parse(amountController.text),
                                title: titleController.text,
                                description: descriptionController.text,
                                date: DateTime.now(),
                                tag: tag,
                                liability: widget.liability));
                          } else if (widget.entity == null) {
                            context.read<ExpenseBloc>().add(AddExpenseEvent(
                                amount: double.parse(amountController.text),
                                title: titleController.text,
                                description: descriptionController.text,
                                date: DateTime.now(),
                                // TODO : IMPLEMENT CUSTOM TIMEING
                                tag: tag));
                          } else {
                            if (widget.entity!.liability.target != null) {
                              context.read<ExpenseBloc>().add(EditExpenseEvent(
                                  title: titleController.text,
                                  amount: double.parse(amountController.text),
                                  description: descriptionController.text,
                                  date: widget.entity!.date,
                                  tag: tag,
                                  // TODO : IMPLEMENT CUSTOM TIMEING
                                  id: widget.entity!.id));
                            } else {
                              context.read<ExpenseBloc>().add(EditExpenseEvent(
                                  title: titleController.text,
                                  amount: double.parse(amountController.text),
                                  description: descriptionController.text,
                                  date: widget.entity!.date,
                                  tag: tag,
                                  // TODO : IMPLEMENT CUSTOM TIMEING
                                  id: widget.entity!.id));
                            }
                          }
                        },
                        icon: Row(
                          children: [
                            const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.send_rounded,
                              color: Theme.of(context)
                                  .extension<AppColorsExtension>()!
                                  .black,
                            ),
                          ],
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
