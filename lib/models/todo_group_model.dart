import 'package:flutter/material.dart';

class TodoGroupModel {
  TodoGroupModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.time,
    required this.groupId,
  });

  factory TodoGroupModel.fromMap(Map<String, dynamic> map) => TodoGroupModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        scheduledDate: DateTime.parse(map['scheduledDate']),
        time: TimeOfDay.fromDateTime(DateTime.parse(map['time'])),
        groupId: map['groupId'],
      );

  final String id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final TimeOfDay time;
  final String groupId;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'scheduledDate': scheduledDate.toIso8601String(),
        'time': scheduledDate
            .add(Duration(hours: time.hour, minutes: time.minute))
            .toIso8601String(),
        'groupId': groupId,
      };
}
