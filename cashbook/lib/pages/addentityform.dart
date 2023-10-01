import 'package:flutter/material.dart';
import 'package:cashbook/classes/ledger.dart';
import '../classes/models.dart';
import '../global.dart';
import '../components/namedcheckbox.dart';
import '../components/selector.dart';

// Account add

class AddEntityForm extends StatefulWidget {
  AddEntityForm({super.key});
  @override
  State<AddEntityForm> createState() => _AddEntityFormState();
}

class _AddEntityFormState extends State<AddEntityForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<AccountModel> fromAccounts = [];
  AccountModel? selectedFromAccount = null;
  List<AccountModel> toAccounts = [];
  AccountModel? selectedToAccount = null;

  String transactionType = "earning";
  Ledger ledger = Ledger();

  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    AccountModel.getOfType(ledger.getDatabase(), ["earning", "savings"])
        .then((value) {
      setState(() {
        fromAccounts = value;
      });
    });
    AccountModel.getOfType(ledger.getDatabase(), ["expense", "savings"])
        .then((value) {
      setState(() {
        toAccounts = value;
      });
    });
  }

  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      Global.log.t("Form not valid!");
      return;
    }
    _formKey.currentState!.save();
    await ledger.loaded;
    await ledger.insertEntity(EntityModel(
        db: ledger.getDatabase(),
        id: null,
        amount: double.parse(amountController.text),
        fromAccount: selectedFromAccount!,
        toAccount: selectedToAccount!,
        datetime: DateTime.parse(dateController.text),
        ledgerId: 1));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added Transactiom Successfully!")));
  }

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
              Expanded(
                  child: ListView(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Add a Transaction",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 10),
                      Tooltip(
                        message:
                            "Add a transaction. a transaction is an expense, income to an account, or a savings category",
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(Icons.help),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Fill out the following details to add an entity",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Transaction Type",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        NamedCheckBox(
                          onChange: (val) {
                            setState(() {
                              switch (val) {
                                case 0:
                                  transactionType = "earning";
                                  break;
                                case 1:
                                  transactionType = "expense";
                                  break;
                                case 2:
                                  transactionType = "savings";
                                  break;
                                default:
                              }
                            });
                          },
                          values: const ["Income", "Expense", "Savings"],
                        ),
                      ],
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text("Amount *"),
                                  suffixIcon:
                                      Icon(Icons.currency_rupee_rounded)),
                              onTapOutside: (val) {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "0" ||
                                    !RegExp(r"^[0-9]+$").hasMatch(value)) {
                                  return "Enter a valid amount";
                                }
                              }),
                          const SizedBox(height: 10),
                          const Text(
                            "Enter how much amount is transfered",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                  label: Text("Date *"),
                                  prefixIcon: Icon(Icons.date_range_outlined)),
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                DateTime? date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1919, 1, 1),
                                    lastDate: DateTime(2200, 1, 1));
                                if (date != null) {
                                  TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (time != null) {
                                    dateController.text = date
                                        .copyWith(
                                            hour: time.hour,
                                            minute: time.minute)
                                        .toLocal()
                                        .toIso8601String();
                                    FocusScope.of(context).unfocus();
                                  }
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Select date";
                                } else {
                                  try {
                                    DateTime d = DateTime.parse(value);
                                    if (d == null || d.year <= 1900) {
                                      return "Enter a valid date";
                                    }
                                  } catch (err) {
                                    return "Enter a valid date";
                                  }
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Enter your account opening date. ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: fromController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text("From Account *"),
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp)),
                            onTapOutside: (val) {
                              FocusScope.of(context).unfocus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Select from account";
                              }
                            },
                            onTap: () {
                              showSelectorDialog(
                                  context: context,
                                  data: fromAccounts,
                                  onSelected: (AccountModel val) {
                                    setState(() {
                                      selectedFromAccount = val;
                                      fromController.text = val.name;
                                    });
                                  },
                                  title: "Select Account");
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Select from which account the amount is transferred",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: toController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text("To Account *"),
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp)),
                            onTapOutside: (val) {
                              FocusScope.of(context).unfocus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Select To Account";
                              }
                            },
                            onTap: () {
                              showSelectorDialog(
                                  context: context,
                                  data: toAccounts,
                                  onSelected: (AccountModel val) {
                                    setState(() {
                                      selectedToAccount = val;
                                      toController.text = val.name;
                                    });
                                  },
                                  title: "Select Account");
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Select to which account the amount want to be transferred",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: notesController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                label: Text("Enter notes ")),
                            onTapOutside: (val) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Enter any notes or description about the transaction, if any.",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ],
              )),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: _submit,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: const Text(
                              "Add Transaction",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ))))
              ]),
            ],
          )),
    );
  }
}
