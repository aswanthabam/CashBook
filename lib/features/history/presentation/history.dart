import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/features/home/presentation/bloc/expense/expense_bloc.dart';
import 'package:cashbook/features/home/presentation/bloc/expense_history/expense_history_bloc.dart';
import 'package:cashbook/features/home/presentation/widgets/history_displayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // late Future<List<MainChartRow>> graphData;
  static int historyPageHistoryCount = 30;
  DateTime startDate = DateTime.now()
      .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0);
  DateTime endDate = DateTime.now()
      .copyWith(day: 30, hour: 23, minute: 59, second: 59, millisecond: 999);
  TextEditingController searchController = TextEditingController();

  // List<MainChartRow> _getChartData(List<Expense> expenses) {
  //   if (expenses.isEmpty) {
  //     return [];
  //   }
  //   if (expenses.length == 1) {
  //     return [
  //       MainChartRow(
  //           value: 0,
  //           date: DateFormat("d MMM").format(DateTime.now().copyWith(day: 1))),
  //       MainChartRow(
  //           value: expenses[0].amount,
  //           date: DateFormat("d MMM").format(expenses[0].date))
  //     ];
  //   }
  //   var data = <MainChartRow>[];
  //   for (var x in expenses) {
  //     data.add(MainChartRow(
  //         value: x.amount, date: DateFormat("d MMM").format(x.date)));
  //   }
  //   return data;
  // }

  void _emitHistoryEvent(ExpenseHistoryBloc bloc) {
    bloc.add(GetExpenseHistoryEvent(count: historyPageHistoryCount));
  }

  @override
  void initState() {
    super.initState();
    ExpenseHistoryBloc historyBloc = context.read<ExpenseHistoryBloc>();
    _emitHistoryEvent(historyBloc);
    historyBloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        _emitHistoryEvent(historyBloc);
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
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Text(
                        "All History",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .extension<AppColorsExtension>()!
                                .primary),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          // TODO : IMPLEMENT ON SEARCH
                          // BlocProvider.of<ExpenseBloc>(context).add(SearchEvent(search: value));
                        },
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .extension<AppColorsExtension>()!
                                    .black),
                            contentPadding: EdgeInsets.all(height * 0.025),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: const Icon(Icons.search)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width / 2 - 20,
                          height: height * 0.05,
                          child: TextField(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1999),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    startDate = value;
                                  });
                                }
                                FocusScope.of(context).unfocus();
                              });
                            },
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                hintText: "Start Date",
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .extension<AppColorsExtension>()!
                                        .black),
                                contentPadding: EdgeInsets.all(height * 0.025),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.calendar_today)),
                          ),
                        ),
                        SizedBox(
                          width: width / 2 - 20,
                          height: height * 0.05,
                          child: TextField(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1999),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    startDate = value;
                                  });
                                }
                                FocusScope.of(context).unfocus();
                              });
                            },
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                hintText: "Start Date",
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .extension<AppColorsExtension>()!
                                        .black),
                                contentPadding: EdgeInsets.all(height * 0.025),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.calendar_today)),
                          ),
                        ),
                      ],
                    ),
                    BlocConsumer<ExpenseHistoryBloc, ExpenseHistoryState>(
                        builder: (context, state) {
                          if (state is ExpenseHistoryLoaded) {
                            if (state.expenses.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                    width: width,
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
                                historyCount: historyPageHistoryCount);
                          }
                          if (state is ExpenseHistoryError) {
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
                          return const SizedBox();
                        },
                        listener: (context, state) {}),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
