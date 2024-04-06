import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/features/main_app/data/models/expense.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense_bloc.dart';
import 'package:cashbook/features/main_app/presentation/widgets/charts/main_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // late Future<List<MainChartRow>> graphData;
  static int historyPageHistoryCount = 30;

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
    bloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        _emitHistoryEvent(bloc);
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
              const MainAppBar(),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                    BlocConsumer<ExpenseBloc, ExpenseState>(
                        builder: (context, state) {
                          if (state is ExpenseHistoryLoaded) {
                            if (state.expenses.isEmpty) {
                              return const Center(
                                child: Text("No data found"),
                              );
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.expenses.length >
                                        historyPageHistoryCount
                                    ? historyPageHistoryCount
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
                                      style: const TextStyle(fontSize: 14),
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
                          if (state is ExpenseHistoryError) {
                            return Center(
                              child: Text(state.message),
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
