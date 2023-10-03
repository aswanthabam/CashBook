import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';
import 'package:cashbook/classes/ledger.dart';
import 'package:cashbook/pages/addentityform.dart';
import 'package:cashbook/global.dart';
import '../classes/models.dart';

class PageMain extends StatefulWidget {
  const PageMain({super.key});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  Ledger? ledger;
  bool expenseAccount = false;
  double totalEarning = 0;
  String topExpenceAC = "---";
  String topEarningAC = "---";
  double expense = 0, earning = 0;

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
  }

  @override
  void initState() {
    super.initState();
    // ledger = widget.ledger;
    ledger = Ledger();
    ledger!.loaded.then((value) {
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
    });
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // EntityButton(
              //     //     onClick: addExpense, text: "Expence", icon: Icons.add),
              //     // EntityButton(
              //     //     onClick: addEarning, text: "Earnings", icon: Icons.add),
              //     // EntityButton(
              //     //     onClick: addAccount, text: "Account", icon: Icons.add)
              //   ],
              // ),
              // const SizedBox(height: 20),
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
                        Text("Total Savings"),
                        Text(
                          "${ledger!.savings}",
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
                          "${ledger == null ? 0 : (!ledger!.is_loaded ? "?" : (ledger!.ledger.cashBalance + ledger!.ledger.bankBalance))}/-",
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
