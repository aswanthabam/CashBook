import 'package:cashbook/core/theme/app_palatte.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/add_button.dart';
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const MainAppBar(),
              Container(
                padding: const EdgeInsets.all(25),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PaginationIndicator(
                      count: 3,
                      index: 1,
                    ),
                    const SizedBox(
                      height: 30,
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
                            onPressed: () {},
                          )
                        ]),
                    const SizedBox(
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
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 2)),
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: AppPalatte.green,
                      ),
                      title:  Text(
                        "Received Money From freelancing",
                        style: TextStyle(fontSize: 14,color:Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle:  Text("5th May 2021",
                          style: TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline1!.color)),
                      trailing: const Text(
                        "+1000",
                        style: TextStyle(
                            color: AppPalatte.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 2)),
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: AppPalatte.green,
                      ),
                      title:  Text(
                        "Received Money From freelancing",
                        style: TextStyle(fontSize: 14,color:Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle:  Text("5th May 2021",
                          style: TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline1!.color)),
                      trailing: const Text(
                        "+1000",
                        style: TextStyle(
                            color: AppPalatte.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 2)),
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: AppPalatte.green,
                      ),
                      title:  Text(
                        "Received Money From freelancing",
                        style: TextStyle(fontSize: 14,color:Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle:  Text("5th May 2021",
                          style: TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline1!.color)),
                      trailing: const Text(
                        "+1000",
                        style: TextStyle(
                            color: AppPalatte.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 2)),
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: AppPalatte.green,
                      ),
                      title:  Text(
                        "Received Money From freelancing",
                        style: TextStyle(fontSize: 14,color:Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle:  Text("5th May 2021",
                          style: TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline1!.color)),
                      trailing: const Text(
                        "+1000",
                        style: TextStyle(
                            color: AppPalatte.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      shape: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 2)),
                      leading: const Icon(
                        Icons.arrow_upward,
                        color: AppPalatte.green,
                      ),
                      title:  Text(
                        "Received Money From freelancing",
                        style: TextStyle(fontSize: 14,color:Theme.of(context).textTheme.headline1!.color),
                      ),
                      subtitle:  Text("5th May 2021",
                          style: TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline1!.color)),
                      trailing: const Text(
                        "+1000",
                        style: TextStyle(
                            color: AppPalatte.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
