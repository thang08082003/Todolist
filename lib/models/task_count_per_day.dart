import 'package:todolist/models/todo_category.dart';

class TaskCountPerDay {
  TaskCountPerDay({
    required this.date,
    required this.taskCounts,
  });

  factory TaskCountPerDay.fromMap(Map<String, dynamic> map) {
    final Map<TodoCategory, int> taskCounts =
        (map['taskCounts'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        TodoCategory.values.firstWhere((e) => e.displayTitle == key),
        value as int,
      ),
    );

    return TaskCountPerDay(
      date: map['date'] as String,
      taskCounts: taskCounts,
    );
  }

  final String date;
  final Map<TodoCategory, int> taskCounts;

  Map<String, dynamic> toMap() => {
        'date': date,
        'taskCounts': taskCounts.map(
          (category, count) => MapEntry(
            category.displayTitle,
            count,
          ),
        ),
      };
}
