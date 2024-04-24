import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/bloc/expense/expense_bloc.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/chart/indicator.dart';
import 'package:cashbook/data/models/expense.dart';
import 'package:cashbook/data/models/tag_data.dart';
import 'package:cashbook/features/history/presentation/page/history/history_bloc.dart';
import 'package:cashbook/features/home/presentation/widgets/history_displayer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Expense> expenses = [];
  List<Expense> expenseTag = [];
  late HistoryBloc historyBloc;
  int selectedType = 1;
  int touchIndex = -1;
  List<Expense> inDisplayExpenses = [];

  List<Expense> getExpensesGroupByTag({required List<Expense> expenses}) {
    expenseTag = [];
    for (var element in expenses) {
      if (element.liability.target != null) {
        final index = expenseTag.indexWhere((elementTag) =>
            elementTag.tag.target?.id == -(element.liability.target!.id + 1));
        if (index != -1) {
          expenseTag[index].amount += element.amount;
        } else {
          var e = Expense(
              id: 0,
              title: element.liability.target?.title ?? "Liability",
              amount: element.amount,
              description: "Expense Filter Group BY Tags",
              date: element.date);
          e.tag.target = TagData(
              title: element.liability.target!.title,
              id: -(element.liability.target!.id + 1),
              color: element.liability.target!.color,
              icon: element.liability.target!.icon ?? '');
          expenseTag.add(e);
        }
      } else if (element.tag.target != null) {
        final index = expenseTag.indexWhere((elementTag) =>
            elementTag.tag.target?.id == element.tag.target?.id);
        if (index != -1) {
          expenseTag[index].amount += element.amount;
        } else {
          var e = Expense(
              id: 0,
              title: element.tag.target!.title,
              amount: element.amount,
              description: "Expense Filter Group BY Tags",
              date: element.date);
          e.tag.target = element.tag.target;
          expenseTag.add(e);
        }
      } else {
        final index = expenseTag
            .indexWhere((elementTag) => elementTag.tag.target?.id == null);
        if (index != -1) {
          expenseTag[index].amount += element.amount;
        } else {
          var e = Expense(
              id: 0,
              title: "Uncategorized",
              amount: element.amount,
              description: "Expense Filter Group BY Tags",
              date: element.date);
          e.tag.target = element.tag.target;
          expenseTag.add(e);
        }
      }
    }
    return expenseTag;
  }

  void _emitRefresh(HistoryBloc historyBloc) {
    historyBloc.add(GetHistoryEvent(
      count: -1,
      startDate: DateTime.now().subtract(Duration(
          days: selectedType == 1
              ? 30
              : selectedType == 2
                  ? 365
                  : 3650)),
      endDate: DateTime.now(),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _emitRefresh(historyBloc);
  }

  @override
  void initState() {
    super.initState();
    historyBloc = context.read<HistoryBloc>();
    ExpenseBloc expenseBloc = context.read<ExpenseBloc>();
    _emitRefresh(historyBloc);
    historyBloc.stream.listen((event) {
      if (event is HistoryLoaded) {
        inDisplayExpenses = event.expenses;
        setState(() {});
      }
    });
    expenseBloc.stream.listen((event) {
      if (event is ExpenseAdded) {
        _emitRefresh(historyBloc);
      } else if (event is ExpenseEdited) {
        _emitRefresh(historyBloc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          const MainAppBar(title: "Analytics"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .grayishWhite,
                  borderRadius: BorderRadius.circular(10)),
              width: width,
              child: DropdownButton(
                  menuMaxHeight: 200,
                  underline: const SizedBox(),
                  isExpanded: true,
                  selectedItemBuilder: (context) => [
                        Text(selectedType == 1 ? "For Month" : ""),
                      ],
                  icon: Icon(
                    BootstrapIcons.calendar2_date,
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .black,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  style: TextStyle(
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .black),
                  hint: Text(
                    selectedType == 1
                        ? "Analytics for last 30 days"
                        : selectedType == 2
                            ? "Analytics for last 365 days"
                            : "Analytics for all time",
                    style: TextStyle(
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .black),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("30 days")),
                    DropdownMenuItem(value: 2, child: Text("365 days")),
                    DropdownMenuItem(value: 3, child: Text("For All Time")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value as int;
                    });
                  }),
            ),
          ),
          BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
            if (state is HistoryLoaded) {
              List<Expense> expenses =
                  getExpensesGroupByTag(expenses: state.expenses);
              inDisplayExpenses = state.expenses;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text("Expenses Grouped By Tags",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .extension<AppColorsExtension>()!
                                  .primary)),
                      const Divider(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TagGraph(
                          expenses: expenses,
                          onTouchedIndex: (index) {
                            if (touchIndex != index && index != -1) {
                              touchIndex = index;
                              inDisplayExpenses =
                                  state.expenses.where((element) {
                                if (element.liability.target != null) {
                                  return -(element.liability.target!.id + 1) ==
                                      expenses[index].tag.target?.id;
                                }
                                return element.tag.target?.id ==
                                    expenses[index].tag.target?.id;
                              }).toList();
                              setState(() {});
                            } else {
                              touchIndex = -1;
                              inDisplayExpenses = state.expenses;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ]),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HistoryDisplayer(
                expenses: inDisplayExpenses,
                historyCount: touchIndex == -1 ? 5 : inDisplayExpenses.length),
          ),
        ])));
  }
}

class TagGraph extends StatefulWidget {
  const TagGraph(
      {super.key, required this.expenses, required this.onTouchedIndex});

  final List<Expense> expenses;
  final Function(int touchedIndex) onTouchedIndex;

  @override
  State<TagGraph> createState() => _TagGraphState();
}

class _TagGraphState extends State<TagGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.5,
          height: width * 0.5,
          child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          touchedIndex = pieTouchResponse
                                  ?.touchedSection?.touchedSectionIndex ??
                              -1;
                          widget.onTouchedIndex(touchedIndex);
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: width * 0.14,
                    sections: widget.expenses.map<PieChartSectionData>((e) {
                      final int i = widget.expenses.indexOf(e);
                      final isTouched = i == touchedIndex;
                      final radius = isTouched ? 60.0 : 50.0;
                      final String text = isTouched
                          ? e.tag.target?.title ?? "Uncategorized"
                          : formatMoney(amount: e.amount);
                      return PieChartSectionData(
                          color: e.tag.target?.color != null
                              ? Color(e.tag.target!.color)
                              : Colors.blue,
                          value: e.amount.toDouble(),
                          radius: radius,
                          titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          title: text);
                    }).toList()),
              )),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: width * 0.25,
          child: Wrap(
            direction: Axis.vertical,
            spacing: 10,
            children: widget.expenses
                .map(
                  (e) => Indicator(
                    color: e.tag.target?.color != null
                        ? Color(e.tag.target!.color)
                        : Colors.blue,
                    text: e.tag.target?.title ?? "Uncategorized",
                    isSquare: true,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
