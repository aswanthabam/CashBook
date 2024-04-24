import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/bloc/expense/expense_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/features/history/presentation/page/history/history_bloc.dart';
import 'package:cashbook/features/home/presentation/widgets/history_displayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  static int historyPageHistoryCount = 30;
  DateTime startDate = DateTime.now()
      .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0);
  DateTime endDate = DateTime.now()
      .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);
  TextEditingController searchController = TextEditingController();
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  void _emitHistoryEvent(HistoryBloc bloc) {
    bloc.add(GetHistoryEvent(count: historyPageHistoryCount));
  }

  @override
  void initState() {
    super.initState();
    startDateController =
        TextEditingController(text: startDate.toIso8601String().split("T")[0]);
    endDateController =
        TextEditingController(text: endDate.toIso8601String().split("T")[0]);
    HistoryBloc historyBloc = context.read<HistoryBloc>();
    _emitHistoryEvent(historyBloc);
    ExpenseBloc expenseBloc = context.read<ExpenseBloc>();
    expenseBloc.stream.listen((event) {
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
              const MainAppBar(title: "Transaction History"),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context
                              .read<HistoryBloc>()
                              .add(SearchHistoryEvent(query: value));
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
                                      lastDate: DateTime.now(),
                                      currentDate: startDate)
                                  .then((value) {
                                if (value != null) {
                                  if (value != startDate) {
                                    context.read<HistoryBloc>().add(
                                        GetHistoryEvent(
                                            count: 50,
                                            startDate: value,
                                            endDate: endDate));
                                    setState(() {
                                      startDate = value;
                                      startDateController.text =
                                          value.toIso8601String().split("T")[0];
                                    });
                                  }
                                }
                                FocusScope.of(context).unfocus();
                              });
                            },
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: startDateController,
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
                                      lastDate: DateTime.now(),
                                      currentDate: endDate)
                                  .then((value) {
                                if (value != null) {
                                  if (endDate != value) {
                                    value = value.copyWith(
                                        hour: 23,
                                        minute: 59,
                                        second: 59,
                                        millisecond: 999);
                                    context.read<HistoryBloc>().add(
                                        GetHistoryEvent(
                                            count: 50,
                                            startDate: startDate,
                                            endDate: value));
                                    setState(() {
                                      endDate = value!;
                                      endDateController.text =
                                          value.toIso8601String().split("T")[0];
                                    });
                                  }
                                }
                                FocusScope.of(context).unfocus();
                              });
                            },
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: endDateController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                hintText: "End Date",
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
                    BlocConsumer<HistoryBloc, HistoryState>(
                        builder: (context, state) {
                          if (state is HistoryLoaded) {
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
                          if (state is HistoryError) {
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
