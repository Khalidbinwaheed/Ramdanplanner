import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressDonut extends StatelessWidget {
  final double percent;
  final String label;
  final Color color;

  const ProgressDonut({
    super.key,
    required this.percent,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 35,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: color,
                      value: percent,
                      showTitle: false,
                      radius: 10,
                    ),
                    PieChartSectionData(
                      color: color.withValues(alpha: 0.2),
                      value: 100 - percent,
                      showTitle: false,
                      radius: 10,
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  '${percent.toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
