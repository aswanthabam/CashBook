import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/add_button.dart';
import 'package:cashbook/core/widgets/pagination_indicator/indicator.dart';
import 'package:cashbook/features/main_app/domain/models/expense.dart';
import 'package:cashbook/features/main_app/presentation/widgets/add_entity/add_entity_popup.dart';
import 'package:cashbook/features/main_app/presentation/widgets/charts/main_chart.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late Future<List<MainChartRow>> graphData;

  Future<List<MainChartRow>> _getChartData() async {
    ExpenseList list = await Expense.getExpenseList(
        DateTime.now()
            .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0),
        DateTime.now().copyWith(
            day: 30, hour: 23, minute: 59, second: 59, millisecond: 999));
    if (list.expenses.isEmpty) {
      return [];
    }
    if (list.expenses.length == 1) {
      return [
        MainChartRow(
            value: 0,
            date: DateFormat("d MMM").format(DateTime.now().copyWith(day: 1))),
        MainChartRow(
            value: list.expenses[0].amount,
            date: DateFormat("d MMM").format(list.expenses[0].date))
      ];
    }
    var data = <MainChartRow>[];
    for (var x in list.expenses) {
      print(x);
      data.add(MainChartRow(
          value: x.amount, date: DateFormat("d MMM").format(x.date)));
    }
    return data;
  }

  Future<List<ListTile>> _getHistoryData() async {
    ExpenseList list = await Expense.getExpenseList(
        DateTime.now()
            .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0),
        DateTime.now().copyWith(
            day: 30, hour: 23, minute: 59, second: 59, millisecond: 999),
        descending: true);
    var data = <ListTile>[];
    for (var x in list.expenses) {
      print(x);
      data.add(ListTile(
        shape: Border(top: BorderSide(color: Colors.grey.shade400, width: 1)),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              BootstrapIcons.hourglass_split,
              color: Theme.of(context)
                  .extension<AppColorsExtension>()!
                  .primarySemiDark,
            ),
            const SizedBox(
              height: 3,
            )
          ],
        ),
        horizontalTitleGap: 25,
        title: Text(
          x.title,
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).extension<AppColorsExtension>()!.black),
        ),
        subtitle: Text(x.date.toString(),
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).extension<AppColorsExtension>()!.black)),
        trailing: Text(
          x.amount.toString(),
          style: TextStyle(
              color: Theme.of(context).extension<AppColorsExtension>()!.red,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ));
    }
    return data;
  }

  // List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    // graphData = _getChartData();
    // AppDatabase.create().then((db) async {
    //   expenses = await db.getAll<Expense>();
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const MainAppBar(),
              Container(
                padding: EdgeInsets.all(width * 0.035),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PaginationIndicator(
                      count: 3,
                      index: 1,
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: MoneyDisplay(
                                text: "+ 54,500 ₹",
                                subText: "Net earnings this month"),
                          ),
                          AddButton(
                            onPressed: () {
                              showAddEntityPopup(context);
                            },
                          )
                        ]),
                    const SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.035),
                child: FutureBuilder(
                    future: _getChartData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text("No data found"),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No data found"),
                        );
                      }
                      return MainChart(
                        data: snapshot.data as List<MainChartRow>,
                      );
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                // decoration: BoxDecoration(
                //   color: Colors.green,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Text("History"),
                    ),
                    FutureBuilder(
                        future: _getHistoryData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data == null) {
                            return const Center(
                              child: Text("No data found"),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text("No data found"),
                            );
                          }
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data as List<Widget>,
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
