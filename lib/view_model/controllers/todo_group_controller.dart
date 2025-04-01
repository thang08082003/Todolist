import 'package:flutter/material.dart';
import 'package:todolist/local_notification/notification_service.dart';
import 'package:todolist/models/todo_group_model.dart';
import 'package:todolist/services/todo_group_service.dart';
import 'package:uuid/uuid.dart';

class TodoGroupController {
  final NotificationService _notificationService = NotificationService();
  final TodoGroupService _todoGroupService = TodoGroupService();
  final Uuid _uuid = const Uuid();

  Future<void> createTask(
    String title,
    String description,
    DateTime scheduledDate,
    TimeOfDay time,
    String groupId,
  ) async {
    final todoTask = TodoGroupModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      scheduledDate: scheduledDate,
      time: time,
      groupId: groupId,
    );

    await _todoGroupService.addTaskToGroup(todoTask);

    await _notificationService.scheduleNotification(
      title,
      description,
      DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Stream<List<TodoGroupModel>> getTasksStreamByGroupId(String groupId) =>
      _todoGroupService.getTasksStreamByGroupId(groupId);
}
