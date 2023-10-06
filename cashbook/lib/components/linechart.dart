import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../classes/models.dart';
import '../classes/ledger.dart';

class LineChart extends StatefulWidget {
  LineChart(
      {super.key,
      required this.data,
      required this.title,
      required this.dateRange,
      this.titleVisible = false,
      this.height = 250});
  double height;
  String title;
  bool titleVisible;
  List<ChartSet> data = [];
  List<DateTime> dateRange;
  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Center(
            child: Container(
                child: SfCartesianChart(
                    title: ChartTitle(
                        text: widget.title,
                        textStyle: TextStyle(
                            color: ThemeData.light().primaryColor,
                            fontSize: 12)),
                    primaryXAxis: DateTimeAxis(
                        minimum: widget.dateRange[0],
                        maximum: widget.dateRange[1]),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryYAxis: NumericAxis(isVisible: false),
                    legend:
                        Legend(isVisible: true, position: LegendPosition.right),
                    series: widget.data
                        .map<ChartSeries>((e) => ColumnSeries<ChartData,
                                DateTime>(
                            name: e.name,
                            enableTooltip: true,
                            dataSource: e.data,
                            xValueMapper: (ChartData data, _) => data.date,
                            yValueMapper: (ChartData data, _) => data.value,
                            dataLabelMapper: (ChartData data, index) => e.name,
                            markerSettings: MarkerSettings(isVisible: true)))
                        .toList()))));
  }
}

class ChartSet {
  Color color;
  List<ChartData> data;
  final String name;
  ChartSet(this.data, this.name, this.color);
}

class ChartData {
  ChartData(this.date, this.value);
  final DateTime date;
  final double value;
}

// class MapData {
//   String name;
//   double value;
//   Color color;
//   MapData({required this.name, required this.value, required this.color});
// }
