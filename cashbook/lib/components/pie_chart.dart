import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../classes/models.dart';
import '../classes/ledger.dart';

class PieChart extends StatefulWidget {
  PieChart(
      {super.key,
      required this.data,
      required this.title,
      this.titleVisible = false,
      this.height = 250});
  double height;
  String title;
  bool titleVisible;
  List<MapData> data = [];
  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: SfCircularChart(
          title: widget.titleVisible ? ChartTitle(text: widget.title) : null,
          tooltipBehavior: TooltipBehavior(enable: true),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Container(
                child: const Text('1000 \$ ',
                    style: TextStyle(
                        color: Color.fromRGBO(47, 56, 58, 0.979),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            )
          ],
          legend: Legend(
              isVisible: true,
              // Border color and border width of legend
              // borderColor: Colors.black,
              toggleSeriesVisibility: true,
              borderWidth: 2),
          series: <CircularSeries<MapData, String>>[
            DoughnutSeries<MapData, String>(
                // Bind data source
                radius: '90%',
                innerRadius: '60%',
                dataSource: widget.data,
                pointColorMapper: (MapData data, _) => data.color,
                xValueMapper: (MapData data, _) => data.name,
                yValueMapper: (MapData data, _) => data.value,
                dataLabelMapper: (MapData data, _) => data.name,
                enableTooltip: true,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                        type: ConnectorType.curve, length: '15%'),
                    labelIntersectAction: LabelIntersectAction.shift,
                    useSeriesColor: true,
                    overflowMode: OverflowMode.shift)),
          ]),
    );
  }
}

class MapData {
  String name;
  double value;
  Color color;
  MapData({required this.name, required this.value, required this.color});
}
