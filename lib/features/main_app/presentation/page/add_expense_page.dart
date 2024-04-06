import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/data/models/tag_data.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/widgets/add_entity/add_tag.dart';
import 'package:cashbook/features/main_app/presentation/widgets/bottom_button.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key, required this.heading});

  final String heading;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  List<TagData> tags = [
    // TagData(name: "One", id: 1, color: Colors.green),
    // TagData(name: "One", id: "one", color: Colors.green),
    // TagData(name: "One", id: "one", color: Colors.green),
    // TagData(name: "One", id: "one", color: Colors.green),
    // TagData(name: "One", id: "one", color: Colors.green),
    // TagData(name: "One", id: "one", color: Colors.green),
  ];

  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  void _validateAndSubmit() {
    throw UnimplementedError();
    if (amountController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Amount cannot be empty");
    } else if (RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(amountController.text) ==
        false) {
      Fluttertoast.showToast(msg: "Amount is not valid");
    } else if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title cannot be empty");
    } else {
      try {
        final Expense expense = Expense(
            id: 0,
            amount: double.parse(amountController.text),
            title: titleController.text,
            description: "",
            date: DateTime.now());
        AppDatabase db = AppDatabase();
        db.insert<Expense>(expense);
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Successfully added expense");
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to add expense");
      }
    }
  }

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
                                  onAddTag: (TagData tag) {
                                    // TODO : IMPLEMENT ON TAG ADD
                                  },
                                  onCreateTag: () {
                                    // TODO : IMPLEMENT ON TAG CREATE
                                  },
                                  tags: tags));
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
                          context.read<ExpenseBloc>().add(AddExpenseEvent(
                              amount: double.parse(amountController.text),
                              title: titleController.text,
                              description: "Unimplemented",
                              date: DateTime.now(),
                              // TODO : IMPLEMENT CUSTOM TIMEING
                              tags: tags.map((e) => e.id).toList()));
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
