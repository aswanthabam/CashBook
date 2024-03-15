import 'package:cashbook/core/theme/app_palatte.dart';
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
            horizontalInterval: 100,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                  color: AppPalatte.primaryLight,
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
              gradient: const LinearGradient(
                colors: [
                  AppPalatte.primaryLight,
                  AppPalatte.primarySemiDark,
                  AppPalatte.primaryDark,
                  AppPalatte.primarySemiDark
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
                    AppPalatte.primaryLight.withOpacity(1),
                    AppPalatte.primaryLight.withOpacity(0.9),
                    AppPalatte.primaryLight.withOpacity(0.8),
                    AppPalatte.primaryLight.withOpacity(0.7),
                    AppPalatte.primaryLight.withOpacity(0.6),
                    AppPalatte.primaryLight.withOpacity(0.5),
                    AppPalatte.primaryLight.withOpacity(0.4),
                    AppPalatte.primaryLight.withOpacity(0.3),
                    AppPalatte.primaryLight.withOpacity(0.2),
                    AppPalatte.primaryLight.withOpacity(0.1),
                    AppPalatte.transparent,
                    AppPalatte.transparent,
                    AppPalatte.transparent,
                    AppPalatte.transparent,
                    AppPalatte.transparent,
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
