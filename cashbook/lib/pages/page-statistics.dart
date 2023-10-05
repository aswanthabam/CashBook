import 'package:flutter/material.dart';
import '../components/pie_chart.dart';
import '../classes/ledger.dart';
import '../classes/models.dart';

class PageStatistics extends StatefulWidget {
  const PageStatistics({super.key});

  @override
  State<PageStatistics> createState() => _PageStatisticsState();
}

class _PageStatisticsState extends State<PageStatistics> {
  Ledger ledger = Ledger();
  List<AccountModel> expenses = [];
  List<AccountModel> earnings = [];
  List<AccountModel> savings = [];
  List<MapData> getMapData(List<AccountModel> acc) {
    return acc
        .map<MapData>((e) =>
            MapData(name: e.name, value: e.currentBalance, color: e.color))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    AccountModel.getOfType(ledger.getDatabase(), ['earning']).then((value) {
      setState(() {
        earnings = value;
      });
    });
    AccountModel.getOfType(ledger.getDatabase(), ['expense']).then((value) {
      setState(() {
        expenses = value;
      });
    });
    AccountModel.getOfType(ledger.getDatabase(), ['savings']).then((value) {
      setState(() {
        savings = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PieChart(
          data: getMapData(earnings),
          title: "Earnings",
          titleVisible: true,
        ),
        PieChart(
          data: getMapData(expenses),
          title: "Expenses",
          titleVisible: true,
        ),
        PieChart(
          data: getMapData(savings),
          title: "Savings",
          titleVisible: true,
        )
      ],
    );
  }
}
