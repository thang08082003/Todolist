import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/task_count_per_day.dart';
import 'package:todolist/models/todo_category.dart';
import 'package:todolist/services/chart_services.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:todolist/utils/theme/app_text_style.dart';
import 'package:todolist/view_model/controllers/chart_data_controller.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartServices = ChartServices();
    final chartDataController = ChartDataController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(AppText.chartTitle, style: AppTextStyle.header),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<TaskCountPerDay>>(
        future: chartServices.fetchTaskCountsPerCategoryPerDay(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<TaskCountPerDay>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final taskCountsPerDay = snapshot.data!;
          final List<double> dailyTasksLearn = <double>[];
          final List<double> dailyTasksWork = <double>[];
          final List<double> dailyTasksGeneral = <double>[];

          double maxTasks = 0;

          final List<String> sortedDates = taskCountsPerDay
              .map((taskCountPerDay) => taskCountPerDay.date)
              .toList()
            ..sort();

          for (final date in sortedDates) {
            final taskCountPerDay = taskCountsPerDay.firstWhere(
              (item) => item.date == date,
              orElse: () => TaskCountPerDay(date: date, taskCounts: {}),
            );

            final learnCount =
                taskCountPerDay.taskCounts[TodoCategory.learn] ?? 0;
            final workCount =
                taskCountPerDay.taskCounts[TodoCategory.work] ?? 0;
            final generalCount =
                taskCountPerDay.taskCounts[TodoCategory.general] ?? 0;

            dailyTasksLearn.add(learnCount.toDouble());
            dailyTasksWork.add(workCount.toDouble());
            dailyTasksGeneral.add(generalCount.toDouble());

            maxTasks = [
              learnCount.toDouble(),
              workCount.toDouble(),
              generalCount.toDouble(),
              maxTasks,
            ].reduce((a, b) => a > b ? a : b);
          }

          final List<FlSpot> spotsLearn =
              chartDataController.createSpots(dailyTasksLearn);
          final List<FlSpot> spotsWork =
              chartDataController.createSpots(dailyTasksWork);
          final List<FlSpot> spotsGeneral =
              chartDataController.createSpots(dailyTasksGeneral);

          final List<LineChartBarData> lineBarsData =
              chartDataController.createLineBarsData(
            spotsLearn,
            spotsWork,
            spotsGeneral,
          );

          return Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: sortedDates.length * 150,
                color: Colors.white,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            return index < sortedDates.length
                                ? Text(sortedDates[index])
                                : const SizedBox.shrink();
                          },
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value == 0) {
                              return const Text('0');
                            }
                            if (value == 1) {
                              return const Text('1');
                            }
                            if (value == -1) {
                              return const Text(' ');
                            }
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          interval: 1,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final int index = value.toInt();
                            return index < sortedDates.length
                                ? Text(sortedDates[index])
                                : const SizedBox.shrink();
                          },
                          interval: 1,
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(width: 2),
                        bottom: BorderSide(width: 2),
                      ),
                    ),
                    minX: 0,
                    maxX: sortedDates.length.toDouble(),
                    minY: -1,
                    maxY: maxTasks + 1,
                    lineBarsData: lineBarsData,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
