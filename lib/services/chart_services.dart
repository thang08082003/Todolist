import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/models/task_count_per_day.dart';
import 'package:todolist/models/todo_category.dart';

class ChartServices {
  Future<List<TaskCountPerDay>> fetchTaskCountsPerCategoryPerDay() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return [];
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('todolist')
            .where('uid', isEqualTo: uid)
            .get();

    final Map<String, Map<TodoCategory, int>> taskCountsPerDay =
        <String, Map<TodoCategory, int>>{};

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      final Map<String, dynamic> data = doc.data();
      final String dateTask = data['dateTask'] as String;
      final String categoryString = data['category'] as String;
      final TodoCategory category = TodoCategory.values.firstWhere(
        (e) => e.displayTitle == categoryString,
      );

      taskCountsPerDay[dateTask] ??= <TodoCategory, int>{};
      taskCountsPerDay[dateTask]![category] =
          (taskCountsPerDay[dateTask]![category] ?? 0) + 1;
    }

    return taskCountsPerDay.entries.map((entry) {
      final date = entry.key;
      final taskCounts = entry.value;
      return TaskCountPerDay(date: date, taskCounts: taskCounts);
    }).toList();
  }
}
