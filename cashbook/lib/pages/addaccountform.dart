import 'package:flutter/material.dart';
import 'package:cashbook/classes/ledger.dart';
import '../classes/models.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../global.dart';
import '../components/namedcheckbox.dart';
// Account add

class AddAccountForm extends StatefulWidget {
  AddAccountForm({super.key});
  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  TextEditingController controller = TextEditingController();
  TextEditingController curBalController = TextEditingController(text: "0");
  TextEditingController openBalController = TextEditingController(text: "0");
  TextEditingController openAcDate = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String selectedType = "earning";
  Ledger ledger = Ledger();
  var _formKey = GlobalKey<FormState>();
  void _submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      Global.log.t("Form not valid!");
      return;
    }
    _formKey.currentState!.save();
    await ledger.loaded;
    await ledger.insertAccount(AccountModel(
        db: ledger.getDatabase(),
        id: null,
        name: controller.text,
        type: selectedType,
        openingBalance: double.parse(openBalController.text),
        openingDate: DateTime.parse(openAcDate.text),
        currentBalance: 0,
        ledgerId: 1,
        color: Color(int.parse(colorController.text)),
        notes: notesController.text));
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Added Account Success!")));
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
                        "Add an Account",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 10),
                      Tooltip(
                        message:
                            "An account is a name used to represent a group of payment in same category. (eg: Food - This name will be used to denote all spendings on eating food)",
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(Icons.help),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Fill out the following details to create an account.",
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
                          "Account Type",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        NamedCheckBox(
                          onChange: (val) {
                            setState(() {
                              switch (val) {
                                case 0:
                                  selectedType = "earning";
                                  break;
                                case 1:
                                  selectedType = "expense";
                                  break;
                                case 2:
                                  selectedType = "savings";
                                  break;
                                default:
                              }
                            });
                          },
                          values: const ["Earning", "Expense", "Savings"],
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
                            controller: controller,
                            decoration: const InputDecoration(
                                label: Text("Account Name *")),
                            onTapOutside: (val) {
                              FocusScope.of(context).unfocus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter a valid name";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Enter the name of the account this account. this name will be displayed every where (eg : Food)",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: openBalController,
                              decoration: const InputDecoration(
                                  label: Text("Opening Balance"),
                                  suffixIcon:
                                      Icon(Icons.currency_rupee_rounded)),
                              keyboardType: TextInputType.number,
                              onTapOutside: (val) {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !RegExp(r"^[0-9]+$").hasMatch(value)) {
                                  return "Enter a valid amount";
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Enter your account opening balance, in case of an expense its the initial cost you spend on that category",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: openAcDate,
                              decoration: const InputDecoration(
                                  label: Text("Opening Date *"),
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
                                    openAcDate.text = date
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
                                  return "Select opening date";
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
                              controller: colorController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  label: const Text("Choose a colour * "),
                                  prefixIcon:
                                      const Icon(Icons.color_lens_outlined),
                                  suffix: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: colorController.text.isEmpty
                                                ? Colors.red
                                                : Color(int.parse(
                                                    colorController.text)),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    ],
                                  )),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Select a colour"),
                                          content: SingleChildScrollView(
                                            child: MaterialPicker(
                                                pickerColor: Colors.red,
                                                onColorChanged: (Color clr) {
                                                  setState(() {
                                                    colorController.text =
                                                        clr.value.toString();
                                                  });

                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                }),
                                          ),
                                        ));
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !RegExp(r"^[0-9]+$").hasMatch(value)) {
                                  return "Choose a colour";
                                }
                              }),
                          const SizedBox(height: 10),
                          const Text(
                            "Choose a colur to denote this account. This colour will be used to denote this account everywhere",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                            "Enter any notes or description about the account, if any.",
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
