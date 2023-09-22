import 'package:flutter/material.dart';
import 'package:cashbook/classes/ledger.dart';

class AddEarningForm extends StatefulWidget {
  AddEarningForm({super.key, required this.ledger});
  Ledger ledger;
  @override
  State<AddEarningForm> createState() => _AddEarningFormState();
}

class _AddEarningFormState extends State<AddEarningForm> {
  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController accountController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  bool fromBank = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      content: Container(
          // padding: const EdgeInsets.all(20),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            decoration: InputDecoration(label: Text("Amount")),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: accountController,
            decoration: InputDecoration(label: Text("Account")),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: datetimeController,
            decoration: InputDecoration(label: Text("Date & Time")),
            keyboardType: TextInputType.datetime,
            onTap: () {
              FocusScope.of(context).unfocus();
              showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2111))
                  .then((date) {
                if (date != null) {
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((time) {
                    DateTime selected;
                    if (time == null) {
                      selected = date;
                    } else {
                      selected = date.copyWith(
                        hour: time.hour,
                        minute: time.minute,
                      );
                    }
                    setState(() {
                      datetimeController.text = selected.toIso8601String();
                    });
                  });
                }
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: fromBank,
                  onChanged: (val) {
                    print("NONE ${val!}");
                    setState(() {
                      fromBank = val ?? false;
                    });
                  }),
              Text("From Bank")
            ],
          ),
          Row(children: [
            Spacer(),
            TextButton(
                onPressed: () async {
                  print(await widget.ledger.insertEntity(
                      EntityModel(
                          id: null,
                          amount: double.parse(amountController.text),
                          bank: fromBank,
                          toAccount: await AccountModel.load(
                              widget.ledger.getDatabase(),
                              int.parse(accountController.text)),
                          datetime: DateTime.parse(datetimeController.text)),
                      widget.ledger.ledger));
                },
                child: Text("Add"))
          ]),
        ],
      )),
    );
  }
}

// Add expense
class AddExpenseForm extends StatefulWidget {
  AddExpenseForm({super.key, required this.ledger});
  Ledger ledger;
  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  TextEditingController controller = TextEditingController();
  TextEditingController curBalController = TextEditingController(text: "0");
  TextEditingController openBalController = TextEditingController(text: "0");
  bool expenseAccount = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      content: Container(
          // padding: const EdgeInsets.all(20),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(label: Text("Account Name")),
          ),
          TextField(
            controller: openBalController,
            decoration: InputDecoration(label: Text("Opening Balance")),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: curBalController,
            decoration: InputDecoration(label: Text("Current Balance")),
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: expenseAccount,
                  onChanged: (val) {
                    print("NONE ${val!}");
                    setState(() {
                      expenseAccount = val ?? false;
                    });
                  }),
              Text("Expense Account")
            ],
          ),
          Row(children: [
            Spacer(),
            TextButton(
                onPressed: () async {
                  print(await widget.ledger!.insertAccount(AccountModel(
                    id: null,
                    name: controller.text,
                    expenceAccount: expenseAccount,
                    openingBalance: double.parse(openBalController.text),
                    currentBalance: double.parse(curBalController.text),
                  )));
                },
                child: Text("Add"))
          ]),
        ],
      )),
    );
  }
}
// Account add

class AddAccountForm extends StatefulWidget {
  AddAccountForm({super.key, required this.ledger});
  Ledger ledger;
  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  TextEditingController controller = TextEditingController();
  TextEditingController curBalController = TextEditingController(text: "0");
  TextEditingController openBalController = TextEditingController(text: "0");
  bool expenseAccount = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      content: Container(
          // padding: const EdgeInsets.all(20),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(label: Text("Account Name")),
          ),
          TextField(
            controller: openBalController,
            decoration: InputDecoration(label: Text("Opening Balance")),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: curBalController,
            decoration: InputDecoration(label: Text("Current Balance")),
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: expenseAccount,
                  onChanged: (val) {
                    print("NONE ${val!}");
                    setState(() {
                      expenseAccount = val ?? false;
                    });
                  }),
              Text("Expense Account")
            ],
          ),
          Row(children: [
            Spacer(),
            TextButton(
                onPressed: () async {
                  print(await widget.ledger!.insertAccount(AccountModel(
                    id: null,
                    name: controller.text,
                    expenceAccount: expenseAccount,
                    openingBalance: openBalController.text.isEmpty
                        ? 0
                        : double.parse(openBalController.text),
                    currentBalance: curBalController.text.isEmpty
                        ? 0
                        : double.parse(curBalController.text),
                  )));
                },
                child: Text("Add"))
          ]),
        ],
      )),
    );
  }
}
