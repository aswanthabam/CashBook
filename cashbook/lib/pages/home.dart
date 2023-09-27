import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';
import 'package:cashbook/classes/ledger.dart';
import 'package:cashbook/components/addform.dart';
import 'package:cashbook/global.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Ledger? ledger = null;
  bool expenseAccount = false;
  double totalEarning = 0;
  String topExpenceAC = "---";
  String topEarningAC = "---";
  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void ledgerChanged(Ledger l) {
    setState(() {
      ledger = l;
    });
    ledger!
        .totalMonth(Ledger.getMonthRange(DateTime.now())[0],
            Ledger.getMonthRange(DateTime.now())[1])
        .then((val) {
      setState(() {
        totalEarning = val.earning - val.expense;
      });
    });
    AccountModel.all(ledger!.getDatabase()).then((value) async {
      Map<String, double> ear = {};
      Map<String, double> exp = {};
      for (var x in value) {
        for (var i in (await x.getStatment(
            ledger!.getDatabase(),
            Ledger.getMonthRange(DateTime.now())[0],
            Ledger.getMonthRange(DateTime.now())[1]))!) {
          if (x.expenseAccount) {
            exp[x.name] = exp.putIfAbsent(x.name, () => 0) + i.amount;
          } else {
            ear[x.name] = ear.putIfAbsent(x.name, () => 0) + i.amount;
          }
        }
      }
      double gr = 0, gr2 = 0;
      String expGR = "---", earGR = "---";
      ear.forEach((key, val) {
        if (val > gr) {
          gr = val;
          earGR = key;
        }
      });
      exp.forEach((key, val) {
        if (val > gr2) {
          gr2 = val;
          expGR = key;
        }
      });
      setState(() {
        topEarningAC = earGR;
        topExpenceAC = expGR;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Ledger.load(1).then((value) {
      if (value == null) {
        Global.log.w("Ledger not created!");
      } else {
        ledger = value;
        ledger!.setChangeNotifier(ledgerChanged);
        ledger!
            .totalMonth(
                DateTime.now().copyWith(hour: 0, minute: 0, day: 1),
                DateTime.now().copyWith(
                    hour: 0,
                    minute: 0,
                    day: 1,
                    month: (DateTime.now().month + 1) % 12))
            .then((val) {
          setState(() {
            totalEarning = val.earning - val.expense;
          });
        });
        Global.log.i("LEDGER CREATED or loaded");
      }
    });
  }

  void addExpense() {
    showDialog(
        context: context,
        builder: (context) {
          return AddExpenseForm(
            ledger: ledger!,
          );
        });
  }

  void addEarning() {
    showDialog(
        context: context,
        builder: (context) {
          return AddEarningForm(
            ledger: ledger!,
          );
        });
  }

  void addAccount() {
    showDialog(
        context: context,
        builder: (context) {
          return AddAccountForm(
            ledger: ledger!,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text("Current Status"),
              Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Expence",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${ledger == null ? 0 : ledger!.expense}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Earnings",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${ledger == null ? 0 : ledger!.earning}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green.shade400,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EntityButton(
                      onClick: addExpense, text: "Expence", icon: Icons.add),
                  EntityButton(
                      onClick: addEarning, text: "Earnings", icon: Icons.add),
                  EntityButton(
                      onClick: addAccount, text: "Account", icon: Icons.add)
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total This Month"),
                        Text(
                          "${totalEarning}",
                          style: TextStyle(
                              color: totalEarning > 0
                                  ? Colors.green.shade500
                                  : Colors.red.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Major Spending on "),
                        Text(
                          topExpenceAC,
                          style: TextStyle(
                              color: Colors.red.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Major Earnings Threw"),
                        Text(
                          topEarningAC,
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Net Balance"),
                        Text(
                          "${ledger == null ? 0 : (ledger!.ledger.cashBalance + ledger!.ledger.bankBalance)}/-",
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "More Details >>",
                          style: TextStyle(
                              color: Colors.blue.shade400,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ]),
              )
            ],
          )),
    );
  }
}

class EntityButton extends StatelessWidget {
  EntityButton(
      {super.key,
      required this.onClick,
      required this.text,
      required this.icon,
      this.iconOnly = false,
      this.width = 80,
      this.height = 80,
      this.iconColor = const Color.fromRGBO(100, 181, 246, 1),
      this.textColor = const Color.fromRGBO(100, 181, 246, 1),
      this.background = Colors.white});
  void Function() onClick;
  late String text = "";
  late IconData icon;
  bool iconOnly = false;
  double width, height;
  Color background, textColor, iconColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onClick,
        child: Container(
          padding: EdgeInsets.all(10),
          width: width,
          height: height,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: iconColor.withAlpha(100),
                blurRadius: 5,
                offset: Offset(1, 0))
          ], color: background, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              iconOnly
                  ? Text("")
                  : Text(
                      text,
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
            ],
          ),
        ));
  }
}
