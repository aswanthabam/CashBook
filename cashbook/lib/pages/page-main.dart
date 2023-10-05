import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';
import 'package:cashbook/classes/ledger.dart';
import 'package:cashbook/pages/addentityform.dart';
import 'package:cashbook/global.dart';
import '../classes/models.dart';
import '../components/pie_chart.dart';

class PageMain extends StatefulWidget {
  const PageMain({super.key});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  Ledger ledger = Ledger();
  bool expenseAccount = false;
  double totalEarning = 0;
  String topExpenceAC = "---";
  String topEarningAC = "---";
  double expense = 0, earning = 0;

  List<AccountStatment> monthEarnings = [];
  List<AccountStatment> monthExpenses = [];
  List<AccountStatment> monthSavings = [];

  List<AccountModel> earnings = [];
  List<AccountModel> expenses = [];
  List<AccountModel> savings = [];

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
    AccountModel.all(ledger.getDatabase()).then((value) async {
      Map<String, double> ear = {};
      Map<String, double> exp = {};
      for (var x in value) {
        for (var i in (await x.getStatment(
                ledger!.getDatabase(),
                Ledger.getMonthRange(DateTime.now())[0],
                Ledger.getMonthRange(DateTime.now())[1]))!
            .received) {
          if (x.type == "expense") {
            exp[x.name] = exp.putIfAbsent(x.name, () => 0) + i.amount;
          } else if (x.type == "earning") {
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
    collectMonthData();
  }

  void collectMonthData() async {
    earnings = await AccountModel.getOfType(ledger.getDatabase(), ["earning"]);
    expenses = await AccountModel.getOfType(ledger.getDatabase(), ["expense"]);
    savings = await AccountModel.getOfType(ledger.getDatabase(), ["savings"]);
    setState(() {
      earnings = earnings;
      expenses = expenses;
      savings = savings;
    });
    for (var i in earnings) {
      var lst = Ledger.getMonthRange(DateTime.now());
      monthEarnings
          .add((await i.getStatment(ledger.getDatabase(), lst[0], lst[1]))!);
    }
    for (var i in expenses) {
      var lst = Ledger.getMonthRange(DateTime.now());
      monthExpenses
          .add((await i.getStatment(ledger.getDatabase(), lst[0], lst[1]))!);
    }
    for (var i in savings) {
      var lst = Ledger.getMonthRange(DateTime.now());
      monthSavings
          .add((await i.getStatment(ledger.getDatabase(), lst[0], lst[1]))!);
    }
    setState(() {
      monthEarnings = monthEarnings;
      monthExpenses = monthExpenses;
      monthSavings = monthSavings;
    });
  }

  @override
  void initState() {
    super.initState();
    ledger.loaded.then((value) {
      if (!value) {
        Global.log.w("Ledger not created!");
      } else {
        ledger!.setChangeNotifier(ledgerChanged, "home");
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

      collectMonthData();
    });
  }

  List<MapData> getMapData(List<AccountStatment> acc) {
    return acc
        .map<MapData>((e) => MapData(
            name: e.account.name,
            value: e.totalReceived - e.totalSend,
            color: e.account.color))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text("Statment", style: TextStyle(fontSize: 17)),
                  Spacer(),
                  Row(
                    children: [
                      Text("June 2023",
                          style: TextStyle(fontSize: 17, color: Colors.grey)),
                      Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                height: 110,
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(61, 10, 155, 128),
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
                                  "Income",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF0C772A),
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${ledger == null ? 0 : ledger!.earning}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Dela",
                                        color: Color(0xFF0C772A),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              width: 2,
                              height: 60,
                              decoration:
                                  BoxDecoration(color: Color(0x7FAE770D))),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Expense",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFC33030),
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${ledger == null ? 0 : ledger!.expense}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Dela",
                                        color: Color(0xFFC33030),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              width: 2,
                              height: 60,
                              decoration:
                                  BoxDecoration(color: Color(0x7FAE770D))),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Savings",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF007981),
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${ledger == null ? 0 : ledger!.savings}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Dela",
                                        color: Color(0xFF007981),
                                      ),
                                    )),
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
              Column(children: [
                PieChart(
                    data: getMapData(monthEarnings),
                    title: "Earnings",
                    titleVisible: true,
                    height: 200),
                PieChart(
                    data: getMapData(monthExpenses),
                    title: "Expenses",
                    titleVisible: true,
                    height: 200),
                PieChart(
                    data: getMapData(monthSavings),
                    title: "Savings",
                    titleVisible: true,
                    height: 200)
              ]),
              const SizedBox(height: 160)
            ],
          )),
    );
  }
}
