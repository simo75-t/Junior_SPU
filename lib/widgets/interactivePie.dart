import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InteractivePieChart extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, Color> categoryColors;
  final String type;

  const InteractivePieChart({
    super.key,
    required this.data,
    required this.categoryColors,
    required this.type,
  });

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final entries = widget.data.entries.toList();

    return AspectRatio(
      aspectRatio: 1.6,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse?.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse!
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 40,
                  sections: _buildSections(entries),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.asMap().entries.map((entry) {
              final index = entry.key;
              final key = entry.value.key;
              final color =
                  widget.categoryColors['${widget.type}$key'] ?? Colors.grey;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: color),
                    const SizedBox(width: 6),
                    Text(
                      key,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      List<MapEntry<String, double>> entries) {
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      final isTouched = index == touchedIndex;
      final percent = (e.value / total) * 100;
      final radius = isTouched ? 60.0 : 50.0;
      final fontSize = isTouched ? 20.0 : 14.0;
      final color =
          widget.categoryColors['${widget.type}${e.key}'] ?? Colors.grey;

      return PieChartSectionData(
        color: color,
        value: e.value,
        title: '${percent.toStringAsFixed(1)}%', // ✅ Percent only
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
