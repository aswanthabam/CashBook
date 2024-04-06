import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/features/main_app/presentation/bloc/expense_bloc.dart';
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
                          if (state is ExpenseDataError) {
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
