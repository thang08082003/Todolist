import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/models/todo_model.dart';
import 'package:todolist/utils/constants.dart';

List<TodoModel> filterTodosByDate(
  List<TodoModel> todos,
  DateTime selectedDate,
) =>
    todos.where((TodoModel todo) {
      final DateTime taskDate = DateFormat(kDateFormat).parse(todo.dateTask);
      return isSameDay(taskDate, selectedDate);
    }).toList();

Future<DateTime?> pickDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(kLastDateYear),
  );
  return pickedDate;
}

DateTime convertStringToDate({
  required String time,
  required String dateFormat,
}) {
  final DateFormat formatter = DateFormat(dateFormat);
  final DateTime scheduledDate = formatter.parse(time);
  return scheduledDate;
}

Future<TimeOfDay?> pickTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  return pickedTime;
}

void setFormattedDate({
  required DateTime date,
  required TextEditingController controller,
}) {
  controller.text = DateFormat(kDateFormat).format(date);
}

void setFormattedTime({
  required TimeOfDay time,
  required TextEditingController controller,
}) {
  controller.text = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}
