import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartDataController {
  List<FlSpot> createSpots(List<double> taskCounts) => List.generate(
        taskCounts.length,
        (int index) => FlSpot(index.toDouble(), taskCounts[index]),
      );

  List<LineChartBarData> createLineBarsData(
    List<FlSpot> spotsLearn,
    List<FlSpot> spotsWork,
    List<FlSpot> spotsGeneral,
  ) =>
      <LineChartBarData>[
        LineChartBarData(
          spots: spotsLearn,
          color: Colors.red,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
          isCurved: true,
          barWidth: 8,
          isStrokeCapRound: true,
        ),
        LineChartBarData(
          spots: spotsWork,
          color: Colors.blue,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
          isCurved: true,
          barWidth: 8,
          isStrokeCapRound: true,
        ),
        LineChartBarData(
          spots: spotsGeneral,
          color: Colors.green,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(),
          isCurved: true,
          barWidth: 8,
          isStrokeCapRound: true,
        ),
      ];
}
