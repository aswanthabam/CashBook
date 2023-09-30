import 'package:flutter/material.dart';
import 'package:cashbook/classes/ledger.dart';
import '../classes/models.dart';

class AddEntityForm extends StatefulWidget {
  AddEntityForm({super.key, required this.ledger});
  Ledger ledger;
  @override
  State<AddEntityForm> createState() => _AddEntityFormState();
}

class _AddEntityFormState extends State<AddEntityForm> {
  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController accountController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  bool fromBank = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
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
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
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
                      print(await widget.ledger.insertEntity(EntityModel(
                          db: widget.ledger.getDatabase(),
                          id: null,
                          amount: double.parse(amountController.text),
                          bank: fromBank,
                          toAccount: (await AccountModel.get(
                              widget.ledger.getDatabase(),
                              int.parse(accountController.text)))!,
                          datetime: DateTime.parse(datetimeController.text),
                          accountId: int.parse(accountController.text),
                          ledgerId: 1)));
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Add an Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(width: 10),
                  const Tooltip(
                    message:
                        "An account is a name used to represent a group of payment in same category. (eg: Food - This name will be used to denote all spendings on eating food)",
                    child: Icon(Icons.help),
                    triggerMode: TooltipTriggerMode.tap,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Fill out the following details to create an account.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(label: Text("Account Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter the name of the account this account. this name will be displayed every where (eg : Food)",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: openBalController,
                decoration: InputDecoration(label: Text("Opening Balance")),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter your account opening balance, in case of an expense its the initial cost you spend on that category",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Account Type : ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  NamedCheckBox(
                    onChange: (val) {
                      print("NONE ${val}");
                      setState(() {
                        expenseAccount = val == 1;
                      });
                    },
                    values: ["Earning", "Expense"],
                  ),
                ],
              ),
              Spacer(),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () async {
                          await widget.ledger.insertAccount(AccountModel(
                              db: widget.ledger.getDatabase(),
                              id: null,
                              name: controller.text,
                              expenseAccount: expenseAccount,
                              openingBalance: openBalController.text.isEmpty
                                  ? 0
                                  : double.parse(openBalController.text),
                              currentBalance: curBalController.text.isEmpty
                                  ? 0
                                  : double.parse(curBalController.text),
                              ledgerId: 1));
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              "Add Account",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ))))
              ]),
            ],
          )),
    );
  }
}

class NamedCheckBox extends StatefulWidget {
  NamedCheckBox({super.key, required this.values, required this.onChange});
  List<String> values;
  Function(int) onChange;
  @override
  State<NamedCheckBox> createState() => _NamedCheckBoxState();
}

class _NamedCheckBoxState extends State<NamedCheckBox> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.values.length * 100,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: widget.values
            .map<Widget>((value) => Expanded(
                child: GestureDetector(
                    onTap: () {
                      if (widget.values.indexOf(value) != selected) {
                        setState(() {
                          selected = widget.values.indexOf(value);
                        });
                        widget.onChange(selected);
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.values.indexOf(value) == selected
                                ? Colors.green.shade500
                                : Colors.transparent,
                            borderRadius: widget.values.indexOf(value) == 0
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))
                                : (widget.values.indexOf(value) ==
                                        widget.values.length - 1
                                    ? BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                    : BorderRadius.circular(0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(value),
                          ],
                        )))))
            .toList(),
      ),
    );
  }
}
