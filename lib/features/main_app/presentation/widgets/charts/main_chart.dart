import 'package:cashbook/core/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MainChart extends StatefulWidget {
  const MainChart({super.key, required this.data});

  final List<MainChartRow> data;

  @override
  State<MainChart> createState() => _MainChartState();
}

class _MainChartState extends State<MainChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: widget.data
                    .asMap()
                    .values
                    .reduce((value, element) =>
                        value.value > element.value ? value : element)
                    .value /
                6,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryLight
                      .withAlpha(150),
                  strokeWidth: 1,
                  dashArray: [5, 5]);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) => Text(
                  widget.data
                      .asMap()[int.parse(meta.formattedValue)]!
                      .date
                      .toString(),
                  style: const TextStyle(fontSize: 10),
                ),
                reservedSize: 30,
                interval: 1,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          lineBarsData: [
            LineChartBarData(show: false, spots: [
              FlSpot(
                  1,
                  widget.data
                          .asMap()
                          .values
                          .reduce((value, element) =>
                              value.value > element.value ? value : element)
                          .value *
                      1.3),
              FlSpot(
                  1,
                  widget.data
                          .asMap()
                          .values
                          .reduce((value, element) =>
                              value.value < element.value ? value : element)
                          .value *
                      1.3),
            ]),
            LineChartBarData(
              spots: widget.data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                  .toList(),
              isCurved: false,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryLight,
                  Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primarySemiDark,
                  Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryDark,
                  Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primarySemiDark
                ],
              ),
              barWidth: 2,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(1),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.9),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.8),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.7),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.6),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.5),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.4),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.3),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.2),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryLight
                        .withOpacity(0.1),
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .transparent,
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .transparent,
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .transparent,
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .transparent,
                    Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .transparent,
                  ],
                  transform: const GradientRotation(1.5708),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainChartRow {
  final double value;
  final String date;

  MainChartRow({required this.value, required this.date});
}
