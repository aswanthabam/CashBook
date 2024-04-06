import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/add_button.dart';
import 'package:cashbook/core/widgets/buttons/icon_button.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/widgets/add_entity/add_entity_popup.dart';
import 'package:cashbook/features/main_app/presentation/widgets/charts/main_chart.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late Future<List<MainChartRow>> graphData;
  static int homePageHistoryCount = 5;

  List<MainChartRow> _getChartData(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return [];
    }
    if (expenses.length == 1) {
      return [
        MainChartRow(
            value: 0,
            date: DateFormat("d MMM").format(DateTime.now().copyWith(day: 1))),
        MainChartRow(
            value: expenses[0].amount,
            date: DateFormat("d MMM").format(expenses[0].date))
      ];
    }
    var data = <MainChartRow>[];
    for (var x in expenses) {
      data.add(MainChartRow(
          value: x.amount, date: DateFormat("d MMM").format(x.date)));
    }
    return data;
  }

  void _emitHistoryEvent(ExpenseBloc bloc) {
    bloc.add(GetHistoryEvent(
        startDate: DateTime.now()
            .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0),
        endDate: DateTime.now().copyWith(
            day: 30, hour: 23, minute: 59, second: 59, millisecond: 999)));
  }

  @override
  void initState() {
    super.initState();
    ExpenseBloc bloc = context.read<ExpenseBloc>();
    _emitHistoryEvent(bloc);
    // _emitTotalExpenseEvent(bloc);
    bloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        _emitHistoryEvent(bloc);
      }
      if (event is ExpenseDataError) {
        Fluttertoast.showToast(msg: event.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
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
                    // const PaginationIndicator(
                    //   count: 3,
                    //   index: 1,
                    // ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: BlocConsumer<ExpenseBloc, ExpenseState>(
                            builder: (context, state) {
                              if (state is ExpenseDataLoaded) {
                                return MoneyDisplay(
                                    text: "- ${state.total.toString()} ₹",
                                    subText: "Net expense this month");
                              }
                              return const SizedBox();
                            },
                            listener:
                                (BuildContext context, ExpenseState state) {},
                          )),
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
                  child: BlocConsumer<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      if (state is ExpenseDataLoaded) {
                        if (state.expenses.isEmpty) {
                          return const Text("No data available to display.");
                        }
                        return MainChart(data: _getChartData(state.expenses));
                      }
                      if (state is ExpenseDataError) {
                        Fluttertoast.showToast(msg: state.message);
                        return Text(state.message);
                      }
                      return const Placeholder();
                    },
                    listener: (context, state) {},
                  )),
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
                    BlocConsumer<ExpenseBloc, ExpenseState>(
                        builder: (context, state) {
                          if (state is ExpenseDataLoaded) {
                            if (state.expenses.isEmpty) {
                              return const Center(
                                child: Text("No data found"),
                              );
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: height * 0.02),
                                itemCount:
                                    state.expenses.length > homePageHistoryCount
                                        ? homePageHistoryCount
                                        : state.expenses.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    shape: const Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 1)),
                                    leading: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          BootstrapIcons.hourglass_split,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        )
                                      ],
                                    ),
                                    horizontalTitleGap: 25,
                                    title: Text(
                                      state
                                          .expenses[
                                              state.expenses.length - index - 1]
                                          .title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .extension<AppColorsExtension>()!
                                              .black),
                                    ),
                                    subtitle: Text(
                                        state
                                            .expenses[state.expenses.length -
                                                index -
                                                1]
                                            .date
                                            .toString(),
                                        style: const TextStyle(fontSize: 12)),
                                    trailing: Text(
                                      state
                                          .expenses[
                                              state.expenses.length - index - 1]
                                          .amount
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }
                          return const SizedBox();
                        },
                        listener: (context, state) {}),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButtonWidget(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("history");
                          },
                          message: "View All Transactions",
                          icon: Icons.chevron_right,
                          alignRight: true,
                        ),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
