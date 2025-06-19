import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSingle extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final Color color;
  final String label;
  final Map<String, Map<String, double>>? categoryData;

  const LineChartSingle({
    Key? key,
    required this.values,
    required this.xLabels,
    required this.color,
    this.label = '',
    this.categoryData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i]),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            minY: 0,
            maxY: values.isEmpty
                ? 10
                : (values.reduce((a, b) => a > b ? a : b)) * 1.3,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 54,
                  getTitlesWidget: (value, meta) {
                    final maxY = values.isEmpty
                        ? 10
                        : (values.reduce((a, b) => a > b ? a : b)) * 1.3;
                    // Hide topmost label
                    if ((maxY - value).abs() < 0.01) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  },
                  interval: ((values.isEmpty
                              ? 10
                              : values.reduce((a, b) => a > b ? a : b)) /
                          4)
                      .ceilToDouble(),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    int idx = value.round();
                    return idx >= 0 && idx < xLabels.length
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              xLabels[idx],
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 4,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withOpacity(0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white,
                tooltipRoundedRadius: 8,
                getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                  int idx = spot.x.toInt();
                  String timeLabel = xLabels[idx];
                  String categoryBreakdown = "";
                  if (categoryData != null) {
                    final categories = categoryData![timeLabel];
                    if (categories != null) {
                      categoryBreakdown = categories.entries
                          .map((e) => "${e.key}: ${e.value}")
                          .join('\n');
                    }
                  }
                  return LineTooltipItem(
                    "$timeLabel\n$categoryBreakdown",
                    TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
