import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/pagination_indicator/indicator.dart';
import 'package:cashbook/features/main_app/presentation/widgets/charts/main_chart.dart';
import 'package:cashbook/features/main_app/presentation/widgets/money_display.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PaginationIndicator(
                      count: 3,
                      index: 1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MoneyDisplay(
                        text: "+ 15,000 ₹", subText: "Net earnings this month"),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MainChart(
                  data: [
                    MainChartRow(value: 100, date: "1st"),
                    MainChartRow(value: 500, date: "5th"),
                    MainChartRow(value: 400, date: "4th"),
                    MainChartRow(value: -200, date: "2nd"),
                    MainChartRow(value: 900, date: "9th"),
                    MainChartRow(value: 300, date: "3rd"),
                    MainChartRow(value: 800, date: "8th"),
                    MainChartRow(value: -200, date: "2nd"),
                    MainChartRow(value: -500, date: "7th"),
                    MainChartRow(value: 1000, date: "10th"),
                    MainChartRow(value: 800, date: "8th"),
                    MainChartRow(value: 800, date: "8th"),
                    MainChartRow(value: 700, date: "7th"),
                    MainChartRow(value: 1000, date: "10th"),
                    MainChartRow(value: 600, date: "6th"),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 900,
                padding:const EdgeInsets.all(25),
                // decoration: BoxDecoration(
                //   color: Colors.green,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History"
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
