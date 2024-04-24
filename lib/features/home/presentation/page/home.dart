import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/bloc/expense/expense_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/add_button.dart';
import 'package:cashbook/core/widgets/buttons/icon_button.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/features/home/presentation/bloc/expense_history/expense_history_bloc.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_entity_popup.dart';
import 'package:cashbook/features/home/presentation/widgets/charts/main_chart.dart';
import 'package:cashbook/features/home/presentation/widgets/history_displayer.dart';
import 'package:cashbook/features/home/presentation/widgets/money_display.dart';
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
  static int homePageHistoryCount = 5;

  List<MainChartRow> _getChartData(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return [];
    }
    if (expenses.length == 1) {
      return [
        MainChartRow(
            color: Colors.blue,
            value: 0,
            date: DateFormat("d MMM")
                .format(DateTime.now().copyWith(day: DateTime.now().day - 1))),
        MainChartRow(
            color: expenses[0].tag.target?.colorValue ?? Colors.blue,
            value: expenses[0].amount,
            date: DateFormat("d MMM").format(expenses[0].date))
      ];
    }
    var data = <MainChartRow>[];
    for (var x in expenses) {
      data.add(MainChartRow(
          color: x.tag.target?.colorValue ?? Colors.blue,
          value: x.amount,
          date: DateFormat("d MMM").format(x.date)));
    }
    return data;
  }

  void _emitHistoryEvent(ExpenseHistoryBloc bloc) {
    bloc.add(GetExpenseHistoryEvent(count: homePageHistoryCount));
  }

  void _emitDataEvent(ExpenseBloc bloc) {
    bloc.add(ExpenseDataEvent(
        startDate: DateTime.now()
            .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0),
        endDate: DateTime.now()
            .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999)));
  }

  @override
  void initState() {
    super.initState();
    ExpenseBloc expenseBloc = context.read<ExpenseBloc>();
    ExpenseHistoryBloc historyBloc = context.read<ExpenseHistoryBloc>();

    _emitHistoryEvent(historyBloc);
    _emitDataEvent(expenseBloc);
    expenseBloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        _emitHistoryEvent(historyBloc);
        _emitDataEvent(expenseBloc);
      } else if (event is ExpenseDataError) {
        Fluttertoast.showToast(msg: event.message);
      } else if (event is ExpenseEdited) {
        _emitHistoryEvent(historyBloc);
        _emitDataEvent(expenseBloc);
      }
    });
    historyBloc.stream.listen((event) {
      if (event is ExpenseHistoryError) {
        Fluttertoast.showToast(msg: event.message);
      }
    });
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
              const MainAppBar(title: "CashBook", showTitle: false),
              Container(
                padding: EdgeInsets.all(width * 0.035),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                    amount: state.total,
                                    subText: "Net expense this month");
                              }
                              return const MoneyDisplay(
                                  amount: 0, subText: "Net expense this month");
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
                          return const ErrorDisplay(
                              title: "No Data Found!",
                              description:
                                  "No data found to display for this month!",
                              icon: BootstrapIcons.database_slash);
                        }
                        return MainChart(data: _getChartData(state.expenses));
                      }
                      if (state is ExpenseDataError) {
                        Fluttertoast.showToast(msg: state.message);
                        return ErrorDisplay(
                          title: "Error Occurred !",
                          description:
                              "There was an error getting transactional data.",
                          icon: BootstrapIcons.bug,
                          mainColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red
                              .withAlpha(190),
                        );
                      }
                      return const AspectRatio(
                          aspectRatio: 1.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator()),
                              SizedBox(height: 20),
                              Text("Loading...")
                            ],
                          ));
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
                    BlocConsumer<ExpenseHistoryBloc, ExpenseHistoryState>(
                        builder: (context, state) {
                          if (state is ExpenseHistoryLoaded) {
                            if (state.expenses.isEmpty) {
                              return Center(
                                child: Container(
                                    width: width * 0.9,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .extension<AppColorsExtension>()!
                                            .primaryLight
                                            .withAlpha(50),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(BootstrapIcons.slash_circle,
                                              size: 15),
                                          SizedBox(width: 10),
                                          Text("No recent transactions found!")
                                        ])),
                              );
                            }
                            return HistoryDisplayer(
                                expenses: state.expenses,
                                historyCount: homePageHistoryCount);
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
